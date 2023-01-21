// TODO: Use a more generic "Mesh" type (instead of a cuboid)

struct Cuboid: Hashable {
    let center: Vec3 = .zero
    let size: Vec3 = .init(x: 1, y: 1, z: 1)
}
