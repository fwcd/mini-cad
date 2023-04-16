import SwiftUI

struct AddModelDialog: View {
    let onSubmit: (String) -> Void
    
    @State private var modelName: String = ""
    
    var body: some View {
        HStack {
            TextField(text: $modelName) {
                Text("Model Name")
            }
            .frame(width: 300)
            .onSubmit {
                onSubmit(modelName)
            }
            Button {
                onSubmit(modelName)
            } label: {
                Text("Add Model")
            }
        }
        .padding(10)
    }
}
