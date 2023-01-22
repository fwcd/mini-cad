import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var stage: StageViewModel
    
    var body: some View {
        VStack {
            Toggle("Orthographic Camera", isOn: $stage.options.usesOrthographicProjection)
        }
    }
}
