import Foundation

/// The built-in constants
let builtInConstants: [String: [Value]] = [
    "PI": [.float(.pi)],
    "TAU": [.float(2 * .pi)],
]

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
    "Translate": { args, trailingBlock in
        let offset = parseVec3(from: args)
        let meshes = trailingBlock.compactMap(\.asMesh)
        return meshes.map { .mesh($0 + offset) }
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
    "sin": { args, _ in
        guard let x = args[safely: 0]?.asFloat else {
            throw InterpretError.invalidArguments("sin", expected: "1 float", actual: "\(args)")
        }
        return [.float(sin(x))]
    },
    "cos": { args, _ in
        guard let x = args[safely: 0]?.asFloat else {
            throw InterpretError.invalidArguments("cos", expected: "1 float", actual: "\(args)")
        }
        return [.float(cos(x))]
    },
    "exp": { args, _ in
        guard let x = args[safely: 0]?.asFloat else {
            throw InterpretError.invalidArguments("exp", expected: "1 float", actual: "\(args)")
        }
        return [.float(exp(x))]
    },
    "log": { args, _ in
        guard let x = args[safely: 0]?.asFloat else {
            throw InterpretError.invalidArguments("log", expected: "1 float", actual: "\(args)")
        }
        return [.float(log(x))]
    },
    "sqrt": { args, _ in
        guard let x = args[safely: 0]?.asFloat else {
            throw InterpretError.invalidArguments("sqrt", expected: "1 float", actual: "\(args)")
        }
        return [.float(sqrt(x))]
    },
]

private func parseVec3(from args: [Value], default: Vec3 = .zero) -> Vec3 {
    Vec3(
        x: args[safely: 0]?.asFloat ?? `default`.x,
        y: args[safely: 1]?.asFloat ?? `default`.y,
        z: args[safely: 2]?.asFloat ?? `default`.z
    )
}
