import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let stlDocument = UTType(importedAs: "public.standard-tesselated-geometry-format")
}

struct STLDocument {
    var raw: String = ""
}

extension STLDocument {
    init<T>(_ convertible: T) where T: STLConvertible {
        self.init(raw: convertible.asAsciiStl)
    }
}

extension STLDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.stlDocument]
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
