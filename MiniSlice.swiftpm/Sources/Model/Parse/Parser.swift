/// Parses a recipe from the given string. Throws a `ParseError` if unsuccessful.
func parseRecipe(from raw: String) throws -> Recipe {
    var tokens = TokenIterator(tokenize(raw))
    return try parseRecipe(from: &tokens)
}

/// Statefully parses and consumes a recipe from the given tokens. Throws a `ParseError` if unsuccessful.
func parseRecipe(from tokens: inout TokenIterator) throws -> Recipe {
    let statements = try parseStatements(from: &tokens)
    return Recipe(statements: statements)
}

/// Statefully parses and consumes statements from the given tokens until the given end token is reached. Throws a `ParseError` if unsuccessful.
func parseStatements(from tokens: inout TokenIterator, until end: Token? = nil) throws -> [Statement] {
    var statements: [Statement] = []
    
    while tokens.peek() != end {
        let statement = try parseStatement(from: &tokens)
        statements.append(statement)
        if tokens.peek() != end {
            try tokens.expect(.newline)
            while tokens.peek() == .newline {
                tokens.next()
                statements.append(.blank)
            }
        }
    }
    
    return statements
}

/// Statefully parses a statement from the given tokens. Throws a `ParseError` if unsuccessful.
func parseStatement(from tokens: inout TokenIterator) throws -> Statement {
    switch tokens.peek() {
    case .let:
        return .varBinding(try parseVarBinding(from: &tokens))
    default:
        return .expression(try parseExpression(from: &tokens))
    }
}

/// Statefully parses a variable binding from the given tokens. Throws a `ParseError` if unsuccessful.
func parseVarBinding(from tokens: inout TokenIterator) throws -> VarBinding {
    try tokens.expect(.let)
    guard case let .identifier(name) = tokens.next() else { throw ParseError.expectedIdentifier(actual: tokens.current) }
    try tokens.expect(.assign)
    let value = try parseExpression(from: &tokens)
    return VarBinding(name: name, value: value)
}

/// Statefully parses an expression from the given tokens. Throws a `ParseError` if unsuccessful.
func parseExpression(from tokens: inout TokenIterator) throws -> Expression {
    switch tokens.peek() {
    case .int(let rawValue):
        tokens.next()
        guard let value = Int(rawValue) else { throw ParseError.couldNotParseIntLiteral }
        return .literal(.int(value))
    case .float(let rawValue):
        tokens.next()
        guard let value = Double(rawValue) else { throw ParseError.couldNotParseFloatLiteral }
        return .literal(.float(value))
    case .identifier(let ident):
        tokens.next()
        switch tokens.peek() {
        case .leftParen:
            let args = try parseArgs(from: &tokens)
            var trailingBlock: [Statement] = []
            if tokens.peek() == .leftCurly {
                trailingBlock = try parseBlock(from: &tokens)
            }
            return .call(ident, args: args, trailingBlock: trailingBlock)
        case .leftCurly:
            let trailingBlock = try parseBlock(from: &tokens)
            return .call(ident, args: [], trailingBlock: trailingBlock)
        default:
            return .identifier(ident)
        }
    default:
        throw ParseError.expectedExpression(actual: tokens.next())
    }
}

/// Statefully parses a function argument list from the given tokens. Throws a `ParseError` if unsuccessful.
func parseArgs(from tokens: inout TokenIterator) throws -> [Expression] {
    try tokens.expect(.leftParen)
    
    var args: [Expression] = []
    while tokens.peek() != .rightParen {
        let arg = try parseExpression(from: &tokens)
        args.append(arg)
        if tokens.peek() != .rightParen {
            try tokens.expect(.comma)
        }
    }
    
    try tokens.expect(.rightParen)
    return args
}

/// Statefully parses a block of statements from the given tokens. Throws a `ParseError` if unsuccessful.
func parseBlock(from tokens: inout TokenIterator) throws -> [Statement] {
    try tokens.expect(.leftCurly)
    tokens.skipAll(.newline)
    
    var statements: [Statement] = []
    if tokens.peek() != .rightCurly {
        statements = try parseStatements(from: &tokens, until: .rightCurly)
    }
    
    try tokens.expect(.rightCurly)
    return statements
}
