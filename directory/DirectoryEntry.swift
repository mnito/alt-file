#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public struct DirectoryEntry {
  public var name : String = ""
  public var type : FileType = FileType.Unknown

  public func isDot() -> Bool {
    return name == "." || name == ".."
  }
}
