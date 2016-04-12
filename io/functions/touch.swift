#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public func touch(path: String) -> Bool {
  return filePutBytes(path, contents: []) != -1
}
