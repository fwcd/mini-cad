class Interpreter {
    private var variables: [String: [Value]] = [:]
    private var parent: Interpreter?
    
    init(parent: Interpreter? = nil) {
        self.parent = parent
    }
    
    func interpret(recipe: Recipe) throws -> [Value] {
        try interpret(statements: recipe.statements)
    }
    
    // TODO: We could probably also use interpret(statement:) to make a nice REPL
    
    func interpret(statements: [Statement]) throws -> [Value] {
        var values: [Value] = []
        
        for statement in statements {
            values += try interpret(statement: statement)
        }
        
        return values
    }
    
    func interpret(statement: Statement) throws -> [Value] {
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
    
    func evaluate(expression: Expression) throws -> [Value] {
        switch expression {
        case .literal(let value):
            return [value]
        case .identifier(let name):
            return try resolve(name: name)
        case let .call(funcName, args, trailingBlock):
            let evaluatedArgs = try args.flatMap { try evaluate(expression: $0) }
            
            let blockInterpreter = Interpreter(parent: self)
            let evaluatedBlock = try blockInterpreter.interpret(statements: trailingBlock)
            
            if let builtIn = builtIns[funcName] {
                return builtIn(evaluatedArgs, evaluatedBlock)
            } else {
                throw InterpretError.functionNotInScope(funcName)
            }
        }
    }
    
    func resolve(name: String) throws -> [Value] {
        if let values = variables[name] {
            return values
        } else if let parent = parent {
            return try parent.resolve(name: name)
        } else {
            throw InterpretError.variableNotInScope(name)
        }
    }
}

func interpret(recipe: Recipe) throws -> [Value] {
    try Interpreter().interpret(recipe: recipe)
}
