import Foundation
import OSLog

private let log = Logger(subsystem: "MiniCAD", category: "BuiltIns")

/// The built-in functions.
let builtInFunctions: [String: ([Value], [Value]) throws -> [Value]] = [
    // TODO: Should we pass vector/tuple-ish types?
    "Cuboid": { args, _ in
        let size = parseVec3(from: args, default: .init(x: 1, y: 1, z: 1))
        return [.mesh(Mesh(Cuboid(size: size)))]
    },
    "Cylinder": { args, _ in
        let radius = args[safely: 0]?.asFloat ?? 1
        let height = args[safely: 1]?.asFloat ?? 1
        let sides = args[safely: 2]?.asInt ?? 8
        return [.mesh(Mesh(Cylinder(radius: radius, height: height, sides: sides)))]
    },
    "Sphere": { args, _ in
        let radius = args[safely: 0]?.asFloat ?? 1
        let latSteps = args[safely: 1]?.asInt ?? 8
        let lonSteps = args[safely: 2]?.asInt ?? 8
        return [.mesh(Mesh(Sphere(radius: radius, latitudeSteps: latSteps, longitudeSteps: lonSteps)))]
    },
    "Suzanne": { _, _ in
        guard let url = Bundle.main.url(forResource: "Suzanne", withExtension: "stl") else {
            log.error("Could not fetch bundle URL for suzanne")
            return []
        }
        guard let data = try? Data(contentsOf: url) else {
            log.error("Could not decode suzanne STL data")
            return []
        }
        do {
            let mesh = try Mesh(binaryStl: data)
            return [.mesh(mesh)]
        } catch {
            log.error("Could not decode suzanne STL mesh: \(error)")
            return []
        }
    },
    "Text": { args, _ in
        let content = args[safely: 0]?.asString ?? ""
        return [.mesh(Mesh(TextLabel(content: content)))]
    },
    "Octree": { args, trailingBlock in
        let maxDepth = args[safely: 0]?.asInt ?? 8
        let mesh = trailingBlock.compactMap(\.asMesh).disjointUnion
        let aabb = mesh.boundingBox
        let octree = Octree(mesh: mesh, aabb: aabb, maxDepth: maxDepth)
        return [.mesh(Mesh(octree: octree, aabb: aabb))]
    },
    "BoundingBox": { args, trailingBlock in
        let mesh = trailingBlock.compactMap(\.asMesh).disjointUnion
        return [.mesh(Mesh(Cuboid(mesh.boundingBox)))]
    },
    "PolygonRoundtrip": { args, trailingBlock in
        let mesh = trailingBlock.compactMap(\.asMesh).disjointUnion
        return [.mesh(Mesh(mesh.facePolygons))]
    },
    "BSPRoundtrip": { args, trailingBlock in
        let mesh = trailingBlock.compactMap(\.asMesh).disjointUnion
        let bsp = BinarySpacePartitioning(inserting: mesh.facePolygons)
        return [.mesh(Mesh(bsp.allPolygons))]
    },
    "Translate": { args, trailingBlock in
        let offset = parseVec3(from: args)
        let meshes = trailingBlock.compactMap(\.asMesh)
        return meshes.map { .mesh($0 + offset) }
    },
    "Union": { _, trailingBlock in
        let meshes = trailingBlock.compactMap(\.asMesh)
        guard let first = meshes.first else { return [.mesh(Mesh())] }
        return [.mesh(meshes[1...].reduce(first) { $0.union($1) })]
    },
    "Intersection": { _, trailingBlock in
        let meshes = trailingBlock.compactMap(\.asMesh)
        guard let first = meshes.first else { return [.mesh(Mesh())] }
        return [.mesh(meshes[1...].reduce(first) { $0.intersection($1) })]
    },
    "Difference": { _, trailingBlock in
        let meshes = trailingBlock.compactMap(\.asMesh)
        guard let first = meshes.first else { return [.mesh(Mesh())] }
        return [.mesh(meshes[1...].reduce(first) { $0.subtracting($1) })]
    },
    "Float": { args, _ in
        guard let x = args[safely: 0]?.asInt else {
            throw InterpretError.invalidArguments("Float", expected: "1 int", actual: "\(args)")
        }
        return [.float(Double(x))]
    },
    "Int": { args, _ in
        guard let x = args[safely: 0]?.asFloat else {
            throw InterpretError.invalidArguments("Int", expected: "1 float", actual: "\(args)")
        }
        return [.int(Int(x))]
    },
    "sin": unaryFloatOperator(name: "sin", sin),
    "cos": unaryFloatOperator(name: "cos", cos),
    "exp": unaryFloatOperator(name: "exp", exp),
    "log": unaryFloatOperator(name: "log", Foundation.log),
    "sqrt": unaryFloatOperator(name: "sqrt", sqrt),
]

private func parseVec3(from args: [Value], default: Vec3 = .zero) -> Vec3 {
    Vec3(
        x: args[safely: 0]?.asFloat ?? `default`.x,
        y: args[safely: 1]?.asFloat ?? `default`.y,
        z: args[safely: 2]?.asFloat ?? `default`.z
    )
}
