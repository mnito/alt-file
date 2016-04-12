enum FileError: ErrorType {
  case Inaccessible(path: String)
}

public class File {
  public let path : String
  public var info : FileInfo
  public var permissions : FilePermissions
  private let lines : LineReader
  private let bytes : ByteReader

  init(path: String) throws {
    if !fileExists(path) {
      guard touch(path) else {
        throw FileError.Inaccessible(path: path)
      }
    }
    self.path = path
    lines = LineReader(path: path)
    bytes = ByteReader(path: path)
    info = fileInfo(path)
    permissions = filePermissions(path)
  }

  func put(contents: String) -> Int {
    return filePutContents(path, contents: contents)
  }

  func put(contents: [Byte]) -> Int {
    return filePutBytes(path, contents: contents)
  }
}
