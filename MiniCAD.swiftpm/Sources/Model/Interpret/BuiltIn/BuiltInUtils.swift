func unaryFloatOperator<T>(name: String, _ f: @escaping (Double) -> T) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible {
    return { args, _ in
        guard let x = args[safely: 0]?.asFloat else {
            throw InterpretError.invalidArguments(name, expected: "1 float", actual: "\(args)")
        }
        return [Value(f(x))]
    }
}

func binaryFloatOperator<T>(name: String, _ f: @escaping (Double, Double) -> T) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible {
    return { args, _ in
        guard let x = args[safely: 0]?.asFloat,
              let y = args[safely: 1]?.asFloat else {
            throw InterpretError.invalidArguments(name, expected: "2 floats", actual: "\(args)")
        }
        return [Value(f(x, y))]
    }
}

func binaryFloatOrIntOperator<T, U>(name: String, _ f: @escaping (Double, Double) -> T, _ g: @escaping (Int, Int) -> U) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible, U: ValueConvertible {
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

func binaryIntOperator<T>(name: String, _ f: @escaping (Int, Int) -> T) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible {
    return { args, _ in
        guard let x = args[safely: 0]?.asInt,
              let y = args[safely: 1]?.asInt else {
            throw InterpretError.invalidArguments(name, expected: "2 ints", actual: "\(args)")
        }
        return [Value(f(x, y))]
    }
}

func binaryBoolOperator<T>(name: String, _ f: @escaping (Bool, Bool) -> T) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible {
    return { args, _ in
        guard let x = args[safely: 0]?.asBool,
              let y = args[safely: 1]?.asBool else {
            throw InterpretError.invalidArguments(name, expected: "2 bools", actual: "\(args)")
        }
        return [Value(f(x, y))]
    }
}

func binaryValueOperator<T>(name: String, _ f: @escaping (Value, Value) -> T) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible {
    return { args, _ in
        guard let x = args[safely: 0],
              let y = args[safely: 1] else {
            throw InterpretError.invalidArguments(name, expected: "2 values", actual: "\(args)")
        }
        return [Value(f(x, y))]
    }
}
