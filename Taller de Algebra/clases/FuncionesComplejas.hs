module  FuncionesComplejas
where
import  FuncionesSimples

cuadruple  :: Num a => a -> a
cuadruple x = doble (doble x)

sumaTupla  :: Num a => (a,a) -> a
sumaTupla t = suma (fst t) (snd t)
