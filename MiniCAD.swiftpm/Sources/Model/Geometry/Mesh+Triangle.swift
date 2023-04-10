extension Mesh {
    init(_ faceTriangles: [Triangle], epsilon: Double = 0.001) {
        // TODO: Use an efficient space-partitioning map (e.g. an octree)
        var vertices: [Vec3] = []
        var faces: [Face] = []
        
        func append(vertex: Vec3) -> Int {
            if let i = vertices.firstIndex(where: { ($0 - vertex).magnitude < epsilon }) {
                return i
            } else {
                let i = vertices.count
                vertices.append(vertex)
                return i
            }
        }
        
        for triangle in faceTriangles {
            let aIndex = append(vertex: triangle.a)
            let bIndex = append(vertex: triangle.b)
            let cIndex = append(vertex: triangle.c)
            faces.append(.init(a: aIndex, b: bIndex, c: cIndex))
        }
        
        self.init(vertices: vertices, faces: faces)
    }
}
