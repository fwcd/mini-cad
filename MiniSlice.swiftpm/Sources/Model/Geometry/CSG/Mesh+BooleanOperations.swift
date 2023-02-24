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
