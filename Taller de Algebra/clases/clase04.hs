factorial ::  Integer -> Integer
factorial 0 = 1
factorial n | n > 0 = n * factorial (n-1)

fib :: Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n | n > 1 = fib (n-1) + fib (n-2)

esPar ::  Integer -> Bool
esPar 0 = True
esPar n | otherwise = not (esPar (n-1))

tresA :: Integer -> Integer
tresA 1 = 2
tresA n | n > 1 = 2 * n * tresA(n-1) + 2^n * factorial (n-1)

tresB :: Integer -> Integer
tresB 1 = 1
tresB 2 = 2
tresB n | n > 2 = (n-2) * tresB(n-1) + 2 * (n-1) * tresB(n-2)

tresC :: Integer -> Integer
tresC 1 = -3
tresC 2 = 6
tresC n | n > 2 && esPar(n) == False = -tresC(n-1) - 3
        | n > 2 && esPar(n) = tresC(n-1) + 2 * tresC(n-2) + 9

sumatoria1 :: Integer -> Integer
sumatoria1 n | n == 0 = 2^n
             | n > 0 = 2^n + sumatoria1(n - 1)

sumatoria2 :: Integer -> Float -> Float
sumatoria2 n q | n == 1 = q^n
               | n > 1 = q^n + sumatoria2 (n-1) q

sumatoria3 :: Integer -> Float -> Float
sumatoria3 n q | n == 1 = q + q^2
               | n > 1 = q^(2 * n) + q^(2 * n - 1) + sumatoria3 (n - 1) q

sumatoria4 :: Integer -> Float -> Float
sumatoria4 n q | n == 2 = 0
               | n > 2 = q^(2 * n) + q^(2 * n - 1) + sumatoria4 (n - 1) q

recursiva1 :: Integer -> Bool
recursiva1 0 = True
recursiva1 n | n < 0 = False
             | otherwise = recursiva1 (n - 3)

sumaImpares :: Integer -> Integer
sumaImpares 1 = 1
sumaImpares n | n > 1 = 2 * n - 1 + sumaImpares (n - 1)

medioFact :: Integer -> Integer
medioFact 1 = 1
medioFact 2 = 2
medioFact n | n > 2 = n * medioFact (n - 2)

stackOverflow :: Integer -> Bool
stackOverflow n | n >= 0 = True
                | otherwise = stackOverflow n
