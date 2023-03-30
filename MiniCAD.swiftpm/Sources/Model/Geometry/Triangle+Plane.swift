extension Triangle {
    init(_ plane: Plane) {
        self.init(a: plane.a, b: plane.b, c: plane.c)
    }
    
    /// The projection of a point onto the plane spanned by the triangle.
    func project(_ point: Vec3) -> Vec3 {
        Plane(self).project(point)
    }
}
