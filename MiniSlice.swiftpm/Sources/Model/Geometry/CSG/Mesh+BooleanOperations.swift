/*
 
Our algorithm for Boolean operations proceeds roughly according to the following steps:

    - Compute the smallest bounding box encompassing all potentially intersecting triangles of the two meshes
    - Build an octree within this bounding box of the triangles. Insertion proceeds as follows:
        - At each level: If the triangle is fully contained by one of the eight regions, recuse (otherwise insert the triangle at that level)
        - If the level exceeds a certain maximum depth, insert the triangle at that level too
    - In each octree cell: Compute all intersections of mesh 1 (only triangles at that level) with mesh 2 (all triangles recursively contained by any child)
    - Retriangulate meshes along intersection lines
    - TODO: Perform the actual booleans
 
 */

extension Mesh {
    func union(_ rhs: Self) -> Self {
        // TODO: Implement union
        return disjointUnion(rhs)
    }
    
    func intersection(_ rhs: Self) -> Self {
        // TODO: Implement intersection
        return disjointUnion(rhs)
    }
    
    func subtracting(_ rhs: Self) -> Self {
        // TODO: Implement difference
        return disjointUnion(rhs)
    }
}
