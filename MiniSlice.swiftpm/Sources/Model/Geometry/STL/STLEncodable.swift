import Foundation

protocol STLEncodable {
    var asAsciiStl: String { get }
    var asBinaryStl: Data { get }
}
