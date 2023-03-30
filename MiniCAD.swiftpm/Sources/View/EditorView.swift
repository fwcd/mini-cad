import SwiftUI

struct EditorView: View {
    @EnvironmentObject private var editor: EditorViewModel
    
    var body: some View {
        VStack {
            CodeEditor(text: $editor.rawRecipe, tokens: editor.tokenizedRecipe)
            HStack {
                if let error = editor.parseError {
                    ErrorView(error: error)
                } else if let error = editor.interpretError {
                    ErrorView(error: error, background: Color(red: 0.4, green: 0, blue: 0.4))
                }
            }
        }
    }
}

