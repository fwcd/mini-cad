import SwiftUI

struct EditorView: View {
    @EnvironmentObject private var editor: EditorViewModel
    
    var body: some View {
        VStack {
            TextEditor(text: $editor.rawRecipe)
                .font(.body.monospaced())
            HStack {
                if let error = editor.parseError {
                    ErrorView(error: error)
                } else if let error = editor.interpretError {
                    ErrorView(error: error)
                }
            }
            // FIXME: Remove (or prettify) the following debug views
            HStack(alignment: .top, spacing: 20) {
                ScrollView(.vertical) {
                    Text(String(describing: editor.parsedRecipe))
                }
                Group {
                    List(editor.cuboids.map { Identified(value: $0) }) {
                        Text(String(describing: $0.value))
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
