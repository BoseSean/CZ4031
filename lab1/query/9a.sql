# (9a). Find authors who have published at least 1 paper every year in the last 30 years, and whose family name start with ‘H’. 

-- Query: 
WITH pub_last_30_years AS (
SELECT *
FROM publication
WHERE pubyear BETWEEN 1988 AND 2018
),

author_fname_H AS (
SELECT * 
FROM author 
WHERE SUBSTRING_INDEX(author.authorname , ' ', -1) LIKE 'H%'
),

author_H_pub AS (
SELECT A.authorname, P.pubid
FROM author_fname_H AS A JOIN pub_author AS P ON A.aid = P.aid
),

author_H_pub_30 AS (
SELECT DISTINCT A.authorname, P.pubyear
FROM author_H_pub AS A 
INNER JOIN pub_last_30_years AS P ON A.pubid = P.pubid
)

SELECT A.authorname
FROM author_H_pub_30 AS A
GROUP BY A.authorname
HAVING COUNT(*) >30;
