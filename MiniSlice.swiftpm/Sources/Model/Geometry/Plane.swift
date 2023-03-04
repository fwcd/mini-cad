/// The infinite plane spanned by three linearly independent points. By convention this uses the counter-clockwise winding order known from rendered triangles too.
struct Plane: Hashable {
    var a: Vec3
    var b: Vec3
    var c: Vec3
    
    /// The normal vector indicating the orientation of the plane.
    var normal: Vec3 {
        (a - b).cross(c - b)
    }
    
    /// Normalizes the spanning vectors (a - b) and (c - b) to unit length. Causes the normal to be a unit normal too.
    var normalized: Self {
        let d1 = (a - b).normalized
        let d2 = (c - b).normalized
        return Self(a: b + d1, b: b, c: b + d2)
    }
}
