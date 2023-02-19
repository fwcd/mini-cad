extension Mesh: STLConvertible {
    var asSTL: String {
        let name = "mesh"
        // TODO: Compute proper normals
        return """
            solid \(name)
            \(faces.map { face in """
                facet normal 0 0 0
                    outer loop
                        vertex \(vertices[face.a].asSTL)
                        vertex \(vertices[face.b].asSTL)
                        vertex \(vertices[face.c].asSTL)
                    endloop
                endfacet
            """ })
            endsolid \(name)
        """
    }
}
