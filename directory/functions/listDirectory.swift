#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public func listDirectory(path: String) -> [DirectoryEntry]? {
  var directory = [DirectoryEntry]()
  let dp = opendir(path)
  if (dp == nil) {
    return nil
  }
  while(true) {
    let ep = readdir(dp)
    if (ep == nil) { break; }
    guard let entry = toEntry(ep) else  { continue }
    directory.append(entry)
  }
  closedir(dp)
  return directory
}
