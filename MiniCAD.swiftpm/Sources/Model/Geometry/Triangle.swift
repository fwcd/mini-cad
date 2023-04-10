/// A 3D triangle defined by its three vertices.
struct Triangle: Hashable {
    var a: Vec3
    var b: Vec3
    var c: Vec3
    
    /// The normal vector indicating the orientation of the triangle.
    var normal: Vec3 {
        (a - b).cross(c - b)
    }
    
    /// Converts the given point (within the triangle) from Cartesian to barycentric coordinates.
    func toBarycentric(point: Vec3) -> Vec3 {
        let d1 = a - b
        let d2 = c - b
        let det = d1.x * d2.y - d2.x * d1.y
        let diff = point - b
        let lambda1 = ((c.y - b.y) * diff.x + (b.x - c.x) * diff.y) / det
        let lambda3 = ((b.y - a.y) * diff.x + (a.x - b.x) * diff.y) / det
        let lambda2 = 1 - lambda1 - lambda3
        return Vec3(x: lambda1, y: lambda2, z: lambda3)
    }
    
    /// Whether triangle contains the given point (asummed to be on the plane).
    func contains(_ point: Vec3) -> Bool {
        let barycentric = toBarycentric(point: point)
        return barycentric >= .zero
    }
}
