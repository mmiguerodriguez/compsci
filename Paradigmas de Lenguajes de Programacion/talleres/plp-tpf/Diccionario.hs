module Diccionario (Diccionario, vacío, definir, definirVarias, obtener, esVacío) where

import Data.Maybe
import Data.List
import Arbol23

{- Definiciones de tipos. -}

type Comp clave = clave->clave->Bool
type Estr clave valor = Árbol23 (clave,valor) clave

data Diccionario clave valor = Dicc {cmp :: Comp clave, estructura :: Maybe (Estr clave valor)}
--El comparador es por menor.

{- Funciones provistas por la cátedra. -}

--Inserta un nuevo par clave, valor en una estructura que ya tiene al menos un dato.
insertar::clave->valor->Comp clave->Estr clave valor-> Estr clave valor
insertar c v comp a23 = interceptar (insertarYPropagar c v comp a23) id (\s1 (c1, s2)->Dos c1 s1 s2)

--Maneja el caso de que la segunda componente sea Nothing.
interceptar::(a,Maybe b)->(a->c)->(a->b->c)->c
interceptar (x,y) f1 f2 = case y of
                   Nothing -> f1 x
                   Just z -> f2 x z

{- Inserta una clave con su valor correspondiente. Si se actualiza el índice, el cambio se propaga hacia arriba
   para mantener balanceado el árbol.
   Usamos recursión explícita porque este tipo de recursión no es estructural (no se aplica a todos los hijos). -}
insertarYPropagar::clave->valor->Comp clave->Estr clave valor-> (Estr clave valor, Maybe (clave, Estr clave valor))
insertarYPropagar c v comp a23 = let rec = insertarYPropagar c v comp in case a23 of
    --Si es hoja, elegimos la máxima de las claves y propagamos el balanceo hacia arriba.
    Hoja (ch,vh) -> if comp c ch 
                then (Hoja (c,v), Just (ch, Hoja (ch,vh)))
                else (Hoja (ch, vh), Just (c, Hoja (c,v)))
    {- Si el actual es Nodo-Dos, o se queda en forma Nodo-Dos o se transforma en 
       Nodo-Tres; no puede ocurrir que haya propagación hacia arriba (retornamos Nothing). -}
    Dos c1 a1 a2 -> (if comp c c1
                then 
                -- La clave c va del lado izquierdo.
                    interceptar (rec a1) 
                        (\s1 -> Dos c1 s1 a2)
                        (\s1 (c3, s2) -> Tres c3 c1 s1 s2 a2)
                else 
                -- La clave c va del lado derecho.
                    interceptar (rec a2) 
                        (\s1 -> Dos c1 a1 s1)
                        (\s1 (c3, s2) -> Tres c1 c3 a1 s1 s2), Nothing)
    {- Nodo-tres sólo propaga si de abajo propagan, Diccionariolos tres casos son muy similares
       Sólo cambia en que árbol se inserta. -}
    Tres c1 c2 a1 a2 a3 -> if comp c c1
                then 
                    -- La clave debe ir en el primer árbol.
                    interceptar (rec a1) 
                        (\s1 -> (Tres c1 c2 s1 a2 a3, Nothing))
                        (\s1 (c3, s2) -> (Dos c3 s1 s2, Just(c1, Dos c2 a2 a3)))
                else if comp c c2
                then 
                    -- La clave debe ir en el árbol del medio.
                    interceptar (rec a2) 
                        (\s1 -> (Tres c1 c2 a1 s1 a3, Nothing))
                        (\s1 (c3, s2) -> (Dos c1 a1 s1, Just(c3, Dos c2 s2 a3)))
                else 
                    --La clave debe ir en el último árbol.
                    interceptar (rec a3) 
                        (\s1 -> (Tres c1 c2 a1 a2 s1, Nothing))
                        (\s1 (c3, s2) -> (Dos c1 a1 a2, Just(c2, Dos c3 s1 s2)))

--La lista no debe tener claves repetidas.
definirVarias::[(clave,valor)]->Diccionario clave valor->Diccionario clave valor
definirVarias = (flip.foldr.uncurry) definir


vacío::Comp clave->Diccionario clave valor
vacío comparador = Dicc comparador Nothing

esVacío::Diccionario clave valor -> Bool
esVacío d = case estructura d of Nothing -> True ; _ -> False

{- Funciones a implementar. -}

definir::clave->valor->Diccionario clave valor->Diccionario clave valor
definir c v d = case (estructura d) of 
              Nothing -> Dicc (cmp d) (Just (Hoja (c, v)))
              Just z -> Dicc (cmp d) (Just (insertar c v (cmp d) z))


obtener::Eq clave=>clave->Diccionario clave valor->Maybe valor
obtener c d = case estructura d of 
            Nothing -> Nothing
            Just t -> recorrer (cmp d) c t

recorrer ::Eq clave=>Comp clave -> clave -> Árbol23 (clave, valor) clave -> Maybe valor
recorrer comp c t = case t of 
            Hoja (cl, v) -> if cl == c then Just v else Nothing
            Dos cl i d -> if comp c cl then recorrer comp c d else recorrer comp c i
            Tres cl1 cl2 i m d -> if comp c cl2 
                              then recorrer comp c d 
                              else if comp c cl1 then recorrer comp c m
                              else recorrer comp c i


