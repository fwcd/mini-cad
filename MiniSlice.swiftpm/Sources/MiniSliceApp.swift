import SwiftUI

private var stage = StageViewModel()
private var editor = EditorViewModel(stage: stage)

@main
struct MiniSliceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stage)
                .environmentObject(editor)
        }
    }
}
