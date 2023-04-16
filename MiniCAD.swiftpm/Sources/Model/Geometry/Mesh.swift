/// A 3D polygon mesh represented as a set of triangular faces.
struct Mesh: Hashable {
    static let zero = Self()
    
    var vertices: [Vec3] = []
    var faces: [Face] = []
    
    // TODO: Investigate whether we need to make this more efficient by avoiding the intermediate arrays
    
    /// A flat representation of the faces.
    var facesFlat: [Int] { faces.flatMap { [$0.a, $0.b, $0.c] } }
    
    /// The mesh with flipped faces.
    var flipped: Self {
        var mesh = self
        mesh.faces = mesh.faces.map(\.flipped)
        return mesh
    }
    
    /// A triangular face defined by its 3 vertex indices. Per standard convention, the vertices are wound in counter-clockwise order (from the viewing direction).
    struct Face: Hashable {
        let a: Int
        let b: Int
        let c: Int
        
        /// The face with its winding order/orientation flipped.
        var flipped: Self {
            Self(a: a, b: c, c: b)
        }
        
        static func +(lhs: Self, rhs: Int) -> Self {
            Self(a: lhs.a + rhs, b: lhs.b + rhs, c: lhs.c + rhs)
        }
    }
    
    func mapVertices(_ f: (Vec3) -> Vec3) -> Self {
        var mesh = self
        mesh.vertices = mesh.vertices.map(f)
        return mesh
    }
    
    static func +(lhs: Self, rhs: Vec3) -> Self {
        Self(vertices: lhs.vertices.map { $0 + rhs }, faces: lhs.faces)
    }
    
    static func +=(lhs: inout Self, rhs: Vec3) {
        for i in lhs.vertices.indices {
            lhs.vertices[i] += rhs
        }
    }
    
    func unitNormal(for face: Face) -> Vec3 {
        (vertices[face.a] - vertices[face.b]).cross(vertices[face.c] - vertices[face.b]).normalized
    }
    
    func disjointUnion(_ rhs: Self) -> Self {
        Mesh(
            vertices: vertices + rhs.vertices,
            faces: faces + rhs.faces.map { $0 + vertices.count }
        )
    }
    
    /// Extrudes this mesh (assuming it is planar).
    func planarExtrude(by delta: Vec3) -> Self {
        let extrudedVertices = vertices.map { $0 + delta }
        let newVertices = vertices + extrudedVertices
        let topDownFaces = faces + faces.map { ($0 + vertices.count).flipped }
        let sideFaces = vertices.indices.flatMap { i in [
            Mesh.Face(a: i, b: (i + 1) % vertices.count + vertices.count, c: i + vertices.count),
            Mesh.Face(a: i, b: (i + 1) % vertices.count, c: (i + 1) % vertices.count + vertices.count),
        ].map(\.flipped) }
        // TODO: We might need to flip them depending on the extrusion orientation
        let newFaces = topDownFaces + sideFaces
        return Self(vertices: newVertices, faces: newFaces)
    }
}

extension Sequence where Element == Mesh {
    var disjointUnion: Mesh {
        reduce(Mesh()) { $0.disjointUnion($1) }
    }
}
