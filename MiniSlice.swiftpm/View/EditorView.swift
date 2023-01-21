//
//  SwiftUIView.swift
//  
//
//  Created by Fredrik on 21.01.23.
//

import SwiftUI

struct EditorView: View {
    @State private var text = ""
    
    var body: some View {
        TextEditor(text: $text)
    }
}

struct EditorViewPreviews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
