ejercicio1 = function() {
  cat("Ejercicio 1: \n")
  
  alfajores <- read.table("alfajores.txt", header = TRUE)
  tabla = table(alfajores)
  
  # Y = Fabrica
  # D = #Alfajores defectuosos
  
  # a
  
  probaQuilmes = sum(tabla[1:5, "0"])/sum(tabla)
  probaPilar = sum(tabla[1:5, "1"])/sum(tabla)
  
  print(paste("P(Y = 0):", probaQuilmes))
  
  # b
  print(paste("P(Y = 0 y D = 3):", tabla["3", "0"]/sum(tabla)))
  
  # c
  proba_puntual <- c()
  proba_puntual <- c(proba_puntual, tabla["0", "0"]/sum(tabla))
  proba_puntual <- c(proba_puntual, tabla["1", "0"]/sum(tabla))
  proba_puntual <- c(proba_puntual, tabla["2", "0"]/sum(tabla))
  proba_puntual <- c(proba_puntual, tabla["3", "0"]/sum(tabla))
  proba_puntual <- c(proba_puntual, tabla["4", "0"]/sum(tabla))
  
  proba_puntual <- c(proba_puntual, tabla["0", "1"]/sum(tabla))
  proba_puntual <- c(proba_puntual, tabla["1", "1"]/sum(tabla))
  proba_puntual <- c(proba_puntual, tabla["2", "1"]/sum(tabla))
  proba_puntual <- c(proba_puntual, tabla["3", "1"]/sum(tabla))
  proba_puntual <- c(proba_puntual, tabla["4", "1"]/sum(tabla))
  
  print(paste("Probabilidad puntual conjunta:", proba_puntual))
  
  proba_puntualX <- c()
  proba_puntualX <- c(proba_puntualX, tabla["0", "0"]/sum(tabla) + tabla["0", "1"]/sum(tabla))
  proba_puntualX <- c(proba_puntualX, tabla["1", "0"]/sum(tabla) + tabla["1", "1"]/sum(tabla))
  proba_puntualX <- c(proba_puntualX, tabla["2", "0"]/sum(tabla) + tabla["2", "1"]/sum(tabla))
  proba_puntualX <- c(proba_puntualX, tabla["3", "0"]/sum(tabla) + tabla["3", "1"]/sum(tabla))
  proba_puntualX <- c(proba_puntualX, tabla["4", "0"]/sum(tabla) + tabla["4", "1"]/sum(tabla))
  
  proba_puntualY <- c()
  proba_puntualY <- c(proba_puntualY, 
                      tabla["0", "0"]/sum(tabla) + tabla["1", "0"]/sum(tabla) +
                      tabla["2", "0"]/sum(tabla) + tabla["3", "0"]/sum(tabla) +
                      tabla["4", "0"]/sum(tabla))
  proba_puntualY <- c(proba_puntualY, 
                      tabla["0", "1"]/sum(tabla) + tabla["1", "1"]/sum(tabla) +
                      tabla["2", "1"]/sum(tabla) + tabla["3", "1"]/sum(tabla) +
                      tabla["4", "1"]/sum(tabla))
  
  print(paste("Proba puntual X:", proba_puntualX))
  print(paste("Proba puntual Y:", proba_puntualY))
  
  # d
  esperanza <- 0
  for (i in seq(0, 4)) {
    esperanza <- esperanza + (i * proba_puntualX[i + 1])
  }
  
  varianza <- 0
  for (i in seq(0, 4)) {
    varianza <- varianza + (i^2 * proba_puntualX[i + 1])
  }
  varianza <- varianza - esperanza^2
  
  print(paste("Esperanza:", esperanza))
  print(paste("Varianza:", varianza))
  
  # e
  probaQuilmes3Def <- tabla["3", "0"]/sum(tabla[1:5, "0"])
  print(paste("P(D = 3 | Y = 0)", probaQuilmes3Def))
  
  # f
  print(paste("P(D = 3):", proba_puntualX[4]))
  
  # g
  print(paste("P(Y = 0 | D = 3):", (probaQuilmes3Def*probaQuilmes)/proba_puntualX[4]))
  
  # h
  probaPilar3Def <- tabla["3", "1"]/sum(tabla[1:5, "1"])
  print(paste("P(Y = 1 | D = 3):", (probaPilar3Def*probaPilar)/proba_puntualX[4]))
}

