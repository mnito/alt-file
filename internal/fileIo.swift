#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

typealias Byte = UInt8

func fileGetBytes(path: String) -> [Byte]? {
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

func filePutBytes(path: String, contents: [Byte]) -> Int {
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

func touch(path: String) -> Bool {
  return filePutBytes(path, contents: []) != -1
}

func filePutBytes(path: String, contents: ByteReader) -> Int {
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

func fileGetContents(path: String) -> String? {
    let file = LineReader(path: path)
    var str = ""
    for line in file {
        str += line
    }
    if(str == "") {
        return nil
    }
    return str
}

func filePutContents(path: String, contents: String) -> Int {
    let fp = fopen(path, "w")
    guard fp != nil else {
        return -1
    }
    fputs(contents, fp)
    fclose(fp)
    return contents.characters.count
}

private func readLine(fp: UnsafeMutablePointer<FILE>) -> String? {
    var buffer: UnsafeMutablePointer<Int8> = nil
    var temp = 0
    if(getline(&buffer, &temp, fp) == -1) {
        return nil
    }
    let str = String.fromCString(buffer)
    free(buffer)
    return str
}

struct LineGenerator<String> : GeneratorType {

    let fp : UnsafeMutablePointer<FILE>

    init(fp: UnsafeMutablePointer<FILE>) {
        self.fp = fp
    }

    mutating func next() -> String? {
        if fp == nil { return nil }
        guard let line = readLine(fp) else {
            fclose(fp)
            return nil
        }
        return line as? String
    }
}

struct LineReader : SequenceType {
    let path : String

    init(path: String) {
        self.path = path
    }

    init(path: String, maxLineLength: Int) {
        self.path = path
    }

    func generate() -> LineGenerator<String> {
        let fp = fopen(path, "r")
        return LineGenerator(fp: fp)
    }
}

struct ByteGenerator<Byte> : GeneratorType {

    let fp : UnsafeMutablePointer<FILE>

    init(fp: UnsafeMutablePointer<FILE>) {
        self.fp = fp
    }

    mutating func next() -> Byte? {
        if fp == nil { return nil }
        let c = fgetc(fp)
        guard c != -1 else {
            fclose(fp)
            return nil
        }
        return UInt8(c) as? Byte
    }
}

struct ByteReader : SequenceType {
    let path : String

    init(path: String) {
        self.path = path
    }

    init(path: String, maxLineLength: Int) {
        self.path = path
    }

    func generate() -> ByteGenerator<Byte> {
        let fp = fopen(path, "rb")
        return ByteGenerator(fp: fp)
    }
}

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
