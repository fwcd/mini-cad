/// A 3D polygon mesh represented as a set of triangular faces.
struct Mesh: Hashable {
    var vertices: [Vec3] = []
    var faces: [Face] = []
    
    /// A triangular face defined by its 3 vertex indices.
    struct Face: Hashable {
        let a: Int
        let b: Int
        let c: Int
    }
}
