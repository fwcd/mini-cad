extension Triangle: AxisAlignedContainable {
    func containedBy(aabb: AxisAlignedBoundingBox) -> Bool {
        a.containedBy(aabb: aabb) && b.containedBy(aabb: aabb) && c.containedBy(aabb: aabb)
    }
}
