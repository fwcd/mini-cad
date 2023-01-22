// TODO: Use a more generic "Mesh" type (instead of a cuboid)

struct Cuboid: Hashable {
    var center: Vec3 = .zero
    var size: Vec3 = .init(x: 1, y: 1, z: 1)
}
