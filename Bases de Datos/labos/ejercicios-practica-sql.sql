-- 1) Listar para cada track el nombre del mismo, el genero y el media type.
SELECT t.name as track , g.name as genre , m.name as media
  FROM track t
  INNER JOIN genre g ON t.genre_id = g.genre_id
  INNER JOIN media_type m ON t.media_type_id = m.media_type_id
  
-- 2) Listar la cantidad de tracks que tiene cada genero.
SELECT g.name , COUNT (t.track_id )
  FROM genre g
  LEFT JOIN track t ON g.genre_id = t.genre_id
  GROUP BY g.genre_id , g.name

-- 3) Obtener los artistas que no tienen albumes. Dar al menos dos soluciones distintas.
SELECT ar.*
  FROM artist ar
  LEFT OUTER JOIN album al ON al.artist_id = ar.artist_id
  WHERE al.album_id IS NULL

SELECT ar.*
  FROM artist ar
  WHERE ar.artist_id NOT IN (
  	SELECT DISTINCT artist_id FROM album
  )

-- 4) Listar el nombre y la cantidad de tracks de los artistas con mas de 50
-- tracks, ordenado por cantidad de tracks de forma ascendente.

SELECT ar.name , COUNT (*)
  FROM artist ar
  INNER JOIN album al ON ar.artist_id = al.artist_id
  INNER JOIN track t ON al.album_id = t.album_id
  GROUP BY ar.artist_id , ar.name
  HAVING COUNT (*) > 50
  ORDER BY COUNT (*)

-- 5) Para cada cliente obtener la cantidad de empleados que viven en la misma
-- ciudad ordenados descendentemente por cantidad de empleados.
SELECT c.customer_id , COUNT (e.employee_id)
  FROM customer c
  LEFT OUTER JOIN employee e ON c.country = e.country AND c.state = e.state AND c.city = e.city
  GROUP BY c.customer_id
  ORDER BY COUNT (e.employee_id) DESC
  
-- 6) Obtener el dinero recaudado por cada empleado durante cada año.
SELECT date_part ('year', i.invoice_date ) as year , e.last_name ,
  SUM (i.total ) as total
  FROM employee e
  INNER JOIN customer c ON c.support_rep_id = e.employee_id
  INNER JOIN invoice i ON i.customer_id = c.customer_id
  GROUP BY e.employee_id , year , e.last_name
  ORDER BY year , total

-- 7) Obtener la cantidad de pistas de audio que tengan una duracion superior a
-- la duracion promedio de todas las pistas de audio. Ademas, obtener la
-- sumatoria de la duracion de todas esas pistas en minutos.
SELECT COUNT (t.track_id) , SUM (t.milliseconds / (1000*60)) as total_minutos
  FROM track t INNER JOIN media_type m
  ON t.media_type_id = m.media_type_id
  WHERE m. name LIKE '%audio%' AND t.milliseconds > (
  SELECT AVG (t2.milliseconds)
    FROM track t2 INNER JOIN media_type m2
    ON t2.media_type_id = m2.media_type_id
    WHERE m2.name LIKE '%audio%'
  )

/* 
8)
  (a) Crear una vista que devuelva las playlists que tienen al menos una
  pista del genero “Rock”.
  (b) Utilizando la vista, obtener la cantidad de playlists que no poseen
  pistas de dicho genero.
*/

-- (a)
CREATE OR REPLACE VIEW rocky_playlists AS
SELECT DISTINCT p.playlist_id , p.name FROM playlist p
WHERE p.playlist_id = ANY (
  SELECT pt.playlist_id FROM playlist_track pt
  INNER JOIN track t ON pt.track_id = t.track_id
  INNER JOIN genre g ON t. genre_id = g.genre_id
  WHERE g.name = 'Rock'
)

SELECT * from rocky_playlists

-- (b)
SELECT COUNT (playlist_id) FROM playlist
WHERE playlist_id NOT IN (
	SELECT playlist_id FROM rocky_playlists
)

/* 9) Obtener las playlists mas caras.
Hint: primero obtener el ‘precio’ de cada playlist.
*/
WITH precios AS (
  SELECT pt.playlist_id, SUM(t.unit_price) as precio
  FROM playlist_track pt
  JOIN track t ON pt.track_id = t.track_id
  GROUP BY pt.playlist_id
), max_price AS (
  SELECT MAX(precio) as maximo FROM precios
)

SELECT pl.* , pr.precio
  FROM playlist pl
  JOIN precios pr ON pl.playlist_id = pr.playlist_id
  CROSS JOIN max_price mp
  WHERE pr.precio = mp.maximo
  