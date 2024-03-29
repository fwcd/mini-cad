import SwiftUI
import OSLog

private let log = Logger(subsystem: "MiniCAD", category: "ToolbarView")

struct ToolbarView: View {
    @EnvironmentObject private var app: AppViewModel
    @EnvironmentObject private var editor: EditorViewModel
    @State private var openImporterShown: Bool = false
    @State private var saveExporterShown: Bool = false
    
    var body: some View {
        HStack {
            Button {
                openImporterShown = true
            } label: {
                Image(systemName: "folder")
                Text("Open (⌘ O)")
            }
            .help("Opens a source file (recipe)")
            .keyboardShortcut("o", modifiers: .command)
            .fileImporter(
                isPresented: $openImporterShown,
                allowedContentTypes: [.recipeDocument]
            ) { result in
                guard case let .success(url) = result else { return }
                do {
                    let document = try NamedDocument(contentsOf: url)
                    app.models.append(document)
                    app.selectedDocument = document
                } catch {
                    log.error("Could not read file: \(error)")
                }
            }
            
            Button {
                saveExporterShown = true
            } label: {
                Image(systemName: "arrow.down.to.line")
                Text("Save (⌘ S)")
            }
            .help("Saves to a source file (.minicad)")
            .keyboardShortcut("s", modifiers: .command)
            .fileExporter(
                isPresented: $saveExporterShown,
                document: RecipeDocument(raw: editor.rawRecipe),
                contentType: .recipeDocument,
                defaultFilename: "Model.minicad"
            ) { _ in }
        }
        .buttonStyle(.bordered)
    }
}
