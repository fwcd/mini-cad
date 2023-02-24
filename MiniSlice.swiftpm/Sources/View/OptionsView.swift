import SwiftUI
import UniformTypeIdentifiers

struct OptionsView: View {
    @EnvironmentObject private var editor: EditorViewModel
    @EnvironmentObject private var preview: PreviewViewModel
    @State private var stlExporterShown: Bool = false
    
    var body: some View {
        VStack {
            Toggle("Orthographic Camera", isOn: $preview.options.usesOrthographicProjection)
                .help("Uses an orthographic camera projection (instead of the default perspective projection).")
            Button {
                stlExporterShown = true
            } label: {
                Image(systemName: "cube.transparent")
                Text("Export STL (⌘ E)")
            }
            .help("Exports the current model to an STL file.")
            .buttonStyle(.borderedProminent)
            .keyboardShortcut("e", modifiers: .command)
            .fileExporter(
                isPresented: $stlExporterShown,
                document: STLDocument(editor.meshes),
                contentType: .stlDocument,
                defaultFilename: "Model.stl"
            ) { _ in }
        }
    }
}