ejercicio2 = function() {
  cat("\n Ejercicio 2: \n")
  
  lamparas <- scan("lamparas.txt")
  cantidad <- length(lamparas)
  
  # a
  masDe30Horas <- 0
  for (i in 1:cantidad) {
    if (lamparas[i] > 30) {
      masDe30Horas <- masDe30Horas + 1
    }
  }
  print(paste("P(D > 30):", masDe30Horas/cantidad))
  
  # b
  x <- seq(1, cantidad)
  plot(x, sort(lamparas), xlab = "# lampara", ylab = "Horas de duracion", type = "l")
  abline(v = 0.1 * cantidad, col = "red")
  abline(v = 0.9 * cantidad, col = "red")
  
  # c
 print(paste("El 90% de las lamparas dura mas de:", quantile(lamparas, 0.1)))
 print(paste("El 10% de las lamparas dura menos de:", quantile(lamparas, 0.1)))
}

ejercicio3 = function() {
  cat("\n Ejercicio 3: \n")
  
  promedios <- scan("graduados.txt")
  
  # a
  print(paste("Media:", mean(promedios)))
  print(paste("Mediana:", median(promedios)))
  
  # b
  print(paste("Desvio estandar:", sd(promedios)))
  print(paste("Distancia intercuartil:", IQR(promedios)))
  
  # c
  hist(promedios, prob = TRUE)
  
  # d
  # boxplot(promedios) # descomentar
  # Caracteristicas sobresalientes: No hay outliers ya que todos los valores estan muy cercanos
  
  # e: Normal(media, (desvio estandar)^2)
  
  # f
  lines(density(promedios), col = "red") # Plotea density en rojo
  
  x <- seq(3, 4, by = 0.01)
  hx <- dnorm(x, mean(promedios), sd(promedios))
  lines(x, hx, col = "blue") # Plotea una normal centrada en la media con varianza = desvio estandar
  
  # qqnorm(promedios)
  # qqline(promedios)
  
}

ejercicio4 = function() {
  cat("\n Ejercicio 4: \n")
  
  ciudades <- read.table("ciudades.txt", header = TRUE)
  # View(ciudades)
  
  # a
  boxplot(ciudades)
  
  # b
  # Por la desviacion estandar, creo que Holanda es el pais que esta mas
  # homogeneamente habitado
  sd(ciudades$Argentina)
  sd(ciudades$EEUU)
  sd(ciudades$Holanda)
  sd(ciudades$Japon)
  
  oldpar <- par(mfrow = c(2, 2))
  plot(density(ciudades$Argentina))
  plot(density(ciudades$EEUU))
  plot(density(ciudades$Holanda))
  plot(density(ciudades$Japon))
  par(oldpar)
  
}

ejercicio5 = function() {
  cat("\n Ejercicio 5: \n")
  
  ingresos <- scan("ingresos.txt")
  
  # a
  total <- length(ingresos)
  percibenMinimo <- sum(ingresos == min(ingresos), na.rm = TRUE)
  
  print(paste("Minimo:", min(ingresos)))
  print(paste("Proporcion que percibe el minimo:", percibenMinimo/total))
  
  # b
  qqplot(seq(1, length(ingresos)), sort(ingresos))
  abline(h = quantile(ingresos, 0.9))
  abline(v = length(ingresos) * 0.9)
  print(paste("Ingreso mensual que se necesita para pertenecer al 10% con ingresos mas altos:", quantile(ingresos, .9)))
  
  # c
  print(paste("Media:", mean(ingresos)))
  print(paste("Mediana:", median(ingresos)))
  print(paste("a-podada con a = 0,10:", mean(ingresos, trim = 0.1)))
  
  # d
  print(paste("Desvio estandar:", sd(ingresos)))
  print(paste("Distancia intercuartil:", IQR(ingresos)))
 
  # e
  hist(ingresos)
  boxplot(ingresos)
  
  # f: No, parece mas una exponencial que una normal, porque los datos no se centran en ningun
  # lado, si no que empiezan altos en el minimo (15 mil pesos) y luego menos gente gana
  # mas dinero que los otros
  
  # g: 
  
}

