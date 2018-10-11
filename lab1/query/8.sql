# (8). List the name of the conferences such that it has ever been held in June, and the corresponding proceedings contain more than 100 publications. 

-- Query:
WITH count_greater_than_100 AS (
 SELECT crossref_pubid AS pubid, COUNT(*) AS count
 FROM inproceedings
 GROUP BY crossref_pubid
 HAVING COUNT(*) > 200
),

conf_in_june AS (
 SELECT pubid, pubkey, title
 FROM publication
 WHERE title LIKE "%june%" and pubtype_id = 2
),

required_conf_dup AS (
SELECT C1.pubid
FROM count_greater_than_100 AS C1 
INNER JOIN conf_in_june AS C2 ON C1.pubid = C2.pubid
)

SELECT DISTINCT P.conf
FROM proceedings AS P INNER JOIN required_conf_dup AS R ON P.pubid = R.pubid;
