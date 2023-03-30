import Combine
import OSLog

private let log = Logger(subsystem: "MiniCAD", category: "EditorViewModel")

class EditorViewModel: ObservableObject {
    @Published private(set) var meshes: [Mesh] = [] {
        didSet {
            preview.update(meshes: meshes)
        }
    }
    @Published private(set) var parsedRecipe: Recipe<SourceRange?> = .init() {
        didSet {
            do {
                let values = try interpret(recipe: parsedRecipe)
                meshes = values.compactMap(\.asMesh)
                interpretError = nil
            } catch let error as InterpretError {
                interpretError = error
            } catch {
                log.warning("Unhandled interpret error: \(error)")
            }
        }
    }
    @Published private(set) var tokenizedRecipe: [Token] = [] {
        didSet {
            do {
                parsedRecipe = try parseRecipe(from: tokenizedRecipe)
                parseError = nil
            } catch let error as ParseError {
                parseError = error
            } catch {
                log.warning("Unhandled parse error: \(error)")
            }
        }
    }
    @Published var rawRecipe: String = "" {
        didSet {
            tokenizedRecipe = tokenize(rawRecipe)
        }
    }
    
    @Published private(set) var parseError: ParseError? = nil
    @Published private(set) var interpretError: InterpretError? = nil
    
    private var preview: PreviewViewModel
    
    init(preview: PreviewViewModel) {
        self.preview = preview
        
        rawRecipe = rawDemoRecipe
    }
}
