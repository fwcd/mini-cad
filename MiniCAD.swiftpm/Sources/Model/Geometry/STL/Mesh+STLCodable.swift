import Foundation

extension Mesh: STLEncodable {
    var asAsciiStl: String {
        let name = "mesh"
        return
            """
            solid \(name)
            \(faces.map { face in
            """
                facet normal \(unitNormal(for: face).asAsciiStl)
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
        var header = "exported from MiniCAD".data(using: .utf8)!
        header += Data(count: 80 - header.count)
        data += header
        data.append(unsafeBytesOf: UInt32(faces.count).littleEndian)
        for face in faces {
            data += unitNormal(for: face).asBinaryStl
            data += vertices[face.a].asBinaryStl
            data += vertices[face.b].asBinaryStl
            data += vertices[face.c].asBinaryStl
            data += Data(count: 2) // Attribute byte count, we don't use this
        }
        return data
    }
}

extension Mesh: STLDecodable {
    init(binaryStl data: Data) throws {
        let faceBytes = 50
        let vecBytes = 12
        let attributeBytes = 2
        
        var data = data.dropFirst(80)
        let count = data.withUnsafeBytes { ptr in
            Int(UInt32(littleEndian: ptr.loadUnaligned(as: UInt32.self)))
        }
        data = data.dropFirst(4)
        guard data.count == count * faceBytes else {
            throw STLDecodeError.countDoesNotMatchSize
        }
        
        var vertices = [Vec3]()
        var vertexMapping = [Vec3: Int]()
        var faces = [Face]()
        
        func append(vertex: Vec3) -> Int {
            if let i = vertexMapping[vertex] {
                return i
            } else {
                let i = vertices.count
                vertices.append(vertex)
                vertexMapping[vertex] = i
                return i
            }
        }
        
        for _ in 0..<count {
            _ = try Vec3(binaryStl: data) // We ignore the normal for now
            data = data.dropFirst(vecBytes)
            let a = try Vec3(binaryStl: data)
            data = data.dropFirst(vecBytes)
            let b = try Vec3(binaryStl: data)
            data = data.dropFirst(vecBytes)
            let c = try Vec3(binaryStl: data)
            data = data.dropFirst(vecBytes + attributeBytes)
            let aIndex = append(vertex: a)
            let bIndex = append(vertex: b)
            let cIndex = append(vertex: c)
            faces.append(.init(a: aIndex, b: bIndex, c: cIndex))
        }
        
        assert(data.isEmpty)
        
        self.init(vertices: vertices, faces: faces)
    }
}

extension Array: STLEncodable where Element == Mesh {
    var asAsciiStl: String {
        disjointUnion.asAsciiStl
    }
    var asBinaryStl: Data {
        disjointUnion.asBinaryStl
    }
}
