listar :: Integer -> Integer -> Integer -> [Integer]
listar a b c = [a,b,c]

pertenece :: Integer -> [Integer] -> Bool
pertenece _ [] = False
pertenece n a | n == head a = True
              | otherwise = pertenece n (tail a)  

pertenece2 :: Integer -> [Integer] -> Bool
pertenece2 _ [] = False
pertenece2 n (x:xs) | n == x = True
                    | otherwise = pertenece2 n xs 

decrecienteNegativos = [1,0..(-100)]

primerMultiplode45345 :: [Integer] -> Integer
primerMultiplode45345 [] = 0
primerMultiplode45345 a | mod (head a) 45345 == 0 = head a
                        | otherwise = primerMultiplode45345 (tail a)
                        
sumatoria :: [Integer] -> Integer
sumatoria [] = 0
sumatoria (x:xs) = sumatoria  xs + x

longitud :: [a] -> Integer
longitud [] = 0
longitud (_:xs)   = 1 + longitud  xs

productoria :: [Integer] -> Integer
productoria [] = 1
productoria (x:xs) = productoria  xs * x

sumarN :: Integer -> [Integer] -> [Integer]
sumarN _ [] = []
sumarN n (x:xs) = (n + x) : sumarN n xs

sumarElPrimero :: [Integer] -> [Integer]
sumarElPrimero (x:xs) = sumarN x (x:xs)

sumarElUltimo :: [Integer] -> [Integer]
sumarElUltimo x = sumarN (agarrarUltimo x) x

agarrarUltimo :: [Integer] -> Integer
agarrarUltimo (x:[]) = x
agarrarUltimo (x:xs) = agarrarUltimo xs

pares :: [Integer] -> [Integer]
pares [] = []
pares (x:xs) | mod x 2 == 0 = x : pares xs
             | otherwise = pares xs
             
multiplosDeN :: Integer -> [Integer] -> [Integer]
multiplosDeN _ [] = []
multiplosDeN n (x:xs) | mod x n == 0 = x : multiplosDeN n xs
                      | otherwise = multiplosDeN n xs
                      
quitar :: Integer -> [Integer] -> [Integer]
quitar _ [] = []
quitar n (x:xs) | n == x = xs
                | otherwise = x : quitar n xs
                
hayRepetidos :: [Integer] -> Bool
hayRepetidos [] = False
hayRepetidos (x:xs) = hayRepetidosAux x xs || hayRepetidos xs

hayRepetidosAux :: Integer -> [Integer] -> Bool
hayRepetidosAux _ [] = False
hayRepetidosAux n (x:xs) | n == x = True
                         | otherwise = hayRepetidosAux n xs

eliminarRepetidos :: [Integer] -> [Integer]
eliminarRepetidos [] = []
eliminarRepetidos (x:xs) = x : eliminarRepetidos (eliminarRepetidosAux x xs) 

eliminarRepetidosAux :: Integer -> [Integer] -> [Integer]
eliminarRepetidosAux _ [] = []
eliminarRepetidosAux n (x:xs) | n == x = eliminarRepetidosAux n xs
                              | otherwise = x : eliminarRepetidosAux n xs

maximo :: [Integer] -> Integer
maximo (a:[]) = a
maximo (a:(x:xs)) | a >= x = maximo (a:xs)
                  | otherwise = maximo (x:xs)
                  
ordenar :: [Integer] -> [Integer]
ordenar [] = []
ordenar x = minimo x : ordenar (quitar (minimo x) x)

minimo :: [Integer] -> Integer
minimo (a:[]) = a
minimo (a:(x:xs)) | a <= x = minimo (a:xs)
                  | otherwise = minimo (x:xs)
                  
reverso :: [Integer] -> [Integer]
reverso [] = []
reverso (x:xs) = reverso xs ++ [x]























