struct Interpreter {
    private var variables: [String: [Value]] = [:]
    
    mutating func interpret(recipe: Recipe) throws -> [Value] {
        try interpret(statements: recipe.statements)
    }
    
    // TODO: We could probably also use interpret(statement:) to make a nice REPL
    
    mutating func interpret(statements: [Statement]) throws -> [Value] {
        var values: [Value] = []
        
        for statement in statements {
            values += try interpret(statement: statement)
        }
        
        return values
    }
    
    mutating func interpret(statement: Statement) throws -> [Value] {
        var values: [Value] = []
        
        switch statement {
        case .varBinding(let binding):
            variables[binding.name] = try evaluate(expression: binding.value)
        case .expression(let expression):
            values += try evaluate(expression: expression)
        case .blank:
            break
        }
        
        return values
    }
    
    mutating func evaluate(expression: Expression) throws -> [Value] {
        switch expression {
        case .literal(let value):
            return [value]
        case .identifier(let ident):
            if let values = variables[ident] {
                return values
            } else {
                throw InterpretError.variableNotInScope(ident)
            }
        case let .call(funcName, args, trailingBlock):
            let evaluatedArgs = try args.flatMap { try evaluate(expression: $0) }
            
            var blockInterpreter = Interpreter() // TODO: Make this a parented interpreter to preserve the scope
            let evaluatedBlock = try blockInterpreter.interpret(statements: trailingBlock)
            
            if let builtIn = builtIns[funcName] {
                return builtIn(evaluatedArgs, evaluatedBlock)
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
