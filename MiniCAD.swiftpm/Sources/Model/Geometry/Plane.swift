/// The infinite plane spanned by three linearly independent points. By convention this uses the counter-clockwise winding order known from rendered triangles too.
struct Plane: Hashable {
    var a: Vec3
    var b: Vec3
    var c: Vec3
    
    /// The normal vector indicating the orientation of the plane.
    var normal: Vec3 {
        (a - b).cross(c - b)
    }
    
    /// The unit normal vector of the plane.
    var unitNormal: Vec3 {
        normal.normalized
    }
    
    /// Normalizes the spanning vectors (a - b) and (c - b) to unit length. Causes the normal to be a unit normal too.
    var normalized: Self {
        let d1 = (a - b).normalized
        let d2 = (c - b).normalized
        return Self(a: b + d1, b: b, c: b + d2)
    }
    
    /// The flipped plane.
    var flipped: Self {
        Self(a: c, b: b, c: a)
    }
    
    /// Projects the given point onto the plane.
    func project(_ point: Vec3) -> Vec3 {
        let unitNormal = self.unitNormal
        return point - (point - b).dot(unitNormal) * unitNormal
    }
    
    /// Flips the orientation of the plane.
    mutating func flip() {
        self = flipped
    }
}
