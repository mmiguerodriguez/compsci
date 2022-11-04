resta :: Integer -> Integer -> Integer
resta x y = x - y

suma :: Integer -> Integer -> Integer
suma x y = x + y

negar :: Integer -> Integer
negar x = -x

inv ::  Float -> Float
inv x | x /= 0 = 1/x

unidades :: Integer -> Integer
unidades x = mod (abs x) 10

sumaUnidades3 :: Integer -> Integer -> Integer -> Integer
sumaUnidades3 x y z = unidades x + unidades y + unidades z

todosImpares :: Integer -> Integer -> Integer -> Bool
todosImpares x y z = mod x 2 == 1 && mod y 2 == 1 && mod z 2 == 1

alMenosUnImpar :: Integer -> Integer -> Integer -> Bool
alMenosUnImpar x y z = mod x 2 == 1 || mod y 2 == 1 || mod z 2 == 1

alMenosDosImpares :: Integer -> Integer -> Integer -> Bool
alMenosDosImpares x y z | mod x 2 == 1 && mod y 2 == 1 = True
                        | mod x 2 == 1 && mod z 2 == 1 = True
                        | mod y 2 == 1 && mod z 2 == 1 = True
                        | otherwise = False

alMenosDosPares :: Integer -> Integer -> Integer -> Bool
alMenosDosPares x y z | mod x 2 == 0 && mod y 2 == 0 = True
                      | mod x 2 == 0 && mod z 2 == 0 = True
                      | mod y 2 == 0 && mod z 2 == 0 = True
                      | otherwise = False

r1 :: Integer -> Integer -> Bool
r1 a b | mod a 2 == 0 && mod b 2 == 0 = True
       | mod a 2 == 1 && mod b 2 == 1 = True
       | otherwise = False

r2 :: Integer -> Integer -> Bool
r2 a b | mod (2 * a + 3 * b) 5 == 0 = True
       | otherwise = False

r3 :: Integer -> Integer -> Bool
r3 a b | unidades a == unidades b && unidades b == unidades (a * b) = True
       | otherwise = False

relacionEquiv1 :: Float -> Float -> Bool
relacionEquiv1 x y | x < 3 && y < 3 || x >= 3 && y >= 3 = True
                   | otherwise = False

relacionEquiv2 :: Float -> Float -> Bool
relacionEquiv2 x y | x < 3 && y < 3 || (x >= 3 && x < 7 && y >= 3 && y < 7) || x >= 7 && y >= 7 = True
                   | otherwise = False

relaciona2Z :: (Integer, Integer) -> (Integer, Integer) -> Bool
relaciona2Z (a, b) (p, q) | a == 0 && p == 0 = mod b q == 0
                          | b == 0 && q == 0 = mod a p == 0
                          | p * b == q * a && a >= p && b >= q = True
                          | otherwise = False

relaciona2R :: (Integer, Integer) -> (Integer, Integer) -> Bool
relaciona2R (a, b) (p, q) | p * b == q * a = True
                          | otherwise = False

