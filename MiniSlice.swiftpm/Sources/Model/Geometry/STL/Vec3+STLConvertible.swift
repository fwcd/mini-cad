import Foundation

extension Vec3: STLConvertible {
    var asAsciiStl: String {
        "\(x) \(y) \(z)"
    }
    var asBinaryStl: Data {
        var data = Data()
        data.append(unsafeBytesOf: Float32(x).bitPattern.littleEndian)
        data.append(unsafeBytesOf: Float32(y).bitPattern.littleEndian)
        data.append(unsafeBytesOf: Float32(z).bitPattern.littleEndian)
        return data
    }
}
