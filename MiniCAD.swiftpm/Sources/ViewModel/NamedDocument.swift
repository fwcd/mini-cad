import Foundation

struct NamedDocument: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var document: RecipeDocument
}

extension NamedDocument {
    init(contentsOf url: URL) throws {
        let raw = try String(contentsOf: url)
        self.init(
            name: String(url.lastPathComponent.split(separator: ".")[0]),
            document: RecipeDocument(raw: raw)
        )
    }
}
