import SwiftUI
import UniformTypeIdentifiers

struct OptionsView: View {
    @EnvironmentObject private var preview: PreviewViewModel
    
    var body: some View {
        VStack {
            Toggle("Orthographic Camera", isOn: $preview.options.usesOrthographicProjection)
                .help("Uses an orthographic camera projection (instead of the default perspective projection).")
            Toggle("Show Axes", isOn: $preview.options.showAxes)
                .help("Display the coordinate axes")
            Toggle("Render as Wireframes", isOn: $preview.options.renderAsWireframes)
                .help("Renders meshes as wireframes rather than as solids")
        }
    }
}
