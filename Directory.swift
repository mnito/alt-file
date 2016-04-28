public struct FileGenerator<File> : GeneratorType {
  var dir: DirectoryEntryGenerator<DirectoryEntry>

  init(dir: DirectoryEntryGenerator<DirectoryEntry>) {
    self.dir = dir
  }

  public mutating func next() -> File? {
    guard let next = dir.next() else {
      return nil
    }
    return Directory.toFile(next) as? File
  }
}

public class Directory : SequenceType {
  let path: String

  init(path: String) {
    self.path = path
  }
  public var list: String {
    return ""
  }

  public func generate() -> FileGenerator<File> {
    let directoryList = DirectoryList(path: path)
    return FileGenerator(dir: directoryList.generate())
  }

  public class func toFile(entry: DirectoryEntry) -> File {
    return File(path: entry.name)
  }
}
