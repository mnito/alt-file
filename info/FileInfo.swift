public struct FileInfo {
  public var size : Int = 0
  public var type : FileType = FileType.Unknown
  public var permissions : FilePermissions = FilePermissions()
  public var lastAccessTime : Int = 0
  public var lastModificationTime : Int = 0
  public var lastChangeTime : Int = 0
  public var numLinks: Int = 0
  public var deviceId: Int = 0
  public var userId: Int = 0
  public var groupId: Int = 0
  public var rDeviceId: Int = 0
  public var blockSize: Int = 0
  public var blocks: Int = 0
}
