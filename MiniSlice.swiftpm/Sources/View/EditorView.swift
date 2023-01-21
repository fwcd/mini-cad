import SwiftUI

struct EditorView: View {
    @EnvironmentObject private var editor: EditorViewModel
    
    var body: some View {
        VStack {
            TextEditor(text: $editor.rawRecipe)
                .font(.body.monospaced())
            if let error = editor.error {
                Text("Could not parse program: \(String(describing: error))")
            }
            Text(String(describing: editor.parsedRecipe))
        }
    }
}

struct EditorViewPreviews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
