use chinook;

SHOW tables;

SELECT * FROM ALBUM LIMIT 10;

-- Trovate il numero totale di canzoni della tabella Tracks
SELECT COUNT(*) FROM TRACK;

-- Trovate i diversi generi presenti nella tabella Genre
SELECT DISTINCT NAME FROM GENRE;


 -- Recuperate il nome di tutte le tracce e del genere associato.
 SELECT TRACK.NAME AS TRACK_NAME, GENRE.NAME AS GENRE_NAME FROM TRACK
 LEFT JOIN GENRE ON TRACK.GenreId = GENRE.GenreId
 ORDER BY GENRE_NAME;
 
 -- Recuperate il nome di tutti gli artisti che hanno almeno un album nel database. Esistono artisti senza album nel database?
 SELECT DISTINCT Artist.Name FROM Artist
 LEFT JOIN Album ON Artist.ArtistId=Album.ArtistId
 WHERE Album.AlbumId IS NOT NULL;

-- Alternativa 
SELECT artist.Name FROM artist
WHERE EXISTS (SELECT album.AlbumId FROM album WHERE artist.ArtistId = album.ArtistId)
ORDER BY 1;

SELECT DISTINCT Artist.Name FROM Artist
LEFT JOIN Album ON Artist.ArtistId=Album.ArtistId
WHERE Album.AlbumId IS NULL;

select album.Title, artist.Name from album
right join artist
ON album.ArtistId= artist.ArtistId
where AlbumId is null;

SELECT COUNT(DISTINCT artist.Name) AS NO_ALBUM FROM Artist
LEFT JOIN Album ON Artist.ArtistId=Album.ArtistId
WHERE Album.AlbumId IS NULL;

 -- Recuperate il nome di tutte le tracce, del genere associato e della tipologia di media. 
 -- Esiste un modo per recuperare il nome della tipologia di media?
SELECT Track.Name AS TRACK_NAME, GENRE.NAME AS GENRE_NAME, MEDIATYPE.Name AS MEDIA_NAME
FROM Track 
INNER JOIN Genre ON Track.GenreId = GENRE.GenreId
INNER JOIN MediaType ON Track.MediaTypeId = MediaType.MediaTypeId;

-- Elencate i nomi di tutti gli artisti e dei loro album
SELECT Artist.Name AS ARTIST_NAME, Album.Title AS ALBUM_TITLE
FROM Artist
JOIN Album ON Artist.ArtistId=Album.ArtistId
ORDER BY ARTIST_NAME;


SELECT g.Name, t.Name, m.Name, count(*) from genre g
INNER JOIN track t ON
g.GenreId = t.GenreId
INNER JOIN mediatype m ON
t.MediaTypeId = m.MediaTypeId
GROUP BY g.Name, t.Name, m.Name;


-- durata media traccie per album
select album.title as album_title, avg(Track.Milliseconds)/1000 as AVG_track
from album 
join track on album.AlbumId=track.AlbumId
group by album.AlbumId;


-- Recuperate tutte le tracce che abbiano come genere “Pop” o “Rock”.
select Track.name as trackname, genre.name as genrename from track
join genre on genre.GenreId=Track.GenreId
where genre.name = 'pop' or genre.name= 'rock'
order by genrename;


select Track.name as trackname, genre.name as genrename from track
join genre on genre.GenreId=Track.GenreId
where genre.name in ('pop', 'rock')
order by genrename;


select * from Genre
where Genre.name = 'pop';


-- Elencate tutti gli artisti e/o gli album che inizino con la lettera “A”

select Artist.name, album.title 
from artist 
left join album on Album.ArtistId=Artist.ArtistId
where artist.name like "A%"
or album.title like "A%";

select Artist.name, album.title 
from artist 
left join album on Album.ArtistId=Artist.ArtistId
where artist.name like "A%"
and album.title like "A%";


-- Elencate tutte le tracce che hanno come genere “Jazz” o che durano meno di 3 minuti.

select track.name, genre.name, Track.Milliseconds/60000 as durata_minuti from track 
join genre on track.GenreId=genre.genreid
where genre.name='jazz'
or track.Milliseconds<180000;

-- Recuperate tutte le tracce più lunghe della durata media.
select track.name,
concat(floor(Milliseconds/60000), ':', Lpad(floor(Milliseconds % 60000/1000), 2, '0')) as durata
from track
where track.Milliseconds > (select avg (track.Milliseconds) from track);


-- Individuate i generi che hanno tracce con una durata media maggiore di 4 minuti.
select genre.name as genre_name
from track
join genre on genre.genreid=track.genreid
group by genre.genreid
having avg(track.Milliseconds) > 240000;



-- Individuate gli artisti che hanno rilasciato più di un album.

select artist.name as artist_name, count(album.albumid) as Album_released
from artist
join album on artist.ArtistId=album.ArtistId
group by artist.name
having count(album.albumid)>1;


-- Trovate la traccia più lunga in ogni album.

select 
a.title as album,
t.name as track,
t.Milliseconds/60000 as durata
from track t
join 
album a on t.AlbumId=a.AlbumId
join 
(select albumid, MAX(Milliseconds) as MAXduration 
from track
group by albumid) as maxTrack on t.albumid=maxtrack.albumid and t.Milliseconds=maxTrack.Maxduration;


-- Individuate la durata media delle tracce per ogni album.

select album.title, avg(track.Milliseconds)/60000 as AVG_Duration_Tracks
from album 
join track on track.AlbumId=Album.AlbumId
Group by album.albumid, album.title;



-- Individuate gli album che hanno più di 20 tracce e mostrate il nome dell’album e il numero di tracce in esso contenute.

select Album.title, count(track.name) as No_Tracks
from album 
join track on Track.AlbumId=Album.AlbumId
group by album.title
having count(track.name)>20;





