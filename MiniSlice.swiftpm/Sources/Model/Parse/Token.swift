/// A lexical token. Before parsing the program/recipe is preprocessed into a sequence of tokens.
struct Token: Hashable {
    var kind: Kind
    var range: Range<String.Index>
    
    enum Kind: Hashable {
        case `let`
        case `for`
        case `in`
        case binaryOperator(BinaryOperator)
        case assign
        case newline
        case leftParen
        case rightParen
        case leftCurly
        case rightCurly
        case comma
        case float(String)
        case int(String)
        case identifier(String)
        case comment
        case string(String)
    }
}

