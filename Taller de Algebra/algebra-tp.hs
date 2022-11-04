-- TP Haskell --
-- Alumnos:
-- Mariano Pironio | DNI: 40543533 
-- Ryan Itzcovitz | LU: 169/19
-- Miguel Rodriguez | LU: 57/19

type Set a = [a]
type Usuario = (Integer, String) -- (id, nombre)
type Relacion = (Usuario, Usuario) -- usuarios que se relacionan
type Publicacion = (Usuario, String, Set Usuario) -- (usuario que publica, texto publicacion, likes)
type RedSocial = (Set Usuario, Set Relacion, Set Publicacion)

-- Funciones basicas

usuarios :: RedSocial -> Set Usuario
usuarios (us, _, _) = us

relaciones :: RedSocial -> Set Relacion
relaciones (_, rs, _) = rs

publicaciones :: RedSocial -> Set Publicacion
publicaciones (_, _, ps) = ps

idDeUsuario :: Usuario -> Integer
idDeUsuario (id, _) = id

nombreDeUsuario :: Usuario -> String
nombreDeUsuario (_, nombre) = nombre

usuarioDePublicacion :: Publicacion -> Usuario
usuarioDePublicacion (u, _, _) = u

likesDePublicacion :: Publicacion -> Set Usuario
likesDePublicacion (_, _, us) = us

-- Ejercicios

-- Dada una red social retorna un conjunto con los nombres de todos los usuarios.
nombresDeUsuarios :: RedSocial -> Set String
nombresDeUsuarios redSocial = nombresDeUsuariosAux (usuarios redSocial)

-- Dado un Set de usuarios usa la funcion agregarAConjunto para insertar nombres y prevenir repetidos
nombresDeUsuariosAux :: Set Usuario -> Set String
nombresDeUsuariosAux [] = []
nombresDeUsuariosAux (usuario:usuarios) = agregarAConjunto (nombreDeUsuario usuario) (nombresDeUsuariosAux usuarios)

-- Dada una red social y un usuario retorna el conjunto de amigos del mismo
amigosDe :: RedSocial -> Usuario -> Set Usuario
amigosDe redSocial usuario = amigosDeAux (relaciones redSocial) usuario

-- Dado un Set de relaciones se fija si un usuario esta en alguno de los dos lados de la relacion
-- Si esta, agrega al amigo
amigosDeAux :: Set Relacion -> Usuario -> Set Usuario
amigosDeAux [] _ = []
amigosDeAux ((usuario1, usuario2):relaciones) usuario
  | usuario == usuario1 = usuario2 : amigosDeAux relaciones usuario
  | usuario == usuario2 = usuario1 : amigosDeAux relaciones usuario
  | otherwise = amigosDeAux relaciones usuario

-- Dada una red social y un usuario retorna la cantidad de amigos de dicho usuario
cantidadDeAmigos :: RedSocial -> Usuario -> Int
cantidadDeAmigos redSocial usuario = length (amigosDe redSocial usuario)

-- Dada una red social retorna el usuario con mas amigos. De existir más de uno devuelve cualquiera de ellos.
usuarioConMasAmigos :: RedSocial -> Usuario
usuarioConMasAmigos redSocial = usuarioConMasAmigosAux redSocial (0, "") 0

usuarioConMasAmigosAux :: RedSocial -> Usuario -> Int -> Usuario
usuarioConMasAmigosAux ([], _, _) usuario _ = usuario
usuarioConMasAmigosAux (usuario:usuarios, relaciones, publicaciones) masAmigos x
  | (cantidadDeAmigos (usuario:usuarios, relaciones, publicaciones) usuario) >= x = usuarioConMasAmigosAux (usuarios, relaciones, publicaciones) usuario (cantidadDeAmigos (usuario:usuarios, relaciones, publicaciones) usuario)
  | otherwise = usuarioConMasAmigosAux (usuarios, relaciones, publicaciones) masAmigos x

-- Dada una red social retorna True si algún usuario tiene más de un millón de amigos
estaRobertoCarlos :: RedSocial -> Bool
estaRobertoCarlos redSocial = cantidadDeAmigos redSocial (usuarioConMasAmigos redSocial) > 1000000

-- Dada una red social y un usuario retorna el conjunto de publicaciones del mismo.
publicacionesDe :: RedSocial -> Usuario -> Set Publicacion
publicacionesDe redSocial usuario = publicacionesDeAux (publicaciones redSocial) usuario

publicacionesDeAux :: Set Publicacion -> Usuario -> Set Publicacion
publicacionesDeAux [] _ = []
publicacionesDeAux (publicacion:publicaciones) usuario 
  | usuarioDePublicacion publicacion == usuario = publicacion : publicacionesDeAux publicaciones usuario
  | otherwise = publicacionesDeAux publicaciones usuario

