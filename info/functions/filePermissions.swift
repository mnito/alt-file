#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public func filePermissions(path: String) -> FilePermissions {
  var fPerm = FilePermissions()
  if(access(path, R_OK) == 0) { fPerm.read = true }
  if(access(path, W_OK) == 0) { fPerm.write = true }
  if(access(path, X_OK) == 0) { fPerm.read = true }
  return fPerm
}
