-- EDA

-- Table overview 
select * from shows
limit 5 ;

-- Counting no of rows 
select 
	count(*) as total_rows 
from shows;

-- no of columns 
show columns from shows;

-- checking values present columns 
select 
	type , 
    count(*) as no_of_values
from shows
group by type ;

select 
	distinct country ,
    count(*) as value_counts
from shows
group by 1;

select 
	release_year,
    count(*) as value_counts
from shows
group by 1
order by value_counts desc;

-- 15  Business Problems

-- 1) count the no of movies Vs tv shows
select 
	type ,
    count(*) as value_counts
from shows
group by 1;

-- 2) find the most common rating for movies and tv shows
with cte as ( 
				select 
					type ,
					rating  ,
					count(*) as rating_counts ,
                    rank() over (partition by type order by count(*) desc) as rnk
				from shows
				group by 1, 2 
			)
select * from cte 
where rnk = 1;

-- 3) list all movies released in a specific year (e.g , 2020)
select *
from shows
where release_year = 2020 and type = "Movie";

-- 4) find the top 5 countries with most content on netflix
select 
    distinct country ,
    count(show_id) as cnt
from shows
group by 1
;

-- 5) identify the longest movie or tv shows duration
select * 
from shows
where type = "Movie" 
and duration = (select max(duration) from shows);

-- 6) find the content that added in the last 5 years
SELECT *
from shows
where str_to_date(date_added, '%M %d, %Y') >= current_date() - interval 5 year;

-- 7) find all movies / tv shows by director 'rajiv chilaka' 
select * 
from shows
where director in (
					select 
						director
					from shows 
					where director like '%Rajiv Chilaka%'
				  );

-- 8) list all TV shows with more than 5 seasons
select * from shows;
select 
	* , 
    substring(duration, 1, 1) as no_of_seasons 
from shows
where type = 'TV Show' and cast(substring(duration, 1, 1) as unsigned) > 5
;

-- 9 count the no of items in each genre
with cte as ( 
				select 
					show_id ,
					substring_index(listed_in,",", 1) as first_del ,
					substring_index(substring_index(listed_in, ",", 2),",",-1) as second_del ,
					substring_index(listed_in,",",-1) as third_del
				from shows
			) ,
final as ( 
			select first_del from cte 
            union all 
            select second_del from cte
            union all 
            select third_del from cte
		 )
select *, 
	count(*) as genre_count 
from final
group by 1
order by 2 desc;
	
-- 10) find each year and the average no of content release by india on netflix
-- return top 5 years with highest avg content release 

select 
    year(str_to_date( date_added, "%M %d,%Y")) as `year`,
    count(*) as content_release , 
    round( count(*) / (select count(*) from shows where country = "India" ) * 100, 0) as avg_content_release
from shows
where country = "India"
group by 1;

-- 11) find all content without a director
select * 
from shows 
where show_id in (
					select 
						show_id
					from shows
					where director is null
				  );
                  
-- 12) list all movies that are in documentaries 
select *
from shows 
where listed_in like "%Documentaries%";

-- 13) find how many movies actor 'Slaman khan' appeared in last 10 years
select 
	*
from shows
where cast like "%Salman Khan%"
and
release_year > year(current_date()) - 10 ;

-- 14_ find the top 10 actors who appeared in the highest number of movies produced in inida
select 
	show_id, 
    cast,
    count(show_id) as cnt
from shows
where show_id in (
					select show_id 
					from shows
					where country = "India"
				  )
group by 1,2 
limit 10;

-- 15) categorise the content based on the presence of the keyword "kill" and "violence" in the 
-- description field. label content containing these keywords as "bad" andd all other content as good.
-- count how many items fall into each category
with cte as ( 
				select *,
					case when description like '%kill%' or '%violence%' then "Bad"
						 else "Good"
						 end as Category
				from shows
			)
select
	category ,
    count(*) as `count`
from cte
group by 1;






