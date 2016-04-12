#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public func isDirectory(path: String) -> Bool {
  return opendir(path) != nil
}
