/// A (possibly nested) variable scope in which recipes, statements and expressions can be interpreted.
class Interpreter {
    private var variables: [String: [Value]]
    private var parent: Interpreter?
    
    init(variables: [String: [Value]] = [:], parent: Interpreter? = nil) {
        self.variables = variables
        self.parent = parent
    }
    
    /// Interprets the given recipe. Throws an `InterpretError` if unsuccessful.
    func interpret(recipe: Recipe) throws -> [Value] {
        try interpret(statements: recipe.statements)
    }
    
    // TODO: We could probably also use interpret(statement:) to make a nice REPL
    
    /// Interprets the given statements. Throws an `InterpretError` if unsuccessful.
    func interpret(statements: [Statement]) throws -> [Value] {
        var values: [Value] = []
        
        for statement in statements {
            values += try interpret(statement: statement)
        }
        
        return values
    }
    
    /// Interprets the given statement. Throws an `InterpretError` if unsuccessful.
    func interpret(statement: Statement) throws -> [Value] {
        var values: [Value] = []
        
        switch statement {
        case let .varBinding(binding):
            variables[binding.name] = try evaluate(expression: binding.value)
        case let .expression(expression):
            values += try evaluate(expression: expression)
        case let .forLoop(name, collection, block):
            let evaluatedCollection = try evaluate(expression: collection)
            guard evaluatedCollection.count == 1 else {
                throw InterpretError.cannotIterate(collection)
            }
            switch evaluatedCollection[0] {
            case let .intRange(range):
                for value in range {
                    let blockInterpreter = Interpreter(variables: [name: [.int(value)]], parent: self)
                    values += try blockInterpreter.interpret(statements: block)
                }
            case let .closedIntRange(range):
                for value in range {
                    let blockInterpreter = Interpreter(variables: [name: [.int(value)]], parent: self)
                    values += try blockInterpreter.interpret(statements: block)
                }
            default:
                throw InterpretError.cannotIterate(collection)
            }
        case .blank:
            break
        }
        
        return values
    }
    
    /// Evaluates the given expression. Throws an `InterpretError` if unsuccessful.
    func evaluate(expression: Expression) throws -> [Value] {
        switch expression {
        case .literal(let value):
            return [value]
        case .identifier(let name):
            return try resolve(name: name)
        case let .call(funcName, args, trailingBlock):
            // Evaluate the arguments (strictly)
            let evaluatedArgs = try args.flatMap { try evaluate(expression: $0) }
            
            // Interpret the trailing block in its own interpreter that
            // inherits the current scope but cannot change it.
            let blockInterpreter = Interpreter(parent: self)
            let evaluatedBlock = try blockInterpreter.interpret(statements: trailingBlock)
            
            // Invoke the function if it exists
            if let builtIn = builtIns[funcName] {
                return builtIn(evaluatedArgs, evaluatedBlock)
            } else {
                throw InterpretError.functionNotInScope(funcName)
            }
        }
    }
    
    /// Resolves the given variable name. Starts in the current scope and works its way up the chain of parent scopes, eventually throwing a `.variableNotInScope` if the variable is unbound.
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
