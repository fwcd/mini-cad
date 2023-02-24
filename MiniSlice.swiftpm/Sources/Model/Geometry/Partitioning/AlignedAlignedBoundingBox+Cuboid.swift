extension AxisAlignedBoundingBox {
    init(_ cuboid: Cuboid) {
        self.init(corner: cuboid.center - (cuboid.size / 2), size: cuboid.size)
    }
}

extension Cuboid {
    init(_ aabb: AxisAlignedBoundingBox) {
        self.init(center: aabb.center, size: aabb.size)
    }
}
