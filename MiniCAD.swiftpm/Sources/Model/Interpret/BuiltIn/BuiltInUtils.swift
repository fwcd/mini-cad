func unaryBoolOperator<T>(name: String, _ f: @escaping (Bool) -> T) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible {
    return { args, _ in
        guard let x = args[safely: 0]?.asBool else {
            throw InterpretError.invalidArguments(name, expected: "1 bool", actual: "\(args)")
        }
        return [Value(f(x))]
    }
}

func unaryFloatOrIntOperator<T, U>(name: String, _ f: @escaping (Double) -> T, _ g: @escaping (Int) -> U) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible, U: ValueConvertible {
    return { args, _ in
        switch args[safely: 0] {
        case let .int(x)?:
            return [Value(g(x))]
        case let .float(x)?:
            return [Value(f(x))]
        default:
            throw InterpretError.invalidArguments(name, expected: "1 float or int", actual: "\(args)")
        }
    }
}

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

func binaryFloatOrIntOperator<T, U>(name: String, _ f: @escaping (Double, Double) throws -> T, _ g: @escaping (Int, Int) throws -> U) -> ([Value], [Value]) throws -> [Value] where T: ValueConvertible, U: ValueConvertible {
    return { args, _ in
        switch (args[safely: 0], args[safely: 1]) {
        case let (.int(x)?, .float(y)?):
            return [Value(try f(Double(x), y))]
        case let (.float(x)?, .int(y)?):
            return [Value(try f(x, Double(y)))]
        case let (.float(x)?, .float(y)?):
            return [Value(try f(x, y))]
        case let (.int(x)?, .int(y)?):
            return [Value(try g(x, y))]
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
