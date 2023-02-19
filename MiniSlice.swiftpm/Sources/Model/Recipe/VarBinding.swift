struct VarBinding<Attachment> {
    var name: String
    var value: Expression<Attachment>
    var attachment: Attachment
    
    func map<T>(_ transform: (Attachment) throws -> T) rethrows -> VarBinding<T> {
        VarBinding<T>(
            name: name,
            value: try value.map(transform),
            attachment: try transform(attachment)
        )
    }
}


extension VarBinding: Equatable where Attachment: Equatable {}

extension VarBinding: Hashable where Attachment: Hashable {}
