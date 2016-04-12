#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public func filePutBytes(path: String, contents: [Byte]) -> Int {
  let fp = fopen(path, "w")
  guard fp != nil else {
    return -1
  }
  for c in contents {
    fputc(Int32(c), fp)
  }
  fclose(fp)
  return contents.count
}

public func filePutBytes(path: String, contents: ByteReader) -> Int {
  let fp = fopen(path, "w")
  guard fp != nil else {
    return -1
  }
  var i = 0
  for c in contents {
    fputc(Int32(c), fp)
    i += 1
  }
  fclose(fp)
  return i
}
