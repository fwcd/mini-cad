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
    
    let n = 8
    let scale = 5.0
    
    for i in 0..<n {
      let theta = (Float(i) / Float(i)) * TAU
      Translate(cos(theta) * scale, 0, sin(theta) * scale) {
        let radius = 0.3
        let height = 0.5
        Cylinder(radius, height)
      }
    }
    """
let demoRecipe: Recipe = try! parseRecipe(from: rawDemoRecipe)
