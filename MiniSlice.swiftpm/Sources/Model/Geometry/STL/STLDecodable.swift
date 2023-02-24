import Foundation

protocol STLDecodable {
    init(binaryStl: Data) throws
    
    // TODO: Add decoder from ASCII-STL
}
