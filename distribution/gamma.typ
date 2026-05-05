#import calc: exp, pi, pow, sqrt
#import "../function/gamma.typ": gamma, gamma_lr

/// Gamma distribution PDF
///
/// $f(x; alpha, beta) = (x^(alpha-1) e^(-beta x) beta^alpha) / Gamma(alpha)$
/// - alpha (float): shape parameter
/// - beta (float): rate parameter
/// -> function
#let pdf(alpha, beta) = {
  x => pow(x, alpha - 1) * exp(-x * beta) * pow(beta, alpha) / gamma(alpha)
}

/// Regularised lower incomplete gamma CDF
/// $F(x; alpha, beta) = P(alpha, beta x)$
/// - alpha (float): shape parameter
/// - beta (float): rate parameter (= 1/scale)
/// -> function
#let cdf(alpha, beta) = {
  x => gamma_lr(alpha, beta * x)
}

// Examples
// #import "@preview/simple-plot:0.3.0": func-plot, plot, plot-fn, scatter
// // #plot-fn(gamma_stirling_approx)
// #plot-fn(gamma)
// #plot-fn(x => lower_incomplete_gamma(5.0, x))
// #plot-fn(cdf(2.0, 1.0), domain: (0.0, 10.0))
