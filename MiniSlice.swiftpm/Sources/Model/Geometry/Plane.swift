/// The infinite plane spanned by three linearly independent points. By convention this uses the counter-clockwise winding order known from rendered triangles too.
struct Plane: Hashable {
    var a: Vec3
    var b: Vec3
    var c: Vec3
    
    var normal: Vec3 {
        (a - b).cross(c - b)
    }
}
