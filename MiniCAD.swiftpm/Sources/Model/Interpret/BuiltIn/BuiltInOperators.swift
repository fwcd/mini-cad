/// The built-in operators.
let builtInOperators: [BinaryOperator: ([Value], [Value]) throws -> [Value]] = [
    .add: binaryFloatOrIntOperator(name: "+", +, +), // TODO: Add string concatenation again
    .subtract: binaryFloatOrIntOperator(name: "-", -, -),
    .multiply: binaryFloatOrIntOperator(name: "*", *, *),
    .divide: binaryFloatOrIntOperator(name: "/", {
        guard $1 != 0 else { throw InterpretError.divisionByZero }
        return $0 / $1
    }, {
        guard $1 != 0 else { throw InterpretError.divisionByZero }
        return $0 / $1
    }),
    .remainder: binaryIntOperator(name: "%", %),
    .equal: binaryValueOperator(name: "==", ==),
    .notEqual: binaryValueOperator(name: "!=", !=),
    .greaterThan: binaryFloatOrIntOperator(name: ">", >, >),
    .greaterOrEqual: binaryFloatOrIntOperator(name: ">=", >=, >=),
    .lessThan: binaryFloatOrIntOperator(name: "<", <, <),
    .lessOrEqual: binaryFloatOrIntOperator(name: "<=", <=, <=),
    .toExclusive: binaryFloatOrIntOperator(name: "..<", ..<, ..<),
    .toInclusive: binaryFloatOrIntOperator(name: "...", ..., ...),
    .logicalAnd: binaryBoolOperator(name: "&&") { $0 && $1 },
    .logicalOr: binaryBoolOperator(name: "||") { $0 || $1 },
]

