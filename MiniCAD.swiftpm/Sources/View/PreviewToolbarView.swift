import SwiftUI
import OSLog

private let log = Logger(subsystem: "MiniCAD", category: "PreviewToolbarView")

struct PreviewToolbarView: View {
    @EnvironmentObject private var editor: EditorViewModel
    @State private var stlExporterShown: Bool = false
    
    var body: some View {
        HStack {
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
