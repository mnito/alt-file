#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public func filePutString(path: String, contents: String) -> Int {
  let fp = fopen(path, "w")
  guard fp != nil else {
    return -1
  }
  fputs(contents, fp)
  fclose(fp)
  return contents.characters.count
}
