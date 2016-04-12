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
let writer = ByteWriter(path: "cool2.test")

print(writer.write(65))
print(writer.write([65,66,67,68]))

let writer2 = LineWriter(path: "/dev/stdout")
writer2.write("hey")
writer2.write("yo")
