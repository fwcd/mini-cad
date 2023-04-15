import Combine
import Foundation

class AppViewModel: ObservableObject {
    @Published var examples: [NamedDocument] = []
    @Published var selectedDocument: NamedDocument? = nil {
        willSet {
            // Save contents of document when switching
            guard let id = selectedDocument?.id else { return }
            for i in examples.indices {
                if examples[i].id == id {
                    examples[i].document.raw = editor.rawRecipe
                    break
                }
            }
        }
        didSet {
            // Load contents of new document
            editor.rawRecipe = selectedDocument?.document.raw ?? ""
        }
    }
    
    private let editor: EditorViewModel
    
    init(editor: EditorViewModel) {
        self.editor = editor
        
        examples = (Bundle.main.urls(forResourcesWithExtension: "minicad", subdirectory: nil) ?? [])
            .compactMap { url -> NamedDocument? in
                guard let raw = try? String(contentsOf: url) else {
                    return nil
                }
                return NamedDocument(
                    name: String(url.lastPathComponent.split(separator: ".")[0]),
                    document: RecipeDocument(raw: raw)
                )
            }
            .sorted { $0.name < $1.name }
        selectedDocument = examples.first
    }
}
