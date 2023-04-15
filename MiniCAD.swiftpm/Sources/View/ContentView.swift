import SwiftUI

struct ContentView: View {
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @EnvironmentObject private var app: AppViewModel
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $app.selectedDocument) {
                Section(header: Text("Documents")) {
                    ForEach(app.documents.sorted { $0.name < $1.name }) { document in
                        Label(document.name, systemImage: "doc.text")
                            .tag(document)
                    }
                }
            }
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
