import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var app: AppViewModel
    
    var body: some View {
        NavigationView {
            List(selection: $app.selectedDocument) {
                Section(header: Text("Examples")) {
                    ForEach(app.examples) { document in
                        Label(document.name, systemImage: "doc.text")
                            .tag(document)
                    }
                }
            }
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
