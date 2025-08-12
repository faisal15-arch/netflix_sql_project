--Netflix project
Drop table if exists netflix

Create table netflix(

show_id varchar(10),
type varchar(10),
title varchar(120),
director  varchar(208),
casts  varchar(1000),
country  varchar(150),
date_added varchar(50),
release_year INT,
rating  varchar(10),
duration  varchar(15),
listed_in   varchar(80),
description  varchar(250)

)
select * from netflix


Select count(*) as total_content from netflix

Select distinct type from netflix

--15 business problems
--Count number of tv vs movies
Select type , count(*) as total_content from netflix
group by type

--find most common ratings for tv shows and movies


Select type,rating from
(Select type, rating, count(*) as total_content,
Rank() over (partition by type order by count(*) desc ) as ranking 
from netflix 
group by 1,2
) as t1
where ranking=1


--list of all movies release in specific year
Select *
from netflix where release_year=2020 and type='Movie'

--find top 5 country with most content on netflix
Select Unnest(String_to_array (country , ',')) as new_country,
count(show_id) as most_watch
from netflix  group by 1
order by 2 desc
limit  5

--identify the longest movie
Select * from netflix
where type='Movie'
and 
duration=(Select max(duration) from netflix)


--find content added in last 5 years 
Select * from netflix 
where  to_date(date_added,'Month DD,YYYY') >=Current_date-interval '5 years'

--find all movies shows by director rajiv 'chalika'
Select * from netflix
where director ilike '%rajiv chilaka%'

--list of all tv shows more than 5 seasons
Select * from netflix
where type='TV Show' And
split_part(duration,' ',1)::numeric > 5


--find the number of contents in each genra
Select 
unnest(String_to_Array(listed_in,',')) as genre,
count(show_id) as total_content
from netflix
group by 1

--find each year and average number of content release by pakistan on netflix
--return top 5 year with highest avg content release:

Select 
Extract(year from TO_DATE(Date_added,'Month DD,YYYY')) as year,
count(*) as yearly_content,
Round(
count(*)::numeric/(Select count(*) from netflix WHERE LOWER(country) = 'pakistan')::numeric*100,2) as avg_content
from netflix
WHERE LOWER(country) = 'pakistan'
 group by 1
order by avg_content desc



--11 list all movies that are documentaries
SELECT * from netflix
where listed_in ilike '%documentaries%'


--12 find all content without director
SELECT * from netflix
where director is NULL

--13 find out how many movies actor 'Salman khan' appeared in last 10 years
Select * from netflix 
where 
casts ilike '%Salman khan%'

