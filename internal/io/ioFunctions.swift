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
