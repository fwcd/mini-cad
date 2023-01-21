import Foundation

struct Identified<Wrapped>: Identifiable {
    var id = UUID()
    var value: Wrapped
}
