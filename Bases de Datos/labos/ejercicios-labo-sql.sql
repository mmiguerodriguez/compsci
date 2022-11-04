-- 1) Cantidad de tracks por genero (BIEN)
SELECT g.name, COUNT (t.track_id)
FROM genre g
LEFT JOIN track t ON g.genre_id = t.genre_id
GROUP BY g.genre_id , g.name

-- 2) Encontrar las facturas que tengan una cantidad de ítems mayor al promedio de todas las facturas (invoices)
WITH average_per_invoice AS (
  SELECT i.invoice_id, SUM(il.quantity) AS s
  FROM invoice i 
  INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
  GROUP BY i.invoice_id
)

SELECT i.invoice_id
	FROM invoice i
	INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
	GROUP BY i.invoice_id
	HAVING SUM(il.quantity) > (
      SELECT AVG(s) fROM average_per_invoice
    )

-- 3) Obtener las playlists que tienen los tracks más vendidos
with ventas as (
  select tr.track_id, sum(quantity) as total
  from track tr 
  inner join invoice_line i on tr.track_id = i.track_id
  group by tr.track_id
)

-- DISTINCT para evitar repetidos
select DISTINCT pl.* from playlist pl
  join playlist_track pt on pt.playlist_id = pl.playlist_id
  join ventas v on v.track_id = pt.track_id
  where v.total = (
      select max(total) from ventas
  )

-- 4) Encontrar los nombres de géneros para los cuales todos sus tracks fueron vendidos
-- MAL: Generos en los que tengan tracks que alguno se vendio
SELECT genre.name FROM genre
	INNER join track ON track.genre_id = genre.genre_id
	LEFT OUTER JOIN invoice_line ON invoice_line.track_id = track.track_id
	where invoice_line.invoice_line_id is NOT NULL
	GROUP BY genre.genre_id

-- BIEN: Lo que dice el enunciado
SELECT genre.genre_id, genre.name FROM genre
	WHERE genre.genre_id NOT IN (
      SELECT genre.genre_id FROM genre
      	INNER JOIN track ON track.genre_id = genre.genre_id
      	LEFT JOIN invoice_line ON invoice_line.track_id = track.track_id
      	WHERE invoice_line.invoice_line_id IS NULL
      )

-- 5) Realizar una consulta 'correlacionada' que me devuelva, si es que lo hubiera, todos los 
-- customers que tengan alguna invoice cuya billing city sea diferente a la city del
-- customer.

SELECT customer.customer_id, customer.first_name, customer.last_name FROM customer
  INNER JOIN invoice ON customer.customer_id = invoice.customer_id
  WHERE customer.city != invoice.billing_city
  GROUP BY customer.customer_id

-- 6) Listar los tracks cuyos artistas tienen tracks en más de dos playlists.
with playlists_por_artista as (
    select artist.artist_id, playlist_track.playlist_id
  		from artist
  		INNER JOIN album ON album.artist_id = artist.artist_id
  		INNER JOIN track on track.album_id = album.album_id
  		INNER JOIN playlist_track ON playlist_track.track_id = track.track_id
), playlist_artistas_mayor AS (
  SELECT ppa.artist_id, COUNT(ppa.playlist_id)
      from playlists_por_artista ppa
      GROUP BY ppa.artist_id
  	  HAVING COUNT(ppa.playlist_id) > 2
      ORDER BY count ASC
  )

select tr.* from artist ar
  join album al on al.artist_id = ar.artist_id
  join track tr on tr.album_id = al.album_id
  where ar.artist_id NOT IN (
    SELECT pam.artist_id from playlist_artistas_mayor pam
 )
