import Combine
import OSLog

private let log = Logger(subsystem: "EditorViewModel", category: "MiniSlice")

class EditorViewModel: ObservableObject {
    @Published private(set) var cuboids: [Cuboid] = []
    @Published private(set) var parsedRecipe: Recipe = .init() {
        didSet {
            do {
                let values = try interpret(recipe: parsedRecipe)
                cuboids = values.compactMap {
                    if case let .cuboid(cuboid) = $0 {
                        return cuboid
                    } else {
                        return nil
                    }
                }
                interpretError = nil
            } catch let error as InterpretError {
                interpretError = error
            } catch {
                log.warning("Unhandled interpret error: \(error)")
            }
        }
    }
    @Published var rawRecipe: String = "" {
        didSet {
            do {
                parsedRecipe = try parseRecipe(from: rawRecipe)
                parseError = nil
            } catch let error as ParseError {
                parseError = error
            } catch {
                log.warning("Unhandled parse error: \(error)")
            }
        }
    }
    
    @Published private(set) var parseError: ParseError? = nil
    @Published private(set) var interpretError: InterpretError? = nil
    
    init() {
        let recipe = demoRecipe
        rawRecipe = "\(recipe)"
    }
}
