let rawDemoRecipe: String = """
    let w = 3
    let h = 4
    
    for i in 0..<w {
      for j in 0..<h {
        Translate(i, i, j) {
          Cuboid()
        }
      }
    }
    """
let demoRecipe: Recipe = try! parseRecipe(from: rawDemoRecipe)