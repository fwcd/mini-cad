import Foundation

/// A 3D cone. Can be used to represent pyramids, e.g. tetraeders when sides = 3.
struct Cone: Hashable {
    var center: Vec3 = .zero
    var radius: Double = 1
    var height: Double = 2
    var sides: Int = GeometryDefaults.circleSides
}

extension Mesh {
    init(_ cone: Cone) {
        let radius = cone.radius
        let sides = cone.sides
        let height = cone.height
        
        let baseVertices = [.zero] + (0..<sides)
            .map { i -> Double in 2 * .pi * Double(i) / Double(sides) }
            .map { theta in Vec3(x: cos(theta) * radius, z: sin(theta) * radius) }
        let bottomVertices = baseVertices.map { $0 - Vec3(y: height / 2) }
        let topVertex = Vec3(y: height / 2)
        
        let baseFaces = (0..<sides).map { i in Mesh.Face(a: 0, b: i + 1, c: (i + 1) % sides + 1) }
        let sideFaces = (0..<sides).flatMap { i in
            let a = i + 1
            let b = (i + 1) % sides + 1
            let top = baseVertices.count
            return [
                Mesh.Face(a: a, b: top, c: b),
            ]
        }
        
        let vertices = bottomVertices + [topVertex]
        let faces = baseFaces + sideFaces
        
        self.init(vertices: vertices, faces: faces)
        self += cone.center
    }
}
