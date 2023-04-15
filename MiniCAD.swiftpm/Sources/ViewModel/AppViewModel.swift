import Combine
import Foundation

class AppViewModel: ObservableObject {
    @Published var examples: [NamedDocument] = []
    @Published var selectedDocument: NamedDocument? = nil {
        didSet {
            editor.rawRecipe = selectedDocument?.document.raw ?? ""
        }
    }
    
    private let editor: EditorViewModel
    
    init(editor: EditorViewModel) {
        self.editor = editor
        
        examples = (Bundle.main.urls(forResourcesWithExtension: "minicad", subdirectory: nil) ?? []).compactMap { url -> NamedDocument? in
            guard let raw = try? String(contentsOf: url) else {
                return nil
            }
            return NamedDocument(
                name: String(url.lastPathComponent.split(separator: ".")[0]),
                document: RecipeDocument(raw: raw)
            )
        }
        selectedDocument = examples.first
    }
}
