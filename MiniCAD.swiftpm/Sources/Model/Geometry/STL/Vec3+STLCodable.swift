import Foundation

extension Vec3: STLEncodable {
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

extension Vec3: STLDecodable {
    init(binaryStl data: Data) throws {
        data.withUnsafeBytes { ptr in
            x = Double(Float32(bitPattern: UInt32(littleEndian: ptr.loadUnaligned(as: UInt32.self))))
            y = Double(Float32(bitPattern: UInt32(littleEndian: ptr.loadUnaligned(fromByteOffset: 4, as: UInt32.self))))
            z = Double(Float32(bitPattern: UInt32(littleEndian: ptr.loadUnaligned(fromByteOffset: 8, as: UInt32.self))))
        }
    }
}
