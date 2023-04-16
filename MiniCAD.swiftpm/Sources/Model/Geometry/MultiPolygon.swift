/// A flat/planar polygon in 3D space with multiple paths.
struct MultiPolygon {
    var paths: [Polygon] = []
    
    /// The polygon with flipped orientation.
    var flipped: Self {
        Self(paths: paths.map(\.flipped))
    }
    
    /// Flips the orientation of the polygon.
    mutating func flip() {
        self = flipped
    }
}
