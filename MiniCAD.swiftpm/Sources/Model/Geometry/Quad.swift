/// A 3D quadrilateral defined by its four vertices.
struct Quad: Hashable {
    var a: Vec3
    var b: Vec3
    var c: Vec3
    var d: Vec3
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
