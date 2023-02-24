protocol AxisAlignedContainable {
    func containedBy(aabb: AxisAlignedBoundingBox) -> Bool
}

extension AxisAlignedBoundingBox {
    func contains<T>(_ value: T) -> Bool where T: AxisAlignedContainable {
        value.containedBy(aabb: self)
    }
}
