#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public struct LineWriter {
  private var fp: UnsafeMutablePointer<FILE>

  init(path: String) {
    fp = fopen(path, "a")
  }

  func write(content: String) -> Int {
    return Int(fputs(content + "\n", fp))
  }

  func toStart() {
    rewind(fp)
  }

  func close() {
    fclose(fp)
  }
}
