import SwiftUI
import UniformTypeIdentifiers

struct OptionsView: View {
    @EnvironmentObject private var editor: EditorViewModel
    @EnvironmentObject private var preview: PreviewViewModel
    @State private var stlExporterShown: Bool = false
    
    var body: some View {
        VStack {
            Toggle("Orthographic Camera", isOn: $preview.options.usesOrthographicProjection)
            Button {
                stlExporterShown = true
            } label: {
                Image(systemName: "cube.transparent")
                Text("Export STL")
            }
            .buttonStyle(.borderedProminent)
            .fileExporter(isPresented: $stlExporterShown, document: STLDocument(editor.meshes), contentType: .stlDocument) { _ in
                // TODO
            }
        }
    }
}
