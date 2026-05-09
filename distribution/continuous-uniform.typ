#import calc: pow

#let new(a, b) = {
  assert(a < b, message: "Lower bound " + str(a) + " must be less than upper bound " + str(b) + ".")
  (
    a: a,
    b: b,
    mean: (a + b) / 2,
    variance: pow(b - a, 2) / 12,
  )
}

#let pdf((a: a, b: b)) = {
  x => {
    if x < a or x > b {
      0.0
    } else {
      1 / (b - a)
    }
  }
}

#let cdf((a: a, b: b)) = {
  x => {
    if x < a {
      0.0
    } else if x > b {
      1.0
    } else {
      (x - a) / (b - a)
    }
  }
}
