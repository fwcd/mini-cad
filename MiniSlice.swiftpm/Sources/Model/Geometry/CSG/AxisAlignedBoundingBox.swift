struct AxisAlignedBoundingBox: Hashable {
    var corner: Vec3
    var size: Vec3
    
    var radius: Vec3 {
        size / 2
    }
    
    var volume: Double {
        size.x * size.y * size.z
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
