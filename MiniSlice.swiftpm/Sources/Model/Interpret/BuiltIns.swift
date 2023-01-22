/// The built-in functions.
let builtIns: [String: ([Value], [Value]) -> [Value]] = [
    "Cuboid": { args, _ in
        // TODO: Should we pass vector/tuple-ish types?
        let size = parseVec3(from: args, default: .init(x: 1, y: 1, z: 1))
        return [.cuboid(Cuboid(size: size))]
    },
    "Translate": { args, trailingBlock in
        let offset = parseVec3(from: args)
        let cuboids = trailingBlock.compactMap(\.asCuboid)
        return cuboids.map {
            var cuboid = $0
            cuboid.center = cuboid.center + offset
            return .cuboid(cuboid)
        }
    },
]

private func parseVec3(from args: [Value], default: Vec3 = .zero) -> Vec3 {
    Vec3(
        x: args[safely: 0]?.asFloat ?? `default`.x,
        y: args[safely: 1]?.asFloat ?? `default`.y,
        z: args[safely: 2]?.asFloat ?? `default`.z
    )
}
