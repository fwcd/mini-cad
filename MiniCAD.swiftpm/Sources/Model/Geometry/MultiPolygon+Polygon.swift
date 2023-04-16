extension MultiPolygon {
    init(_ polygon: Polygon) {
        self.init(paths: [polygon])
    }
}
