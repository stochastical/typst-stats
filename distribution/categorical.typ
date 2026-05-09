#import calc: pow

#let new(weights) = {
  assert(weights.all(w => w >= 0), message: "All weights must be non-negative.")

  // Pre-compute cumulative weights for efficient sampling
  let (cum_weights, current_sum) = ((), 0.0)
  for w in weights {
    current_sum += w
    cum_weights.push(current_sum)
  }
  assert(current_sum == 1, message: "The sum of weights must be 1.")

  (
    weights: weights,
    cum_weights: cum_weights,
  )
}

#let pmf((weights: weights)) = k => weights.at(k)
#let cdf((cum_weights: cum_weights)) = {
  k => if k < 0 {
    0
  } else if k >= cum_weights.len() {
    1
  } else {
    cum_weights.at(k)
  }
}

/// Find the first index where the cumulative probability exceeds u
///
/// - (cum_weights: cum_weights) (dictionary): A Categorical distribution.
/// - u (float): A random sample from a uniform distribution on $[0,1]$
/// -> int
#let sample((cum_weights: cum_weights), u) = {
  let idx = cum_weights.position(c => c >= u)
  idx
}

// Examples
#let Cat = new((0.1, 0.3, 0.2, 0.4))
#Cat.cum_weights
