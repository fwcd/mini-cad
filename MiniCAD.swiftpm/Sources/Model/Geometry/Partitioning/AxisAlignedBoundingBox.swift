struct AxisAlignedBoundingBox: Hashable {
    static let zero: AxisAlignedBoundingBox = .init()
    
    var corner: Vec3 = .zero
    var size: Vec3 = .zero
    
    var volume: Double { size.x * size.y * size.z }
    
    var radius: Vec3 {
        get { size / 2 }
        set { size = newValue * 2 }
    }
    
    var bottomLeft: Vec3 {
        get { corner }
        set { corner = newValue }
    }
    
    var topRight: Vec3 {
        get { corner + size }
        set { corner = newValue - size }
    }
    
    var center: Vec3 {
        get { corner + radius }
        set { corner = newValue - radius }
    }
    
    var octants: [AxisAlignedBoundingBox] {
        let r = radius
        return [
            AxisAlignedBoundingBox(corner: corner,                                size: radius),
            AxisAlignedBoundingBox(corner: corner + Vec3(x: 0,   y: 0,   z: r.z), size: radius),
            AxisAlignedBoundingBox(corner: corner + Vec3(x: 0,   y: r.y, z: 0),   size: radius),
            AxisAlignedBoundingBox(corner: corner + Vec3(x: 0,   y: r.y, z: r.z), size: radius),
            AxisAlignedBoundingBox(corner: corner + Vec3(x: r.x, y: 0,   z: 0),   size: radius),
            AxisAlignedBoundingBox(corner: corner + Vec3(x: r.x, y: 0,   z: r.z), size: radius),
            AxisAlignedBoundingBox(corner: corner + Vec3(x: r.x, y: r.y, z: 0),   size: radius),
            AxisAlignedBoundingBox(corner: corner + Vec3(x: r.x, y: r.y, z: r.z), size: radius),
        ]
    }
}
