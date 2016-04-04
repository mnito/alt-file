#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

struct FileInfoStruct {
    var size : Int = 0
    var type : FileType = FileType.Unknown
    var permissions : FilePermissions = FilePermissions()
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

enum FileType { 
    case Regular 
    case Directory
    case BlockDevice
    case CharacterDevice 
    case Symlink
    case Socket
    case Pipe
    case Unknown 
}

struct FilePermissions
{
    var read : Bool = false
    var write : Bool = false
    var execute : Bool = false
}

private func parseFileType(st_mode: UInt32) -> FileType {
    var type = FileType.Unknown
    switch(st_mode & S_IFMT) {
        case S_IFREG : type = FileType.Regular
        case S_IFDIR : type = FileType.Directory
        case S_IFBLK : type = FileType.BlockDevice
        case S_IFCHR : type = FileType.CharacterDevice
        case S_IFLNK : type = FileType.Symlink
        case S_IFSOCK : type = FileType.Socket
        case S_IFIFO : type = FileType.Pipe
        default : type = FileType.Unknown
    }
    return type
}

func filePermissions(path: String) -> FilePermissions
{
    var fPerm = FilePermissions()
    if(access(path, R_OK) == 0) { fPerm.read = true }
    if(access(path, W_OK) == 0) { fPerm.write = true }
    if(access(path, X_OK) == 0) { fPerm.read = true }
    return fPerm
}

func fileInfo(path: String) -> FileInfoStruct {
    var fInfo = FileInfoStruct()
    var buffer =  stat()
    if stat(path, &buffer) != 0 {
        return fInfo
    }
    fInfo.size = buffer.st_size
    fInfo.type = parseFileType(buffer.st_mode)
    fInfo.permissions = filePermissions(path)
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
    return access(path, F_OK) == 0
}
