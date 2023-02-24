struct AxisAlignedBoundingBox: Hashable {
    var corner: Vec3 = Vec3(all: -0.5)
    var size: Vec3 = Vec3(all: 1)
    
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
    
    func fullyContains(_ triangle: Triangle) -> Bool {
        contains(triangle.a) && contains(triangle.b) && contains(triangle.c)
    }
    
    func contains(_ point: Vec3) -> Bool {
        point >= bottomLeft && point < topRight
    }
}
