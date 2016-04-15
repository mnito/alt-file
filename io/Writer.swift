#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public struct Writer {
  let fp : UnsafeMutablePointer<FILE>
  private var byteWriter: ByteWriter
  private var lineWriter: LineWriter

  init(path: String) {
    fp = fopen(path, "a")
    byteWriter = ByteWriter(fp: fp)
    lineWriter = LineWriter(fp: fp)
  }

  public func write(byte: Byte) -> Int {
    return byteWriter.write(byte)
  }

  public func write(bytes: [Byte]) -> Int {
    return byteWriter.write(bytes)
  }

  public func write(content: String) -> Int {
    return lineWriter.write(content)
  }

  public func toStart() {
    rewind(fp)
  }

  public func close() {
    fclose(fp)
  }
}
