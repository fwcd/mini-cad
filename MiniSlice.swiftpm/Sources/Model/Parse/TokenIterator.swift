/// A peekable iterator over a sequence of tokens with a few convenience functions that are useful for parsing.
struct TokenIterator: IteratorProtocol {
    private var iterator: Array<Token>.Iterator
    private var peeked: Token? = nil
    
    /// The token returned by the most recent `.next()` call.
    private(set) var current: Token? = nil
    
    /// Whether the iterator has not reached the end yet.
    var hasNext: Bool {
        mutating get { peek() != nil }
    }
    
    init(_ tokens: [Token]) {
        iterator = tokens.makeIterator()
    }
    
    /// Consumes the next token and throws an error if it doesn't match the given token.
    @discardableResult
    mutating func expect(_ kind: Token.Kind) throws -> Token {
        let actual = next()
        guard actual?.kind == kind else {
            throw ParseError.expected(kind, actual: actual)
        }
        return actual!
    }
    
    /// Consumes and parses an integer literal.
    mutating func expectInt() throws -> Int {
        guard case let .int(rawValue) = next()?.kind,
              let value = Int(rawValue) else { throw ParseError.couldNotParseIntLiteral }
        return value
    }
    
    /// Consumes and parses a float literal.
    mutating func expectFloat() throws -> Double {
        guard case let .float(rawValue) = next()?.kind,
              let value = Double(rawValue) else { throw ParseError.couldNotParseFloatLiteral }
        return value
    }
    
    /// Consumes the next token if it matches the given token.
    mutating func skip(_ token: Token) {
        if peek() == token {
            next()
        }
    }
    
    /// Consumes the next token while it matches the given token.
    mutating func skipAll(_ kind: Token.Kind) {
        while peek()?.kind == kind {
            next()
        }
    }
    
    /// Peeks the next token without advancing the iteration.
    mutating func peek() -> Token? {
        if let peeked = peeked {
            return peeked
        } else {
            let peeked = iterator.next()
            self.peeked = peeked
            return peeked
        }
    }
    
    /// Consumes and returns the next token.
    @discardableResult
    mutating func next() -> Token? {
        if let peeked = peeked {
            self.peeked = nil
            current = peeked
        } else {
            current = iterator.next()
        }
        return current
    }
}
