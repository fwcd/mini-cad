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
            // FIXME: Remove the following debug views
            HStack(alignment: .top, spacing: 20) {
                Text(String(describing: editor.parsedRecipe))
                Group {
                    switch Result(catching: { try interpret(recipe: editor.parsedRecipe) }) {
                    case .success(let values):
                        Text(String(describing: values))
                    case .failure(let error):
                        ErrorView(error: error)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(10)
        }
    }
}

struct EditorViewPreviews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
