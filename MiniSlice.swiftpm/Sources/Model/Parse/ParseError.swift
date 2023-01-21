enum ParseError: Error {
    case expected(Token, actual: Token?)
    case expectedIdentifier(actual: Token?)
    case expectedExpression(actual: Token?)
}
