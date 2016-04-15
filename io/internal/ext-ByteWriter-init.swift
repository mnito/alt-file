#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

extension ByteWriter {

  internal init(fp: UnsafeMutablePointer<FILE>) {
    self.fp = fp
  }
}
