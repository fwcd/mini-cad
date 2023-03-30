extension Vec3: AxisAlignedContainable {
    func containedBy(aabb: AxisAlignedBoundingBox) -> Bool {
        self >= aabb.bottomLeft && self <= aabb.topRight
    }
}
