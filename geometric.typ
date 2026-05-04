#import calc: pow

/// $f(x) = (1-p)^(x-1)p$
#let pmf(p) = {
  x => {
    if x == 0.0 {
      0.0
    } else {
      pow(1 - p, x - 1) * p
    }
  }
}

/// $F(x) = 1 - (1-p)^x$
#let cdf(p) = {
  x => {
    if x == 0.0 {
      0.0
    } else {
      1 - pow(1 - p, x)
    }
  }
}