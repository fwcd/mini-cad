import Combine
import OSLog

private let log = Logger(subsystem: "EditorViewModel", category: "MiniSlice")

class EditorViewModel: ObservableObject {
    @Published private(set) var parsedRecipe: Recipe
    @Published private(set) var error: ParseError?
    @Published var rawRecipe: String {
        didSet {
            do {
                parsedRecipe = try parseRecipe(from: rawRecipe)
                error = nil
            } catch let error as ParseError {
                self.error = error
            } catch {
                log.warning("Unhandled parse error: \(error)")
            }
        }
    }
    
    init() {
        let recipe = demoRecipe
        parsedRecipe = recipe
        error = nil
        rawRecipe = "\(recipe)"
    }
}
