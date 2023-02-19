import SwiftUI

struct ContentView: View {
    @Binding var document: RecipeDocument
    @EnvironmentObject private var editor: EditorViewModel
    
    var body: some View {
        HStack {
            EditorView()
            PreviewView()
        }
        .onAppear {
            // TODO: Is this sufficient? The user should be able to open documents, which might not cause the ContentView to 're-appear' but only update? We don't listen to document changes directly to prevent a listener cycle.
            editor.rawRecipe = document.raw
        }
        .onChange(of: editor.rawRecipe) { raw in
            document.raw = raw
        }
    }
}
