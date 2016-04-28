public class File {
  public let path: String
  public var info: FileInfo
  public var permissions: FilePermissions
  
  private var lineReader: LineReader?
  private var byteReader: ByteReader?
  private var _lineWriter: LineWriter?
  private var _byteWriter: ByteWriter?

  public var lines: LineReader {
    if(lineReader != nil) {
      return lineReader!
    }
    let reader = LineReader(path: path)
    lineReader = reader
    return reader
  }

  public var bytes: ByteReader {
    if(self.byteReader != nil) {
      return byteReader!
    }
    let reader = ByteReader(path: path)
    byteReader = reader
    return reader
  }

  public var byteWriter: ByteWriter {
    return ByteWriter(path: path)
  }

  public var lineWriter: LineWriter {
    return LineWriter(path: path)
  }

  public var string: String {
    return fileGetString(path)!
  }

  init(path: String) {
    if !fileExists(path) {
      touch(path)
    }
    self.path = path
    info = fileInfo(path)
    permissions = filePermissions(path)
  }

  public func put(contents: String) -> Int {
    return filePutString(path, contents: contents)
  }

  public func put(bytes: [Byte]) -> Int {
    return filePutBytes(path, contents: bytes)
  }

  public func get() -> String {
    return string
  }

  public func getBytes() -> [Byte] {
    return fileGetBytes(path)!
  }
}
