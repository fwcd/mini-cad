import Foundation

struct NamedDocument: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var document: RecipeDocument
}
