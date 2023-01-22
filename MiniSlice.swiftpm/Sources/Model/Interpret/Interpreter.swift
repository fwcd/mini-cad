struct Interpreter {
    private static let builtIns: [String: ([Value]) -> Value] = [
        "Cuboid": { args in
            // TODO: Should we pass vector/tuple-ish types?
            let size = Vec3(
                x: args[safely: 0]?.asFloat ?? 1,
                y: args[safely: 1]?.asFloat ?? 1,
                z: args[safely: 2]?.asFloat ?? 1
            )
            return .cuboid(Cuboid(size: size))
        },
    ]
    
    private var variables: [String: Value] = [:]
    
    mutating func interpret(recipe: Recipe) throws -> [Value] {
        var values: [Value] = []
        
        for statement in recipe.statements {
            values += try interpret(statement: statement)
        }
        
        return values
    }
    
    // TODO: We could probably also use interpret(statement:) to make a nice REPL
    
    mutating func interpret(statement: Statement) throws -> [Value] {
        var values: [Value] = []
        
        switch statement {
        case .varBinding(let binding):
            variables[binding.name] = try evaluate(expression: binding.value)
        case .expression(let expression):
            values.append(try evaluate(expression: expression))
        case .blank:
            break
        }
        
        return values
    }
    
    mutating func evaluate(expression: Expression) throws -> Value {
        switch expression {
        case .literal(let value):
            return value
        case .identifier(let ident):
            if let value = variables[ident] {
                return value
            } else {
                throw InterpretError.variableNotInScope(ident)
            }
        case .call(let funcName, let args):
            let evaluatedArgs = try args.map { try evaluate(expression: $0) }
            if let builtIn = Self.builtIns[funcName] {
                return builtIn(evaluatedArgs)
            } else {
                throw InterpretError.functionNotInScope(funcName)
            }
        }
    }
}

func interpret(recipe: Recipe) throws -> [Value] {
    var interpreter = Interpreter()
    return try interpreter.interpret(recipe: recipe)
}
