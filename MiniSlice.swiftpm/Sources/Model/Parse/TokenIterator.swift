struct TokenIterator: IteratorProtocol {
    private var iterator: Array<Token>.Iterator
    private var peeked: Token? = nil
    
    init(_ tokens: [Token]) {
        iterator = tokens.makeIterator()
    }
    
    mutating func peek() -> Token? {
        if let peeked = peeked {
            return peeked
        } else {
            let peeked = iterator.next()
            self.peeked = peeked
            return peeked
        }
    }
    
    mutating func next() -> Token? {
        if let peeked = peeked {
            self.peeked = nil
            return peeked
        } else {
            return iterator.next()
        }
    }
}
