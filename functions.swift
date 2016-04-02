#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

struct fileInfoStruct {
    var size : Int = 0
    var lastAccessTime : Int = 0
    var lastModificationTime : Int = 0
    var lastChangeTime : Int = 0
    var numLinks: Int = 0
    var deviceId: Int = 0
    var userId: Int = 0
    var groupId: Int = 0
    var rDeviceId: Int = 0
    var blockSize: Int = 0
    var blocks: Int = 0
}

func fileInfo(path: String) -> fileInfoStruct {
    var fInfo = fileInfoStruct()
    var buffer =  stat()
    if stat(path, &buffer) != 0 {
        return fInfo
    }
    fInfo.size = buffer.st_size
    fInfo.lastAccessTime = buffer.st_atim.tv_sec
    fInfo.lastModificationTime = buffer.st_mtim.tv_sec
    fInfo.lastChangeTime = buffer.st_ctim.tv_sec
    fInfo.numLinks = Int(buffer.st_nlink)
    fInfo.deviceId = Int(buffer.st_dev)
    fInfo.userId = Int(buffer.st_uid)
    fInfo.groupId = Int(buffer.st_gid)
    fInfo.rDeviceId = Int(buffer.st_rdev)
    fInfo.blockSize = buffer.st_blksize
    fInfo.blocks = buffer.st_blocks
    return fInfo
}

func fileExists(path: String) -> Bool {
    var buffer = stat()
    return stat(path, &buffer) == 0
}

/*
struct DirectoryGenerator : GeneratorType {

    mutating func next() -> String? {
        
    }

struct Directory : SequenceType
{
    var path : String

    init(path: String) {
        self.path = path
    }

    func generate() -> GeneratorType {
    }
}
*/

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
        print(dtype)
        print(file)
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
