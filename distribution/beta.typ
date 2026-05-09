#import calc: pow
#import "../function/gamma.typ": gamma, lm-gamma
#import "../function/beta.typ": beta-reg

#let new(alpha: 1.0, beta: 1.0) = {
  let (α, β) = (alpha, beta)
  assert(α > 0, message: "Alpha parameter " + str(α) + " must be positive.")
  assert(β > 0, message: "Beta parameter " + str(β) + " must be positive.")
  (
    α: α,
    β: β,
    mean: α / (α + β),
    variance: (α * β) / (pow(α + β, 2) * (α + β + 1))
  )
}

#let pdf((α: α, β: β)) = {
  x => {
    if x < 0.0 or x > 1.0 {
      0.0
    } else if α == 1.0 and β == 1.0 {
      1.0
    } else if α > 80.0 or β > 80.0 {
      exp(ln_pdf(α, β)(x))
    } else {
      let bb = gamma(α + β) / (gamma(α) * gamma(β))
      bb * pow(x, α - 1.0) * pow(1.0 - x, β - 1.0)
    }
  }
}

#let ln_pdf((α: α, β: β)) = {
  x => {
    if x < 0.0 or x > 1.0 {
      -float.inf
    } else if α == 1.0 and β == 1.0 {
      0.0
    } else {
      let aa = lm-gamma(α + β) - lm-gamma(α) - lm-gamma(β)
      let bb = if α == 1.0 and x == 0.0 {
        0.0
      } else if x == 0.0 {
        -float.inf
      } else {
        (α - 1.0) * ln(x)
      }
      let cc = if β == 1.0 and x == 1.0 {
        0.0
      } else if x == 1.0 {
        -float.inf
      } else {
        (β - 1.0) * ln(1.0 - x)
      }
      aa + bb + cc
    }
  }
}


#let cdf((α: α, β: β)) = {
  x => {
    if x < 0.0 {
      0.0
    } else if x >= 1.0 {
      1.0
    } else if α == 1.0 and β == 1.0 {
      x
    } else {
      beta-reg(α, β)(x)
    }
  }
}