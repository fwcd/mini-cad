/// The syntax tree for a for-loop.
struct ForLoop: Hashable {
    var name: String
    var sequence: Expression
    var block: [Statement] = []
}
