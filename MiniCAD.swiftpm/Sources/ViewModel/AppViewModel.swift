import Combine
import Foundation

class AppViewModel: ObservableObject {
    @Published var documents: [NamedDocument] = []
    @Published var selectedDocument: NamedDocument? = nil {
        didSet {
            print("Setting")
            editor.rawRecipe = selectedDocument?.document.raw ?? ""
        }
    }
    
    private let editor: EditorViewModel
    
    init(editor: EditorViewModel) {
        self.editor = editor
        
        documents = (Bundle.main.urls(forResourcesWithExtension: "minicad", subdirectory: nil) ?? []).compactMap { url -> NamedDocument? in
            guard let raw = try? String(contentsOf: url) else {
                return nil
            }
            return NamedDocument(
                name: String(url.lastPathComponent.split(separator: ".")[0]),
                document: RecipeDocument(raw: raw)
            )
        }
        selectedDocument = documents.first
    }
}
