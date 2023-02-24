extension Mesh: STLConvertible {
    var asAsciiStl: String {
        let name = "mesh"
        // TODO: Compute proper normals
        return
            """
            solid \(name)
            \(faces.map { face in
            """
                facet normal \((vertices[face.a] - vertices[face.b]).cross(vertices[face.c] - vertices[face.b]).normalized.asAsciiStl)
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
}

extension Array: STLConvertible where Element == Mesh {
    var asAsciiStl: String {
        reduce(Mesh()) { $0.disjointUnion($1) }.asAsciiStl
    }
}
