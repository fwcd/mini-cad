extension Triangle {
    init(_ plane: Plane) {
        self.init(a: plane.a, b: plane.b, c: plane.c)
    }
    
    /// Whether triangle contains the given point after projection to the plane.
    func planarContains(_ point: Vec3) -> Bool {
        let plane = Plane(self)
        plane.project(point)
        return false // TODO
    }
}
