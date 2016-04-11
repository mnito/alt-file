#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
  import Darwin
#else
  import Glibc
#endif

private func readLine(fp: UnsafeMutablePointer<FILE>) -> String? {
    var buffer: UnsafeMutablePointer<Int8> = nil
    var temp = 0
    if(getline(&buffer, &temp, fp) == -1) {
        return nil
    }
    let str = String.fromCString(buffer)
    free(buffer)
    return str
}

struct LineGenerator<String> : GeneratorType {

    let fp : UnsafeMutablePointer<FILE>

    init(fp: UnsafeMutablePointer<FILE>) {
        self.fp = fp
    }

    mutating func next() -> String? {
        if fp == nil { return nil }
        guard let line = readLine(fp) else {
            fclose(fp)
            return nil
        }
        return line as? String
    }
}

struct LineReader : SequenceType {
    let path : String

    init(path: String) {
        self.path = path
    }

    init(path: String, maxLineLength: Int) {
        self.path = path
    }

    func generate() -> LineGenerator<String> {
        let fp = fopen(path, "r")
        return LineGenerator(fp: fp)
    }
}
