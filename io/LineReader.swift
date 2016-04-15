#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

private func readLine(fp: UnsafeMutablePointer<FILE>) -> String? {
  var buffer: UnsafeMutablePointer<Int8> = nil
  var temp = 0
  if(getline(&buffer, &temp, fp) == -1) {
      return nil
  }
  let str = String.fromCString(buffer)
  free(buffer)
  return str
  /*
  var buffer: [Int8]
  while(true) {
    let c = fgetc(fp)
    if(c == -1) {
      return nil
    }
    let s = String(Character(UnicodeScalar(UInt32(c))))
    line += s
    if s == "\n" {
      break
    }
  }
  return line
  */
}

public struct LineGenerator<String> : GeneratorType {
  let fp : UnsafeMutablePointer<FILE>

  init(fp: UnsafeMutablePointer<FILE>) {
    self.fp = fp
  }

  public mutating func next() -> String? {
    if fp == nil { return nil }
    guard let line = readLine(fp) else {
      fclose(fp)
      return nil
    }
    return line as? String
  }
}

public struct LineReader : SequenceType {
  let path : String

  init(path: String) {
    self.path = path
  }

  public func generate() -> LineGenerator<String> {
    let fp = fopen(path, "r")
    return LineGenerator(fp: fp)
  }
}