-- Dada una red social y un usuario retorna el conjunto de publicaciones a las que el usuario les dió like.
publicacionesQueLeGustanA :: RedSocial -> Usuario -> Set Publicacion
publicacionesQueLeGustanA redSocial usuario = publicacionesQueLeGustanAAux (publicaciones redSocial) usuario

publicacionesQueLeGustanAAux :: Set Publicacion -> Usuario -> Set Publicacion
publicacionesQueLeGustanAAux [] _ = []
publicacionesQueLeGustanAAux (publicacion:publicaciones) usuario
  | elem usuario (likesDePublicacion publicacion) = publicacion : publicacionesQueLeGustanAAux publicaciones usuario
  | otherwise = publicacionesQueLeGustanAAux publicaciones usuario

-- Dada una red social y dos usuarios indica si les gustan las mismas publicaciones
lesGustanLasMismasPublicaciones :: RedSocial -> Usuario -> Usuario -> Bool
lesGustanLasMismasPublicaciones redSocial usuario1 usuario2 = igualesConjuntos (publicacionesQueLeGustanA redSocial usuario1) (publicacionesQueLeGustanA redSocial usuario2)

-- Dada una red social y un usuario u, indica si existe un usuario que le puso like a todas las publicaciones de u.
tieneUnSeguidorFiel :: RedSocial -> Usuario -> Bool
tieneUnSeguidorFiel redSocial usuario = existeUsuarioQueLikeoTodo redSocial (usuarios redSocial) (publicacionesDe redSocial usuario)

-- Dado un conjunto de publicaciones dice si hay un usuario en la red que likeo todas las publicaciones del conjunto
existeUsuarioQueLikeoTodo :: RedSocial -> Set Usuario -> Set Publicacion -> Bool
existeUsuarioQueLikeoTodo redSocial [] publicaciones = False
existeUsuarioQueLikeoTodo _ _ [] = False
existeUsuarioQueLikeoTodo redSocial (usuario:usuarios) publicaciones
  | likeoTodasLasPublicaciones redSocial usuario publicaciones = True
  | otherwise = existeUsuarioQueLikeoTodo redSocial usuarios publicaciones

-- Dado un usuario y un conjunto de publicaciones dice si ese usuario particular likeo todas las publicaciones del conjunto
likeoTodasLasPublicaciones :: RedSocial -> Usuario -> Set Publicacion -> Bool
likeoTodasLasPublicaciones redSocial usuario publicaciones = incluidoEnConjunto publicaciones (publicacionesQueLeGustanA redSocial usuario)

{-
  Un usuario esta checkeado cuando no es el usuario buscado y sus amigos tampoco lo son
  Un usuario es una conexion cuando es amigo de un usuario que fue checkeado
  Un usuario puede ser una conexion sin estar en la lista de checkeados
  Cuando llegamos al ultimo amigo de un usuario, nos fijamos si todos los amigos del padre estan checkeados (amigosDePadreCheckeados)
    Si estan todxs checkeados en vez de llamar a los amigos y al padre llamamos a las conexiones
    Si no estan todxs checkeados se vuelve a llamar a la funcion con los amigos del padre
-}

-- Dada una red social y dos usuarios, indica si existe una secuencia de usuarios relacionados para llegar del primero al segundo.
existeSecuenciaDeAmigos :: RedSocial -> Usuario -> Usuario -> Bool
existeSecuenciaDeAmigos redSocial usuario1 usuario2
  | usuario1 == usuario2 = True
  | elem usuario2 (amigosDe redSocial usuario1) = True
  | otherwise = existeSecuenciaDeAmigosAux redSocial usuario1 usuario2 (amigosDe redSocial usuario1) [usuario1] (usuario1 : (amigosDe redSocial usuario1))

existeSecuenciaDeAmigosAux :: RedSocial -> Usuario -> Usuario -> Set Usuario -> Set Usuario -> Set Usuario -> Bool
existeSecuenciaDeAmigosAux redSocial padre usuario (amigo:[]) checkeados conexiones
  | incluidoEnConjunto checkeados conexiones && incluidoEnConjunto conexiones checkeados = False
  | elem amigo checkeados = amigosDePadreCheckeados redSocial padre usuario (amigosDe redSocial padre) checkeados conexiones
  | amigo == usuario = True
  | elem usuario (amigosDe redSocial amigo) = True
  | otherwise = existeSecuenciaDeAmigosAux redSocial padre usuario (amigosDe redSocial amigo) (agregarAConjunto amigo checkeados) ((amigosDe redSocial amigo) ++ conexiones)

