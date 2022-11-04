type Polinomio = [Float]

grado :: Polinomio -> Integer
grado (p:ps) = toInteger (length ps)

evaluar :: Polinomio -> Float -> Float
evaluar [x] _ = x
evaluar p x = (head p)*x^(grado p) + evaluar (tail p) x

derivada :: Polinomio -> Polinomio
derivada [x] = []
derivada p = fromInteger(grado p) * (head p) : derivada (tail p)

derivadaN :: Integer -> Polinomio -> Polinomio
derivadaN 0 p = p
derivadaN n p = derivadaN (n-1) (derivada p)

suma :: Polinomio -> Polinomio -> Polinomio
suma p1 p2 
  | grado p2 > grado p1 = sumaAux p2 p1
  | otherwise = sumaAux p1 p2

sumaAux :: Polinomio -> Polinomio -> Polinomio
sumaAux [] [] = []
sumaAux p1 p2
  | grado p1 > grado p2 = head p1 : suma (tail p1) p2
  | head p1 + head p2 == 0 = suma (tail p1) (tail p2)
  | otherwise = head p1 + head p2 : suma (tail p1) (tail p2)
  
productoPorEscalar :: Float -> Polinomio -> Polinomio
productoPorEscalar x [] = []
productoPorEscalar x (p:xd) = x*p : productoPorEscalar x xd

productoPorMonomio :: (Float, Integer) -> Polinomio -> Polinomio
productoPorMonomio (a, 0) [] = []
productoPorMonomio (a, n) [] = 0.0 : productoPorMonomio (a, n-1) []
productoPorMonomio (a, n) p = a * (head p) : productoPorMonomio (a, n) (tail p)

producto :: Polinomio -> Polinomio -> Polinomio
producto p1 p2
  | grado p2 > grado p1 = producto p2 p1
  | otherwise = productoAux p1 p2 p2 []

productoAux :: Polinomio -> Polinomio -> Polinomio -> [(Float, Integer)] -> Polinomio
productoAux [] p2 p2F x = arreglameElPoli x x (elGradoMasGrande x 0) 0
productoAux p1 [] p2F x = productoAux (tail p1) p2F p2F x
productoAux p1 p2 p2F x = productoAux p1 (tail p2) p2F (((head p1) * (head p2), (grado p1) + (grado p2)):x)

arreglameElPoli :: [(Float, Integer)] -> [(Float, Integer)]  -> Integer -> Float -> Polinomio
arreglameElPoli [] x (-1) v = []
arreglameElPoli [] x n v = v : arreglameElPoli x x (n-1) 0
arreglameElPoli ((valor,g):p) x n v
  | g == n = arreglameElPoli p x n (v + valor)
  | otherwise = arreglameElPoli p x n v


elGradoMasGrande :: [(Float, Integer)] -> Integer -> Integer
elGradoMasGrande [] x = x
elGradoMasGrande ((_,g):polis) x
  | g >= x = elGradoMasGrande polis g
  | otherwise = elGradoMasGrande polis x













