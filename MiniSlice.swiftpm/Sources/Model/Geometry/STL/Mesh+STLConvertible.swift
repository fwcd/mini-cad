import Foundation

extension Mesh: STLConvertible {
    var asAsciiStl: String {
        let name = "mesh"
        // TODO: Compute proper normals
        return
            """
            solid \(name)
            \(faces.map { face in
            """
                facet normal \(normal(for: face).asAsciiStl)
                    outer loop
                        vertex \(vertices[face.a].asAsciiStl)
                        vertex \(vertices[face.b].asAsciiStl)
                        vertex \(vertices[face.c].asAsciiStl)
                    endloop
                endfacet
            """
            }.joined(separator: "\n"))
            endsolid \(name)
            """
    }
    var asBinaryStl: Data {
        var data = Data()
        var header = "exported from MiniSlice".data(using: .utf8)!
        header += Data(count: 80 - header.count)
        data.append(unsafeBytesOf: UInt32(faces.count).littleEndian)
        for face in faces {
            data += normal(for: face).asBinaryStl
            data += vertices[face.a].asBinaryStl
            data += vertices[face.b].asBinaryStl
            data += vertices[face.c].asBinaryStl
            data += Data(count: 2) // Attribute byte count, we don't use this
        }
        return data
    }
}

extension Array: STLConvertible where Element == Mesh {
    var asAsciiStl: String {
        reduce(Mesh()) { $0.disjointUnion($1) }.asAsciiStl
    }
    var asBinaryStl: Data {
        reduce(Mesh()) { $0.disjointUnion($1) }.asBinaryStl
    }
}
