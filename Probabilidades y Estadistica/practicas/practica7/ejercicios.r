library(MASS)

ejercicio1 = function() {
  data = scan("ejercicio1.txt")
  
  # a
  sum(data)/length(data)
  
  # b
  median(data)
  
  # c
  sum(data <= 76.5)/length(data)
}

ejercicio3 = function() {
  # a
  caramelos = scan("ejercicio3a.txt")
  media = sum(caramelos)/length(caramelos)
  varianza = sqrt(sum((caramelos - media)^2)/length(caramelos))

  x = seq(-4, 4,length = 100) * varianza + media
  hx = dnorm(x, media, varianza)
  
  hist(caramelos, probability = TRUE)
  lines(x, hx, col = "red")
  
  # b ( quizas esta mal )
  mediciones = scan("ejercicio3b.txt")
  
  hist = hist(mediciones, probability = TRUE)

  varianzaError = 0.01
  
  mu = sum(mediciones - varianzaError)/length(mediciones)
  varianzaMu = sqrt(sum((mediciones - (mu - varianzaError))^2)/length(mediciones))
  
  x = seq(-4, 4,length = 100) * varianzaMu + mu
  hx = dnorm(x, mu, varianzaMu)
  lines(x, hx, col = "red")
  
  print(paste("mu estimado:", mu))
  print(paste("varianza estimador mu:", varianzaMu))
  
  # c
  sistema = scan("ejercicio3c.txt")
}

ejercicio4 = function() {
  # d
  lamparas = scan("ejercicio4d.txt")
  tita = length(lamparas)/sum(lamparas)
  percentil90 = quantile(lamparas, 0.9)
  
  print(paste("tita:", tita))
  print(paste("percentil 90:", percentil90))
  
  # e
  lamparas2 = scan("lamparas2.txt")
  tita = length(lamparas2)/sum(lamparas2)
  percentil90 = quantile(lamparas2, 0.9)
  
  print(paste("tita:", tita))
  print(paste("percentil 90:", percentil90))
}

ejercicio5 = function() {
  # d
  llamadas = scan("ejercicio5d.txt")
  lambda = sum(llamadas)/length(llamadas)
  
  print(paste("lambda estimado:", lambda))
  print(paste("P(llamadas = 40) (b):"))
  print(paste("P(llamadas = 40) (c):", sum(llamadas == 40)/length(llamadas)))
  
  # e
  llamadas2 = scan("llamadas.txt")
  lambda = sum(llamadas2)/length(llamadas2)
  
  print(paste("lambda estimado:", lambda))
  print(paste("P(llamadas = 40) (b):"))
  print(paste("P(llamadas = 40) (c):", sum(llamadas2 == 40)/length(llamadas2)))
  
}

ejercicio6 = function() {
  # d
  datos = scan("ejercicio6d.txt")
  
  titaMV = -sum(log(datos))/length(datos)
  titaM = length(datos)/sum(datos) - 1
}

ejercicio12 = function() {
  dias = scan("dias.txt")
  
  # fitdistr(dias, densfun = "negative binomial")
  estimadorMomentos = mean(dias)
}

ejercicio15 = function() {
  p = 0.5
  n = 10
  datos = rbinom(n, 1, p)
  
  pMV = mean(datos)
  tita = p * (1 - p)
  titaM = pMV * (1 - pMV)
  
  
}

ejercicio1ConDatos = function() {
  print("Ejercicio 1")
  n = c(5, 50, 100)
  
  for(i in 1:length(n)) {
    data = read.csv(paste("datos_Practica7_ej1libreta5719n_", n[i], ".csv", sep = ""))
    carbohidratos = data$carbohidratos
    
    # a
    esperanza = sum(carbohidratos)/length(carbohidratos)
    
    # b
    mediana = median(carbohidratos)
    
    # c
    probaMenor = sum(carbohidratos <= 76.5)/length(carbohidratos)
    
    print(paste("Datos n =", n[i]))
    print(paste("E(X) =", esperanza))
    print(paste("Mediana(X) =", mediana))
    print(paste("P(X <= 76.5) =", probaMenor))
  }
}

ejercicio4ConDatos = function() {
  print("Ejercicio 4")
  n = c(5, 50, 100)
  
  for(i in 1:length(n)) {
    data = read.csv(paste("datos_Practica7_ej4libreta5719n_", n[i], ".csv", sep = ""))
    lamparas = data$lamparas
    
    lambdaEst = length(lamparas)/sum(lamparas)
    # P(X <= x) = 0.9
    # => FX(x) = 1 - e^(-lambda * x) = 0.9
    # => e^(-x * lambda) = 0.1 => -lambda * x = ln(0.1) => x = ln(0.1)/(-lambda)
    percentil = log(0.1)/(-lambdaEst)
    # percentil = qexp(rate = lambdaEst, 0.9)
    
    lamparas = sort(lamparas)
    
    print(paste("Datos n =", n[i]))
    print(paste("percentil 90 est. = ", percentil)) # Este seria el "con modelo"?
    print(paste("percentil 90 datos =", lamparas[length(lamparas) * 0.9]))
  }
}

ejercicio5ConDatos = function() {
  print("Ejercicio 5")
  n = c(5, 50, 100)
  
  for(i in 1:length(n)) {
    data = read.csv(paste("datos_Practica7_ej5libreta5719n_", n[i], ".csv", sep = ""))
    llamadas = data$llamadas
    
    k = 40
    
    lambdaEst = sum(llamadas)/length(llamadas)
    probaPuntualEst = (exp(1)^-lambdaEst * lambdaEst^k)/factorial(k)
    
    proba = sum(llamadas == k)/length(llamadas)
    
    print(paste("Datos n =", n[i]))
    print(paste("P(X = 40) sin modelo =", proba))
    print(paste("P(X = 40) con modelo =", probaPuntualEst))
  }
}

ejercicio1ConDatos()
ejercicio4ConDatos()
ejercicio5ConDatos()