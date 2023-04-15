import SwiftUI

private let preview = PreviewViewModel()
private let editor = EditorViewModel(preview: preview)
private let app = AppViewModel(editor: editor)

@main
struct MiniCADApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(preview)
                .environmentObject(editor)
                .environmentObject(app)
        }
    }
}
