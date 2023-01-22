import SwiftUI

struct EditorView: View {
    @EnvironmentObject private var editor: EditorViewModel
    
    var body: some View {
        VStack {
            CodeEditor(text: $editor.rawRecipe)
            HStack {
                if let error = editor.parseError {
                    ErrorView(error: error)
                } else if let error = editor.interpretError {
                    ErrorView(error: error, background: Color(red: 0.4, green: 0, blue: 0.4))
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

