eAprox :: Integer -> Float
eAprox n | n == 0 = 1
         | n > 0 = 1/fromInteger(factorial(n)) + eAprox(n - 1)

factorial ::  Integer -> Integer
factorial 0 = 1
factorial n | n > 0 = n * factorial (n - 1)

e = eAprox 100

parteEntera :: Float -> Integer
parteEntera n | n >= 0 && n < 1 = 0
              | n > 0 = 1 + parteEntera (n - 1)

parteEnteraN :: Float -> Integer
parteEnteraN n | n >= 0 = parteEntera(n)
               | n < 0 = -parteEntera(-n) - 1

-- aca seguro hay if de mas --
division :: Integer -> Integer -> (Integer, Integer)
division a d | a > (-d) && a < d && a > 0 = (0, a)
             | a > (-d) && a < d && a < 0 = (0, (-a))
             | a < d = (fst (division (a + d) d) - 1, snd (division (a + d) d))
             | otherwise = (fst (division (a - d) d) + 1, snd (division (a - d) d))

sumaDivisoresHasta :: Integer -> Integer -> Integer
sumaDivisoresHasta n k | k == 0 = 0
                       | mod n k == 0 = k + sumaDivisoresHasta n (k - 1)
                       | otherwise = sumaDivisoresHasta n (k - 1)
                       
sumaDivisores :: Integer -> Integer
sumaDivisores n = sumaDivisoresHasta n n

menorDivisor :: Integer -> Integer
menorDivisor n = menorDivisorAux n 2

menorDivisorAux :: Integer -> Integer -> Integer
menorDivisorAux n i | mod n i == 0 = i
                    | otherwise = menorDivisorAux n (i + 1)

esPrimo :: Integer -> Bool
esPrimo 1 = True
esPrimo 2 = True
esPrimo n = esPrimoAux n 2

esPrimoAux :: Integer -> Integer -> Bool
esPrimoAux n i | mod n i == 0 = False
               | n == i + 1 = True
               | otherwise = esPrimoAux n (i + 1)

-- sumatoria -> n con i = 0 de sumatoria -> m, j = 0 i^j 
sumatoriaDoble :: Integer -> Integer -> Integer
sumatoriaDoble n m | n > 0 = sumatoria n m + sumatoriaDoble (n - 1) m
                   | n == 0 = 0

sumatoria :: Integer -> Integer -> Integer
sumatoria n m | m == 0 = 0
              | m > 0 = n^m + sumatoria n (m - 1)

-- Funciona
sumaPotencias :: Integer -> Integer -> Integer -> Integer
sumaPotencias q n m | n > 1 = sumaPotenciasAux q n m + sumaPotencias q (n - 1) m
                    | n == 1 = sumaPotenciasAux q n m

sumaPotenciasAux :: Integer -> Integer -> Integer -> Integer
sumaPotenciasAux q n m | m > 1 = q^(n + m) + sumaPotenciasAux q n (m - 1)
                       | m == 1 = q^(n + m)
   
-- ????
-- sumaRacionales :: Integer -> Integer -> Float




