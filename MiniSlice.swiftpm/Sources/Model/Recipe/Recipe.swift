/// A recipe syntax tree.
struct Recipe: Hashable {
    var statements: [Statement] = []
}
