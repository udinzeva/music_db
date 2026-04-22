CREATE TABLE IF NOT EXISTS artists (
    artist_id SERIAL PRIMARY KEY,
    artist_name VARCHAR(50) NOT NULL UNIQUE 
);

CREATE TABLE IF NOT EXISTS albums (
    album_id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    album_year INTEGER
);

CREATE TABLE IF NOT EXISTS tracks (
    track_id SERIAL PRIMARY KEY,
    track_name VARCHAR(50) NOT NULL,
    duration TIME,
    album_id INTEGER NOT NULL REFERENCES albums(album_id)
);

CREATE TABLE IF NOT EXISTS genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS collections (
    collection_id SERIAL PRIMARY KEY,
    collection_name VARCHAR(50) NOT NULL,
    collection_year INTEGER
);

CREATE TABLE IF NOT EXISTS artist_albums (
    artist_id INTEGER REFERENCES artists(artist_id),
    album_id INTEGER REFERENCES albums(album_id),
    CONSTRAINT pk_artist_albums PRIMARY KEY (artist_id, album_id)
);

CREATE TABLE IF NOT EXISTS artist_genres (
    artist_id INTEGER REFERENCES artists(artist_id),
    genre_id INTEGER REFERENCES genres(genre_id),
    CONSTRAINT pk_artist_genres PRIMARY KEY (artist_id, genre_id)
);

CREATE TABLE IF NOT EXISTS collection_tracks (
    collection_id INTEGER REFERENCES collections(collection_id),
    track_id INTEGER REFERENCES tracks(track_id),
    CONSTRAINT pk_collection_tracks PRIMARY KEY (collection_id, track_id)
);


- - задание 1
- - добавление данных в таблицы


INSERT INTO artists (artist_name)
VALUES
    ('Green Day'),
    ('Marilyn Manson'),
    ('Limp Bizkit'),
    ('Beastie Boys'),
    ('Linkin Park'),
    ('Sum 41'),
    ('Madonna');

INSERT INTO genres (genre_name)
VALUES
    ('Punk rock'),
    ('Industrial metal'),
    ('Nu metal'),
    ('Rap rock'),
    ('Pop punk'),
    ('Pop'),
    ('Disco');

INSERT INTO albums (title, album_year)
VALUES 
    ('39/Smooth', 1990),
    ('Portrait of an American Family', 1994),
    ('Three Dollar Bill, Y’all$', 1997),
    ('Licensed to Ill', 1986),
    ('Hybrid Theory', 2000),
    ('Half Hour of Power', 2000),
    ('Madame X', 2019);
    
INSERT INTO tracks (track_name, duration, album_id)
VALUES
    ('Going to Pasalacqua', '00:03:38', 1),
    ('Green Day', '00:02:55', 1),
    ('Disappearing Boy', '00:03:16', 1),
    ('Cake and Sodomy', '00:03:40', 2),
    ('Lunchbox', '00:04:35', 2),
    ('Get Your Gunn', '00:03:18', 2),
    ('My Monkey', '00:04:31', 2),
    ('Counterfeit', '00:02:46', 3),
    ('Nobody Loves Me', '00:03:52', 3),
    ('Sour', '00:03:07', 3),
    ('(You Gotta) Fight for Your Right (To Party!)', '00:03:09', 4),
    ('No Sleep till Brooklyn', '00:04:10', 4),
    ('Hold It Now, Hit It', '00:03:29', 4),
    ('In the End', '00:03:36', 5),
    ('Crawling', '00:03:39', 5),
    ('One Step Closer', '00:02:35', 5),
    ('Makes No Difference', '00:03:32', 6),
    ('What I Believe', '00:02:20', 6),
    ('Machine Gun', '00:01:49', 6),
    ('Medellín', '00:04:58', 7),
    ('Crave', '00:03:21', 7),
    ('I Rise', '00:03:44', 7);
    
INSERT INTO collections (collection_name, collection_year)
VALUES
    ('Quarantine Mob Rocknmob', 2020),
    ('Sing the Hits of Sum 41 (Karaoke Version)', 2014),
    ('Def Jam Classics, Vol. 1', 1989),
    ('MTV Spring Break: Live Performances 1998', 1998),
    ('Crave (Remixes)', 2019),
    ('The Best World Ballads 37 Part 1', 2019);

INSERT INTO artist_albums
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7);

INSERT INTO artist_genres
VALUES
    (1, 1),
    (1, 5),
    (2, 2),
    (3, 3),
    (3, 4),
    (4, 4),
    (5, 3),
    (6, 1),
    (6, 5),
    (7, 6),
    (7, 7);

INSERT INTO collection_tracks 
VALUES
    (1, 14),
    (2, 18),
    (3, 12),
    (4, 9),
    (5, 21),
    (6, 22);


- - задание 2


SELECT track_name, duration
FROM tracks
WHERE duration = (SELECT MAX(duration) FROM tracks);

SELECT track_name, duration
FROM tracks 
WHERE duration >= '00:03:30'

SELECT collection_name, collection_year
FROM collections
WHERE collection_year BETWEEN 2018 AND 2020;

SELECT artist_name
FROM artists
WHERE artist_name NOT LIKE '% %';

SELECT track_name
FROM tracks
WHERE 
    track_name ILIKE 'my %'
    OR track_name ILIKE '% my'
    OR track_name ILIKE '% my %'
    OR track_name ILIKE 'my'
    OR track_name ILIKE 'мой %'
    OR track_name ILIKE '% мой'
    OR track_name ILIKE '% мой %'
    OR track_name ILIKE 'мой';

- - задание 3

SELECT genres.genre_name, COUNT(artist_genres.artist_id) AS total_artists
FROM genres
LEFT JOIN artist_genres
    ON genres.genre_id = artist_genres.genre_id
GROUP BY genres.genre_id, genres.genre_name
ORDER BY total_artists DESC;

SELECT COUNT(*) AS track_count
FROM tracks
JOIN albums ON tracks.album_id = albums.album_id
WHERE albums.album_year BETWEEN 2019 AND 2020;

SELECT 
    albums.album_id,
    albums.title,
    AVG(tracks.duration) AS avg_track_duration
FROM tracks
JOIN albums ON tracks.album_id = albums.album_id
GROUP BY albums.album_id, albums.title;

SELECT artist_name 
FROM artists
WHERE artist_id NOT IN (
    SELECT DISTINCT artist_id
    FROM artist_albums
    JOIN albums ON artist_albums.album_id = albums.album_id
    WHERE albums.album_year = 2020);

SELECT DISTINCT collections.collection_name
FROM collections
JOIN collection_tracks ON collections.collection_id = collection_tracks.collection_id 
JOIN tracks ON collection_tracks.track_id = tracks.track_id 
JOIN albums ON tracks.album_id = albums.album_id 
JOIN artist_albums ON albums.album_id = artist_albums.album_id 
JOIN artists ON artist_albums.artist_id = artists.artist_id 
WHERE artists.artist_name = 'Madonna'
ORDER BY collections.collection_name;






    














