#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public struct LineWriter {
  internal var fp: UnsafeMutablePointer<FILE>

  public init(path: String) {
    fp = fopen(path, "a")
  }

  public func write(content: String) -> Int {
    return Int(fputs(content + "\n", fp))
  }

  public func toStart() {
    rewind(fp)
  }

  public func close() {
    fclose(fp)
  }
}
