#import calc: exp, pow

#let new(rate) = {
  assert(rate > 0, message: "Rate parameter " + str(rate) + " must be positive.")
  (λ: rate, mean: 1 / rate, variance: 1 / pow(rate, 2))
}

/// Exponential distribution PDF
///
/// $f(x; lambda) = lambda e^(-lambda x),  x >= 0$
/// - lambda (float): Rate parameter
/// -> float
#let pdf((λ: λ)) = {
  x => {
    if x < 0.0 {
      0.0
    } else {
      λ * exp(-λ * x)
    }
  }
}

/// Exponential distribution CDF
///
/// $F(x; lambda) = 1 - e^(-lambda x),  x >= 0$
/// - lambda (float): Rate parameter
/// -> float
#let cdf((λ: λ)) = {
  x => {
    if x < 0.0 {
      0.0
    } else {
      1.0 - exp(-λ * x)
    }
  }
}
