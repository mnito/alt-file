#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public func fileExists(path: String) -> Bool {
  return access(path, F_OK) == 0
}
