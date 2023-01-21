import SwiftUI

@main
struct MiniSliceApp: App {
    @StateObject var stage = StageViewModel()
    @StateObject var editor = EditorViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stage)
                .environmentObject(editor)
        }
    }
}
