import SwiftUI

struct EditorView: View {
    @EnvironmentObject private var editor: EditorViewModel
    
    var body: some View {
        VStack {
            TextEditor(text: $editor.rawRecipe)
                .font(.body.monospaced())
            if let error = editor.error {
                ErrorView(error: error)
            }
            // FIXME: Remove (or prettify) the following debug views
            HStack(alignment: .top, spacing: 20) {
                ScrollView(.vertical) {
                    Text(String(describing: editor.parsedRecipe))
                }
                Group {
                    switch Result(catching: { try interpret(recipe: editor.parsedRecipe) }) {
                    case .success(let values):
                        List(values.map { Identified(value: $0) }) {
                            Text(String(describing: $0.value))
                        }
                    case .failure(let error):
                        ErrorView(error: error)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: 200)
            .padding(10)
        }
    }
}

struct EditorViewPreviews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
