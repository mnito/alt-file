#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

internal func parseType(dtype: Int) -> FileType {
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

internal func toEntry(ep: UnsafeMutablePointer<dirent>) -> DirectoryEntry? {
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

public struct DirectoryGenerator<DirectoryEntry> : GeneratorType {

  let dp : COpaquePointer

  init(dp: COpaquePointer) {
    self.dp = dp
  }

  public mutating func next() -> DirectoryEntry? {
    if dp == nil { return nil }
    let ep = readdir(dp)
    if (ep == nil) {
      closedir(dp)
      return nil
    }
    return toEntry(ep) as? DirectoryEntry
  }
}

public struct DirectoryList : SequenceType {

  let path : String

  init(path: String) {
    self.path = path
  }

  public func generate() -> DirectoryGenerator<DirectoryEntry> {
    let dp = opendir(path)
    return DirectoryGenerator(dp: dp)
  }
}
