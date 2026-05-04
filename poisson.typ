#import calc: exp, fact, floor, pow

/// Poisson distribution PMF
///
/// - lambda (float): $lambda > 0$ is the rate parameter
/// -> float
#let pmf(lambda) = {
  assert(lambda >= 0.0, message: "Rate parameter $lambda$ must be non-negative")
  k => {
    assert(k >= 0.0, message: "Poisson distribution is only defined for non-negative integers")
    pow(lambda, k) * exp(-lambda) / fact(k)
  }
}

/// Poisson distribution CDF
///
/// - lambda (float): $lambda > 0$ is the rate parameter
/// -> float
#let cdf(lambda) = {
  assert(lambda >= 0.0, message: "Rate parameter $lambda$ must be non-negative")
  k => {
    assert(k >= 0.0, message: "Poisson distribution is only defined for non-negative integers")
    range(0, floor(k) + 1).fold(0.0, (acc, i) => acc + pmf(lambda)(i))
  }
}

#let mean(lambda) = lambda
#let variance(lambda) = lambda

// Examples
#pmf(3.0)(2)

#cdf(3.0)(2)
