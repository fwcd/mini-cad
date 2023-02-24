extension Plane {
    func intersection(_ line: Line) -> Vec3 {
        // TODO: Handle degenerate cases
        
        let normal = self.normal
        let origin = line.a
        let direction = line.b - line.a
        
        // normal.dot((origin + lambda * direction) - a) == 0
        // normal.dot(origin) + lambda * normal.dot(direction) - normal.dot(a) == 0
        // lambda == (normal.dot(a) - normal.dot(origin)) / normal.dot(direction)
        
        let lambda = (normal.dot(a) - normal.dot(origin)) / normal.dot(direction)
        
        return origin + lambda * direction
    }
}

extension Line {
    func intersection(_ plane: Plane) -> Vec3 {
        plane.intersection(self)
    }
}
