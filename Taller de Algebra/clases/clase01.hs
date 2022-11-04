--f x y = x * x + y * y
g x y z = x + y + z * z

doble x = 2*x
suma x y = x + y

cuadrado x = x * x

norma x y = sqrt (cuadrado x + cuadrado y)
const x = 8
respuestaATodo = 42

f n | n == 0 = 1
    | otherwise = n

signo n | n > 0 = 1
        | n == 0 = 0
        | n < 0 = -1
        
absoluto n | n < 0 = -n
           | otherwise = n

maximo x y | x > y = x
           | otherwise = y
           
maximo3 x y z | (x > y) && (x > z) = x
              | (y >= x) && (y > z) = y
              | otherwise = z
