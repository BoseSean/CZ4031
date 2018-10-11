# (2) Find all the conferences that have ever published more than 200 papers in one year and are held in July.  

-- Query: 
WITH count_greater_than_200 AS (
 SELECT crossref_pubid AS pubid, COUNT(*) AS count
 FROM inproceedings
 GROUP BY crossref_pubid
 HAVING COUNT(*) > 200
),

conf_in_JULY AS (
 SELECT pubid, pubkey, title
 FROM publication
 WHERE title LIKE "%JULY%" and pubtype_id = 2
),

required_conf_dup AS (
SELECT C1.pubid
FROM count_greater_than_200 AS C1
INNER JOIN conf_in_JULY AS C2 on C1.pubid = C2.pubid
)

SELECT DISTINCT P.conf
FROM proceedings AS P INNER JOIN required_conf_dup AS R ON P.pubid = R.pubid;
