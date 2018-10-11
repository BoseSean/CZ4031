# (10). Find the top 3 authors with largest number of publications in DBLP. 

-- Query: 
WITH author_top3 AS (
SELECT aid, COUNT(*) AS cnt
FROM pub_author
GROUP BY aid
ORDER BY COUNT(*) DESC
LIMIT 3
)

SELECT A.authorname, author_top3.cnt
FROM author_top3 INNER JOIN author AS A ON author_top3.aid = A.aid;

