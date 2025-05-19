package main

import (
  "fmt"
  "math"
  "sort"
)

type Root struct {
  value float64
}

func calc(x float64, c []float64) float64 {
  r := 0.0
  for i := 0; i < len(c); i++ {
    r += c[i] * math.Pow(x, float64(len(c)-1-i))
  }
  return r
}

func find(a, b float64, c []float64, p float64) float64 {
  for math.Abs(b-a) > p {
    m := (a + b) / 2.0
    if calc(a, c)*calc(m, c) <= 0 {
      b = m
    } else {
      a = m
    }
  }
  return (a + b) / 2.0
}

func solve(r []float64, p float64, c []float64) []Root {
  var roots []Root
  s := (r[1] - r[0]) / 100.0

  for x := r[0]; x <= r[1]; x += s {
    n := x + s
    if calc(x, c)*calc(n, c) <= 0 {
      root := find(x, n, c, p)
      d := -math.Log10(p)
      root = math.Round(root*math.Pow(10, d)) / math.Pow(10, d)

      roots = append(roots, Root{value: root})
    }
  }
  
  uniqueRoots := make(map[Root]bool)
  for _, root := range roots {
    uniqueRoots[root] = true
  }

  var result []Root
  for root := range uniqueRoots {
    result = append(result, root)
  }

  sort.Slice(result, func(i, j int) bool {
    return result[i].value < result[j].value
  })

  return result
}

func main() {
  r1 := []float64{-5, 5}
  p1 := 0.0001
  c1 := []float64{1, -1, -6}
  res1 := solve(r1, p1, c1)
  fmt.Println("Пример 1: y = x^2 - x - 6")
  fmt.Print("Найденные корни: [")
  for i, root := range res1 {
    if i > 0 {
      fmt.Print(", ")
    }
    fmt.Printf("%.1f", root.value)
  }
  fmt.Println("]")
  fmt.Println("Ожидаемый результат: [-2.0, 3.0]")
  fmt.Println()

  r2 := []float64{-5, 5}
  p2 := 0.0001
  c2 := []float64{1, 0, 0, 0}
  res2 := solve(r2, p2, c2)
  fmt.Println("Пример 2: y = x^3")
  fmt.Print("Найденные корни: [")
  for i, root := range res2 {
    if i > 0 {
      fmt.Print(", ")
    }
    fmt.Printf("%.1f", root.value)
  }
  fmt.Println("]")
  fmt.Println("Ожидаемый результат: [0.0]")
}
