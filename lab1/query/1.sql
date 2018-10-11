# (1) For each type of publication, count the total number of publications of that type between 2000- 2017. 

-- Query: 
WITH temp_count AS(
SELECT pubtype_id, COUNT(*) AS count
FROM publication
GROUP BY pubtype_id
)

SELECT pubtype.pubname, temp_count.count
FROM temp_count JOIN pubtype
WHERE temp_count.pubtype_id = pubtype.pubtype_id; 
