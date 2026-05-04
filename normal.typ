#import calc: abs, exp, pi, pow, sqrt

/// $f(x) = phi(x) = 1 / (sqrt(2 pi) sigma) e^(-1/2 ((x - mu) / sigma)^2)$
#let pdf(mu, std) = {
  x => 1.0 / (sqrt(2.0 * pi) * std) * exp(-0.5 * pow((x - mu) / std, 2))
}

/// #link("https://personal.math.ubc.ca/%7Ecbm/aands/page_299.htm")[Abramowitz-Stegun approximation (¶7.1.26)] for the error function erf(x)
/// $Phi(x) approx 1 - (a_1 t + a_2 t^2 + a_3 t^3 + a_4 t^4 + a_5 t^5)e^(-x^2)$ where $t=1 / (1 + p x)$
/// We apply Horner's method to the polynomial for efficiency and use the odd symmetry of the error function to handle negative $x$ values: $Phi(x) = -Phi(-x)$
#let erf(x) = {
  let (p, a1, a2, a3, a4, a5) = (
    0.3275911,
    0.254829592,
    -0.284496736,
    1.421413741,
    -1.453152027,
    1.061405429,
  )
  let t = 1.0 / (1.0 + p * abs(x))
  let poly = ((((a5 * t + a4) * t + a3) * t + a2) * t + a1) * t
  x.signum() * (1.0 - poly * exp(-pow(x, 2)))
}

#let cdf(mu, std) = {
  x => {
    let z = (x - mu) / std
    0.5 * (1 + erf(z / sqrt(2)))
  }
}
