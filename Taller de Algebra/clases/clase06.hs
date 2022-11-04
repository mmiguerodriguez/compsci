-- (n+1) no es parametro
-- no se pueden definir dos parametros con el mismo nombre

yLogico :: Bool -> Bool -> Bool
yLogico True True = True
yLogico _ _ = False

oLogico :: Bool -> Bool -> Bool
oLogico True _ = True
oLogico _ True = True
oLogico _ _ = False

implica :: Bool -> Bool -> Bool
implica _ True = True
implica False False = True
implica _ _ = False

sumaGaussiana :: Integer -> Integer
sumaGaussiana 0 = 0
sumaGaussiana n = n + sumaGaussiana (n - 1)

algunoEsCero :: (Integer, Integer, Integer) -> Bool
algunoEsCero (0, _, _) = True
algunoEsCero (_, 0, _) = True
algunoEsCero (_, _, 0) = True
algunoEsCero _ = False

productoInterno :: (Float, Float) -> (Float, Float) -> Float
productoInterno (x1, y1) (x2, y2) = x1 * x2 + y1 * y2

sumaDigitosPositivos :: Integer -> Integer
sumaDigitosPositivos 0 = 0
sumaDigitosPositivos n = mod n 10 + sumaDigitosPositivos (div n 10)

todosDigitosIguales :: Integer -> Bool
todosDigitosIguales n | n < 0 = todosDigitosIguales(-n)
                      | n < 10 = True
                      | otherwise = (mod n 10 == mod (div n 10) 10) && todosDigitosIguales (div n 10)

esSumaDeDosPrimos :: Integer -> Bool
esSumaDeDosPrimos n | n <= 3 = False
                    | esSumaDePrimos (n - 2) 2 = True
                    | otherwise = False
                    
esSumaDePrimos :: Integer -> Integer -> Bool
esSumaDePrimos x y | x < y = False
                   | esPrimo(x) && esPrimo(y) = True
                   | otherwise = esSumaDePrimos (x - 1) (y + 1)

goldbach :: Integer -> Bool
goldbach n | n == 4 = esSumaDeDosPrimos(4)
           | esSumaDeDosPrimos(n) && goldbach (n - 2) = True

esPrimo :: Integer -> Bool
esPrimo 1 = True
esPrimo 2 = True
esPrimo n = esPrimoAux n 2

esPrimoAux :: Integer -> Integer -> Bool
esPrimoAux n i | mod n i == 0 = False
               | n == i + 1 = True
               | otherwise = esPrimoAux n (i + 1)
               
collatz3 :: Integer -> (Integer, Integer)
collatz3 n = collatz2(n , 1)

collatz2 :: (Integer, Integer) -> (Integer, Integer)
collatz2 (n, y) | n == 1 && y > 1 = (1, y)
                | mod n 2 == 0 = collatz2 (div n 2, y + 1)
                | otherwise = collatz2 (3 * n + 1, y + 1)

collatz :: (Integer, Integer) -> Integer
collatz (x, y) | y == 10001 = x
               | snd (collatz3(x)) >= snd (collatz3(y)) = collatz(x, y + 1)
               | otherwise = collatz(y, y + 1)
               
elVerdaderoCollatz :: Integer
elVerdaderoCollatz = collatz (1, 2) 
