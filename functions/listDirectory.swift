#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

struct DirectoryEntry
{
    enum FileType { case Regular, Directory, Unknown }
    var name : String = ""
    var type : FileType = FileType.Unknown
    func isDot() -> Bool {
        return name == "." || name == ".."
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

func isDirectory(path: String) -> Bool
{
    return opendir(path) != nil
}

func isFile(path: String) -> Bool
{
    return opendir(path) == nil
}
