#import calc: abs, exp, pi, pow, sqrt
#import "../function/erf.typ": erf

#let new(mean: 0.0, std: 1.0) = {
  let (μ, σ) = (mean, std)
  assert(σ > 0, message: "The standard deviation " + str(σ) + " must be positive.")
  (μ: μ, σ: σ, mean: μ, variance: pow(σ, 2))
}

/// $f(x) = phi(x) = 1 / (sqrt(2 pi) sigma) e^(-1/2 ((x - mu) / sigma)^2)$
#let pdf((μ: μ, σ: σ)) = {
  x => 1.0 / (sqrt(2.0 * pi) * σ) * exp(-0.5 * pow((x - μ) / σ, 2))
}

#let cdf((μ: μ, σ: σ)) = {
  x => {
    let z = (x - μ) / σ
    0.5 * (1 + erf(z / sqrt(2)))
  }
}

