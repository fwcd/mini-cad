//
//  ToolbarView.swift
//  MiniSlice
//
//  Created by Fredrik on 24.02.23.
//

import SwiftUI

struct ToolbarView: View {
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
                document: STLDocument(editor.meshes),
                contentType: .stlDocument,
                defaultFilename: "Model.stl"
            ) { _ in }
        }
        .buttonStyle(.borderedProminent)
    }
}
