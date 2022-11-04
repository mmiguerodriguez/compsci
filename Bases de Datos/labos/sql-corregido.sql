-- Miguel Rodriguez
-- LU: 57/19

-- Ejercicio 1) Cantidad de tracks por genero

SELECT g.name , COUNT (t.track_id)
FROM genre g
LEFT JOIN track t ON g . genre_id = t. genre_id
GROUP BY g.genre_id , g.name

--BIEN

-- Ejercicio 2) Encontrar las facturas que tengan una cantidad de ítems mayor al promedio de todas las facturas(invoices)

WITH average_per_invoice AS (
  SELECT SUM(il.quantity) AS s
  FROM invoice i 
  INNER JOIN invoice_line il
  ON i.invoice_id = il.invoice_id
  GROUP BY i.invoice_id, il.quantity
)

SELECT i.invoice_id
FROM invoice i 
INNER JOIN invoice_line il
ON i.invoice_id = il.invoice_id
GROUP BY i.invoice_id
HAVING SUM(il.quantity) > (
  SELECT AVG(s) fROM average_per_invoice
)

--BIEN

-- Ejercicio 3) 

WITH sum_per_track_id AS (
  SELECT track.track_id, SUM(invoice_line.quantity) AS s
  FROM track
  INNER JOIN invoice_line ON track.track_id = invoice_line.track_id
  GROUP BY track.track_id
)

WITH total_maximum aS (
  (SELECT MAX(s) FROM sum_per_track_id)
 )

 
SELECT track.track_id, SUM(invoice_line.quantity) AS s
FROM track
INNER JOIN invoice_line ON track.track_id = invoice_line.track_id
INNER JOIN playlist_track ON playlist_track.track_id = track.track_id
INNER JOIN playlist ON playlist.playlist_id = playlist_track.playlist_id
HAVING s = total_maximum
GROUP BY track.track_id

--NO FUNCIONA. ERROR DE SINTAXIS

--Ejercicio 4) Encontrar los nombres de géneros para los cuales todos sus tracks fueron vendidos

SELECT genre.name
FROM genre
INNER join track ON track.genre_id = genre.genre_id
LEFT OUTER JOIN invoice_line ON invoice_line.track_id = track.track_id
where invoice_line.invoice_line_id is NOT NULL
GROUP BY genre.genre_id

--MAL. ESTO NO TE DA TODOS, TE DA ALGUNAS
--ADEMAS PUEDE UN TRACK VENDERSE MUCHAS VECES
--TENDRIAS QUE IR POR EL NOT: NO HAY NINGUNO QUE NO HAYA SIDO VENDIDO

-- 5. Realizar una consulta correlacionada que me devuelva, si es que lo hubiera, todos los 
-- customers que tengan alguna invoice cuya billing city sea diferente a la city del
-- customer.

SELECT customer.customer_id, customer.first_name, customer.last_name
FROM customer
INNER JOIN invoice ON customer.customer_id = invoice.customer_id
WHERE customer.city != invoice.billing_city

--BIEN-
--OJO CON LAS FILAS REPETIDAS

--6 INCOMPLETO



