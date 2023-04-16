// Based on MIT-licensed code from https://github.com/evanw/csg.js
// Copyright (c) 2011 Evan Wallace (http://madebyevan.com/)

// Constructive Solid Geometry (CSG) is a modeling technique that uses Boolean
// operations like union and intersection to combine 3D solids. This file
// implements CSG operations on meshes elegantly and concisely using BSP trees,
// and is meant to serve as an easily understandable implementation of the
// algorithm. All edge cases involving overlapping coplanar polygons in both
// solids are correctly handled.
//
// Example usage:
//
//     let cube = Cuboid()
//     let cylinder = Cylinder()
//     let difference = cube.subtracting(cylinder)
//
// ## Implementation Details
//
// All CSG operations are implemented in terms of two functions, `clip(to:)` and
// `invert()`, which remove parts of a BSP tree inside another BSP tree and swap
// solid and empty space, respectively. To find the union of `a` and `b`, we
// want to remove everything in `a` inside `b` and everything in `b` inside `a`,
// then combine polygons from `a` and `b` into one solid:
//
//     a.clip(to: b)
//     b.clip(to: a)
//     a.insert(polygons: b.allPolygons)
//
// The only tricky part is handling overlapping coplanar polygons in both trees.
// The code above keeps both copies, but we need to keep them in one tree and
// remove them in the other tree. To remove them from `b` we can clip the
// inverse of `b` against `a`. The code for union now looks like this:
//
//     a.clip(to: b)
//     b.clip(to: a)
//     b.invert()
//     b.clip(to: a)
//     b.invert()
//     a.insert(polygons: b.allPolygons)
//
// Subtraction and intersection naturally follow from set operations. If
// union is `A | B`, subtraction is `A - B = ~(~A | B)` and intersection is
// `A & B = ~(~A | ~B)` where `~` is the complement operator.

extension Mesh {
    /// Return a new CSG solid representing space in either this solid or in the
    /// solid `csg`. Neither this solid nor the solid `csg` are modified.
    ///
    ///     A.union(B)
    ///
    ///     +-------+            +-------+
    ///     |       |            |       |
    ///     |   A   |            |       |
    ///     |    +--+----+   =   |       +----+
    ///     +----+--+    |       +----+       |
    ///          |   B   |            |       |
    ///          |       |            |       |
    ///          +-------+            +-------+
    ///
    func union(_ rhs: Self) throws -> Self {
        var a = try BinarySpacePartitioning(inserting: facePolygons)
        var b = try BinarySpacePartitioning(inserting: rhs.facePolygons)
        try a.clip(to: b)
        try b.clip(to: a)
        try b.invert()
        try b.clip(to: a)
        try b.invert()
        try a.insert(polygons: b.allPolygons)
        return Mesh(a.allPolygons)
    }
    
    /// Return a new CSG solid representing space both this solid and in the
    /// solid `csg`. Neither this solid nor the solid `csg` are modified.
    ///
    ///     A.intersect(B)
    ///
    ///     +-------+
    ///     |       |
    ///     |   A   |
    ///     |    +--+----+   =   +--+
    ///     +----+--+    |       +--+
    ///          |   B   |
    ///          |       |
    ///          +-------+
    ///
    func intersection(_ rhs: Self) throws -> Self {
        var a = try BinarySpacePartitioning(inserting: facePolygons)
        var b = try BinarySpacePartitioning(inserting: rhs.facePolygons)
        try a.invert()
        try b.clip(to: a)
        try b.invert()
        try a.clip(to: b)
        try b.clip(to: a)
        try a.insert(polygons: b.allPolygons)
        try a.invert()
        return Mesh(a.allPolygons)
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
    func subtracting(_ rhs: Self) throws -> Self {
        var a = try BinarySpacePartitioning(inserting: facePolygons)
        var b = try BinarySpacePartitioning(inserting: rhs.facePolygons)
        try a.invert()
        try a.clip(to: b)
        try b.clip(to: a)
        try b.invert()
        try b.clip(to: a)
        try b.invert()
        try a.insert(polygons: b.allPolygons)
        try a.invert()
        return Mesh(a.allPolygons)
    }
}
