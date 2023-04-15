import SwiftUI

struct EditorView: View {
    @EnvironmentObject private var editor: EditorViewModel
    
    var body: some View {
        VStack {
            CodeEditor(text: $editor.rawRecipe, tokens: editor.tokenizedRecipe)
            HStack {
                if editor.isRunning {
                    ProgressView()
                        .padding(10)
                } else if let error = editor.parseError {
                    StatusBar(error: error)
                } else if let error = editor.interpretError {
                    StatusBar(error: error, background: Color(red: 0.4, green: 0, blue: 0.4))
                }
            }
        }
    }
}

