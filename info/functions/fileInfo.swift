#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

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

public func fileInfo(path: String) -> FileInfo {
  var fInfo = FileInfo()
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
