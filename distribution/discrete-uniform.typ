#import calc: min, pow

#let new(a, b) = {
  assert(a < b, message: "Lower bound " + str(a) + " must be less than upper bound " + str(b) + ".")
  (
    a: a,
    b: b,
    mean: (a + b) / 2,
    variance: (pow((b - a + 1), 2) - 1) / 12,
  )
}

#let pmf((a: a, b: b)) = {
  x => {
    if x >= a and x <= b {
      1.0 / (b - a + 1)
    } else {
      0.0
    }
  }
}

/// Could also use
/// $F(x) = (floor(x) - a + 1) / (b - a + 1)$ on $k$ in ${a, a+1, ..., b}$
#let cdf((a: a, b: b)) = {
  x => {
    if x < a {
      0.0
    } else if x >= b {
      1.0
    } else {
      min((x - a + 1) / (b - a + 1), 1.0)
    }
  }
}
