#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public struct ByteGenerator<Byte> : GeneratorType {
  let fp : UnsafeMutablePointer<FILE>

  init(fp: UnsafeMutablePointer<FILE>) {
    self.fp = fp
  }

  public mutating func next() -> Byte? {
    if fp == nil { return nil }
      let c = fgetc(fp)
      guard c != -1 else {
        fclose(fp)
        return nil
      }
      return UInt8(c) as? Byte
  }
}

public struct ByteReader : SequenceType {
  let path : String

  init(path: String) {
    self.path = path
  }

  init(path: String, maxLineLength: Int) {
      self.path = path
  }

  public func generate() -> ByteGenerator<Byte> {
    let fp = fopen(path, "rb")
    return ByteGenerator(fp: fp)
  }
}
