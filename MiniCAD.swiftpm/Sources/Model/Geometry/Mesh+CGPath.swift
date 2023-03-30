import CoreGraphics
import OSLog

private let log = Logger(subsystem: "MiniCAD", category: "Mesh+CGPath")

extension Array where Element == Mesh {
    init(_ path: CGPath) {
        var vertices: [Vec3] = []
        var meshes: [Mesh] = []
        
        func closePath() {
            if vertices.count >= 3 {
                meshes.append(Mesh(Polygon(vertices: vertices.reversed())))
            }
            vertices = []
        }
        
        path.applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            switch element.type {
            case .moveToPoint:
                closePath()
                vertices.append(Vec3(element.points[0]))
            case .addLineToPoint:
                vertices.append(Vec3(element.points[0]))
            case .addQuadCurveToPoint:
                vertices.append(Vec3(element.points[0]))
                vertices.append(Vec3(element.points[1]))
            case .closeSubpath:
                closePath()
            default:
                log.error("Conversion of CGPathElementType \(String(describing: element.type)) is unsupported")
            }
        }
        
        closePath()
        
        self = meshes
    }
}

extension Mesh {
    init(_ path: CGPath) {
        self = [Mesh](path).disjointUnion
    }
}
