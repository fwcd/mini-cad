let demoRecipe: Recipe = Recipe(statements: [
    .varBinding(.init(name: "w", value: 3)),
    .varBinding(.init(name: "h", value: 4)),
    .blank,
    .forLoop(.init(name: "i", sequence: .binary(.range(0, "w")), block: [
        .forLoop(.init(name: "j", sequence: .binary(.range(0, "h")), block: [
            .expression(.call("Translate", args: ["i", "i", "j"], trailingBlock: [
                .expression(.call("Cuboid", args: [], trailingBlock: [])),
            ])),
        ])),
    ])),
])
