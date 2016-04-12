#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

public func fileGetString(path: String) -> String? {
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
