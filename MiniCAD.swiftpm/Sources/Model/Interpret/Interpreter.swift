/// A (possibly nested) variable scope in which recipes, statements and expressions can be interpreted.
class Interpreter {
    private var variables: [String: [Value]]
    private var parent: Interpreter?
    
    init(variables: [String: [Value]] = [:], parent: Interpreter? = nil) {
        self.variables = variables
        self.parent = parent
    }
    
    /// Interprets the given recipe. Throws an `InterpretError` if unsuccessful.
    func interpret<T>(recipe: Recipe<T>) throws -> [Value] {
        try interpret(statements: recipe.statements)
    }
    
    // TODO: We could probably also use interpret(statement:) to make a nice REPL
    
    /// Interprets the given statements. Throws an `InterpretError` if unsuccessful.
    func interpret<T>(statements: [Statement<T>]) throws -> [Value] {
        var values: [Value] = []
        
        for statement in statements {
            values += try interpret(statement: statement)
        }
        
        return values
    }
    
    /// Interprets the given statement. Throws an `InterpretError` if unsuccessful.
    func interpret<T>(statement: Statement<T>) throws -> [Value] {
        var values: [Value] = []
        
        switch statement {
        case let .varBinding(binding):
            variables[binding.name] = try evaluate(expression: binding.value)
        case let .expression(expression):
            values += try evaluate(expression: expression)
        case let .forLoop(loop):
            let evaluatedCollection = try evaluateUniquely(expression: loop.sequence)
            switch evaluatedCollection {
            case let .intRange(range):
                for value in range {
                    let blockInterpreter = Interpreter(variables: [loop.name: [.int(value)]], parent: self)
                    values += try blockInterpreter.interpret(statements: loop.block)
                }
            case let .closedIntRange(range):
                for value in range {
                    let blockInterpreter = Interpreter(variables: [loop.name: [.int(value)]], parent: self)
                    values += try blockInterpreter.interpret(statements: loop.block)
                }
            default:
                throw InterpretError.cannotIterate(loop.sequence.map { $0 as Any })
            }
        case .blank:
            break
        }
        
        return values
    }
    
    /// Evaluates the given expression. Throws an `InterpretError` if unsuccessful.
    func evaluate<T>(expression: Expression<T>) throws -> [Value] {
        switch expression {
        case .literal(let value):
            return [value]
        case .identifier(let name):
            return try resolve(name: name)
        case .binary(let binaryExpr):
            return try evaluate(binaryExpression: binaryExpr)
        case .call(let callExpr):
            // Evaluate the arguments (strictly)
            let evaluatedArgs = try callExpr.args.flatMap { try evaluate(expression: $0) }
            
            // Interpret the trailing block in its own interpreter that
            // inherits the current scope but cannot change it.
            let blockInterpreter = Interpreter(parent: self)
            let evaluatedBlock = try blockInterpreter.interpret(statements: callExpr.trailingBlock)
            
            // Invoke the function if it exists
            if let builtIn = builtInFunctions[callExpr.identifier] {
                return try builtIn(evaluatedArgs, evaluatedBlock)
            } else {
                throw InterpretError.functionNotInScope(callExpr.identifier)
            }
        }
    }
    
    /// Evaluates the given binary expression. Throws an `InterpretError` if unsuccessful.
    func evaluate<T>(binaryExpression: BinaryExpression<T>) throws -> [Value] {
        let lhs = try evaluateUniquely(expression: binaryExpression.lhs)
        let rhs = try evaluateUniquely(expression: binaryExpression.rhs)
        guard let builtIn = builtInOperators[binaryExpression.op] else {
            throw InterpretError.binaryOperatorNotImplemented(binaryExpression.op)
        }
        return try builtIn([lhs, rhs], [])
    }
    
    /// Evaluates the given expression uniquely. Throws an `InterpretError` if unsuccessful.
    func evaluateUniquely<T>(expression: Expression<T>) throws -> Value {
        let values = try evaluate(expression: expression)
        guard values.count == 1 else {
            throw InterpretError.ambiguousExpression(expression.map { $0 as Any }, values)
        }
        return values[0]
    }
    
    /// Resolves the given variable name. Starts in the current scope and works its way up the chain of parent scopes, eventually throwing a `.variableNotInScope` if the variable is unbound.
    func resolve(name: String) throws -> [Value] {
        if let values = variables[name] {
            return values
        } else if let parent = parent {
            return try parent.resolve(name: name)
        } else if let constant = builtInConstants[name] {
            return constant
        } else {
            throw InterpretError.variableNotInScope(name)
        }
    }
}

func interpret<T>(recipe: Recipe<T>) throws -> [Value] {
    try Interpreter().interpret(recipe: recipe)
}