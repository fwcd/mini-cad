import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var app: AppViewModel
    @State private var newModelSheetShown: Bool = false
    @State private var newModelName: String = ""
    
    var body: some View {
        NavigationView {
            List(selection: $app.selectedDocument) {
                Section(header: Text("Examples")) {
                    ForEach(app.examples) { document in
                        DocumentSnippet(document: document)
                    }
                }
                Section {
                    ForEach(app.models) { document in
                        DocumentSnippet(document: document)
                            .contextMenu {
                                Button {
                                    app.models.removeAll { $0.id == document.id }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .onMove { offsets, target in
                        app.models.move(fromOffsets: offsets, toOffset: target)
                    }
                    .onDelete { offsets in
                        app.models.remove(atOffsets: offsets)
                    }
                    if app.models.isEmpty {
                        Text("Create a model by tapping +")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray.opacity(0.6))
                    }
                } header: {
                    Text("Models")
                    Button {
                        newModelSheetShown = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .popover(isPresented: $newModelSheetShown) {
                        AddModelDialog { modelName in
                            newModelSheetShown = false
                            app.models.append(.init(name: modelName.nilIfEmpty ?? "Untitled Model", document: .init(raw: "// Add some code here")))
                        }
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
