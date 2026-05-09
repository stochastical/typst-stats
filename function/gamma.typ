#import calc: abs, e, exp, ln, pi, pow, sin, sqrt

/// Gamma function approximation using Stirling's formula
///
/// - z (float):
/// -> float
#let gamma-stirling-approx(z) = {
  if z <= 0.0 {
    float.nan
  } else {
    sqrt(2 * pi) * pow(z, z - 0.5) * exp(-z)
  }
}

/// Gamma function approximation using Lanczos' method
/// Reference: #link("https://docs.rs/statrs/latest/src/statrs/function/gamma.rs.html")[statrs rust implementation]

#let TWO_SQRT_E_OVER_PI = 1.8603827342052657173362492472666631120594218414085755

#let GAMMA_R = 10.900511
#let GAMMA_DK = (
  2.48574089138753565546e-5,
  1.05142378581721974210,
  -3.45687097222016235469,
  4.51227709466894823700,
  -2.98285225323576655721,
  1.05639711577126713077,
  -1.95428773191645869583e-1,
  1.70970543404441224307e-2,
  -5.71926117404305781283e-4,
  4.63399473359905636708e-6,
  -2.71994908488607703910e-9,
)

// Note that we add an extra guard for x <= 0 (we don't use the reflection formula for x < 0.5, so we need to handle negative x values separately) to avoid the singularity at x = 0 when evaluating the reflection formula for negative x values
// TOOD: work out what the best way to handle out-of-domain values is (e.g. return NaN, 0, or throw an error)
#let gamma(x) = {
  if x <= 0.0 {
    float.nan
  } else if x < 0.5 {
    let s = GAMMA_DK.enumerate().slice(1).fold(GAMMA_DK.at(0), (s, t) => s + t.at(1) / (t.at(0) - x))

    pi / (sin(pi * x) * s * TWO_SQRT_E_OVER_PI * (pow((0.5 - x + GAMMA_R) / e, 0.5 - x)))
  } else {
    let s = GAMMA_DK.enumerate().slice(1).fold(GAMMA_DK.at(0), (s, t) => s + t.at(1) / (x + t.at(0) - 1.0))

    s * 2 * sqrt(e / pi) * pow((x - 0.5 + GAMMA_R) / exp(1), x - 0.5)
  }
}

#let lm-gamma(x) = {
  if x < 0.5 {
    let s = GAMMA_DK.enumerate().slice(1).fold(GAMMA_DK.at(0), (s, t) => s + t.at(1) / (t.at(0) - x))

    ln(pi) - ln(sin(pi * x)) - ln(s) - ln(TWO_SQRT_E_OVER_PI) - (0.5 - x) * ln((0.5 - x + GAMMA_R) / e)
  } else {
    let s = GAMMA_DK.enumerate().slice(1).fold(GAMMA_DK.at(0), (s, t) => s + t.at(1) / (x + t.at(0) - 1.0))

    ln(s) + ln(TWO_SQRT_E_OVER_PI) + (x - 0.5) * ln((x - 0.5 + GAMMA_R) / e)
  }
}

/// Computes the lower incomplete regularized gamma function
/// `P(a,x) = 1 / Gamma(a) * int(exp(-t)t^(a-1), t=0..x) for real a > 0, x > 0`
/// where `a` is the argument for the gamma function and `x` is the upper
/// integral limit.
///
/// # Remarks
///
/// Returns `f64::NAN` if either argument is `f64::NAN`
///
/// # Errors
///
/// if `a` or `x` are not in `(0, +inf)`
#let gamma-lr(a, x) = {
  if a <= 0.0 or x <= 0.0 {
    return float.nan
  }

  let eps = 0.000000000000001
  let big = 4503599627370496.0
  let big_inv = 2.22044604925031308085e-16

  let ax = a * ln(x) - x - lm-gamma(a)
  if ax < -709.78271289338399 {
    if a < x {
      return 1.0
    }
    return 0.0
  }

  if x <= 1.0 or x <= a {
    let r2 = a
    let c2 = 1.0
    let ans2 = 1.0
    while true {
      r2 += 1.0
      c2 *= x / r2
      ans2 += c2

      if c2 / ans2 <= eps {
        break
      }
    }
    return exp(ax) * ans2 / a
  }

  let y = 1.0 - a
  let z = x + y + 1.0
  let c = 0.0

  let p3 = 1.0
  let q3 = x
  let p2 = x + 1.0
  let q2 = z * x
  let ans = p2 / q2

  while true {
    y += 1.0
    z += 2.0
    c += 1.0
    let yc = y * c

    let p = p2 * z - p3 * yc
    let q = q2 * z - q3 * yc

    p3 = p2
    p2 = p
    q3 = q2
    q2 = q

    if abs(p) > big {
      p3 *= big_inv
      p2 *= big_inv
      q3 *= big_inv
      q2 *= big_inv
    }

    if q != 0.0 {
      let nextans = p / q
      let error = abs((ans - nextans) / nextans)
      ans = nextans

      if error <= eps {
        break
      }
    }
  }
  1.0 - exp(ax) * ans
}

/// Computes the upper incomplete regularized gamma function
/// `Q(a,x) = 1 / Gamma(a) * int(exp(-t)t^(a-1), t=0..x) for a > 0, x > 0`
/// where `a` is the argument for the gamma function and
/// `x` is the lower integral limit.
///
/// # Remarks
///
/// Returns `f64::NAN` if either argument is `f64::NAN`
///
/// # Errors
///
/// if `a` or `x` are not in `(0, +inf)`
#let gamma-ur(a, x) = {
  x = float(x) //TODO hackery

  if a.is-nan() or x.is-nan() or a <= 0.0 or a.is-infinite() or x <= 0.0 or x.is-infinite() {
    return float.nan
  }

  let eps = 0.000000000000001
  let big = 4503599627370496.0
  let big_inv = 2.22044604925031308085e-16

  if x < 1.0 or x <= a {
    return 1.0 - gamma-lr(a, x) //TODO check if this is right function
  }

  let ax = a * ln(x) - x - lm-gamma(a)
  if ax < -709.78271289338399 {
    return if a < x { 0.0 } else { 1.0 }
  }

  ax = exp(ax)
  let y = 1.0 - a
  let z = x + y + 1.0
  let c = 0.0
  let pkm2 = 1.0
  let qkm2 = x
  let pkm1 = x + 1.0
  let qkm1 = z * x
  let ans = pkm1 / qkm1

  while true {
    y += 1.0
    z += 2.0
    c += 1.0
    let yc = y * c
    let pk = pkm1 * z - pkm2 * yc
    let qk = qkm1 * z - qkm2 * yc

    pkm2 = pkm1
    pkm1 = pk
    qkm2 = qkm1
    qkm1 = qk

    if abs(pk) > big {
      pkm2 *= big_inv
      pkm1 *= big_inv
      qkm2 *= big_inv
      qkm1 *= big_inv
    }

    if qk != 0.0 {
      let r = pk / qk
      let t = abs((ans - r) / r)
      ans = r

      if t <= eps {
        break
      }
    }
  }
  ans * ax
}
