setwd("D:/Google Drive Backups/Ciencias de la Computacion/2019C2/PROBABILIDADES Y ESTADISTICA/practica8/datos")

confianza = function (alpha, datos, varianza) {
  limInf = mean(datos) - qnorm(1 - alpha/2) * (sqrt(varianza/length(datos)))
  limSup = mean(datos) + qnorm(1 - alpha/2) * (sqrt(varianza/length(datos)))
  
  return(c(limInf, limSup))
}

ejercicio1 = function() {
  confianza = function (alpha, n, varianza) {
    limInf = 25.01 - qnorm(1 - alpha/2) * (sqrt(varianza/n))
    limSup = 25.01 + qnorm(1 - alpha/2) * (sqrt(varianza/n))
    
    return(c(limInf, limSup))
  }
  
  # b
  # ii.
  media = 0
  varianza = 0.01
  alpha = 0.05
  n = 62
  intervalo = confianza(alpha, n, varianza)
  intervalo[2] - intervalo[1]
  
  # iii. 
  media = 0
  varianza = 0.1
  alpha = 0.05
  n = 615
  intervalo = confianza(alpha, n, varianza)
  intervalo[2] - intervalo[1]
}

ejercicio4 = function() {
  # b
  datos = scan("ejercicio4b.txt")
  mu = 185
  alpha = 0.1
  n = length(datos)
  
  suma = sum((datos - mu)^2)
  
  limInf = suma/qchisq(1 - alpha/2, n)
  limSup = suma/qchisq(alpha/2, n)
  
  return(c(limInf, limSup))
}

ejercicio6 = function() {
  # b (usando datos de 4b)
  datos = scan("ejercicio4b.txt")
  alpha = 0.1
  n = length(datos)
  
  s = sum((datos - mean(datos))^2)
  
  limInf = s/qchisq(1 - alpha/2, n - 1)
  limSup = s/qchisq(alpha/2, n - 1)
  
  # d
  setwd("D:/Google Drive Backups/Ciencias de la Computacion/2019C2/PROBABILIDADES Y ESTADISTICA/practica7/datos")
  datos_exp = scan("ejercicio4d.txt")
  alpha_exp = 0.05
  n_exp = length(datos_exp)
  
  limInf_exp = (qchisq(alpha_exp/2, 2 * n_exp))/(2 * sum(datos))
  limSup_exp = (qchisq(1 - alpha_exp/2, 2 * n_exp))/(2 * sum(datos))
}

ejercicio7 = function() {
  # d
  # (rehacer el item b)
  datos1000 = read.csv("datos_Practica8_ej6libreta5719n_1000.csv")
  
  n = length(datos1000$encuesta)
  enContra = sum(datos1000$encuesta == "en contra")
  p = enContra/n
  alpha = 0.1
  
  limInf = p - qnorm(1 - alpha/2) * sqrt((p * (1 - p))/n)
  limSup = p + qnorm(1 - alpha/2) * sqrt((p * (1 - p))/n)
  
  # (rehacer el item c)
  datosN = read.csv("datos_Practica8_ej6libreta5719n_6456.csv")
  
  n = length(datosN$encuesta)
  enContra = sum(datosN$encuesta == "en contra")
  p = enContra/n
  alpha = 0.1
  
  limInf = p - 1.64 * sqrt((p * (1 - p))/n)
  limSup = p + 1.64 * sqrt((p * (1 - p))/n)
  
  diferencia = limSup - limInf
}

ejercicio9 = function() {
  setwd("D:/Google Drive Backups/Ciencias de la Computacion/2019C2/PROBABILIDADES Y ESTADISTICA/practica7/datos")
  n = c(5, 50, 100)
  alpha = 0.05
  
  for(i in 1:length(n)) {
    data = read.csv(paste("datos_Practica7_ej5libreta5719n_", n[i], ".csv", sep = ""))
    llamadas = data$llamadas
    
    lambdaEst = sum(llamadas)/length(llamadas)
    
    s = sd(llamadas)
    limInf = lambdaEst - qnorm(1 - 0.05/2) * s/sqrt(n)
    limSup = lambdaEst + qnorm(1 - 0.05/2) * s/sqrt(n)
  }
}

ejercicio10 = function() {
  # a
  tita = 9
  n = 100
  x = runif(n, 0, tita)
  alpha = 0.05
  
  a = alpha^(1/n)
  b = 1
  
  limInf = max(x)/b
  limSup = max(x)/a
  
  # b
  alpha = 0.05
  tita = 1/2
  n = 10000
  
  # Calculo usando f^(-1)
  f = function (x) exp(1)^(-(x - tita))
  simf = function(n) tita - log(1 - runif(n, 0, 1))
  data1 = simf(n)
  
  limInf1 = min(data1) + log(alpha)/n
  limSup1 = min(data1)
  
  hist(data1, prob = TRUE, breaks = 50, xlim = c(tita, 7), ylim = c(0, 1))
  curve(f, add = TRUE, col = "red", lwd = 2)
  
  # Usando paquete PoweR
  data2 = gensample(law.index = 12, n = n, law.pars = c(tita, 1))$sample
  
  limInf2 = min(data2) + log(alpha)/n
  limSup2 = min(data2)
  
  hist(data2, prob = TRUE, breaks = 50, xlim = c(tita, 7), ylim = c(0, 1))
  curve(f, add = TRUE, col = "2", lwd = 2)
}

ejercicio11 = function() {
  alpha = 0.05
  X = c(0.44, -1.63, 2.59, 1.54, 0.45, -0.13, -2.76, -1.53)
  Y = c(0.06, -0.24, 4.65, 2.27, 3.88, 2.35, 3.92, -0.73)
  
  # a
  n = length(X)
  s = sd(X)
  
  limInf = mean(X) - qt(1 - alpha/2, n - 1) * s/sqrt(n)
  limSup = mean(X) + qt(1 - alpha/2, n - 1) * s/sqrt(n)
  
  # b
  n = length(Y)
  s = sd(Y)
  
  limInf = mean(Y) - qt(1 - alpha/2, n - 1) * s/sqrt(n)
  limSup = mean(Y) + qt(1 - alpha/2, n - 1) * s/sqrt(n)
  
  # c
  lX = length(X)
  lY = length(Y)
  promX = mean(X)
  promY = mean(Y)
  
  sp = ((lX - 1) * sd(X)^2 + (lY - 1) * sd(Y)^2)/(lX + lY - 2)
  
  limInf = (promX - promY) - qt(1 - alpha/2, lX + lY - 2) * sqrt(sp * (1/lX + 1/lY))
  limSup = (promX - promY) + qt(1 - alpha/2, lX + lY - 2) * sqrt(sp * (1/lX + 1/lY))
}

ejercicioParcial = function() {
  # https://www.cubawiki.com.ar/images/a/aa/Proba_Verano_2P2018.pdf
  # Muy interesante (pagina 35-36 ejercicios proba)
  
  tita = 3
  n = 10000
  alpha = 0.05
  
  f = function (x) 3/((x - tita)^4)
  
  cdf = function(x) 1 - 1/(x - tita)^3
  invcdf = inverse(cdf, lower = tita + 1, upper = Inf)
  
  data1 = sapply(runif(n), invcdf)
  
  limInf1 = min(data1) - alpha^(-1/(3*n))
  limSup1 = min(data1) - 1
  
  hist(data1, prob = TRUE, breaks = 100, xlim = c(tita + 1,  10))
  curve(f, add = TRUE, col = "red", lwd = 2)
}