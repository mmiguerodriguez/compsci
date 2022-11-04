est1 = function(datos) {
  return (sum(datos >  1)/length(datos))
}

est2 = function(datosExp) {
  return (1 - pexp(1, rate = 1/mean(datosExp)))
} 

est3 = function(datos){
  desvioEstandar = sqrt((sum((datos - mean(datos))^2))/length(datos))
  return (1 - pnorm(1, mean = mean(datos), sd = desvioEstandar))
}

datos = c(12.23,6.37,6.10,0.70,3.48,2.82,9.55,2.21,0.72, 9.09)
est1(datos)
est2(datos)

#simulacion 1

verdadExp = 1 - pexp(1, rate = 0.2)
est1(rexp(50,0.2))
est2(rexp(50,0.2))

sim1 = function(nrep, n) {
  estimaciones1 = c()
  estimaciones2 = c()
  
  for (i in 1:nrep) {
    dato = rexp(n, 0.2)
    estimaciones1 = c(est1(dato), estimaciones1)
    estimaciones2 = c(est2(dato), estimaciones2)
  }
  
  hist (estimaciones1, prob = TRUE, xlim = c(0.7, 0.9))
  abline(v = verdadExp, col = "red")
  hist (estimaciones2, prob = TRUE, xlim = c(0.7, 0.9))
  abline(v = verdadExp, col = "red")
  
  ecme1 = (1/nrep)*(sum((estimaciones1 - verdadExp)^2))
  ecme2 = (1/nrep)*(sum((estimaciones2 - verdadExp)^2))
  
  print(paste("ECME 1er estimador:", ecme1))
  print(paste("ECME 2do estimador:", ecme2))
  
  return (c(ecme1, ecme2))
}

simulacion1 = function() {
  data = c()
  
  data = c(sim1(1000, 50))
  data = c(data, sim1(1000, 150))
  data = c(data, sim1(1000, 200))
  data = c(data, sim1(1000, 500))
  data = c(data, sim1(1000, 1000))
  
  data = matrix(data, ncol = 2, byrow = TRUE)
  colnames(data) = c("ECME Estimador1", "ECME Estimador2")
  rownames(data) = c("n = 50", "n = 150", "n = 200", "n = 500", "n = 1000")
  data = as.table(data)
  
  return(data)
}

simulacion1()

# simulacion 2

verdadNormal = 1 - pnorm(1, mean = 5, sd = 5)

sim2 = function(nrep, n){
  estimaciones1 = c()
  estimaciones2 = c()
  estimaciones3 = c()
  
  for (i in 1:nrep) {
    dato = rnorm(n, mean = 5, sd = 5)
    estimaciones1 = c(estimaciones1, est1(dato))
    estimaciones2 = c(estimaciones2, est2(dato))
    estimaciones3 = c(estimaciones3, est3(dato))
  }
  
  hist (estimaciones1, prob = TRUE, xlim = c(verdadNormal - 0.1, verdadNormal + 0.1), xlab = "")
  abline(v = verdadNormal, col = "red")
  hist (estimaciones2, prob = TRUE, xlim = c(verdadNormal - 0.1, verdadNormal + 0.1), xlab = "")
  abline(v = verdadNormal, col = "red")
  hist (estimaciones3, prob = TRUE, xlim = c(verdadNormal - 0.1, verdadNormal + 0.1), xlab = "")
  abline(v = verdadNormal, col = "red")
  
  ecme1 = (1/nrep)*(sum((estimaciones1 - verdadNormal)^2))
  ecme2 = (1/nrep)*(sum((estimaciones2 - verdadNormal)^2))
  ecme3 = (1/nrep)*(sum((estimaciones3 - verdadNormal)^2))
  
  print(paste("ECME 1er estimador:", ecme1))
  print(paste("ECME 2do estimador:", ecme2))
  print(paste("ECME 3er estimador:", ecme3))
  
  return (c(ecme1, ecme2, ecme3))
}

simulacion2 = function() {
  data = c()

  oldpar = par(mfrow = c(2, 3))
  data = c(data, sim2(1000,0150))
  data = c(data, sim2(1000,0200))
  par(oldpar)
  
  oldpar = par(mfrow = c(2, 3))
  data = c(data, sim2(1000,0500))
  data = c(data, sim2(1000,1000))
  par(oldpar)
  
  data = matrix(data, ncol = 3, byrow = TRUE)
  colnames(data) = c("ECME Estimador1", "ECME Estimador2", "ECME Estimador3")
  rownames(data) = c("n = 150", "n = 200", "n = 500", "n = 1000")
  data = as.table(data)
  
  return(data)
}

simulacion2()
