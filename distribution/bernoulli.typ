#let new(p) = {
  assert(p >= 0.0 and p <= 1.0, message: "Probability p=" + str(p) + " must be in the range $[0, 1]$")
  (
    p: p,
    mean: p,
    variance: p * (1 - p),
  )
}

#let pmf((p: p)) = {
  x => {
    assert(x == 0.0 or x == 1.0, message: "Bernoulli distribution is only defined for $x=0$ and $x=1$, got x=" + str(x))
    if x == 0.0 { 1 - p } else { p }
  }
}

#let cdf((p: p)) = {
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
