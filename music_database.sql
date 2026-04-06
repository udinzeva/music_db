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













