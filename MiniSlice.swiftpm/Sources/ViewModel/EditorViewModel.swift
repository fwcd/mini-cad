import Combine

class EditorViewModel: ObservableObject {
    @Published var recipe: Recipe = demoRecipe
}
