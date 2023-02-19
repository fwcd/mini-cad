/// The syntax tree for a for-loop.
struct ForLoop<Attachment> {
    var name: String
    var sequence: Expression<Attachment>
    var block: [Statement<Attachment>] = []
    var attachment: Attachment
    
    func map<T>(_ transform: (Attachment) throws -> T) rethrows -> ForLoop<T> {
        ForLoop<T>(
            name: name,
            sequence: try sequence.map(transform),
            block: try block.map { try $0.map(transform) },
            attachment: try transform(attachment)
        )
    }
}

extension ForLoop: Equatable where Attachment: Equatable {}

extension ForLoop: Hashable where Attachment: Hashable {}
