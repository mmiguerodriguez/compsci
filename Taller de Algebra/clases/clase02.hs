esPar :: Integer -> Bool
esPar x | (mod x 2 == 0) = True
        | otherwise = False

esMultiplo :: Integer -> Integer -> Bool
esMultiplo x y | (mod x y == 0) = True
               | otherwise = False

crearPar :: a -> b -> (a, b) 
crearPar a b = (a, b)

invertirPar :: (a, b) -> (b, a)
invertirPar p = (snd p, fst p)

distanciaPuntos :: (Float, Float) -> (Float, Float) -> Float
distanciaPuntos p q = sqrt((fst p - fst q)^2 + (snd p - snd q)^2)

f1 :: Float -> (Float, Float, Float)
f1 x = (2 * x, x^2, x - 7)

f2 :: Integer -> Integer
f2 x | mod x 2 == 0 = div x 2
     | otherwise = x + 1

f :: Integer -> Integer
f x | mod x 6 == 0 = div (x ^ 2) 2
    | otherwise = 3 * x + 1

g :: (Integer, Integer) -> Integer
g p = fst p * (snd p + 1)

h :: (Integer, Integer) -> Integer
h p = f(g (fst p, snd p))
