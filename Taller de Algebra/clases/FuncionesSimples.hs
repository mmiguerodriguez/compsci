module  FuncionesSimples
(suma , doble)
where

suma :: Num a => a -> a -> a
suma x y =   x + y

doble  :: Num a => a -> a
doble x = 2 * x

triple  :: Num a => a -> a
triple x = 3 * x
