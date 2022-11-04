module Arbol23 where

data Árbol23 a b = Hoja a | Dos b (Árbol23 a b) (Árbol23 a b) | Tres b b (Árbol23 a b) (Árbol23 a b) (Árbol23 a b) deriving Eq

{- Funciones para mostrar el árbol. -}

instance (Show a, Show b) => Show (Árbol23 a b) where
    show = ("\n" ++) . (padTree 0 0 False)

padlength = 5    
    
padTree:: (Show a, Show b) => Int -> Int -> Bool -> (Árbol23 a b)-> String
padTree nivel acum doPad t = case t of 
                  (Hoja x) -> initialPad ++ stuff x
                  (Dos x i d) -> initialPad ++ stuff x ++ 
                                                 pad padlength ++ rec x False i ++ "\n" ++
                                                 rec x True d ++ "\n"
                  (Tres x y i m d) -> initialPad ++ stuff x ++ --(' ':tail (stuff y)) ++
                                                      pad padlength ++ rec x False i ++ "\n" ++
                                                      pad levelPad ++ stuff y ++ pad padlength ++ rec x False m ++ "\n" ++
                                                      rec x True d ++ "\n" 
  where l = length . stuff
        levelPad = (padlength*nivel + acum)
        initialPad = (if doPad then pad levelPad else "")
        rec x = padTree (nivel+1) (acum+l x)

                      
stuff:: Show a => a -> String
stuff x = if n > l then pad (n-l) ++ s else s
  where s = show x
        l = length s
        n = padlength
                      
pad:: Int -> String
pad i = replicate i ' '
              
foldNat::a->(a->a)->Integer->a
foldNat caso0 casoSuc n | n == 0 = caso0
            | n > 0 = casoSuc (foldNat caso0 casoSuc (n-1))
            | otherwise = error "El argumento de foldNat no puede ser negativo."

{- Funciones pedidas. -}

foldA23 :: (a -> c) -> (b -> c -> c -> c) -> (b -> b -> c -> c -> c -> c) -> Árbol23 a b -> c
foldA23 casoHoja casoDos casoTres t = case t of
    (Hoja x) -> casoHoja x
    (Dos x i d) -> casoDos x (rec i) (rec d)
    (Tres x y i m d) -> casoTres x y (rec i) (rec m) (rec d)
  where rec = foldA23 casoHoja casoDos casoTres

--Lista las hojas de izquierda a derecha.
hojas::Árbol23 a b->[a]
hojas = foldA23 (\a -> [a]) (\_ i d -> i ++ d) (\_ _ i m d -> i ++ m ++ d)

esHoja::Árbol23 a b->Bool
esHoja t = case t of
    (Hoja x) -> True
    (Dos x i d) -> False
    (Tres x y i m d) -> False

mapA23::(a->c)->(b->d)->Árbol23 a b->Árbol23 c d
mapA23 casoHoja casoNodo t = case t of
    (Hoja x) -> Hoja (casoHoja x)
    (Dos x i d) -> Dos (casoNodo x) (rec i) (rec d)
    (Tres x y i m d) -> Tres (casoNodo x) (casoNodo y) (rec i) (rec m) (rec d)
  where rec = mapA23 casoHoja casoNodo

--Ejemplo de uso de mapA23.
--Incrementa en 1 el valor de las hojas.
incrementarHojas::Num a =>Árbol23 a b->Árbol23 a b
incrementarHojas = mapA23 (+1) id


--Trunca el árbol hasta un determinado nivel. Cuando llega a 0, reemplaza el resto del árbol por una hoja con el valor indicado.
--Funciona para árboles infinitos.
truncar::a->Integer->Árbol23 a b->Árbol23 a b
truncar v n = foldNat (\_ -> Hoja v) casos n
  where casos = \rec -> \t -> case t of
                  Hoja x -> Hoja x
                  Dos x i d -> Dos x (rec i) (rec d)
                  Tres x y i m d -> Tres x y (rec i) (rec m) (rec d)

--Evalúa las funciones tomando los valores de los hijos como argumentos.
--En el caso de que haya 3 hijos, asocia a izquierda.
evaluar::Árbol23 a (a->a->a)->a
evaluar = foldA23 (\x -> x) (\x i d -> x i d) (\x y i m d -> y (x i m) d)
