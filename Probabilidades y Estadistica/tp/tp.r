# Ejercicio 1
ejercicio1 = function(lambda) {
  x <- seq(1, 3000) 
  promedios <- c()
  
  for(i in seq(1, 3000)) {
    promedios <- c(promedios, mean(rexp(i, lambda)))
  }
  
  plot(x, promedios, type="l")
  abline(h=1/lambda, col="red")
}

ejercicio1(5)

# Vemos que a medida que n crece, y se aumentan las mediciones
# El promedio tiende a la esperanza de la exponencial que es
# 1/lambda (este caso 1/5 o 0.2)

# Esto se debe a la "Ley de los Grandes Numeros"


# Ejercicio 2
ejercicio2 = function(lambda, n) {
  x <- seq(1, 1000)
  promedios <- c()
  
  for (i in seq(1, 1000)) {
    promedios <- c(promedios, mean(rexp(n, lambda)))
  }
  
  hist(promedios, main=paste("Histograma n =", n))
  qqplot(promedios, x, main=paste("QQ-Plot n =", n))
  boxplot(promedios, main=paste("Box-Plot n =", n))
}

n <- exp(1)
oldpar <- par(mfrow=c(4,3))
ejercicio2(n, 2)
ejercicio2(n, 5)
ejercicio2(n, 30)
ejercicio2(n, 500)
par(oldpar)

# a) Que caracteristicas tienen? 
# b) Que se observa? Se observa que los graficos estan mas cerca de la 
# esperanza a medida que se aumentan las mediciones
# d) ¿Que pasaria si se siguiera aumentando el tamano de la muestra?
# Si se siguiera aumentando el tamano de la muestra, se intensificaria
# lo visto anteriormente
# Esto se debe a la ley de los grades numeros

# Ejercicio 3
ejercicio3 = function(lambda, n) {
  x <- seq(1, 1000)
  promedios <- c()
  
  for (i in seq(1, 1000)) {
    promedios <- c(promedios, (mean(rexp(n, lambda))-1/lambda)/(sqrt((1/lambda^2)/n)))
  }

  grilla <- seq(-5,5, by = 0.1)
  hist(promedios, probability = TRUE, main=paste("Histograma n =",n))
  
  lines(grilla, dnorm(grilla), col = "red")
  qqplot(promedios, x, main=paste("QQ-Plot n =",n))
  boxplot(promedios, main=paste("Box-Plot n =",n))
}

n <- exp(1)
oldpar <- par(mfrow=c(4,3))
ejercicio3(n, 2)
ejercicio3(n, 5)
ejercicio3(n, 30)
ejercicio3(n, 500)
par(oldpar)

# Por la LGN tiende todo a Normal(0, 1)
# Ejercicio 4


#TP2

# Ejercicio 1
cantidadDeSumas <- c()
for(i in seq(1, 10000)) {
  listaUniformes <- runif(100)
  suma <- 0
  j <- 0
  while (suma <= 1) {
    j <- j + 1
    suma <- suma + listaUniformes[j]
  }
  cantidadDeSumas <- c(cantidadDeSumas, j)
}
mean(cantidadDeSumas)


# Ejercicio 2
# a)
archivo <- read.table("D:/Google Drive Backups/Ciencias de la Computacion/2019C2/PROBABILIDADES Y ESTADISTICA/TP/dietas.txt", sep = "\t", header = TRUE)

# b)
mean(archivo$dietaa)
mean(archivo$dietaa, trim = 0.1)
mean(archivo$dietaa, trim = 0.2)
median(archivo$dietaa)

mean(archivo$dietab)
mean(archivo$dietab, trim = 0.1)
mean(archivo$dietab, trim = 0.2)
median(archivo$dietab)

mean(archivo$dietac)
mean(archivo$dietac, trim = 0.1)
mean(archivo$dietac, trim = 0.2)
median(archivo$dietac)

# c)
sd(archivo$dietaa)
IQR(archivo$dietaa)
mad(archivo$dietaa)

sd(archivo$dietab)
IQR(archivo$dietab)
mad(archivo$dietab)

sd(archivo$dietac)
IQR(archivo$dietac)
mad(archivo$dietac)

# d)
quantile(archivo$dietaa, 0.1)
quantile(archivo$dietaa, 0.25)
quantile(archivo$dietaa, 0.5)
quantile(archivo$dietaa, 0.75)
quantile(archivo$dietaa, 0.9)

quantile(archivo$dietab, 0.1)
quantile(archivo$dietab, 0.25)
quantile(archivo$dietab, 0.5)
quantile(archivo$dietab, 0.75)
quantile(archivo$dietab, 0.9)

quantile(archivo$dietac, 0.1)
quantile(archivo$dietac, 0.25)
quantile(archivo$dietac, 0.5)
quantile(archivo$dietac, 0.75)
quantile(archivo$dietac, 0.9)

# e)
oldpar <- par(mfrow=c(3,1))
hist(archivo$dietaa)
abline(v = 80, col = "red")
abline(v = 110, col = "red")
hist(archivo$dietab)
abline(v = 80, col = "red")
abline(v = 110, col = "red")
hist(archivo$dietac)
abline(v = 80, col = "red")
abline(v = 110, col = "red")
par(oldpar)

stem(archivo$dietaa)
stem(archivo$dietab)
stem(archivo$dietac)

# f)
oldpar <- par(mfrow=c(3,1))
boxplot(archivo$dietaa)
boxplot(archivo$dietab)
boxplot(archivo$dietac)
par(oldpar)

# g)
x <- seq(1, 100)
oldpar <- par(mfrow=c(3,1))
qqplot(archivo$dietaa, x)
qqplot(archivo$dietab, x)
qqplot(archivo$dietac, x)
par(oldpar)


# Ejercicio 3
lambda <- 1
tiempo <- seq(0, 9.95, by = 0.05)
sorteo <- c(rexp(1,lambda))

for (i in seq(1,201)) {
  sorteo <- c(sorteo, sorteo[i]+rexp(1,lambda))
}
#for(i in seq(1,16)) {
#sorteo <- sort(rexp(200, lambda))
plot(tiempo, sorteo, type = "l")
  lines(tiempo, sort(rpois(200, lambda)), type = "l", col = "#7834FF")
#}