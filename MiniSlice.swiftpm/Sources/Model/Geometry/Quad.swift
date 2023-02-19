/// A 3D quadrilateral defined by its four vertices.
struct Quad: Hashable {
    let a: Vec3
    let b: Vec3
    let c: Vec3
    let d: Vec3
}

extension Mesh {
    init(_ quad: Quad) {
        self.init(
            vertices: [quad.a, quad.b, quad.c, quad.d],
            faces: [
                .init(a: 0, b: 2, c: 1),
                .init(a: 0, b: 3, c: 2),
            ]
        )
    }
}
