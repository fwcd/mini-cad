import Foundation
import OSLog

private let log = Logger(subsystem: "MiniSlice", category: "BuiltIns")

/// The built-in constants
let builtInConstants: [String: [Value]] = [
    "PI": [.float(.pi)],
    "TAU": [.float(2 * .pi)],
]

/// The built-in operators.
let builtInOperators: [BinaryOperator: ([Value], [Value]) throws -> [Value]] = [
    .add: binaryFloatOrIntOperator(name: "+", +, +), // TODO: Add string concatenation again
    .subtract: binaryFloatOrIntOperator(name: "-", -, -),
    .multiply: binaryFloatOrIntOperator(name: "*", *, *),
    .divide: binaryFloatOrIntOperator(name: "/", /, /),
    .remainder: binaryIntOperator(name: "%", %),
    .equal: binaryValueOperator(name: "==", ==),
    .notEqual: binaryValueOperator(name: "!=", !=),
    .greaterThan: binaryFloatOrIntOperator(name: ">", >, >),
    .greaterOrEqual: binaryFloatOrIntOperator(name: ">=", >=, >=),
    .lessThan: binaryFloatOrIntOperator(name: "<", <, <),
    .lessOrEqual: binaryFloatOrIntOperator(name: "<=", <=, <=),
    .toExclusive: binaryFloatOrIntOperator(name: "..<", ..<, ..<),
    .toInclusive: binaryFloatOrIntOperator(name: "...", ..., ...),
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
    "Translate": { args, trailingBlock in
        let offset = parseVec3(from: args)
        let meshes = trailingBlock.compactMap(\.asMesh)
        return meshes.map { .mesh($0 + offset) }
    },
    "Union": { _, trailingBlock in
        let meshes = trailingBlock.compactMap(\.asMesh)
        return [.mesh(meshes.reduce(Mesh()) { $0.union($1) })]
    },
    "Intersection": { _, trailingBlock in
        let meshes = trailingBlock.compactMap(\.asMesh)
        guard let first = meshes.first else { return [.mesh(Mesh())] }
        return [.mesh(meshes.reduce(first) { $0.intersection($1) })]
    },
    "Difference": { _, trailingBlock in
        let meshes = trailingBlock.compactMap(\.asMesh)
        guard let first = meshes.first else { return [.mesh(Mesh())] }
        return [.mesh(meshes.reduce(first) { $0.subtracting($1) })]
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

private func unaryFloatOperator<T>(name: String, _ f: @escaping (Double) -> T) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible {
    return { args, _ in
        guard let x = args[safely: 0]?.asFloat else {
            throw InterpretError.invalidArguments(name, expected: "1 float", actual: "\(args)")
        }
        return [Value(f(x))]
    }
}

private func binaryFloatOperator<T>(name: String, _ f: @escaping (Double, Double) -> T) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible {
    return { args, _ in
        guard let x = args[safely: 0]?.asFloat,
              let y = args[safely: 1]?.asFloat else {
            throw InterpretError.invalidArguments(name, expected: "2 floats", actual: "\(args)")
        }
        return [Value(f(x, y))]
    }
}

private func binaryFloatOrIntOperator<T, U>(name: String, _ f: @escaping (Double, Double) -> T, _ g: @escaping (Int, Int) -> U) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible, U: ValueConvertible {
    return { args, _ in
        switch (args[safely: 0], args[safely: 1]) {
        case let (.int(x)?, .float(y)?):
            return [Value(f(Double(x), y))]
        case let (.float(x)?, .int(y)?):
            return [Value(f(x, Double(y)))]
        case let (.float(x)?, .float(y)?):
            return [Value(f(x, y))]
        case let (.int(x)?, .int(y)?):
            return [Value(g(x, y))]
        default:
            throw InterpretError.invalidArguments(name, expected: "2 floats or ints", actual: "\(args)")
        }
    }
}

private func binaryIntOperator<T>(name: String, _ f: @escaping (Int, Int) -> T) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible {
    return { args, _ in
        guard let x = args[safely: 0]?.asInt,
              let y = args[safely: 1]?.asInt else {
            throw InterpretError.invalidArguments(name, expected: "2 ints", actual: "\(args)")
        }
        return [Value(f(x, y))]
    }
}

private func binaryValueOperator<T>(name: String, _ f: @escaping (Value, Value) -> T) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible {
    return { args, _ in
        guard let x = args[safely: 0],
              let y = args[safely: 1] else {
            throw InterpretError.invalidArguments(name, expected: "2 values", actual: "\(args)")
        }
        return [Value(f(x, y))]
    }
}
