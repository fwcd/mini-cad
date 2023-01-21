enum Token: Hashable {
    case `let`
    case assign
    case newline
    case leftParen
    case rightParen
    case leftCurly
    case rightCurly
    case comma
    case float(Double)
    case int(Int)
    case identifier(String)
}

