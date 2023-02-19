/// A 3D polygon mesh represented as a set of triangular faces.
struct Mesh: Hashable {
    var vertices: [Vec3] = []
    var faces: [Face] = []
    
    // TODO: Investigate whether we need to make this more efficient by avoiding the intermediate arrays
    
    /// A flat representation of the faces.
    var facesFlat: [Int] { faces.flatMap { [$0.a, $0.b, $0.c] } }
    
    /// A triangular face defined by its 3 vertex indices.
    struct Face: Hashable {
        let a: Int
        let b: Int
        let c: Int
    }
}
