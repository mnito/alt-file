#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

//Testing

guard Process.arguments.count > 1 else {
    print("Enter a file as an argument.")
    exit(0)
}

let file = Process.arguments[1]

if isDirectory(file) {
    print(listDirectory(file)!)
} else if(fileExists(file)) {
    print(fileInfo(file))
} else {
    print("File does not exist.")
}

print("-----------------------------------------")

if isDirectory(file) {
    var dir = DirectoryList(path: file)
    for entry in dir {
       print(entry.name + " : " + String(entry.type))
    }
} else if(fileExists(file)) {
    var bytes = ByteReader(path: file)
    for byte in bytes { print(byte, terminator: "") }
    filePutBytes("test.file", contents: bytes)
}

print("------------------------------------------")

var file2 = File(path: "test/uc.test")

for line in file2.lines {
  print(line, terminator: "")
}
