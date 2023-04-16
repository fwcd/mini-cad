import SwiftUI

struct DocumentSnippet: View {
    let document: NamedDocument
    
    var body: some View {
        Label(document.name, systemImage: "doc.text")
            .tag(document)
    }
}

