mcd :: Integer -> Integer -> Integer
mcd a 0 = a
mcd a 1 = 1
mcd a b | a > b = mcd b (mod a b)
        | b > a = mcd a (mod b a)
        | otherwise = a

emcd :: Integer -> Integer -> (Integer, Integer, Integer)
emcd a b | b > a = emcd b a
         | otherwise = (mcd a b, fst (calcularSyT a b (mcd a b) 1), snd (calcularSyT a b (mcd a b) 1))

calcularSyT :: Integer -> Integer -> Integer -> Integer -> (Integer, Integer)
calcularSyT a b g t | mod (g - t*b) a == 0 = (div (g - t*b) a, t)
                    | otherwise = calcularSyT a b g (t + 1)

tieneSolucion :: Integer -> Integer -> Integer -> Bool
tieneSolucion a b m | mod (mcd a m) b == 0 = True
                    | otherwise = False

solucionGeneral :: Integer -> Integer -> Integer -> (Integer, Integer)
solucionGeneral a b m = ((solucionk (div a (mcd a m)) (div m (mcd a m)) 1) * (div b (mcd a m)), div m (mcd a m))

solucionk :: Integer -> Integer -> Integer -> Integer
solucionk a m k | mod (a*k) m == 1 = k
                | mod (a*(-k)) m == 1 = -k
                | otherwise = solucionk a m (k+1)
