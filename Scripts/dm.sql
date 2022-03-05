
show databases -- checking all the db that we have
create database BIM_22 ---create new db that we are going to use in our project
use bim_22 --- use it


---create temp table where we are going to store our csv file

CREATE TABLE temp (
    university VARCHAR(500),
    year INT,
    rank_display VARCHAR(20),
    score FLOAT,
    link VARCHAR(255),
    country VARCHAR(100),
    city VARCHAR(100),
    region VARCHAR(100),
    logo VARCHAR(255),
    type VARCHAR(500),
    research_output VARCHAR(100),
    student_faculty_ratio INT,
    international_students FLOAT,
    size VARCHAR(20),
    faculty_count FLOAT
);

---create first dimension table (location)

CREATE TABLE dim_location (
    location_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    country VARCHAR(100),
    city VARCHAR(100),
    region VARCHAR(100)
)

---import data from temp table into location table


INSERT IGNORE INTO dim_location (country,city,region)
SELECT DISTINCT country,city,region FROM temp

---create second dimension table (university)

CREATE TABLE dim_university (
    university_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    university VARCHAR(255),
    link VARCHAR(255),
    logo VARCHAR(255),
    type VARCHAR(255)
)

---import data from temp table into university table

INSERT IGNORE INTO dim_university (university,link,logo,type)
SELECT DISTINCT university,link,logo,type FROM temp

---create fact table


CREATE TABLE fact_about (
    fact_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    location_id INT,
    university_id INT,
    student_faculty_ratio INT,
    international_students FLOAT,
    size VARCHAR(20),
    faculty_count FLOAT,
    rank_display VARCHAR(20),
    score FLOAT,
    year INT,
    research_output VARCHAR(100),
    FOREIGN KEY (location_id)
        REFERENCES bim_22.dim_location (location_id)
        ON DELETE SET NULL,
    FOREIGN KEY (university_id)
        REFERENCES bim_22.dim_university (university_id)
        ON DELETE SET NULL
)

---insert data from temp table into fact table

INSERT IGNORE INTO fact_about
   (location_id,
    university_id,
    student_faculty_ratio,
    international_students,
    size,
    faculty_count,
    rank_display ,
    score,
    year,
    research_output
    )
    SELECT distinct 
	l.location_id,
    u.university_id,
    t.student_faculty_ratio,
    t.international_students,
    t.size,
    t.faculty_count,
    t.rank_display ,
    t.score,
    t.year,
    t.research_output
    from temp t
    inner join dim_university u on u.university = t.university
    inner join dim_location l on l.city = t.city
    
---checking the duplicates first way

select location_id,
       university_id,
       student_faculty_ratio,
       international_students,
       size,
       faculty_count,
       rank_display ,
       score,
       year,
       research_output,
       count(*) d_count
from fact_about
group by 1,2,3,4,5,6,7,8,9,10 
having d_count > 1

---checking the duplicates second way

with list as 
(select location_id,
        university_id,
        student_faculty_ratio,
        international_students,
        size,
        faculty_count,
        rank_display,
        score,
        year,
        research_output,
        row_number() over(partition by location_id,
                                       university_id,
									   student_faculty_ratio,
									   international_students,
									   size,
									   faculty_count,
								       rank_display,
									   score,
									   year,
									   research_output order by fact_id
						  ) d_count
from fact_about
)
	select * 
	from list 
	where d_count > 1



    
    
   







