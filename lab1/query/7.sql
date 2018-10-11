# (7). Find the top 10 authors with the largest number of publications that are published in conferences and journals whose titles contain word “Data” in the last 5 years.

-- Query: 
WITH conf_DATA AS (
SELECT P.pubid
FROM proceedings AS I 
LEFT JOIN publication AS P ON I.pubid = P.pubid
WHERE P.title LIKE "%DATA%" and P.pubyear > 2013
),

inproceedings_in_conf AS (
SELECT I.pubid AS pubid
FROM conf_DATA AS C 
INNER JOIN inproceedings AS I ON C.pubid = I.crossref_pubid
),

aid_count AS (
SELECT P.aid, COUNT(*) AS count
FROM inproceedings_in_conf AS I 
INNER JOIN pub_author AS P ON I.pubid = P.pubid
GROUP BY P.aid
ORDER BY COUNT(*) DESC
LIMIT 10
)

SELECT A2.authorname, A1.count
FROM aid_count AS A1 JOIN author AS A2 on A1.aid = A2.aid;

