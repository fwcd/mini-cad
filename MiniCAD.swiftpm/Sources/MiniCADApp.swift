import SwiftUI

private var preview = PreviewViewModel()
private var editor = EditorViewModel(preview: preview)

@main
struct MiniCADApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(preview)
                .environmentObject(editor)
        }
    }
}
