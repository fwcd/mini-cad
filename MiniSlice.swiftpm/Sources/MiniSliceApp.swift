import SwiftUI

private var preview = PreviewViewModel()
private var editor = EditorViewModel(preview: preview)

@main
struct MiniSliceApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: RecipeDocument()) { configuration in
            ContentView(document: configuration.$document)
                .environmentObject(preview)
                .environmentObject(editor)
        }
    }
}
