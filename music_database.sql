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
    duration VARCHAR(5),
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
    ('Sum 41');

INSERT INTO genres (genre_name)
VALUES
    ('Punk rock'),
    ('Industrial metal'),
    ('Nu metal'),
    ('Rap rock'),
    ('Pop punk');

INSERT INTO albums (title, album_year)
VALUES 
    ('39/Smooth', 1990),
    ('Portrait of an American Family', 1994),
    ('Three Dollar Bill, Y’all$', 1997),
    ('Licensed to Ill', 1986),
    ('Hybrid Theory', 2000),
    ('Half Hour of Power', 2000);
    
INSERT INTO tracks (track_name, duration, album_id)
VALUES
    ('Going to Pasalacqua', '3:38', 20),
    ('Green Day', '2:55', 20),
    ('Disappearing Boy', '3:16', 20),
    ('Cake and Sodomy', '3:40', 21),
    ('Lunchbox', '4:35', 21),
    ('Get Your Gunn', '3:18', 21),
    ('Counterfeit', '2:46', 22),
    ('Nobody Loves Me', '3:52', 22),
    ('Sour', '3:07', 22),
    ('(You Gotta) Fight for Your Right (To Party!)', '3:09', 23),
    ('No Sleep till Brooklyn', '4:10', 23),
    ('Hold It Now, Hit It', '3:29', 23),
    ('In the End', '3:36', 24),
    ('Crawling', '3:39', 24),
    ('One Step Closer', '2:35', 24),
    ('Makes No Difference', '3:32', 25),
    ('What I Believe', '2:20', 25),
    ('Machine Gun', '1:49', 25);

INSERT INTO collections (collection_name, collection_year)
VALUES
    ('Quarantine Mob Rocknmob', 2020),
    ('Sing the Hits of Sum 41 (Karaoke Version)', 2014),
    ('Def Jam Classics, Vol. 1', 1989),
    ('MTV Spring Break: Live Performances 1998', 1998);
    
INSERT INTO artist_albums
VALUES
    ('1', '20'),
    ('2', '21'),
    ('3', '22'),
    ('4', '23'),
    ('5', '24'),
    ('6', '25');

INSERT INTO artist_genres
VALUES
    ('1', '1'),
    ('1', '5'),
    ('2', '2'),
    ('3', '3'),
    ('3', '4'),
    ('4', '4'),
    ('5', '3'),
    ('6', '1'),
    ('6', '5');

INSERT INTO collection_tracks 
VALUES
    ('1', '13'),
    ('2', '17'),
    ('3', '11'),
    ('4', '8');

- - дополнительная информация 

INSERT INTO artists (artist_name)
VALUES ('Madonna');

INSERT INTO genres (genre_name)
VALUES
    ('Pop'),
    ('Disco');

INSERT INTO albums (title, album_year)
VALUES 
    ('Madame X', 2019);

INSERT INTO tracks (track_name, duration, album_id)
VALUES
    ('My Monkey', '4:31', 21),
    ('Medellín', '4:58', 26),
    ('Crave', '3:21', 26),
    ('I Rise', '3:44', 26);

INSERT INTO collections (collection_name, collection_year)
VALUES
    ('Crave (Remixes)', 2019),
    ('The Best World Ballads 37 Part 1', 2019);

INSERT INTO artist_albums
VALUES
    ('7', '26');

INSERT INTO artist_genres
VALUES
    ('7', '6'),
    ('7', '7');

INSERT INTO collection_tracks 
VALUES
    ('5', '26'),
    ('6', '27');

- - задание 2

SELECT track_name, duration
FROM tracks
WHERE duration = (SELECT MAX(duration) FROM tracks);

SELECT track_name, duration
FROM tracks 
WHERE duration > '3:30'

SELECT collection_name, collection_year
FROM collections
WHERE collection_year BETWEEN 2018 AND 2020;

SELECT artist_name
FROM artists
WHERE artist_name NOT LIKE '% %';

SELECT track_name
FROM tracks
WHERE LOWER(track_name) LIKE LOWER('%my%') OR LOWER(track_name) LIKE LOWER('%мой%');

- - задание 3

SELECT g.genre_name, (SELECT COUNT(*) FROM artist_genres ag WHERE ag.genre_id = g.genre_id) AS total_artists
FROM genres g
ORDER BY total_artists DESC

SELECT COUNT(*) AS track_count
FROM tracks
JOIN albums ON tracks.album_id = albums.album_id
WHERE albums.album_year BETWEEN 2019 AND 2020;

SELECT 
    albums.album_id,
    albums.title, 
    CONCAT(
    FLOOR(AVG(
      SPLIT_PART(tracks.duration, ':', 1)::INTEGER * 60 +
      SPLIT_PART(tracks.duration, ':', 2)::INTEGER
    ) / 60),
    ':',
    LPAD(
      ROUND(
        AVG(
          SPLIT_PART(tracks.duration, ':', 1)::INTEGER * 60 +
          SPLIT_PART(tracks.duration, ':', 2)::INTEGER
        ) % 60
      )::TEXT,
      2,
      '0'
    )
  ) AS avg_track_duration
FROM tracks
JOIN albums ON tracks.album_id = albums.album_id
GROUP BY albums.album_id, albums.title

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






    














