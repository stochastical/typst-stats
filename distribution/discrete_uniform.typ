#let pmf(min, max) = {
  x => {
    if x >= min and x <= max {
      1.0 / (max - min + 1)
    } else {
      0.0
    }
  }
}

#let cdf(min, max) = {
  x => {
    if x < min {
      0.0
    } else if x >= max {
      1.0
    } else {
      let lower = min
      let upper = max
      let ans = (x - lower + 1) / (upper - lower + 1)
      if ans > 1.0 {
        1.0
      } else {
        ans
      }
    }
  }
}
