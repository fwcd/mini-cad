import SwiftUI

struct EditorView: View {
    @EnvironmentObject private var editor: EditorViewModel
    
    var body: some View {
        TextEditor(text: .constant(editor.recipe.description))
            .font(.body.monospaced())
    }
}

struct EditorViewPreviews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
