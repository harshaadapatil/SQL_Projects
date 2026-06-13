-- Advanced sql project -- spotify dataset

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--Q.1 Retrieve the names of all tracks that have more than 1 billion streams.
	SELECT * FROM spotify 
	WHERE streams > 1000000000 ;

--Q.2 List all albums along with their respective artists.
	SELECT DISTINCT album, artist
	from spotify ;
	
--Q.3 Get the total number of comments for tracks where licensed = TRUE.
	SELECT SUM(comments)AS total_comments
	FROM spotify 
	WHERE licensed = 'true' ;
	
--Q.4 Find all tracks that belong to the album type single.
	SELECT * FROM spotify 
	WHERE album_type = 'single' ;

--Q.5 Count the total number of tracks by each artist.
	SELECT 
	artits, COUNT(*) AS total_songs
	FROM spotify 
	GROUP BY artists 
	ORDER BY 2;

--Q.6 Calculate the average danceability of tracks in each album.
	SELECT
	album, AVG(danceability) AS avg_danceability
	FROM spotify
	GROUP BY album
	ORDER BY 2 DESC ;

--Q.7 Find the top 5 tracks with the highest energy values.
	SELECT
	tracks, MAX(energy)
	FROM spotify
	GROUP BY 1
	ORDER BY 2 DESC 
	LIMIT 5;

--Q.8 List all tracks along with their views and likes where official_video = TRUE.
	SELECT 
	tracks, SUM(views) AS total_views, SUM(likes) AS total_likes
	FROM spotify
	WHERE official_video = 'true'
	GROUP BY 1
	ORDER BY 2;

--Q.9 For each album, calculate the total views of all associated tracks.
	SELECT 
	album, track, SUM(views) AS total_views
	FROM spotify 
	GROUP BY 1
	ORDER BY 2 DESC; 

--Q.10 Retrieve the track names that have been streamed on Spotify more than YouTube.
	SELECT * FROM 
	(SELECT track,
		COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as streamed_on_youtube,
		COALESCE(SUM(CASE WHEN most_played_on = 'spotify' THEN stream END),0) as streamed_on_spotify,
	FROM spotify
	GROUP BY 1
	) as t1
	WHERE 
	streamed_on_spotify > streamed_on_youtube
	AND
	streamed_on_youtube <> 0 ;

-- Q.11 Find the top 3 most-viewed tracks for each artist using window functions.
	WITH ranking_artist
	AS 
	(SELECT
	artist, track,
	SUM(views) as total_views,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank 
	FROM spotify
	GROUP BY 1,2
	ORDER BY 1, 3 DESC
	)
	SELECT * FROM ranking_artist
	WHERE rank <= 3 ;
		 
-- Q.12 Write a query to find tracks where the liveness score is above the average.
	SELECT track, artist, liveness
	FROM spotify 
	WHERE liveness > (SELECT AVG (liveness) FROM spotify) ;

--Q.13  Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

	WITH cte
	AS
	(SELECT album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
	FROM spotify
	GROUP BY 1
	)
	SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
	FROM cte
	ORDER BY 2 DESC ;

--Q.14  Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT track, energy, liveness,
SELECT track, energy, liveness,
	energy / NULLIF (liveness, 0) AS energy_liveness_ratio
	FROM spotify
	WHERE (energy / NULLIF (liveness, 0)) > 1.2
	ORDER BY energy_liveness_ratio DESC ;
	
--Q.15 Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT track, views, likes
     SUM(likes) OVER(ORDER BY views) AS cumulative_likes
FROM spotify ;	 
