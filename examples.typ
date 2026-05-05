#import "@preview/simple-plot:0.3.0": line-plot, plot, scatter
#import "./lib.typ": *

= Distributions

== Discrete distributions

#table(
  columns: (auto, auto, auto),
  // inset: 10pt,
  align: horizon,
  table.header([*Distribution*], [*PMF*], [*CDF*]),
  [Bernoulli],
  [
    #let p = 0.8
    #let Be = bernoulli.pmf(p)
    #plot(
      width: 4,
      height: 4,
      xmin: 0,
      xmax: 1.4,
      ymin: 0,
      ymax: 1,
      xlabel: $k$,
      ylabel: $p(k)= cases(1-p &"if" k = 0, p &"if" k = 1)$,
      axis-y-extend: 0,
      axis-x-extend: 0,
      scatter(((0, Be(0)),), label: $1-p=#{ calc.round(1 - p, digits: 2) }$, label-anchor: "south-west"),
      scatter(((1, Be(1)),), label: $p=#{ calc.round(p, digits: 2) }$, label-anchor: "south"),
    )
  ],
  [
    #let p = 0.8
    #let Be = bernoulli.cdf(p)
    #plot(
      width: 4,
      height: 4,
      xmin: -0.5,
      xmax: 1.5,
      ymin: 0,
      ymax: 1.1,
      xlabel: $k$,
      ylabel: $F(k) = cases(0 &"if" k < 0, 1-p &"if" 0 <= k < 1, 1 &"if" k >= 1)$,
      axis-y-extend: 0,
      axis-x-extend: 0,
      scatter(((0, Be(0)),), label: $1-p=#{ calc.round(1 - p, digits: 2) }$, label-anchor: "south-west"),
      scatter(((1, Be(1)),), label: $p=#{ calc.round(p, digits: 2) }$, label-anchor: "south"),
     )
  ],

  [Binomial],
  [
    #let (n, p) = (10, 0.3)
    #let Bi = binomial.pmf(n, p)

    #let points = range(0, n + 1).map(i => scatter(((i, Bi(i)),)))
    #let ymax = 1.2 * points.map(p => p.points.at(0).at(1)).reduce((acc, x) => calc.max(acc, x))

    #plot(
      width: 4,
      height: 4,
      xmin: 0,
      xmax: n,
      ymin: 0,
      ymax: ymax,
      xlabel: $k$,
      // ylabel-pos: ,
      ylabel: $p(k) = binom(n, k) p^k (1-p)^(n-k)$,
      axis-y-extend: 0,
      ..points,
    )],

  [
    #let (n, p) = (10, 0.3)
    #let Bi = binomial.cdf(n, p)

    #let points = range(0, n + 1).map(i => scatter(((i, Bi(i)),)))
    #let ymax = 1.2 * points.map(p => p.points.at(0).at(1)).reduce((acc, x) => calc.max(acc, x))
    #plot(
      width: 4,
      height: 4,
      xmin: 0,
      xmax: n,
      ymin: 0,
      ymax: ymax,
      xlabel: $k$,
      // ylabel-pos: ,
      ylabel: $F(k) = sum_(i=0)^(k) p(i)$,
      axis-y-extend: 0,
      ..points,
    )
  ],

  [Geometric],
  [
    #plot(
      width: 4,
      height: 4,
      xmin: 0,
      xmax: 8,
      ymin: 0,
      ymax: 1,
      xlabel: $k$,
      ylabel: $p(k) = (1-p)^(k-1)p$,
      axis-y-extend: 0,
      (fn: geometric.pmf(0.2), label: $p=0.2$, label-pos: 0.1, label-side: "below-left"),
      (fn: geometric.pmf(0.5), label: $p=0.5$, label-pos: 0.01, label-side: "left"),
      (fn: geometric.pmf(0.8), label: $p=0.8$, label-pos: 0.1, label-side: "right"),
    )
  ],

  [
    #plot(
      width: 4,
      height: 4,
      xmin: 0,
      xmax: 10,
      ymin: 0,
      ymax: 1,
      xlabel: $k$,
      ylabel: $F(k) = 1 - (1-p)^k$,

      axis-y-extend: 0,
      (fn: geometric.cdf(0.2), label: $p=0.2$, label-pos: 0.5, label-side: "below-right"),
      (fn: geometric.cdf(0.5), label: $p=0.5$, label-pos: 0.5, label-side: "below-right"),
      (fn: geometric.cdf(0.8), label: $p=0.8$, label-pos: 0.5, label-side: "above-right"),
    )
  ],

  [Poisson],
  [
    #let lam = 3
    #let Pois = poisson.pmf(lam)

    #let n = 11
    #let points = range(0, n).map(i => scatter(((i, Pois(i)),)))
    #let ymax = 1.2 * points.map(p => p.points.at(0).at(1)).reduce((acc, x) => calc.max(acc, x))

    #plot(
      width: 4,
      height: 4,
      xmin: 0,
      xmax: n,
      ymin: 0,
      ymax: ymax,
      xlabel: $k$,
      ylabel: $f(k) = (lambda^k e^(-lambda)) / k!$,
      axis-y-extend: 0,
      ..points,
    )
  ],
  [
    #let (n, lambda) = (10, 3)
    #let Pois = poisson.cdf(lambda)

    #let points = range(0, n + 1).map(i => scatter(((i, Pois(i)),)))
    #let ymax = 1.2 * points.map(p => p.points.at(0).at(1)).reduce((acc, x) => calc.max(acc, x))
    #plot(
      width: 4,
      height: 4,
      xmin: 0,
      xmax: n,
      ymin: 0,
      ymax: ymax,
      xlabel: $k$,
      ylabel: $F(k) = sum_(i=0)^(k) p(i)$,
      axis-y-extend: 0,
      ..points,
    )
  ],
)

