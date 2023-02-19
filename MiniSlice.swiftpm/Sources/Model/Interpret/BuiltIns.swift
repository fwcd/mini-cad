import Foundation

/// The built-in constants
let builtInConstants: [String: [Value]] = [
    "PI": [.float(.pi)],
    "TAU": [.float(2 * .pi)],
]

/// The built-in operators.
let builtInOperators: [BinaryOperator: ([Value], [Value]) throws -> [Value]] = [
    .add: binaryFloatOrIntOperator(name: "add", +, +), // TODO: Add string concatenation again
    .subtract: binaryFloatOrIntOperator(name: "subtract", -, -),
    .multiply: binaryFloatOrIntOperator(name: "multiply", *, *),
    .divide: binaryFloatOrIntOperator(name: "divide", /, /),
    .remainder: binaryIntOperator(name: "remainder", %),
    .equal: binaryValueOperator(name: "equal") { .bool($0 == $1) },
    .notEqual: binaryValueOperator(name: "notEqual") { .bool($0 != $1) },
    // TODO: Add logical and range operators
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
    "sin": unaryFloatOperator(name: "sin", sin),
    "cos": unaryFloatOperator(name: "cos", cos),
    "exp": unaryFloatOperator(name: "exp", exp),
    "log": unaryFloatOperator(name: "log", log),
    "sqrt": unaryFloatOperator(name: "sqrt", sqrt),
]

private func parseVec3(from args: [Value], default: Vec3 = .zero) -> Vec3 {
    Vec3(
        x: args[safely: 0]?.asFloat ?? `default`.x,
        y: args[safely: 1]?.asFloat ?? `default`.y,
        z: args[safely: 2]?.asFloat ?? `default`.z
    )
}

private func unaryFloatOperator(name: String, _ f: @escaping (Double) -> Double) -> ([Value], [Value]) throws -> [Value] {
    return { args, _ in
        guard let x = args[safely: 0]?.asFloat else {
            throw InterpretError.invalidArguments(name, expected: "1 float", actual: "\(args)")
        }
        return [.float(f(x))]
    }
}

private func binaryFloatOperator(name: String, _ f: @escaping (Double, Double) -> Double) -> ([Value], [Value]) throws -> [Value] {
    return { args, _ in
        guard let x = args[safely: 0]?.asFloat,
              let y = args[safely: 1]?.asFloat else {
            throw InterpretError.invalidArguments(name, expected: "2 floats", actual: "\(args)")
        }
        return [.float(f(x, y))]
    }
}

private func binaryFloatOrIntOperator(name: String, _ f: @escaping (Double, Double) -> Double, _ g: @escaping (Int, Int) -> Int) -> ([Value], [Value]) throws -> [Value] {
    return { args, _ in
        switch (args[safely: 0], args[safely: 1]) {
        case let (.float(x)?, .float(y)?):
            return [.float(f(x, y))]
        case let (.int(x)?, .int(y)?):
            return [.int(g(x, y))]
        default:
            throw InterpretError.invalidArguments(name, expected: "2 floats or ints", actual: "\(args)")
        }
    }
}

private func binaryIntOperator(name: String, _ f: @escaping (Int, Int) -> Int) -> ([Value], [Value]) throws -> [Value] {
    return { args, _ in
        guard let x = args[safely: 0]?.asInt,
              let y = args[safely: 1]?.asInt else {
            throw InterpretError.invalidArguments(name, expected: "2 ints", actual: "\(args)")
        }
        return [.int(f(x, y))]
    }
}

private func binaryValueOperator(name: String, _ f: @escaping (Value, Value) -> Value) -> ([Value], [Value]) throws -> [Value] {
    return { args, _ in
        guard let x = args[safely: 0],
              let y = args[safely: 1] else {
            throw InterpretError.invalidArguments(name, expected: "2 values", actual: "\(args)")
        }
        return [f(x, y)]
    }
}
