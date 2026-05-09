#import "@preview/suiji:0.5.1": *
#import "../lib.typ": categorical

== Sampling Random Variates

=== Categorical Distribution
#let n_samples = 1000
#let Cat = categorical.new((0.1, 0.3, 0.2, 0.4))
#let counts = (0,) * Cat.weights.len()
#let (rng, u) = (gen-rng-f(42), none)

// Sampling Loop
#for _ in range(n_samples) {
  (rng, u) = uniform-f(rng)
  let result = categorical.sample(Cat, u)
  counts.at(result) += 1
}

// Frequency Table
#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: center,
  [*Category*], [*Count*], [*%*],
  ..for (i, count) in counts.enumerate() {
    (
      [#i],
      [#count],
      [#(calc.round(count / n_samples * 100, digits: 1))%],
    )
  },
)
