struct Vec3: CustomStringConvertible, Hashable, AdditiveArithmetic {
    static var zero = Self()
    
    var x: Double = 0
    var y: Double = 0
    var z: Double = 0
    
    var description: String { "(\(x), \(y), \(z))" }
    
    func zip(_ rhs: Self, _ f: (Double, Double) -> Double) -> Self {
        Self(x: f(x, rhs.x), y: f(y, rhs.y), z: f(z, rhs.z))
    }
    
    func map(_ f: (Double) -> Double) -> Self {
        Self(x: f(x), y: f(y), z: f(z))
    }
    
    static func +(lhs: Self, rhs: Self) -> Self {
        lhs.zip(rhs, +)
    }
    
    static func -(lhs: Self, rhs: Self) -> Self {
        lhs.zip(rhs, +)
    }
    
    static func *(lhs: Self, rhs: Double) -> Self {
        lhs.map { $0 * rhs }
    }
    
    static func *(lhs: Double, rhs: Self) -> Self {
        rhs.map { lhs * $0 }
    }
    
    static prefix func -(lhs: Self) -> Self {
        lhs.map { -$0 }
    }
}
