--	NETFLIX ANALYSIS

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix;



select count(show_id) from netflix;

select distinct type from netflix;


--1. Count the number of Movies vs TV Shows
select 
type,
count (type) as total_content
from netflix 
group by type;


--2. Find the most common rating for movies and TV shows
select
type,
rating from (select type,rating,count(rating),
				rank()over(partition by type order by count(rating) desc) as Ranking
				from netflix 
				group by type,rating ) 
where ranking=1;



--3. List all movies released in a specific year (e.g., 2020)
select title,release_year from netflix
where type = 'Movie' 
	  and 
	  release_year=2020;



--4. Find the top 5 countries with the most content on Netflix
select 
unnest(string_to_array(Country,',')) as New_countries,
count(show_id) as total_content
from netflix
group by total_countries 
order by count(show_id) desc
limit 5;



--5. Identify the longest movie
select title,duration from netflix
where type='Movie' 
	  and 
      duration=(select max(duration) from netflix) 
limit 1;
     
--6. Find content added in the last 5 years
select *  from netflix 
where 
	to_date(date_added,'month dd yyyy') >= current_date-interval '5 years';



--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select title from netflix where director like '%Rajiv Chilaka%';


--8. List all TV shows with more than 5 seasons
select * from netflix where type='TV Show' and split_part(duration,' ',1)::numeric > 5;

--9. Count the number of content items in each genre
select unnest(string_to_array(listed_in,',')) as genre,
count(type) from netflix
group by genre
order by count(type) desc;


--10.Find each year and the average numbers of content release in India on netflix.return top 5 year with highest avg content release!
select 
extract(year from to_date(date_added,'month dd, year')) as year,
count (type),
round(count (type)::numeric/(select count(*) from netflix where country='India')::numeric *100,2) as avg_content_per_year
from netflix 
where country='India' 
group by 1 ;


--11. List all movies that are documentaries
select * from netflix where type='Movie'and listed_in like '%Documentaries%';

--12. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from netflix
where casts like '%Salman Khan%' 
      and 
	  release_year > extract(year from current_date) -10;

--13.find all content without a director
select * from netflix where director is null;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select
unnest(string_to_array(casts,',')) as actors,
count(type) from netflix 
where type= 'Movie' and country ilike '%India' 
group by actors 
order by count(type) desc
limit 10;

select listed_in,avg(cast(replace(duration,' min','') as int)) from netflix where type='Movies' group by listed_in;




--15.avg duration of movies in each genre
SELECT 
   trim(unnest(string_to_array(listed_in, ','))) AS genre ,
    round(AVG(CAST(REPLACE(duration, ' min', '') AS INT)),2) AS avg_duration
FROM netflix
WHERE type = 'Movie'
GROUP BY genre
;
