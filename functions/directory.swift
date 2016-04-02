#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

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
        return parseEntry(ep) as? DirectoryEntry
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

/*
func listDirectory(path: String) -> [DirectoryEntry]? {
    var directory = [DirectoryEntry]()
    let dp = opendir(path)
    if (dp == nil) {
        return nil
    }
    while(true) {
        let ep = readdir(dp)
        if (ep == nil) { break; }
        let file = withUnsafePointer(&ep.memory.d_name) {
            String.fromCString(UnsafePointer($0))
        }
        let dtype = ep.memory.d_type
        if let fileName = file {
            var entry = DirectoryEntry()
            entry.name = fileName
            var type = DirectoryEntry.FileType.Unknown
            if Int(dtype) == Int(DT_REG) {
                type = DirectoryEntry.FileType.Regular
            } else if Int(dtype) == Int(DT_DIR) {
                type = DirectoryEntry.FileType.Directory
            }
            entry.type = type
            directory.append(entry)
        }
    }
    closedir(dp)
    return directory
}
*/

func parseEntry(ep: UnsafeMutablePointer<dirent>) -> DirectoryEntry? {
        let file = withUnsafePointer(&ep.memory.d_name) {
            String.fromCString(UnsafePointer($0))
        }
        let dtype = ep.memory.d_type
        guard let fileName = file else {
            return nil
        }
        var entry = DirectoryEntry()
        entry.name = fileName
        var type = DirectoryEntry.FileType.Unknown
        if Int(dtype) == Int(DT_REG) {
           type = DirectoryEntry.FileType.Regular
        } else if Int(dtype) == Int(DT_DIR) {
            type = DirectoryEntry.FileType.Directory
        }
        entry.type = type
        return entry
}
