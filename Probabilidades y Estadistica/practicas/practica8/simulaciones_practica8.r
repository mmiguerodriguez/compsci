# Estimar mu con varianza conocida
ic1 = function (datos, varianza) {
  alpha = 0.1
  
  limInf = mean(datos) - qnorm(1 - alpha/2) * (sqrt(varianza/length(datos)))
  limSup = mean(datos) + qnorm(1 - alpha/2) * (sqrt(varianza/length(datos)))
  
  return(c(limInf, limSup))
}

# Estimar mu con varianza desconocida
ic2 = function(datos) {
  alpha = 0.1
  
  s = sqrt(sum((datos - mean(datos))^2)/(length(datos) - 1))
  
  limInf = mean(datos) - qt(1 - alpha/2, length(datos) - 1) * (s/sqrt(length(datos)))
  limSup = mean(datos) + qt(1 - alpha/2, length(datos) - 1) * (s/sqrt(length(datos)))
  
  return(c(limInf, limSup))
}

# Estimar varianza con media conocida
ic3 = function(datos, media) {
  alpha = 0.1
  
  limInf = sqrt(sum((datos - media)^2)/qchisq(1 - alpha/2, length(datos)))
  limSup = sqrt(sum((datos - media)^2)/qchisq(alpha/2, length(datos)))
  
  return(c(limInf, limSup))
}

# Estimar t en Exp(1/t)
ic4 = function(datos) {
  alpha = 0.1
  
  limInf = (2 * sum(datos))/qchisq(1 - alpha/2, 2 * length(datos))
  limSup = (2 * sum(datos))/qchisq(alpha/2, 2 * length(datos))
  
  return(c(limInf, limSup))
}

# Simulaciones
sim1 = function(n, range, mu, varianza) {
  limInf = c()
  limSup = c()
  
  for(i in 1:range){
    datos = rnorm(n, mean = mu, sd = varianza)
    
    intervalo = ic1(datos, varianza)
    
    limInf = c(limInf, intervalo[1])
    limSup = c(limSup, intervalo[2])
  }
  
  x = 1:range
  
  #plotPolygon(x, mu, range, limInf, limSup, paste("IC 0.9 con mu =", mu, "y varianza conocida =", varianza, ", n =", n))
  plotSegments(x, mu, range, limInf, limSup, paste("IC 0.9 con mu =", mu, "y varianza conocida =", varianza, ", n =", n))
}

sim2 = function(n, range, mu, varianza) {
  limInf = c()
  limSup = c()
  
  for(i in 1:range){
    datos = rnorm(n, mean = mu, sd = varianza)
    varianzaEst = mean((datos - mean(datos))^2)
    
    intervalo = ic1(datos, varianzaEst)
    
    limInf = c(limInf, intervalo[1])
    limSup = c(limSup, intervalo[2])
  }
  
  x = 1:range
  
  #plotPolygon(x, mu, range, limInf, limSup, paste("IC 0.9 con mu =", mu, "y varianza estimada, n =", n))
  plotSegments(x, mu, range, limInf, limSup, paste("IC 0.9 con mu =", mu, "y varianza estimada, n =", n))
}

sim3 = function(n, range, mu, varianza) {
  limInf = c()
  limSup = c()
  
  for(i in 1:range){
    datos = rnorm(n, mean = mu, sd = varianza)
    
    intervalo = ic2(datos)
    
    limInf = c(limInf, intervalo[1])
    limSup = c(limSup, intervalo[2])
  }
  
  x = 1:range
  
  #plotPolygon(x, mu, range, limInf, limSup, paste("IC 0.9 con mu =", mu, "y varianza desconocida =", varianza, ", n =", n))
  plotSegments(x, mu, range, limInf, limSup, paste("IC 0.9 con mu =", mu, "y varianza desconocida =", varianza, ", n =", n))
  
}

sim4 = function(n, range, mu, varianza) {
  limInf = c()
  limSup = c()
  
  for(i in 1:range){
    datos = rnorm(n, mean = mu, sd = varianza)
    
    intervalo = ic3(datos, mu)
    
    limInf = c(limInf, intervalo[1])
    limSup = c(limSup, intervalo[2])
  }
  
  x = 1:range
  
  #plotPolygon(x, varianza, range, limInf, limSup, paste("IC 0.9 con mu conocido =", mu, "y varianza =", varianza, ", n =", n))
  plotSegments(x, varianza, range, limInf, limSup, paste("IC 0.9 con mu conocido =", mu, "y varianza =", varianza, ", n =", n))
}

sim5 = function(n, range, t) {
  limInf = c()
  limSup = c()
  
  for(i in 1:range){
    datos = rexp(n, rate = 1/t)
    
    intervalo = ic4(datos)
    
    limInf = c(limInf, intervalo[1])
    limSup = c(limSup, intervalo[2])
  }
  
  x = 1:range
  
  #plotPolygon(x, t, range, limInf, limSup, paste("IC 0.9 de Exp(1/t) con t =", t, ", n =", n))
  plotSegments(x, t, range, limInf, limSup, paste("IC 0.9 de Exp(1/t) con t =", t, ", n =", n))
}

# Plots
plotSegments = function(x, y, range, limInf, limSup, title) {
  plot(x, rep(y, range), type = "l", main = title)
  intervalos_fuera = 0
  
  for (i in 1:range) {
    if (limInf[i] < y && limSup[i] > y) {
      segments(i, limInf[i], i, limSup[i], col = "blue")
    } else {
      intervalos_fuera = intervalos_fuera + 1
      segments(i, limInf[i], i, limSup[i], col = "red")
    }
  }
  print(paste(title, ", nivel de cubrimiento =", (range - intervalos_fuera)/range))
}

plotPolygon = function(x, y, range, limInf, limSup, title) {
  plot(x, rep(y, range), type = "l", main = title)
  
  polygon(c(x, rev(x)), c(limInf, rev(limSup)), col = "grey75", border = FALSE)
  
  lines(x, rep(y, range), lwd = 2)
  lines(x, limSup, col = "red", lty = 2)
  lines(x, limInf, col = "red", lty = 2)
}

# Ejecutar Simulaciones
simular = function(n, range, mu, varianza, t) {
  for (i in 1:length(n)) {
    sim1(n[i], range, mu, varianza)
    sim2(n[i], range, mu, varianza)
    sim3(n[i], range, mu, varianza)
    sim4(n[i], range, mu, varianza)
    sim5(n[i], range, t)
    
    cat("\n")
  }
}

n = c(5, 10, 30, 100)
range = 100
mu = 0
varianza = 1
t = 2

simular(n, range, mu, varianza, t)
