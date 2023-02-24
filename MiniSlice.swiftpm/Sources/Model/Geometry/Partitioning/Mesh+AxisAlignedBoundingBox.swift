extension Mesh {
    var boundingBox: AxisAlignedBoundingBox {
        guard let first = vertices.first else { return .zero }
        let bottomLeft = vertices.reduce(first) { $0.min($1) }
        let topRight = vertices.reduce(first) { $0.max($1) }
        let size = topRight - bottomLeft
        return .init(corner: bottomLeft, size: size)
    }
}
