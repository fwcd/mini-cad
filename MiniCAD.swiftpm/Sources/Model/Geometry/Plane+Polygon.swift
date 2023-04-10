extension Plane {
    init(_ polygon: Polygon) {
        assert(polygon.vertices.count >= 3, "Cannot construct plane from polygon with fewer than 3 vertices")
        self.init(a: polygon.vertices[0], b: polygon.vertices[1], c: polygon.vertices[2])
    }
}
