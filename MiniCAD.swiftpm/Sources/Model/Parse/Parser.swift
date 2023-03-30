/// Parses a recipe from the given string. Throws a `ParseError` if unsuccessful.
func parseRecipe(from raw: String) throws -> Recipe<SourceRange?> {
    return try parseRecipe(from: tokenize(raw))
}

/// Parses a recipe from the given tokens. Throws a `ParseError` if unsuccessful.
func parseRecipe(from tokens: [Token]) throws -> Recipe<SourceRange?> {
    var tokens = TokenIterator(tokens.filter { !$0.kind.isComment })
    return try parseRecipe(from: &tokens)
}

/// Statefully parses and consumes a recipe from the given tokens. Throws a `ParseError` if unsuccessful.
func parseRecipe(from tokens: inout TokenIterator) throws -> Recipe<SourceRange?> {
    tokens.skipAll(.newline)
    let statements = try parseStatements(from: &tokens)
    return Recipe(statements: statements)
}

/// Statefully parses and consumes statements from the given tokens until the given end token is reached. Throws a `ParseError` if unsuccessful.
func parseStatements(from tokens: inout TokenIterator, until end: Token.Kind? = nil) throws -> [Statement<SourceRange?>] {
    var statements: [Statement<SourceRange?>] = []
    
    while tokens.peek()?.kind != end {
        let statement = try parseStatement(from: &tokens)
        statements.append(statement)
        if tokens.peek()?.kind != end {
            try tokens.expect(.newline)
            while let token = tokens.peek(), token.kind == .newline {
                tokens.next()
                statements.append(.blank)
            }
        }
    }
    
    return statements
}

/// Statefully parses a statement from the given tokens. Throws a `ParseError` if unsuccessful.
func parseStatement(from tokens: inout TokenIterator) throws -> Statement<SourceRange?> {
    switch tokens.peek()?.kind {
    case .let:
        return .varBinding(try parseVarBinding(from: &tokens))
    case .for:
        return .forLoop(try parseForLoop(from: &tokens))
    default:
        return .expression(try parseExpression(from: &tokens))
    }
}

/// Statefully parses a variable binding from the given tokens. Throws a `ParseError` if unsuccessful.
func parseVarBinding(from tokens: inout TokenIterator) throws -> VarBinding<SourceRange?> {
    try tokens.expect(.let)
    let name = try parseIdentifier(from: &tokens)
    try tokens.expect(.assign)
    let value = try parseExpression(from: &tokens)
    return VarBinding(name: name, value: value, attachment: nil) // TODO: Source range
}

/// Statefully parses a for-loop from the given tokens. Throws a `ParseError` if unsuccessful.
func parseForLoop(from tokens: inout TokenIterator) throws -> ForLoop<SourceRange?> {
    try tokens.expect(.for)
    let name = try parseIdentifier(from: &tokens)
    try tokens.expect(.in)
    let sequence = try parseExpression(from: &tokens)
    let block = try parseBlock(from: &tokens)
    return ForLoop(name: name, sequence: sequence, block: block, attachment: nil) // TODO: Source range
}

/// Statefully parses an identifier from the given tokens. Throws a `ParseError` if unsuccessful.
func parseIdentifier(from tokens: inout TokenIterator) throws -> String {
    guard case let .identifier(ident) = tokens.next()?.kind else { throw ParseError.expectedIdentifier(actual: tokens.current) }
    return ident
}

// We use the operator precedence parser from Wikipedia to parse expressions:
// https://en.wikipedia.org/wiki/Operator-precedence_parser#Pseudocode

/// Statefully parses an expression from the given tokens. Throws a `ParseError` if unsuccessful.
func parseExpression(from tokens: inout TokenIterator) throws -> Expression<SourceRange?> {
    let lhs = try parsePrimaryExpression(from: &tokens, allowTrailing: true)
    if case .call(let call) = lhs, !call.trailingBlock.isEmpty {
        // We are done parsing this expression after a trailing block
        return lhs
    }
    return try parseExpression(from: &tokens, lhs: lhs, minPrecedence: 0)
}

/// Statefully parses an infix expression starting at the operator. Throws a `ParseError` if unsuccessful.
func parseExpression(from tokens: inout TokenIterator, lhs: Expression<SourceRange?>, minPrecedence: Int) throws -> Expression<SourceRange?> {
    var lhs = lhs
    while case let .binaryOperator(op)? = tokens.peek()?.kind, op.precedence >= minPrecedence {
        tokens.next()
        var rhs = try parsePrimaryExpression(from: &tokens, allowTrailing: false)
        while case let .binaryOperator(nextOp)? = tokens.peek()?.kind,
              nextOp.precedence > op.precedence || (nextOp.associativity == .right && nextOp.precedence == op.precedence) {
            rhs = try parseExpression(from: &tokens, lhs: rhs, minPrecedence: op.precedence + (nextOp.precedence - op.precedence).signum())
        }
        lhs = .binary(.init(lhs: lhs, op: op, rhs: rhs, attachment: nil)) // TODO: Source range
    }
    return lhs
}
    
/// Statefully parses a non-operated-on expression from the given tokens. Throws a `ParseError` if unsuccessful.
func parsePrimaryExpression(from tokens: inout TokenIterator, allowTrailing: Bool) throws -> Expression<SourceRange?> {
    switch tokens.peek()?.kind {
    case .leftParen:
        tokens.next()
        let expr = try parseExpression(from: &tokens)
        try tokens.expect(.rightParen)
        return expr
    case .int(_):
        let value = try tokens.expectInt()
        return .literal(.int(value))
    case .float(_):
        let value = try tokens.expectFloat()
        return .literal(.float(value))
    case .string(let value):
        tokens.next()
        return .literal(.string(value))
    case .identifier(let ident):
        tokens.next()
        switch tokens.peek()?.kind {
        case .leftParen:
            let args = try parseArgs(from: &tokens)
            var trailingBlock: [Statement<SourceRange?>] = []
            if tokens.peek()?.kind == .leftCurly {
                trailingBlock = try parseBlock(from: &tokens)
            }
            return .call(.init(identifier: ident, args: args, trailingBlock: trailingBlock, attachment: nil)) // TODO: Source range
        case .leftCurly where allowTrailing:
            let trailingBlock = try parseBlock(from: &tokens)
            return .call(.init(identifier: ident, trailingBlock: trailingBlock, attachment: nil)) // TODO: Source range
        default:
            return .identifier(ident)
        }
    default:
        throw ParseError.expectedExpression(actual: tokens.next())
    }
}

/// Statefully parses a function argument list from the given tokens. Throws a `ParseError` if unsuccessful.
func parseArgs(from tokens: inout TokenIterator) throws -> [Expression<SourceRange?>] {
    try tokens.expect(.leftParen)
    
    var args: [Expression<SourceRange?>] = []
    while tokens.peek()?.kind != .rightParen {
        let arg = try parseExpression(from: &tokens)
        args.append(arg)
        if tokens.peek()?.kind != .rightParen {
            try tokens.expect(.comma)
        }
    }
    
    try tokens.expect(.rightParen)
    return args
}

/// Statefully parses a block of statements from the given tokens. Throws a `ParseError` if unsuccessful.
func parseBlock(from tokens: inout TokenIterator) throws -> [Statement<SourceRange?>] {
    try tokens.expect(.leftCurly)
    tokens.skipAll(.newline)
    
    var statements: [Statement<SourceRange?>] = []
    if tokens.peek()?.kind != .rightCurly {
        statements = try parseStatements(from: &tokens, until: .rightCurly)
    }
    
    try tokens.expect(.rightCurly)
    return statements
}