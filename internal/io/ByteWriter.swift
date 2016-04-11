#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public struct ByteWriter {
  private var fp: UnsafeMutablePointer<FILE>

  init(path: String) {
    fp = fopen(path, "a")
  }

  func write(byte: Byte) -> Int {
    return Int(fputc(Int32(byte), fp))
  }

  func write(bytes: [Byte]) -> Int {
    var written = 0
    for byte in bytes {
      let c = write(byte)
      guard c >= 0 else {
        break
      }
      written += 1
    }
    return written
  }

  func toStart() {
    rewind(fp)
  }

  func close() {
    fclose(fp)
  }
}
