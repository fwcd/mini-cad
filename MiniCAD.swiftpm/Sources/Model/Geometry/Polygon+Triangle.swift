extension Polygon {
    init(_ triangle: Triangle) {
        self.init(vertices: [triangle.a, triangle.b, triangle.c])
    }
}