existeSecuenciaDeAmigosAux redSocial padre usuario (amigo:amigos) checkeados conexiones
  | incluidoEnConjunto checkeados conexiones && incluidoEnConjunto conexiones checkeados = False
  | elem amigo checkeados = existeSecuenciaDeAmigosAux redSocial padre usuario amigos checkeados conexiones
  | amigo == usuario = True
  | elem usuario (amigosDe redSocial amigo) = True
  | otherwise = existeSecuenciaDeAmigosAux redSocial padre usuario (amigosDe redSocial amigo) (agregarAConjunto amigo checkeados) ((amigosDe redSocial amigo) ++ conexiones)

amigosDePadreCheckeados :: RedSocial -> Usuario -> Usuario -> Set Usuario -> Set Usuario -> Set Usuario -> Bool
amigosDePadreCheckeados redSocial padre usuario amigos checkeados conexiones
  | incluidoEnConjunto (amigosDe redSocial padre) checkeados = existeSecuenciaDeAmigosAux redSocial padre usuario conexiones checkeados conexiones
  | otherwise = existeSecuenciaDeAmigosAux redSocial padre usuario (amigosDe redSocial padre) checkeados conexiones

-- Funciones Auxiliares --

-- Agrega un elemento a un conjunto del tipo de ese elemento, se usa Eq porque elem tiene ese tipo, usa el operador (==) que se encuentra en esa familia
agregarAConjunto :: Eq a => a -> Set a -> Set a
agregarAConjunto x css
      | elem x css = css
      | otherwise = x:css

-- Determina si el primer conjunto esta incluido en el segundo
incluidoEnConjunto :: Eq a => Set a -> Set a -> Bool
incluidoEnConjunto [] _ = True
incluidoEnConjunto (c:css) xss = elem c xss && incluidoEnConjunto css xss

-- Determina si dos conjuntos son iguales
igualesConjuntos :: Eq a => Set a -> Set a -> Bool
igualesConjuntos conj1 conj2 = incluidoEnConjunto conj1 conj2 && incluidoEnConjunto conj2 conj1

-- Fin Funciones Auxiliares --

-- Ejemplos

usuario1 = (1, "Juan")
usuario2 = (2, "Natalia")
usuario3 = (3, "Pedro")
usuario4 = (4, "Mariela")
usuario5 = (5, "Natalia")
usuario6 = (6, "Jorge")

relacion1_2 = (usuario1, usuario2)
relacion1_3 = (usuario1, usuario3)
relacion1_4 = (usuario4, usuario1) -- Notar que el orden en el que aparecen los usuarios es indistinto
relacion2_3 = (usuario3, usuario2)
relacion2_4 = (usuario2, usuario4)
relacion3_4 = (usuario4, usuario3)

publicacion1_1 = (usuario1, "Este es mi primer post", [usuario2, usuario4])
publicacion1_2 = (usuario1, "Este es mi segundo post", [usuario4])
publicacion1_3 = (usuario1, "Este es mi tercer post", [usuario2, usuario4])
publicacion1_4 = (usuario1, "Este es mi cuarto post", [])

publicacion2_1 = (usuario2, "Hello World", [usuario4])
publicacion2_2 = (usuario2, "Good Bye World", [usuario1, usuario4])

publicacion3_1 = (usuario3, "Lorem Ipsum", [])
publicacion3_2 = (usuario3, "dolor sit amet", [usuario2])
publicacion3_3 = (usuario3, "consectetur adipiscing elit", [usuario2, usuario4])

publicacion4_1 = (usuario4, "I am Alice. Not", [usuario1, usuario2])
publicacion4_2 = (usuario4, "I am Bob", [])
publicacion4_3 = (usuario4, "Just kidding, i am Mariela", [usuario1, usuario3])


usuariosA = [usuario1, usuario2, usuario3, usuario4]
relacionesA = [relacion1_2, relacion1_4, relacion2_3, relacion2_4, relacion3_4]
publicacionesA = [publicacion1_1, publicacion1_2, publicacion2_1, publicacion2_2, publicacion3_1, publicacion3_2, publicacion4_1, publicacion4_2]
redA = (usuariosA, relacionesA, publicacionesA)

usuariosB = [usuario1, usuario2, usuario3, usuario5]
relacionesB = [relacion1_2, relacion2_3]
publicacionesB = [publicacion1_1, publicacion1_2, publicacion1_3, publicacion1_4, publicacion3_1, publicacion3_2, publicacion3_3]
redB = (usuariosB, relacionesB, publicacionesB)

