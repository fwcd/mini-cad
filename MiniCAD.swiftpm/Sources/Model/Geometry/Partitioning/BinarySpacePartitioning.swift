// Based on MIT-licensed code from https://github.com/evanw/csg.js
// Copyright (c) 2011 Evan Wallace (http://madebyevan.com/)

/// A binary space partitioning node used to perform CSG operations.
struct BinarySpacePartitioning {
    /// The plane of this node.
    private(set) var plane: Plane? = nil
    /// The front side.
    @Box private(set) var front: BinarySpacePartitioning? = nil
    /// The back side.
    @Box private(set) var back: BinarySpacePartitioning? = nil
    /// Polygons within the plane.
    private(set) var polygons: [Polygon] = []
    
    /// All of the polygons that are recursively contained in this BSP tree.
    var allPolygons: [Polygon] {
        polygons + (front?.allPolygons ?? []) + (back?.allPolygons ?? [])
    }
    
    /// Convert solid to empty space and vice versa.
    mutating func invert() throws {
        try Task.checkCancellation()
        
        for i in polygons.indices {
            polygons[i].flip()
        }
        plane?.flip()
        try front?.invert()
        try back?.invert()
        (front, back) = (back, front)
    }
    
    /// Inserts the given polygons.
    mutating func insert(polygons insertedPolygons: [Polygon]) throws {
        try Task.checkCancellation()
        
        guard let firstPolygon = insertedPolygons.first else { return }
        
        if plane == nil {
            plane = Plane(firstPolygon)
        }
        
        var frontPolygons: [Polygon] = []
        var backPolygons: [Polygon] = []
        var coplanarFront: [Polygon] = []
        var coplanarBack: [Polygon] = []
        
        // Classify polygons into coplanar and front/back
        for polygon in insertedPolygons {
            try plane!.split(
                polygon: polygon,
                coplanarFront: &coplanarFront,
                coplanarBack: &coplanarBack,
                front: &frontPolygons,
                back: &backPolygons
            )
        }
        
        // Store coplanar polygons in this node
        polygons += coplanarFront + coplanarBack
        
        // Recursively build BSP tree on front and back side
        if !frontPolygons.isEmpty {
            if front == nil {
                front = BinarySpacePartitioning()
            }
            try front!.insert(polygons: frontPolygons)
        }
        if !backPolygons.isEmpty {
            if back == nil {
                back = BinarySpacePartitioning()
            }
            try back!.insert(polygons: backPolygons)
        }
    }
    
    /// Remove all polygons in this BSP that are inside the other BSP tree.
    mutating func clip(to bsp: BinarySpacePartitioning) throws {
        polygons = try bsp.clip(polygons: polygons)
        try front?.clip(to: bsp)
        try back?.clip(to: bsp)
    }
    
    /// Filter out all of the given polygons that are inside this BSP tree.
    private func clip(polygons clippedPolygons: [Polygon]) throws -> [Polygon] {
        guard let plane = self.plane else {
            return polygons
        }
        
        var frontPolygons: [Polygon] = []
        var backPolygons: [Polygon] = []
        var coplanarFront: [Polygon] = []
        var coplanarBack: [Polygon] = []
        
        for polygon in clippedPolygons {
            try plane.split(
                polygon: polygon,
                coplanarFront: &coplanarFront,
                coplanarBack: &coplanarBack,
                front: &frontPolygons,
                back: &backPolygons
            )
        }
        
        frontPolygons += coplanarFront
        backPolygons += coplanarBack
        
        if let front = self.front {
            frontPolygons = try front.clip(polygons: frontPolygons)
        }
        if let back = self.back {
            backPolygons = try back.clip(polygons: backPolygons)
        } else {
            backPolygons = []
        }
        
        return frontPolygons + backPolygons
    }
}

extension BinarySpacePartitioning {
    init(inserting polygons: [Polygon]) throws {
        self.init()
        try insert(polygons: polygons)
    }
}

private struct Classification: OptionSet {
    let rawValue: UInt8
    
    static let coplanar: Self = []
    static let front = Self(rawValue: 1)
    static let back = Self(rawValue: 2)
    static let spanning = Self(rawValue: 3)
}

extension Plane {
    /// Split the polygon in this plane if needed and put the fragments into the appropriate lists. Coplanar polygons go into either `coplanarFront` or `coplanarBack`, depending on orientation and polygons in front or back go into either `front` or `back`.
    fileprivate func split(
        polygon: Polygon,
        coplanarFront: inout [Polygon],
        coplanarBack: inout [Polygon],
        front: inout [Polygon],
        back: inout [Polygon]
    ) throws {
        try Task.checkCancellation()
        
        guard polygon.vertices.count >= 3 else { return }
        
        // Classification tolerance
        let epsilon = GeometryDefaults.epsilon
        
        // Classify each point as well as the entire polygon
        var polygonClass: Classification = []
        var vertexClasses: [Classification] = []
        let normal = self.normal
        let offset = normal.dot(b)
        
        for vertex in polygon.vertices {
            let t = normal.dot(vertex) - offset
            let vertexClass: Classification = (t < -epsilon)
                ? .front
                : (t > epsilon)
                    ? .back
                    : .coplanar
            polygonClass.insert(vertexClass)
            vertexClasses.append(vertexClass)
        }
        
        // Put the polygon in the correct list, splitting if necessary
        let polygonPlane = Plane(polygon)
        switch polygonClass {
        case .coplanar:
            if normal.dot(polygonPlane.normal) > 0 {
                coplanarFront.append(polygon)
            } else {
                coplanarBack.append(polygon)
            }
        case .front:
            front.append(polygon)
        case .back:
            back.append(polygon)
        case .spanning:
            var frontVertices: [Vec3] = []
            var backVertices: [Vec3] = []
            
            for i in 0..<polygon.vertices.count {
                let j = (i + 1) % polygon.vertices.count
                
                let ci = vertexClasses[i]
                let cj = vertexClasses[j]
                let vi = polygon.vertices[i]
                let vj = polygon.vertices[j]
                
                if ci != .back {
                    frontVertices.append(vi)
                }
                if ci != .front {
                    backVertices.append(vi)
                }
                
                if case .spanning = ci.union(cj) {
                    let t = (offset - normal.dot(vi)) / normal.dot(vj - vi)
                    let planeIntersection = vi.interpolate(vj, t)
                    frontVertices.append(planeIntersection)
                    backVertices.append(planeIntersection)
                }
            }
            
            if frontVertices.count >= 3 {
                front.append(Polygon(vertices: frontVertices))
            }
            if backVertices.count >= 3 {
                back.append(Polygon(vertices: backVertices))
            }
        default:
            fatalError("Unreachable")
        }
    }
}
