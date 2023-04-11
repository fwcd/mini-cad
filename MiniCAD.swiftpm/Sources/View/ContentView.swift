import SwiftUI

struct ContentView: View {
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // TODO
        } detail: {
            HStack {
                EditorView()
                PreviewView()
            }
            // TODO: Figure out a more elegant way to integrate the sidebar toggle button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ToolbarView()
                }
            }
        }
    }
}
