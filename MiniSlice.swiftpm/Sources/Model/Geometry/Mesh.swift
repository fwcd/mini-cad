/// A 3D polygon mesh represented as a set of triangular faces.
struct Mesh: Hashable {
    var vertices: [Vec3] = []
    var faces: [Face] = []
    
    // TODO: Investigate whether we need to make this more efficient by avoiding the intermediate arrays
    
    /// A flat representation of the faces.
    var facesFlat: [Int] { faces.flatMap { [$0.a, $0.b, $0.c] } }
    
    /// A triangular face defined by its 3 vertex indices. Per standard convention, the vertices are wound in counter-clockwise order (from the viewing direction).
    struct Face: Hashable {
        let a: Int
        let b: Int
        let c: Int
        
        static func +(lhs: Self, rhs: Int) -> Self {
            Self(a: lhs.a + rhs, b: lhs.b + rhs, c: lhs.c + rhs)
        }
    }
    
    static func +(lhs: Self, rhs: Vec3) -> Self {
        Self(vertices: lhs.vertices.map { $0 + rhs }, faces: lhs.faces)
    }
    
    static func +=(lhs: inout Self, rhs: Vec3) {
        for i in lhs.vertices.indices {
            lhs.vertices[i] += rhs
        }
    }
    
    func union(_ rhs: Self) -> Self {
        Mesh(
            vertices: vertices + rhs.vertices,
            faces: faces + rhs.faces.map { $0 + faces.count }
        )
    }
}
