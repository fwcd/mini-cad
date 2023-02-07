import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var preview: PreviewViewModel
    
    var body: some View {
        VStack {
            Toggle("Orthographic Camera", isOn: $preview.options.usesOrthographicProjection)
        }
    }
}
