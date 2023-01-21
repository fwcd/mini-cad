import Combine

class EditorViewModel: ObservableObject {
    @Published var recipe: Recipe = .init(statements: [
        .varBinding(.init(name: "x", value: 3)),
        .varBinding(.init(name: "y", value: 4.3)),
        .blank,
        .expression(.call("Cube", [])),
    ])
}
