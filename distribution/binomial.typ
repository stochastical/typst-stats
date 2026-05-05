#import calc: binom, pow
#import "../function/beta.typ": beta_reg

/// $p(k) = binom(n, k) p^k (1-p)^(n-k)$ for $k in {0, 1, ..., n}$
#let pmf(n, p) = {
  assert(p >= 0.0 and p <= 1.0, message: "Probability $p$ must be in the range $[0, 1]$")
  assert(n >= 0, message: "Number of trials $n$ must be non-negative")
  k => {
    assert(k >= 0 and k <= n, message: "The number of successes $k$ must be in ${0, 1, ..., n}$")
    binom(n, k) * pow(p, k) * pow(1 - p, n - k)
  }
}

/// $F(k) = sum_(i=0)^(k) p(i)$ for $k in {0, 1, ..., n}$
/// TODO: could use floor and handle k > n more efficiently by returning 1.0 immediately
/// TODO: Also, fold is probably not optimal - I can cache the pmf(n, p)
// #let cdf(n, p) = {
//   assert(p >= 0.0 and p <= 1.0, message: "Probability $p$ must be in the range $[0, 1]$")
//   assert(n >= 0, message: "Number of trials $n$ must be non-negative")
//   k => {
//     assert(k >= 0 and k <= n, message: "The number of successes $k$ must be in ${0, 1, ..., n}$")
//     range(0, k + 1).fold(0.0, (acc, i) => acc + pmf(n, p)(i))
//   }
// }

/// Binomial CDF
/// Calculates the cumulative distribution function for the binomial distribution at $k$
/// $I_(1 - p)(n - k, 1 + k)$
///
/// where $I_(x)(a, b)$ is the regularized incomplete beta function
#let cdf(n, p) = {
  k => {
    assert(n >= 0, message: "Number of trials $n$ must be non-negative")
    assert(p >= 0.0 and p <= 1.0, message: "Probability $p$ must be in the range $[0, 1]$")

    if k >= n {
      1.0
    } else { beta_reg(n - k, k + 1, 1 - p) }
  }
}

#let mean(n, p) = n * p
#let variance(n, p) = n * p * (1 - p)

// Examples
#pmf(20, 0.14)(7)

#cdf(20, 0.14)(7)

#mean(20, 0.14)

#variance(20, 0.14)
