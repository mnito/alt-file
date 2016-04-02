#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#else
    import Glibc
#endif

/*
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
*/

var dir = Directory(path: ".")

for file in dir {
   print(file)
}
