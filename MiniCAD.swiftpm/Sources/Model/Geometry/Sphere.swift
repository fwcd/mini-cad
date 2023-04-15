import Foundation

/// A 3D sphere.
struct Sphere: Hashable {
    var center: Vec3 = .zero
    var radius: Double = 0.5
    var latitudeSteps: Int = GeometryDefaults.circleSides
    var longitudeSteps: Int = GeometryDefaults.circleSides
}

extension Mesh {
    init(_ sphere: Sphere) {
        let radius = sphere.radius
        let latSteps = sphere.latitudeSteps
        let lonSteps = sphere.longitudeSteps
        
        let vertices = (0..<latSteps).flatMap { i in
            (0..<lonSteps).map { j in
                let lat = (Double(i) / Double(latSteps - 1)) * .pi
                let lon = (Double(j) / Double(lonSteps - 1)) * 2 * .pi
                let r = sin(lat) * radius
                return Vec3(
                    x: cos(lon) * r,
                    y: cos(lat) * radius,
                    z: sin(lon) * r
                )
            }
        }
        let faces: [Mesh.Face] = (1..<latSteps).flatMap { i -> [Mesh.Face] in
            (0..<lonSteps).flatMap { j -> [Mesh.Face] in
                [
                    Mesh.Face(
                        a: (i - 1) * lonSteps + (j + 1) % lonSteps,
                        b: i * lonSteps + (j + 1) % lonSteps,
                        c: i * lonSteps + j % lonSteps
                    ),
                    Mesh.Face(
                        a: (i - 1) * lonSteps + (j + 1) % lonSteps,
                        b: i * lonSteps + j % lonSteps,
                        c: (i - 1) * lonSteps + j % lonSteps
                    ),
                ]
            }
        }
        
        self.init(vertices: vertices, faces: faces)
        self += sphere.center
    }
}
