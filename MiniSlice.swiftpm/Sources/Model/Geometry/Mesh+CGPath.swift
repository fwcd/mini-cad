import CoreGraphics
import OSLog

private let log = Logger(subsystem: "MiniSlice", category: "Mesh+CGPath")

extension Mesh {
    init(_ path: CGPath) {
        var vertices: [Vec3] = []
        var polygons: [Polygon] = []
        
        path.applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            switch element.type {
            case .moveToPoint, .addLineToPoint:
                if !vertices.isEmpty {
                    polygons.append(.init(vertices: vertices))
                }
                vertices.append(Vec3(element.points[0]))
            case .addQuadCurveToPoint:
                vertices.append(Vec3(element.points[0]))
                vertices.append(Vec3(element.points[1]))
            default:
                log.error("Conversion of CGPathElementType \(String(describing: element.type)) is unsupported")
            }
        }
        
        if !vertices.isEmpty {
            polygons.append(.init(vertices: vertices))
        }
        
        self = polygons.map(Mesh.init).disjointUnion
    }
}
