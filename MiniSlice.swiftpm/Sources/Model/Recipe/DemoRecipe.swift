let demoRecipe: Recipe = [
    .varBinding(.init(name: "w", value: 3)),
    .varBinding(.init(name: "h", value: 4)),
    .blank,
    .forLoop(.init(name: "i", sequence: .binary(.range(0, "w")), block: [
        .forLoop(.init(name: "j", sequence: .binary(.range(0, "h")), block: [
            .expression(.call(.init(identifier: "Translate", args: ["i", "i", "j"], trailingBlock: [
                .expression(.call("Cuboid")),
            ]))),
        ])),
    ])),
]
