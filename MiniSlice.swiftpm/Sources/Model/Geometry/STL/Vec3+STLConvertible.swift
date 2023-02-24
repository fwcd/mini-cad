import Foundation

extension Vec3: STLConvertible {
    var asAsciiStl: String {
        "\(x) \(y) \(z)"
    }
    var asBinaryStl: Data {
        var data = Data()
        data.append(unsafeBytesOf: x.bitPattern.littleEndian)
        data.append(unsafeBytesOf: y.bitPattern.littleEndian)
        data.append(unsafeBytesOf: z.bitPattern.littleEndian)
        return data
    }
}
