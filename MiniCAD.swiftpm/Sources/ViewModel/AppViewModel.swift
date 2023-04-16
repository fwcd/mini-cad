import Combine
import Foundation

class AppViewModel: ObservableObject {
    @Published var examples: [NamedDocument] = []
    @Published var models: [NamedDocument] = []
    @Published var selectedDocument: NamedDocument? = nil {
        willSet {
            // Save contents of document when switching
            guard let id = selectedDocument?.id else { return }
            for i in examples.indices {
                if examples[i].id == id {
                    examples[i].document.raw = editor.rawRecipe
                    return
                }
            }
            for i in models.indices {
                if models[i].id == id {
                    models[i].document.raw = editor.rawRecipe
                    return
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
            .compactMap { try? NamedDocument(contentsOf: $0) }
            .sorted { $0.name < $1.name }
        selectedDocument = examples.first
    }
}
