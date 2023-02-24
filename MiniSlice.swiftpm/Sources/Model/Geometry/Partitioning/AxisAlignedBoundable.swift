protocol AxisAlignedBoundable {
    func containedBy(aabb: AxisAlignedBoundingBox) -> Bool
}

extension AxisAlignedBoundingBox {
    func contains<T>(_ value: T) -> Bool where T: AxisAlignedBoundable {
        value.containedBy(aabb: self)
    }
}
