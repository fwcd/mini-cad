extension Mesh: STLConvertible {
    var asSTL: String {
        let name = "mesh"
        // TODO: Compute proper normals
        return
            """
            solid \(name)
            \(faces.map { face in
            """
                facet normal \((vertices[face.a] - vertices[face.b]).cross(vertices[face.c] - vertices[face.b]).normalized.asSTL)
                    outer loop
                        vertex \(vertices[face.a].asSTL)
                        vertex \(vertices[face.b].asSTL)
                        vertex \(vertices[face.c].asSTL)
                    endloop
                endfacet
            """
            }.joined(separator: "\n"))
            endsolid \(name)
            """
    }
}

extension Array: STLConvertible where Element == Mesh {
    var asSTL: String {
        reduce(Mesh()) { $0.disjointUnion($1) }.asSTL
    }
}
