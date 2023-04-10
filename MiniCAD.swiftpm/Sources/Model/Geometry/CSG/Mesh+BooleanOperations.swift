// Inspired by MIT-licensed code from https://github.com/evanw/csg.js
// Copyright (c) 2011 Evan Wallace (http://madebyevan.com/)

extension Mesh {
    func union(_ rhs: Self) -> Self {
        // TODO: Implement union
        return disjointUnion(rhs)
    }
    
    func intersection(_ rhs: Self) -> Self {
        // TODO: Implement intersection
        return disjointUnion(rhs)
    }
    
    /// Return a new CSG solid representing space in this solid but not in the
    /// solid `csg`. Neither this solid nor the solid `csg` are modified.
    ///
    ///     A.subtract(B)
    ///
    ///     +-------+            +-------+
    ///     |       |            |       |
    ///     |   A   |            |       |
    ///     |    +--+----+   =   |    +--+
    ///     +----+--+    |       +----+
    ///          |   B   |
    ///          |       |
    ///          +-------+
    ///
    func subtracting(_ rhs: Self) -> Self {
        var a = BinarySpacePartitioning(inserting: facePolygons)
        var b = BinarySpacePartitioning(inserting: rhs.facePolygons)
        a.invert()
        a.clip(to: b)
        b.clip(to: a)
        b.invert()
        b.clip(to: a)
        b.invert()
        a.insert(polygons: b.allPolygons)
        a.invert()
        return Mesh(a.allPolygons)
    }
}
