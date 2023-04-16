import CoreGraphics
import OSLog

private let log = Logger(subsystem: "MiniCAD", category: "MultiPolygon+CGPath")

extension MultiPolygon {
    init(_ path: CGPath) {
        var vertices: [Vec3] = []
        
        func closePath() {
            if vertices.count >= 3 {
                paths.append(Polygon(vertices: vertices.reversed()))
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
    }
}