#pagebreak()

== Continuous distributions

#table(
  columns: (auto, auto, auto),
  // inset: 10pt,
  align: horizon,
  table.header([*Distribution*], [*PMF*], [*CDF*]),
  [Normal],
  [
    #plot(
      width: 5,
      height: 5,
      xmin: -5,
      xmax: 5,
      ymin: 0,
      ymax: 0.5,
      axis-y-extend: 0,
      (fn: normal.pdf(0, 1)),
    )
  ],
  [
    #plot(
      width: 5,
      height: 5,
      xmin: -4,
      xmax: 4,
      ymin: 0,
      ymax: 1.1,
      axis-y-extend: 0,
      (fn: normal.cdf(0, 1)),
    )
  ],

  [Uniform],
  [
    #plot(
      width: 5,
      height: 5,
      xmin: -1,
      xmax: 2,
      ymin: 0,
      ymax: 1.1,
      axis-y-extend: 0,
      (fn: continuous_uniform.pdf(0, 1)),
    )
  ],
  [
    #plot(
      width: 5,
      height: 5,
      xmin: -1,
      xmax: 2,
      ymin: 0,
      ymax: 1.1,
      axis-y-extend: 0,
      (fn: continuous_uniform.cdf(0, 1)),
    )
  ],

  [Exponential],
  [
    #plot(
      width: 5,
      height: 5,
      xmin: 0,
      xmax: 5,
      ymin: 0,
      ymax: 1.1,
      axis-y-extend: 0,
      (fn: exponential.pdf(1)),
    )
  ],
  [
    #plot(
      width: 5,
      height: 5,
      xmin: 0,
      xmax: 5,
      ymin: 0,
      ymax: 1.1,
      axis-y-extend: 0,
      (fn: exponential.cdf(1)),
    )
  ],

  [Gamma],
  [
    #plot(
      width: 5,
      height: 5,
      xmin: 0,
      xmax: 10,
      ymin: 0,
      ymax: 0.2,
      axis-y-extend: 0,
      (fn: gamma.pdf(2, 0.5)),
    )
  ],
  [
    #plot(
      width: 5,
      height: 5,
      xmin: 0,
      xmax: 10,
      ymin: 0,
      ymax: 1.1,
      axis-y-extend: 0,
      (fn: gamma.cdf(2, 0.5)),
    )
  ],
)

