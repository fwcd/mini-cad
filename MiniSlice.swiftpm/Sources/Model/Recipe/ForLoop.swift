/// The syntax tree for a for-loop.
struct ForLoop: Hashable, CustomStringConvertible {
    var name: String
    var sequence: Expression
    var block: [Statement] = []
    
    var description: String {
        (["for \(name) in \(sequence) {"] + block.map { "\($0)" } + ["}"]).joined(separator: "\n")
    }
}
