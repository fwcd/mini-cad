import SwiftUI

struct AddModelDialog: View {
    let onSubmit: (String) -> Void
    
    @State private var modelName: String = ""
    
    var body: some View {
        HStack {
            AutoFocusTextField(placeholder: "Model Name", text: $modelName) {
                onSubmit(modelName)
            }
            .frame(width: 300)
            Button {
                onSubmit(modelName)
            } label: {
                Text("Add Model")
            }
        }
        .padding(10)
    }
}