-- Nuestra red --

u1 = (1, "Miguel")
u2 = (2, "Ryan")
u3 = (3, "Mariano")
u4 = (4, "Diego")
u5 = (5, "Alberto")

r1 = (u1, u2)
r2 = (u1, u3)
r3 = (u1, u4)
r4 = (u1, u5)
r5 = (u2, u3)
r6 = (u2, u4)
r7 = (u3, u4)
r8 = (u4, u5)

p1 = (u1, "Que mal juega la seleccion", [u3, u4])
p2 = (u1, "Aca en la pile tomando sol", [u1, u2, u3, u4, u5])
p3 = (u2, "Que suenio que tengo", [u2])
p4 = (u3, "Traeme la copa Messi, traeme la co", [u1, u2, u4, u5])
p5 = (u4, "Que sale hoy", [u1, u2])
p6 = (u4, "Se saleeee", [u1, u5, u4])
p7 = (u4, "Scaloni yo te banco", [])
p8 = (u2, "Ivael tercero", [u2,u3,u4,u5])

usuariosC = [u1,u2,u3,u4,u5]
relacionesC = [r1,r2,r3,r4,r5,r6,r7,r8]
publicacionesC = [p1,p2,p3,p4,p5,p6,p8]

redC = (usuariosC, relacionesC, publicacionesC)

-- Fin nuestra red --

{-
Tests:
======

nombresDeUsuarios redA ~~~> {Juan, Natalia, Pedro, Mariela}

amigosDe redA usuario1 ~~~> {usuario2, usuario4}
amigosDe redA usuario2 ~~~> {usuario1, usuario3, usuario4}
amigosDe redA usuario4 ~~~> {usuario2, usuario1, usuario3}

cantidadDeAmigos redA usuario1 ~~~> 2

Notar que para usuarioConMasAmigos podría haber más de un resultado válido.
usuarioConMasAmigos redA == usuario2 || usuarioConMasAmigos redA == usuario4 ~~~> True

estaRobertoCarlos redA ~~~> False

publicacionesDe redA usuario2 ~~~> {publicacion2_1, publicacion2_2}

publicacionesQueLeGustanA redA usuario1 ~~~> {publicacion2_2, publicacion4_1}

lesGustanLasMismasPublicaciones redB usuario1 usuario2 ~~~> False

tieneUnSeguidorFiel redA usuario1 ~~> True
tieneUnSeguidorFiel redA usuario2 ~~> True
tieneUnSeguidorFiel redA usuario3 ~~> False

existeSecuenciaDeAmigos redA usuario1 usuario3 ~~~> True

----

nombresDeUsuarios redB ~~~> {Juan, Pedro, Natalia}

amigosDe redB usuario1 ~~~> {usuario2}
amigosDe redB usuario2 ~~~> {usuario1, usuario3}
amigosDe redB usuario3 ~~~> {usuario2}
amigosDe redB usuario5 ~~~> {}

cantidadDeAmigos redB usuario1 ~~~> 1
cantidadDeAmigos redB usuario2 ~~~> 2
cantidadDeAmigos redB usuario3 ~~~> 1
cantidadDeAmigos redB usuario5 ~~~> 0

usuarioConMasAmigos redB ~~~> usuario2

estaRobertoCarlos redB ~~~> False

publicacionesDe redB usuario1 ~~~> {publicacion1_1, publicacion1_2, publicacion1_3, publicacion1_4}
publicacionesDe redB usuario2 ~~~> {}
publicacionesDe redB usuario3 ~~~> {publicacion3_1, publicacion3_2, publicacion3_3}
publicacionesDe redB usuario5 ~~~> {}

publicacionesQueLeGustanA redB usuario1 ~~~> {}
publicacionesQueLeGustanA redB usuario2 ~~~> {publicacion1_1, publicacion1_3, publicacion3_2, publicacion3_3}
publicacionesQueLeGustanA redB usuario3 ~~~> {}
publicacionesQueLeGustanA redB usuario5 ~~~> {}

lesGustanLasMismasPublicaciones redB usuario1 usuario3 ~~~> True
lesGustanLasMismasPublicaciones redB usuario1 usuario2 ~~~> False

tieneUnSeguidorFiel redB usuario1 ~~> False
tieneUnSeguidorFiel redB usuario2 ~~> False
tieneUnSeguidorFiel redB usuario3 ~~> False
tieneUnSeguidorFiel redB usuario5 ~~> False

existeSecuenciaDeAmigos redB usuario1 usuario3 ~~~> True
existeSecuenciaDeAmigos redB usuario1 usuario5 ~~~> False

-}
