let demoRecipe: Recipe = Recipe(statements: [
    .varBinding(.init(name: "w", value: 3)),
    .varBinding(.init(name: "h", value: 4)),
    .blank,
    .forLoop(.init(name: "i", sequence: .binary(.init(lhs: 0, op: .toExclusive, rhs: "w")), block: [
        .forLoop(.init(name: "j", sequence: .binary(.init(lhs: 0, op: .toExclusive, rhs: "h")), block: [
            .expression(.call(.init(identifier: "Translate", args: ["i", "i", "j"], trailingBlock: [
                .expression(.call("Cuboid")),
            ]))),
        ])),
    ])),
])
