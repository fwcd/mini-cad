func parseRecipe(from tokens: inout TokenIterator) throws -> Recipe {
    var statements: [Statement] = []
    
    while tokens.hasNext {
        let statement = try parseStatement(from: &tokens)
        statements.append(statement)
    }
    
    return Recipe(statements: statements)
}

func parseStatement(from tokens: inout TokenIterator) throws -> Statement {
    switch tokens.peek() {
    case .let:
        return .varBinding(try parseVarBinding(from: &tokens))
    default:
        return .expression(try parseExpression(from: &tokens))
    }
}

func parseVarBinding(from tokens: inout TokenIterator) throws -> VarBinding {
    try tokens.expect(.let)
    guard case let .identifier(name) = tokens.next() else { throw ParseError.expectedIdentifier }
    try tokens.expect(.assign)
    let value = try parseExpression(from: &tokens)
    return VarBinding(name: name, value: value)
}

func parseExpression(from tokens: inout TokenIterator) throws -> Expression {
    switch tokens.peek() {
    case .int(let value):
        tokens.next()
        return .intLiteral(value)
    case .float(let value):
        tokens.next()
        return .floatLiteral(value)
    case .identifier(let ident):
        tokens.next()
        switch tokens.peek() {
        case .leftParen:
            var args: [Expression] = []
            while tokens.peek() != .rightParen {
                let arg = try parseExpression(from: &tokens)
                args.append(arg)
                if tokens.peek() != .rightParen {
                    try tokens.expect(.comma)
                }
            }
            return .call(ident, args)
        default:
            return .identifier(ident)
        }
    default:
        throw ParseError.expectedExpression
    }
}
