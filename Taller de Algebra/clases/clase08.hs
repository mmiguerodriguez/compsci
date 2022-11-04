type Set a = [a]

vacio :: Set Integer
vacio = []

agregar :: Integer -> Set Integer -> Set Integer
agregar n [] = [n]
agregar n x | elem n x = x
            | otherwise = n : x

incluido :: Set Integer -> Set Integer -> Bool
incluido [] _ = True
incluido (x:xs) y = elem x y && incluido xs y

iguales :: Set Integer -> Set Integer -> Bool
iguales x y = incluido x y && incluido y x

agregarATodos :: Integer -> Set (Set Integer) -> Set (Set Integer)
agregarATodos n [] = []
agregarATodos n (x:xs) = (n : x) : agregarATodos n xs 

partes :: Integer -> Set (Set Integer)
partes 2 = [[], [1], [2], [1,2]]
partes n = partes (n-1) ++ agregarATodos n (partes (n-1))

partesAux :: Integer -> Set (Set Integer)
partesAux 0 = [[]]
partesAux n = partesAux (n - 1) ++ [[n]]

productoCartesiano :: Set Integer -> Set Integer -> Set (Integer, Integer)
productoCartesiano [] _ = []
productoCartesiano (x:xs) y = productoCartesianoAux x y ++ productoCartesiano xs y

productoCartesianoAux :: Integer -> Set Integer -> Set (Integer, Integer)
productoCartesianoAux _ [] = []
productoCartesianoAux x (y:ys) = [(x, y)] ++ productoCartesianoAux x ys

-- Hacer variaciones

insertarEn :: [Integer] -> Integer -> Integer -> [Integer]
insertarEn l n i = insertarEnAux [] l n i

insertarEnAux :: [Integer] -> [Integer] -> Integer -> Integer -> [Integer]
insertarEnAux l ls n 1 = l ++ [n] ++ ls
insertarEnAux l (x:xs) n i = insertarEnAux (l ++ [x]) xs n (i-1)

-- Seguirt con todo lo demas
