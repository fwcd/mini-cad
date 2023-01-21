import SwiftUI

@main
struct MiniSliceApp: App {
    @StateObject var stage = StageViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stage)
        }
    }
}
