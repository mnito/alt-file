#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public func fileGetBytes(path: String) -> [Byte]? {
  var bytes = [Byte]()
  let fp = fopen(path, "rb")
  guard fp != nil else {
      return nil
  }
  while(true) {
    let c = fgetc(fp)
    guard c != -1 else {
      fclose(fp)
      break
    }
    bytes.append(Byte(c))
  }
  return bytes
}
