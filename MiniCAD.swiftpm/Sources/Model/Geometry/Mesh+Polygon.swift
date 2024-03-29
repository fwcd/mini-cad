import OSLog

private let log = Logger(subsystem: "MiniCAD", category: "Mesh+Polygon")

private struct AnnotatedVertex {
    var position: Vec3
    var isConvex: Bool
}

extension AnnotatedVertex {
    init(predecessor: Vec3, position: Vec3, successor: Vec3, plane: Plane) {
        let d1 = predecessor - position
        let d2 = successor - position
        let d = d1.cross(d2).dot(plane.normal) // Plane is assumed to be normalized
        self.init(position: position, isConvex: d > 0)
    }
}

extension Mesh {
    var facePolygons: [Polygon] {
        faceTriangles.map { Polygon($0) }
    }
    
    /// Creates a planar mesh by triangulating the given polygon.
    init(_ polygon: Polygon) {
        assert(polygon.vertices.count >= 3)
        let vertices = polygon.vertices
        let plane = Plane(polygon).normalized // 'Fit' a plane
        
        // Triangulate the polygon using ear clipping (i.e. by repeatedly pruning "ears" = sets of 3 consecutive, convex vertices)
        // Loosely based on https://wiki.delphigl.com/index.php/Ear_Clipping_Triangulierung
        
        var remaining = Array(vertices.enumerated())
        var faces: [Face] = []
        
        outer:
        while remaining.count > 3 {
            for i in 0..<remaining.count {
                let i0 = i
                let i1 = (i + 1) % remaining.count
                let i2 = (i + 2) % remaining.count
                let (j0, p0) = remaining[i0]
                let (j1, p1) = remaining[i1]
                let (j2, p2) = remaining[i2]
                
                let d0 = p0 - p1
                let d2 = p2 - p1
                let d = d0.cross(d2).dot(plane.normal)
                let isConvex = d >= 0
                
                if isConvex {
                    let triangle = Triangle(a: p0, b: p1, c: p2)
                    if !remaining.enumerated().contains(where: { ($0.offset != i0 && $0.offset != i1 && $0.offset != i2 ) && triangle.contains($0.element.element) }) {
                        faces.append(.init(a: j0, b: j1, c: j2))
                        remaining.remove(at: i1)
                        continue outer
                    }
                }
            }
            
            // TODO: We should probably do a throwing initializer instead
            log.error("Could not cut ear from \(String(describing: remaining.map(\.element))), no convex vertices found.")
            break
        }
        
        faces.append(.init(a: remaining[0].offset, b: remaining[1].offset, c: remaining[2].offset))
        
        self.init(vertices: vertices, faces: faces)
    }
    
    /// Creates a mesh by triangulating and merging the given polygons.
    init(_ polygons: [Polygon]) {
        let triangulatedFaceMeshes = polygons
            .map { $0.mergingCloseVertices() }
            .filter { $0.vertices.count >= 3 }
            .map { Mesh($0) }
        self = triangulatedFaceMeshes.disjointUnion
    }
}
