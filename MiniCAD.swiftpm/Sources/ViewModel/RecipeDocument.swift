import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let recipeDocument = UTType(exportedAs: "dev.fwcd.MiniCAD.recipe3")
}

struct RecipeDocument {
    var raw: String = ""
}

extension RecipeDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.recipeDocument]
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let raw = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.raw = raw
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let data = raw.data(using: .utf8) else {
            throw CocoaError(.fileWriteInapplicableStringEncoding)
        }
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        return fileWrapper
    }
}