ejercicio6 = function() {
  # a
  muestra25norm <- rnorm(25, 0, 1)
  muestra50norm <- rnorm(50, 0, 1)
  muestra100norm <- rnorm(100, 0, 1)
  
  oldpar <- par(mfrow = c(2, 2))
  qqnorm(muestra25norm)
  qqnorm(muestra50norm)
  qqnorm(muestra100norm)
  par(oldpar)
  
  # b
  muestra100gamma <- rgamma(100, shape = 5, scale = 2)
  qqnorm(muestra100gamma)
  qqplot(muestra100gamma, qgamma(seq(0, 1, length = 100), shape = 5, scale = 2))
  
  # c
  oldpar <- par(mfrow = c(2, 2))
  qqnorm(rnorm(25, 0, 1)/runif(25), main = "Y = Z/U | Z ~ N(0, 1) | U ~ U(0, 1) | 25")
  qqnorm(rnorm(50, 0, 1)/runif(50), main = "50")
  qqnorm(rnorm(100, 0, 1)/runif(100), main = "100")
  par(oldpar)
  
  # d
  oldpar <- par(mfrow = c(2, 2))
  qqnorm(runif(25), main = "Z ~ N(0,1) | 25")
  qqnorm(runif(50), main = "50")
  qqnorm(runif(100), main = "100")
  par(oldpar)
  
  # e
  oldpar <- par(mfrow = c(2, 2))
  qqnorm(rexp(25), main = "X ~ E(1) | 25")
  qqnorm(rexp(50), main = "50")
  qqnorm(rexp(100), main = "100")
  par(oldpar)
  
  # f: 
}

ejercicio7  = function() {
  lambda <- 1
  n <- 10
  data <- rexp(n, lambda)
  
  # a
  l2 = function(c) {
    suma <- 0
    
    for (i in 1:length(data)) {
      suma <- suma + (data[i] - c)^2
    }
    
    return(suma)
  }
  
  error_l2 <- c()
  for (i in seq(-5, 5, length.out = 1000)) {
    error_l2 <- c(error_l2, l2(i))
  }
  
  plot(seq(-5, 5, length.out = 1000), error_l2)
  abline(v = 1/lambda, col = "red")
  
  # Se minimiza en la Esperanza, en este caso la E(X) = 1/lambda
  # X ~ E(lambda)
  
  # A mayor n, mas se achica el error a la altura de la esperanza
 
  
  # b
  l1 = function(c) {
    suma <- 0
    
    for (i in 1:length(data)) {
      suma <- suma + abs(data[i] - c)
    }
    
    return(suma)
  }
  
  error_l1 <- c()
  for (i in seq(-5, 5, length.out = 1000)) {
    error_l1 <- c(error_l1, l1(i))
  }
  
  plot(seq(-5, 5, length.out = 1000), error_l1)
  abline(v = 1/lambda, col = "red")
}

ejercicio8 = function() {
  # a
  
  # i
  c <- 0.5
  x <- rexp(100)
  y <- x + c
  
  print(paste("Media de X:", mean(x)))
  print(paste("Mediana de X:", median(x)))
  
  print(paste("Media de Y:", mean(y)))
  print(paste("Mediana de Y:", median(y)))
  
  # La media y la mediana de Y aumentan c con respecto a X
  # Si la media y mediana era 2 y c = 1/2, la nueva media y
  # mediana sera 2 + 1/2
  
  # ii
  z <- x * c
  print(paste("Media de Z:", mean(z)))
  print(paste("Mediana de Z:", median(z)))
  
  # La media y la mediana de Z se multiplican c con respecto a X
  # Si la media y mediana era 2 y c = 1/2, la nueva media y
  # mediana sera 1
  
  # b
  # i
  sx <- (1/(length(x) - 1))*(sum((x - mean(x))^2))
  sy <- (1/(length(y) - 1))*(sum((y - mean(y))^2))
  print(paste("Sx^2=", sx, ", Sy^2=", sy))
  
  # ii
  sz <- (1/(length(z) - 1))*(sum((z - mean(z))^2))
  print(paste("c^2.Sx^2=", c^2*sx, ", Sy^2=", sz))


  # iii
  sumaDeX = (1/(length(x) - 1))*(sum(x^2)) - (length(x)/(length(x) - 1))*(sum(mean(x)^2))
  print(paste("Sx^2=", sx, " formula=", sumaDeX))
}

ejercicio1()
ejercicio2()
ejercicio3()
ejercicio4()
ejercicio5()
ejercicio6()
ejercicio7()
ejercicio8()
