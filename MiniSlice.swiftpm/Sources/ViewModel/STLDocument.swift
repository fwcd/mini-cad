import Foundation
import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let stlDocument = UTType(importedAs: "public.standard-tesselated-geometry-format")
}

enum STLDocument {
    case ascii(String)
    case binary(Data)
}

extension STLDocument {
    init<T>(_ convertible: T, useAscii: Bool = true) where T: STLConvertible {
        if useAscii {
            self = .ascii(convertible.asAsciiStl)
        } else {
            self = .binary(convertible.asBinaryStl)
        }
    }
}

extension STLDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.stlDocument]
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        if let raw = String(data: data, encoding: .utf8), raw.starts(with: "solid") {
            self = .ascii(raw)
        } else {
            self = .binary(data)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        switch self {
        case .binary(let data):
            return FileWrapper(regularFileWithContents: data)
        case .ascii(let raw):
            guard let data = raw.data(using: .utf8) else {
                throw CocoaError(.fileWriteInapplicableStringEncoding)
            }
            return FileWrapper(regularFileWithContents: data)
        }
    }
}
