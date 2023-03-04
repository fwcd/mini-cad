import SwiftUI
import OSLog

private let log = Logger(subsystem: "MiniSlice", category: "ToolbarView")

struct ToolbarView: View {
    @EnvironmentObject private var editor: EditorViewModel
    @State private var openImporterShown: Bool = false
    @State private var saveExporterShown: Bool = false
    @State private var stlExporterShown: Bool = false
    
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
                    editor.rawRecipe = try String(contentsOf: url)
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
            .help("Saves to a source file (recipe)")
            .keyboardShortcut("s", modifiers: .command)
            .fileExporter(
                isPresented: $saveExporterShown,
                document: RecipeDocument(raw: editor.rawRecipe),
                contentType: .recipeDocument,
                defaultFilename: "Model.recipe"
            ) { _ in }
            
            Button {
                stlExporterShown = true
            } label: {
                Image(systemName: "cube.transparent")
                Text("Export STL (⌘ E)")
            }
            .help("Exports the current model to an STL file.")
            .keyboardShortcut("e", modifiers: .command)
            .fileExporter(
                isPresented: $stlExporterShown,
                document: STLDocument.lazy(editor.meshes),
                contentType: .stlDocument,
                defaultFilename: "Model.stl"
            ) { _ in }
        }
        .buttonStyle(.borderedProminent)
    }
}
