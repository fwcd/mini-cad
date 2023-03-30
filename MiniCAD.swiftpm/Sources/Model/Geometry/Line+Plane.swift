extension Line {
    func intersection(_ plane: Plane) -> Vec3 {
        plane.intersection(self)
    }
}
