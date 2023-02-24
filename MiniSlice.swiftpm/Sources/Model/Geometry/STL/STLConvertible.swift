import Foundation

protocol STLConvertible {
    var asAsciiStl: String { get }
    var asBinaryStl: Data { get }
}
