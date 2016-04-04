#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif


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
    var dir = Directory(path: file)

    for entry in dir {
       print(entry.name + " : " + String(entry.type))
    }
} else if(fileExists(file)) {

    var lines = File(path: file, maxLineLength: 0)
    for line in lines { print(line, terminator: "") }
    print(fileGetContents(file)!)
}
