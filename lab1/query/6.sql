# (6). Find the most collaborative authors who published in a conference or journal whose name contains “data”. 

-- Query: 
WITH pub_title_contain_data AS (
SELECT pubid, title
FROM publication
WHERE title LIKE "%DATA%"
),

pubid_author_count as (
SELECT P1.pubid, COUNT(*) AS num_coauthor
FROM pub_title_contain_data AS P1
 INNER JOIN pub_author AS P2
ON P1.pubid = P2.pubid
GROUP BY P1.pubid
),

aid_coauthor_count AS (
SELECT P2.aid, P1.num_coauthor
FROM pubid_author_count AS P1 INNER JOIN pub_author AS P2
ON P1.pubid = P2.pubid
),

most_coauthor AS (
 SELECT aid, SUM(num_coauthor - 1 ) AS total_coauthor
 FROM aid_coauthor_count
 GROUP BY aid
 ORDER BY total_coauthor DESC
 LIMIT 1
)

SELECT A2.authorname, A1.total_coauthor
FROM most_coauthor AS A1 INNER JOIN author AS A2 ON A1.aid = A2.aid;
