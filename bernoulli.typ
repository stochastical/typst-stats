#let pmf(p) = {
  assert(p >= 0.0 and p <= 1.0, message: "Probability $p$ must be in the range $[0, 1]$")
  x => {
    assert(x == 0.0 or x == 1.0, message: "Bernoulli distribution is only defined for $x=0$ and $x=1$")
    if x == 0.0 { 1 - p } else { p }
  }
}

#let cdf(p) = {
  assert(p >= 0.0 and p <= 1.0, message: "Probability $p$ must be in the range $[0, 1]$")
  x => {
    if x < 0.0 {
      0.0
    } else if x < 1.0 {
      1 - p
    } else {
      1.0
    }
  }
}
