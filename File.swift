/*IN PROGRESS*/

enum FileError: ErrorType {
  case Inaccessible(path: String)
}

public class File {
  public let path: String
  public var info: FileInfo
  public var permissions: FilePermissions
  private var lineGenerator: LineGenerator<String>
  private var byteGenerator: ByteGenerator<Byte>

  init(path: String) throws {
    if !fileExists(path) {
      guard touch(path) else {
        throw FileError.Inaccessible(path: path)
      }
    }
    self.path = path
    let lineReader = LineReader(path: path)
    let byteReader = ByteReader(path: path)
    lineGenerator = lineReader.generate()
    byteGenerator = byteReader.generate()
    info = fileInfo(path)
    permissions = filePermissions(path)
  }

  func put(contents: String) -> Int {
    return filePutString(path, contents: contents)
  }

  func put(contents: [Byte]) -> Int {
    return filePutBytes(path, contents: contents)
  }

  public var bytes: [Byte] {
    return fileGetBytes(path)!
  }

  public var string: String {
    return fileGetString(path)!
  }

  public func nextByte() -> Byte? {
    return byteGenerator.next()
  }

  public func nextLine() -> String? {
    return lineGenerator.next()
  }
}
