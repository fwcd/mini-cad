extension Vec3: AxisAlignedBoundable {
    func containedBy(aabb: AxisAlignedBoundingBox) -> Bool {
        self >= aabb.bottomLeft && self <= aabb.topRight
    }
}
