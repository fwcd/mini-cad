import SceneKit

/// A vector in (continuous) 3D space.
struct Vec3: CustomStringConvertible, Hashable, AdditiveArithmetic {
    static let zero = Self()
    
    var x: Double = 0
    var y: Double = 0
    var z: Double = 0
    
    var magnitude: Double {
        (x * x + y * y + z * z).squareRoot()
    }
    
    var normalized: Vec3 {
        self / magnitude
    }
    
    var description: String { "(\(x), \(y), \(z))" }
    
    func zip(_ rhs: Self, _ f: (Double, Double) -> Double) -> Self {
        Self(x: f(x, rhs.x), y: f(y, rhs.y), z: f(z, rhs.z))
    }
    
    func map(_ f: (Double) -> Double) -> Self {
        Self(x: f(x), y: f(y), z: f(z))
    }
    
    func dot(_ rhs: Self) -> Double {
        x * rhs.x + y * rhs.y + z * rhs.z
    }
    
    func cross(_ rhs: Self) -> Self {
        Self(
            x: y * rhs.z - rhs.y * z,
            y: rhs.x * z - x * rhs.z,
            z: x * rhs.y - rhs.x * y
        )
    }
    
    func max(_ rhs: Self) -> Self {
        zip(rhs, Swift.max)
    }
    
    func min(_ rhs: Self) -> Self {
        zip(rhs, Swift.min)
    }
    
    func interpolate(_ rhs: Self, _ lambda: Double) -> Self {
        zip(rhs) {
            $0 * (1 - lambda) + $1 * lambda
        }
    }
    
    static func +(lhs: Self, rhs: Self) -> Self {
        lhs.zip(rhs, +)
    }
    
    static func -(lhs: Self, rhs: Self) -> Self {
        lhs.zip(rhs, -)
    }
    
    static func *(lhs: Self, rhs: Double) -> Self {
        lhs.map { $0 * rhs }
    }
    
    static func *(lhs: Double, rhs: Self) -> Self {
        rhs.map { lhs * $0 }
    }
    
    static func /(lhs: Self, rhs: Double) -> Self {
        lhs.map { $0 / rhs }
    }
    
    static prefix func -(lhs: Self) -> Self {
        lhs.map { -$0 }
    }
    
    static func >=(lhs: Self, rhs: Self) -> Bool {
        lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z
    }
    
    static func <=(lhs: Self, rhs: Self) -> Bool {
        lhs.x <= rhs.x && lhs.y <= rhs.y && lhs.z <= rhs.z
    }
    
    static func >(lhs: Self, rhs: Self) -> Bool {
        lhs.x > rhs.x && lhs.y > rhs.y && lhs.z > rhs.z
    }
    
    static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z
    }
}

extension Vec3 {
    init(all value: Double) {
        self.init(x: value, y: value, z: value)
    }
}

extension SCNVector3 {
    init(_ vec3: Vec3) {
        self.init(x: Float(vec3.x), y: Float(vec3.y), z: Float(vec3.z))
    }
}

extension SCNVector4 {
    init(_ vec3: Vec3, w: Double = 0) {
        self.init(x: Float(vec3.x), y: Float(vec3.y), z: Float(vec3.z), w: Float(w))
    }
}

extension Vec3 {
    init(_ scnVec: SCNVector3) {
        self.init(x: Double(scnVec.x), y: Double(scnVec.y), z: Double(scnVec.z))
    }
    
    init(_ scnVec: SCNVector4) {
        self.init(x: Double(scnVec.x), y: Double(scnVec.y), z: Double(scnVec.z))
    }
    
    init(_ point: CGPoint) {
        self.init(x: Double(point.x), y: Double(point.y))
    }
}
