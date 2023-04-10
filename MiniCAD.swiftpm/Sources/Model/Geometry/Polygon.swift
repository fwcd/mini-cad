/// A flat/planar polygon in 3D space (i.e. all the points are assumed lie within a plane). By convention this uses the counter-clockwise winding order known from rendered triangles too.
struct Polygon {
    var vertices: [Vec3] = []
    
    /// The polygon with flipped orientation.
    var flipped: Self {
        Self(vertices: vertices.reversed())
    }
    
    /// Flips the orientation of the polygon.
    mutating func flip() {
        self = flipped
    }
}
