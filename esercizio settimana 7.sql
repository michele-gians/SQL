use chinook;

-- Elencate il numero di tracce per ogni genere in ordine discendente, escludendo quei generi che hanno meno di 10 tracce.


select Genre.name, count(genre.name) as N_Track
from genre
join track on genre.genreid=track.genreid 
group by genre.genreid
having count(genre.name)>=10
order by N_track desc;



-- Trovate le tre canzoni più costose.

select track.name,track.unitPrice as costo 
from track
order by costo desc
limit 3;


-- Elencate gli artisti che hanno canzoni più lunghe di 6 minuti.

select distinct artist.name 
from artist 
join album on artist.artistid=album.artistid
join track on album.albumid=track.albumid
where track.Milliseconds> 360000;

-- Individuate la durata media delle tracce per ogni genere.

select genre.name, floor(avg(Track.Milliseconds/60000)) as AVG_DURATION, 
round((round(avg(Track.Milliseconds/60000))-floor(avg(Track.Milliseconds/60000)))*60)
from genre
join track on genre.genreid=track.genreid
group by genre.name;



select genre.name, concat(floor(avg(Track.Milliseconds/60000)),":", lpad(floor(avg(Track.Milliseconds%60000*60)),2,"0")) as AVG_DURATION
from genre
join track on genre.genreid=track.genreid
group by genre.name
order by AVG_DURATION desc;


-- Elencate tutte le canzoni con la parola “Love” nel titolo, ordinandole alfabeticamente prima per genere e poi per nome.

select track.name, genre.name 
from track
join genre on genre.genreid=track.genreid
where track.name like "% love %"
order by genre.name, track.name;


-- Trovate il costo medio per ogni tipologia di media.

select MediaType.Name as Media_name, avg(track.UnitPrice) as AVG_costo
from MediaType
join track on Track.MediaTypeId=MediaType.MediaTypeId
group by Media_name;

-- Individuate il genere con più tracce.

select genre.name, count(track.name) as tracce_genere
from genre
join track on Track.GenreId=genre.genreid
group by genre.name
order by tracce_genere desc
limit 1;

-- Trovate gli artisti che hanno lo stesso numero di album dei Rolling Stones.


SELECT A1.Name
FROM Artist A1
JOIN Album AL1 ON A1.ArtistId = AL1.ArtistId
JOIN (SELECT COUNT(*) AS NumAlbums
FROM Album
WHERE ArtistId = (SELECT ArtistId
FROM Artist
WHERE Name = 'The Rolling Stones')) AS RS 
ON RS.NumAlbums = (SELECT COUNT(*) AS NumAlbums
FROM Album
WHERE ArtistId = A1.ArtistId)
WHERE A1.Name != 'The Rolling Stones'
GROUP BY A1.name;


-- Trovate l’artista con l’album più costoso.

select artist.name




