ejercicio3 = function() {
  data = c(27, 41, 22, 27, 23, 35, 30, 24, 27, 28, 22)
  
  alpha = 0.05
  s0 = 6
  
  s = sd(data)^2
  n = length(data)
  
  r = ((n - 1) * s)/(6^2)
  r < qchisq(alpha, n - 1)

  potencia = function(x, n) {
    return(pchisq(qchisq(1 - alpha, n - 1) * (s0^2/x^2), n - 1))
  }
  
  x = seq(0, 100, by = 1)
  plot(x, potencia(x, n))
}

ejercicio4 = function() {
  # d
  potencia = function(x) {
    mu = 0.1
    
    return(pnorm(qnorm(1 - 0.05) * sqrt((mu * (1 - mu))/(x * (1 - x))) + ((mu - x) * sqrt(200))/sqrt(x * (1 - x))))
  }
  
  x = seq(0, 0.25, by = 0.003)
  plot(x, potencia(x), type = "l")
  abline(v = 0.1, col = "red")
}

ejercicio5 = function() {
  x = seq(0, 1, by = 0.01)
  plot(x, qchisq(x, 1))
  
  potencia = function(x) {
    return(1 - pnorm(qnorm(0.95) * sqrt(50/x) + (50 - x)/sqrt(x/40)))
  }
  
  x = seq(45, 60, by = 0.5)
  plot(x, potencia(x))
}