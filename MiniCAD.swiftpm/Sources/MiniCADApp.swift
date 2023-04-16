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
                .onAppear {
                    #if targetEnvironment(macCatalyst) && canImport(UIKit)
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        scene.sizeRestrictions?.minimumSize = CGSize(width: 1600, height: 700)
                    }
                    #endif
                }
        }
    }
}
