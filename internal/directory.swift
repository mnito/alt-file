#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

struct DirectoryEntry
{
    var name : String = ""
    var type : FileType = FileType.Unknown
    func isDot() -> Bool {
        return name == "." || name == ".."
    }
}

func isDirectory(path: String) -> Bool
{
    return opendir(path) != nil
}

func isFile(path: String) -> Bool
{
    return opendir(path) == nil
}

private func parseType(dtype: Int) -> FileType
{
    var type = FileType.Unknown
    switch(dtype) {
        case DT_REG : type = FileType.Regular
        case DT_DIR : type = FileType.Directory
        case DT_BLK : type = FileType.BlockDevice
        case DT_CHR : type = FileType.CharacterDevice
        case DT_LNK : type = FileType.Symlink
        case DT_SOCK : type = FileType.Socket
        case DT_FIFO : type = FileType.Pipe
        default : type = FileType.Unknown
    }
    return type
}

private func toEntry(ep: UnsafeMutablePointer<dirent>) -> DirectoryEntry? {
    let file = withUnsafePointer(&ep.memory.d_name) {
        String.fromCString(UnsafePointer($0))
    }
    let dtype = ep.memory.d_type
    guard let fileName = file else {
        return nil
    }
    var entry = DirectoryEntry()
    entry.name = fileName
    entry.type = parseType(Int(dtype))
    return entry
}

struct DirectoryGenerator<DirectoryEntry> : GeneratorType {

    let dp : COpaquePointer

    init(dp: COpaquePointer) {
        self.dp = dp
    }

    mutating func next() -> DirectoryEntry? {
        if dp == nil { return nil }
        let ep = readdir(dp)
        if (ep == nil) {
            closedir(dp)
            return nil
        }
        return toEntry(ep) as? DirectoryEntry
    }
}

struct Directory : SequenceType
{
    let path : String

    init(path: String) {
        self.path = path
    }

    func generate() -> DirectoryGenerator<DirectoryEntry> {
        let dp = opendir(path)
        return DirectoryGenerator(dp: dp)
    }
}

func listDirectory(path: String) -> [DirectoryEntry]? {
    var directory = [DirectoryEntry]()
    let dp = opendir(path)
    if (dp == nil) {
        return nil
    }
    while(true) {
        let ep = readdir(dp)
        if (ep == nil) { break; }
        guard let entry = toEntry(ep) else  { continue }
        directory.append(entry)
    }
    closedir(dp)
    return directory
}
