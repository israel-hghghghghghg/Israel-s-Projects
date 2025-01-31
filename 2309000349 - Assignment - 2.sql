-- create database music management system
create database music_manag_system;
use music_manag_system;


-- create table artists
CREATE TABLE Artists (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    country VARCHAR(50)
);

-- create table albums
CREATE TABLE Albums (
    album_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    release_date DATE,
    artist_id INT,
    FOREIGN KEY (artist_id) REFERENCES Artists(artist_id)
);

-- crate table tracks
CREATE TABLE Tracks (
    track_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    duration INT,  -- Duration in seconds
    album_id INT,
    artist_id INT,
    FOREIGN KEY (album_id) REFERENCES Albums(album_id),
    FOREIGN KEY (artist_id) REFERENCES Artists(artist_id)
);

show tables;

-- Create table genres
CREATE TABLE Genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

-- create table albumgenres -- linking genres to albums

CREATE TABLE AlbumGenres (
    album_id INT,
    genre_id INT,
    PRIMARY KEY (album_id, genre_id),
    FOREIGN KEY (album_id) REFERENCES Albums(album_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);

-- Insert Gospel artists
INSERT INTO Artists (name, genre, country)
VALUES ('Israel Mbonyi', 'Gospel', 'RWANDA'),
       ('Nathaniel Bassey', 'Gospel', 'NIGERIA'),
       ('Prosper Nkomezi', 'Gospel', 'RWANDA'),
       ('Kaestrings', 'Gospel', 'NIGERIA');
       select * from artists;
       -- Insert Gospel albums
INSERT INTO Albums (title, release_date, artist_id)
VALUES ('BAHO', '2024-04-23', 1),
       ('YAHWEH SABAOTH', '2013-09-10', 2),
       ('NZAYIVUGA', '2020-06-22', 3),
       ('RAHAMA', '2017-02-03', 4);
       select * from albums;
       -- Insert Gospel tracks
INSERT INTO Tracks (title, duration, album_id, artist_id)
VALUES ('He Reigns', 225, 1, 1),
       ('Silver and Gold', 300, 1, 1),
       ('Break Every Chain', 310, 2, 2),
       ('For Your Glory', 270, 2, 2),
       ('I Call You Faithful', 280, 3, 3),
       ('We Fall Down', 220, 3, 3),
       ('Never Have to Be Alone', 250, 4, 4),
       ('Believe For It', 300, 4, 4);
       select * from tracks;
       
       -- Insert Gospel genre
INSERT INTO Genres (name)
VALUES ('Gospel');
select * from genres;

-- Link albums to the Gospel genre (optional)
INSERT INTO AlbumGenres (album_id, genre_id)
VALUES (1, 1),  -- 'BAHO' is Gospel
       (2, 1),  -- 'YAHWEH SABAOTH ' is Gospel
       (3, 1),  -- 'NZAYIVUGA' is Gospel
       (4, 1);  -- 'RAHAMA' is Gospel
select *from albumgenres;

-- Get all gospel artists
SELECT * FROM Artists WHERE genre = 'Gospel';

-- Get album from Israel Mbonyi
SELECT * FROM Albums WHERE artist_id = 1;

-- Get tracks from Nathaniel Bassey
SELECT * FROM Tracks WHERE album_id = 2;

-- Get the genre of a specific album (optional):
SELECT a.title, g.name AS genre
FROM Albums a
JOIN AlbumGenres ag ON a.album_id = ag.album_id
JOIN Genres g ON ag.genre_id = g.genre_id
WHERE a.album_id = 1;

-- using crude
-- 1. Create Operations (Inserting Data)
INSERT INTO Artists (name, genre, country)
VALUES ('Chryso Ndasingwa', 'Gospel', 'RWANDA');
select *from artists;
INSERT INTO Albums (title, release_date, artist_id)
VALUES ('WAHOZEHO', '2020-03-01', 5);  
select *from albums;
INSERT INTO Tracks (title, duration, album_id, artist_id)
VALUES ('INKOMOKO', 180, 5, 5); 
select * from tracks;

-- 2. Read operation of specific tasks
-- Get Albums by Israel Mbonyi
SELECT * FROM Albums
WHERE artist_id = (SELECT artist_id FROM Artists WHERE name = 'Israel Mbonyi');
-- Get All Tracks from NZAYIVUGA Album
SELECT * FROM Tracks
WHERE album_id = (SELECT album_id FROM Albums WHERE title = 'NZAYIVUGA');
-- Get All Tracks by NATHANIEL BASSEY
SELECT Tracks.title, Tracks.duration
FROM Tracks
JOIN Albums ON Tracks.album_id = Albums.album_id
JOIN Artists ON Albums.artist_id = Artists.artist_id
WHERE Artists.name = 'NATHANIEL BASSEY';

-- 3.Update Operations (Modifying Data)
-- Update Artist's Genre:
UPDATE Artists
SET genre = 'Contemporary Gospel'
WHERE artist_id = 1; 
select *from Artists;
-- Update Album's Release Date:
UPDATE Albums
SET release_date = '2021-01-01'
WHERE album_id = 2;  
select *from Albums;
-- Update Track Duration:
UPDATE Tracks
SET duration = 820  -- New duration in seconds
WHERE track_id = 1;  
select *from Tracks;

-- 4.Delete Operations (Removing Data)
-- delete a track
DELETE FROM Tracks
WHERE track_id = 1;  
select *from Tracks;

-- COUNT FUNCTION
-- Count the Total Number of Artists:
SELECT COUNT(*) AS total_artists
FROM Artists;

-- Count the Total Number of Albums:
SELECT COUNT(*) AS total_albums
FROM Albums;

-- Count the Total Number of Tracks:
SELECT COUNT(*) AS total_tracks
FROM Tracks;

-- AVERAGE FUNCTION
-- Average Duration of Tracks:
SELECT AVG(duration) AS average_duration
FROM Tracks;
-- Average Number of Tracks per Album:
SELECT AVG(track_count) AS average_tracks_per_album
FROM (
    SELECT COUNT(*) AS track_count
    FROM Tracks
    GROUP BY album_id
) AS album_track_counts;

-- SUM FUNCTION
-- Total Duration of All Tracks:
SELECT SUM(duration) AS total_duration
FROM Tracks;
-- Total Number of Tracks in All Albums:
SELECT SUM(track_count) AS total_tracks_in_all_albums
FROM (
    SELECT COUNT(*) AS track_count
    FROM Tracks
    GROUP BY album_id
) AS album_track_counts;



-- Getting the Number of Artists in a Genre
SELECT COUNT(*) AS gospel_artists
FROM Artists
WHERE genre = 'Gospel';


-- Getting the Average Track Duration for a Specific Artist:
SELECT AVG(duration) AS avg_track_duration
FROM Tracks
JOIN Albums ON Tracks.album_id = Albums.album_id
JOIN Artists ON Albums.artist_id = Artists.artist_id
WHERE Artists.name = 'Chryso Ndasingwa';

-- Getting the Total Duration of Tracks for a Specific Album:
SELECT SUM(duration) AS total_duration
FROM Tracks
JOIN Albums ON Tracks.album_id = Albums.album_id
WHERE Albums.title = 'YAHWEH SABAOTH';

-- Total Number of Artists, Albums, and Tracks in full:
SELECT 
    (SELECT COUNT(*) FROM Artists) AS total_artists,
    (SELECT COUNT(*) FROM Albums) AS total_albums,
    (SELECT COUNT(*) FROM Tracks) AS total_tracks;
    
    -- Average Duration of Tracks for All Artists:
    SELECT 
    AVG(Tracks.duration) AS average_duration
FROM Tracks
JOIN Albums ON Tracks.album_id = Albums.album_id
JOIN Artists ON Albums.artist_id = Artists.artist_id;

-- Total Duration of Tracks in Gospel Genre:
SELECT 
    SUM(Tracks.duration) AS total_duration
FROM Tracks
JOIN Albums ON Tracks.album_id = Albums.album_id
JOIN Artists ON Albums.artist_id = Artists.artist_id
WHERE Artists.genre = 'Gospel';


-- VIEWS OF DIFFERENT FORMS
-- 1. View for All Artists with Their Genre
CREATE VIEW artist_genre_view AS
SELECT artist_id, name AS artist_name, genre
FROM Artists;
select * from artist_genre_view;
-- 2. View for All Albums and Their Release Dates
CREATE VIEW album_release_view AS
SELECT album_id, title AS album_title, release_date
FROM Albums;
select * from album_release_view;
-- 3. View for All Tracks and Their Duration
CREATE VIEW track_duration_view AS
SELECT track_id, title AS track_title, duration
FROM Tracks;
select * from track_duration_view;
-- 4. View for Artists from a Specific Country
CREATE VIEW artists_from_country AS
SELECT artist_id, name AS artist_name
FROM Artists
WHERE country = 'RWANDA';
select * from artists_from_country;
-- 5. View for Albums Released in a Specific Year
CREATE VIEW albums_2020 AS
SELECT album_id, title AS album_title, release_date
FROM Albums
WHERE YEAR(release_date) = 2020;
select * from albums_2020;
-- 6. View for Artists in a Specific Genre
CREATE VIEW gospel_artists AS
SELECT artist_id, name AS artist_name
FROM Artists
WHERE genre = 'Gospel';
select * from gospel_artists;
/* 7. View for Tracks Longer Than 5 Minutes
This view displays tracks longer than 5 minutes (300 seconds). */
CREATE VIEW long_tracks AS
SELECT Tracks.track_id, Tracks.title AS track_title, Tracks.duration, Albums.title AS album_title, Artists.name AS artist_name
FROM Tracks
JOIN Albums ON Tracks.album_id = Albums.album_id
JOIN Artists ON Albums.artist_id = Artists.artist_id
WHERE Tracks.duration > 300;
select * from long_tracks;
 
-- 1. Stored Procedure to Add an Artist
-- DELIMITER //

CREATE PROCEDURE AddArtist(IN artist_name VARCHAR(255), IN artist_genre VARCHAR(255), IN artist_country VARCHAR(255))
-- BEGIN
    INSERT INTO Artists (name, genre, country) 
    VALUES (artist_name, artist_genre, artist_country);
-- END //
 CALL AddArtist('Abbey Ojomu', 'Gospel', 'NIGERIA');
select * from artists;

-- 2. Stored Procedure to Add an Album
DELIMITER //

CREATE PROCEDURE AddAlbum(IN album_title VARCHAR(255), IN album_release_date DATE, IN artist_id INT)
BEGIN
    INSERT INTO Albums (title, release_date, artist_id) 
    VALUES (album_title, album_release_date, artist_id);
END //

DELIMITER ;
CALL AddAlbum('Israel Mbonyi', '2021-01-01', 1);
select * from Albums;

-- 3. Stored Procedure to Add a Track
DELIMITER //

CREATE PROCEDURE AddTrack(IN track_title VARCHAR(255), IN track_duration INT, IN album_id INT)
BEGIN
    INSERT INTO Tracks (title, duration, album_id) 
    VALUES (track_title, track_duration, album_id);
END //

DELIMITER ;
CALL AddTrack('Yaratwimanye', 300, 1);
select *from Tracks;

-- 4. Stored Procedure to Get All Albums by Artist
DELIMITER //

CREATE PROCEDURE GetAlbumsByArtist(IN artist_id INT)
BEGIN
    SELECT * FROM Albums WHERE artist_id = artist_id;
END //

DELIMITER ;
CALL GetAlbumsByArtist(1);

-- 5. Stored Procedure to Get Total Number of Tracks by Album
DELIMITER //

CREATE PROCEDURE GetTrackCountByAlbum(IN album_id INT)
BEGIN
    SELECT COUNT(*) AS total_tracks FROM Tracks WHERE album_id = album_id;
END //

DELIMITER ;
CALL GetTrackCountByAlbum(1);  

-- 6 Stored Procedure to Get Tracks from an Album
DELIMITER //

CREATE PROCEDURE GetTracksByAlbum(IN album_id INT)
BEGIN
    SELECT * FROM Tracks WHERE album_id = album_id;
END //

DELIMITER ;
CALL GetTracksByAlbum(1);



-- Create user and password
create user '1234'@'127.0.0.1' identified by '1234';
grant all privileges on music_manag_system. *to '123'@'127.0.0.1';

-- 





















































 






















