import SceneKit

/// A 3x3 matrix.
struct Mat3: CustomStringConvertible, Hashable, AdditiveArithmetic {
    static var zero = Self()
    
    var i: Vec3 = .init(x: 1)
    var j: Vec3 = .init(y: 1)
    var k: Vec3 = .init(z: 1)
    
    var transpose: Self {
        Self(
            i: Vec3(x: i.x, y: j.x, z: k.x),
            j: Vec3(x: i.y, y: j.y, z: k.y),
            k: Vec3(x: i.z, y: j.z, z: k.z)
        )
    }
    
    var description: String { "(\(i), \(j), \(k))^T" }
    
    func zip(_ rhs: Self, _ f: (Double, Double) -> Double) -> Self {
        Self(i: i.zip(rhs.i, f), j: j.zip(rhs.j, f), k: k.zip(rhs.k, f))
    }
    
    func map(_ f: (Double) -> Double) -> Self {
        Self(i: i.map(f), j: j.map(f), k: k.map(f))
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
    
    static func *(lhs: Self, rhs: Vec3) -> Vec3 {
        let t = lhs.transpose
        return Vec3(x: t.i.dot(rhs), y: t.j.dot(rhs), z: t.k.dot(rhs))
    }
    
    static func *(lhs: Self, rhs: Self) -> Self {
        Self(i: lhs * rhs.i, j: lhs * rhs.j, k: lhs * rhs.k)
    }
    
    static func /(lhs: Self, rhs: Double) -> Self {
        lhs.map { $0 / rhs }
    }
    
    static prefix func -(lhs: Self) -> Self {
        lhs.map { -$0 }
    }
}

extension Mat3 {
    init(xyzEuler: Vec3) {
        // Based on https://blender.stackexchange.com/a/272110
        let ci = cos(xyzEuler.x)
        let cj = cos(xyzEuler.y)
        let ch = cos(xyzEuler.z)
        let si = sin(xyzEuler.x)
        let sj = sin(xyzEuler.y)
        let sh = sin(xyzEuler.z)
        let cc = ci * ch
        let cs = ci * sh
        let sc = si * ch
        let ss = si * sh
        self.init(
            i: Vec3(x: cj * ch, y: cj * sh, z: -sj),
            j: Vec3(x: sj * sc - cs, y: sj * ss + cc, z: cj * si),
            k: Vec3(x: sj * cc + ss, y: sj * cs - sc, z: cj * ci)
        )
    }
    
    init(diagonal: Vec3) {
        self.init(i: .init(x: diagonal.x), j: .init(y: diagonal.y), k: .init(z: diagonal.z))
    }
}
