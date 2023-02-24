/// A 3D triangle defined by its three vertices.
struct Triangle: Hashable {
    var a: Vec3
    var b: Vec3
    var c: Vec3
}

extension Mesh {
    init(_ tri: Triangle) {
        self.init(
            vertices: [tri.a, tri.b, tri.c],
            faces: [
                .init(a: 0, b: 1, c: 2),
            ]
        )
    }
    
    func triangle(for face: Face) -> Triangle {
        Triangle(
            a: vertices[face.a],
            b: vertices[face.b],
            c: vertices[face.c]
        )
    }
}
