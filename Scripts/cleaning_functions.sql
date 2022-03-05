SELECT DISTINCT size FROM fact_about    --getting unique values in a column 'size'
   
--making 'size' column more readable using case statement   
   SELECT 
    *,
    CASE
        WHEN LOWER(size) = 's' THEN 'Small'
        WHEN LOWER(size) = 'm' THEN 'Medium'
        WHEN LOWER(size) = 'l' THEN 'Large'
        ELSE 'Extra Large'
    END Size
FROM
    fact_about
           
-- uploading values into dim table
           
INSERT INTO dim_university (university,link,logo,type)
VALUES (null,'Sam','John',null)
ORDER BY university_id DESC

--return and replace the first non-null value 
SELECT 
    COALESCE(university, 'E R R R O R') mist
FROM
    dim_university
ORDER BY mist
  
--replace certain value with null value

SELECT 
    NULLIF(university, 'E R R R O R') back
FROM
    dim_university
ORDER BY back

--checking the table to identify inserted above record
SELECT 
    *
FROM
    dim_university
ORDER BY university_id DESC

--delete inserted above record using where clause

DELETE FROM dim_university 
WHERE
    university_id = 2048