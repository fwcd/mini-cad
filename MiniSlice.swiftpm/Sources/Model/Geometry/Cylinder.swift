import Foundation

/// A 3D cylinder.
struct Cylinder: Hashable {
    var center: Vec3 = .zero
    var radius: Double = 1
    var height: Double = 1
    var sides: Int = 8
}

extension Mesh {
    init(_ cylinder: Cylinder) {
        let radius = cylinder.radius
        let sides = cylinder.sides
        let height = cylinder.height
        
        let baseVertices = [.zero] + (0..<sides)
            .map { i -> Double in 2 * .pi * Double(i) / Double(sides) }
            .map { theta in Vec3(x: cos(theta) * radius, z: sin(theta) * radius) }
        let topVertices = baseVertices.map { $0 + Vec3(y: height) }
        
        let baseFaces = (0..<sides).map { i -> Mesh.Face in .init(a: 0, b: i + 1, c: (i + 1) % sides + 1) }
        let topFaces = baseFaces.map { $0 + baseVertices.count }
        let sideFaces: [Mesh.Face] = [] // TODO: Generate side faces
        
        let vertices = baseVertices + topVertices
        let faces = baseFaces + topFaces + sideFaces
        
        self.init(vertices: vertices, faces: faces)
        self += cylinder.center
    }
}
