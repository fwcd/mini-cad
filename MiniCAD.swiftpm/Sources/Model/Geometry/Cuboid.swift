/// A 3D cuboid.
struct Cuboid: Hashable {
    var center: Vec3 = .zero
    var size: Vec3 = .init(x: 2, y: 2, z: 2)
}

extension Mesh {
    init(_ cuboid: Cuboid) {
        let radius = cuboid.size / 2
        let vertices = [
            Vec3(x: -radius.x, y: -radius.y, z: -radius.z),
            Vec3(x: -radius.x, y: -radius.y, z:  radius.z),
            Vec3(x: -radius.x, y:  radius.y, z: -radius.z),
            Vec3(x: -radius.x, y:  radius.y, z:  radius.z),
            Vec3(x:  radius.x, y: -radius.y, z: -radius.z),
            Vec3(x:  radius.x, y: -radius.y, z:  radius.z),
            Vec3(x:  radius.x, y:  radius.y, z: -radius.z),
            Vec3(x:  radius.x, y:  radius.y, z:  radius.z),
        ]
        let faces = [
            // negative x
            Mesh.Face(a: 0, b: 1, c: 3),
            Mesh.Face(a: 0, b: 3, c: 2),
            // positive x
            Mesh.Face(a: 6, b: 7, c: 5),
            Mesh.Face(a: 6, b: 5, c: 4),
            // negative y
            Mesh.Face(a: 4, b: 5, c: 1),
            Mesh.Face(a: 4, b: 1, c: 0),
            // positive y
            Mesh.Face(a: 2, b: 3, c: 7),
            Mesh.Face(a: 2, b: 7, c: 6),
            // negative z
            Mesh.Face(a: 6, b: 4, c: 0),
            Mesh.Face(a: 6, b: 0, c: 2),
            // positive z
            Mesh.Face(a: 5, b: 7, c: 3),
            Mesh.Face(a: 5, b: 3, c: 1),
        ]
        self.init(vertices: vertices, faces: faces)
        self += cuboid.center
    }
}
