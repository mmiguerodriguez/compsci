menorLex :: (Float, Float, Float) -> (Float, Float, Float) -> Bool
menorLex (x1,x2,x3) (y1,y2,y3) | x1 < y1 = True
                               | x1 == y1 && x2 < y2 = True
                               | x1 == y1 && x2 == y2 && x3 < y3 = True
                               | otherwise = False
                               
fibonacci :: Integer -> Integer
fibonacci 0 = 1
fibonacci 1 = 1
fibonacci n = fibonacci (n-1) + fibonacci (n-2)

sumaFibonacci :: Integer -> Integer
sumaFibonacci 0 = fibonacci 0
sumaFibonacci n = fibonacci n + sumaFibonacci (n-1)

esDefectivo :: Integer -> Bool
esDefectivo 0 = False
esDefectivo 1 = True
esDefectivo n = sumaDivisores n (n-1) < n

sumaDivisores :: Integer -> Integer -> Integer
sumaDivisores n 1 = 1
sumaDivisores n m | mod n m == 0 = m + sumaDivisores n (m-1)
                  | otherwise = sumaDivisores n (m-1)

maximaDistancia :: [Integer] -> Integer
maximaDistancia [] = 0
maximaDistancia x = maximaDistanciaAux x 0

maximaDistanciaAux :: [Integer] -> Integer -> Integer
maximaDistanciaAux (x:[]) d = d
maximaDistanciaAux (x:xs) d | modulovich(x-(head xs)) > d = maximaDistanciaAux xs (modulovich(x-(head xs)))
                            | otherwise = maximaDistanciaAux xs d

modulovich :: Integer -> Integer
modulovich 0 = 0
modulovich n | n < 0 = -n
             | n > 0 = n

comprimir :: [Integer] -> [(Integer, Integer)]
comprimir [] = []
comprimir (x:xs) = [(x, 1 + llenar x xs)] ++ comprimir(rellenar x xs)

llenar :: Integer -> [Integer] -> Integer
llenar n [] = 0
llenar n (x:xs) | n == x = 1 + llenar n xs
                | otherwise = 0

rellenar :: Integer -> [Integer] -> [Integer]
rellenar n [] = []
rellenar n (x:xs) | n == x = rellenar n xs
                  | otherwise = (x:xs)


menorLexR :: (Float, Float, Float) -> (Float, Float, Float) -> Bool
menorLexR (x1,x2,x3) (y1,y2,y3) = x1 < y1 || (x1 == y1 && (x2 < y2 || (x2 == y2 && x3 < y3)))

esDefectivoR :: Integer -> Bool
esDefectivoR n = n > esDefectivoAux n (div n 2)

esDefectivoAux :: Integer -> Integer -> Integer
esDefectivoAux _ 0 = 0
esDefectivoAux n x | mod n x == 0 = x + esDefectivoAux n (x-1)
                   | otherwise = esDefectivoAux n (x-1)

maximaDistanciaR :: [Integer] -> Integer
maximaDistanciaR x = maxDistAux x 0

maxDistAux :: [Integer] -> Integer -> Integer
maxDistAux (x:[]) n = n
maxDistAux (x:(y:ys)) n | n >= modulovich (x-y) = maxDistAux (y:ys) n
                        | otherwise = maxDistAux (y:ys) (modulovich (x-y))

comprimirR :: [Integer] -> [(Integer, Integer)]
comprimirR (x:xs) = comprimirAux (x:xs) (-x)

comprimirAux :: [Integer] -> Integer -> [(Integer, Integer)]
comprimirAux [] _ = []
comprimirAux (x:xs) y | x == y = comprimirAux xs x
                      | otherwise = [(x, apariciones x xs 1)] ++ comprimirAux xs x
                      
apariciones :: Integer -> [Integer] -> Integer -> Integer
apariciones _ [] n = n
apariciones x (y:ys) n | x == y = apariciones x ys (n+1)
                       | otherwise = n
