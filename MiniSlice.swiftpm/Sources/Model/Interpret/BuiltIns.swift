let builtIns: [String: ([Value]) -> Value] = [
    "Cuboid": { args in
        // TODO: Should we pass vector/tuple-ish types?
        let size = parseVec3(from: args, default: .init(x: 1, y: 1, z: 1))
        return .cuboid(Cuboid(size: size))
    },
    "Translate": { args in
        let offset = parseVec3(from: args)
        guard var cuboid = args[safely: 3]?.asCuboid else { return .nil }
        cuboid.center = cuboid.center + offset
        return .cuboid(cuboid)
    },
]

private func parseVec3(from args: [Value], default: Vec3 = .zero) -> Vec3 {
    Vec3(
        x: args[safely: 0]?.asFloat ?? `default`.x,
        y: args[safely: 1]?.asFloat ?? `default`.y,
        z: args[safely: 2]?.asFloat ?? `default`.z
    )
}
