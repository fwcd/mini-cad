import Foundation

extension Data {
    mutating func append<T>(unsafeBytesOf value: T) {
        Swift.withUnsafeBytes(of: value) { ptr in
            self += ptr
        }
    }
}
