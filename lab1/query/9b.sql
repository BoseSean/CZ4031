# (9b) Find the names and number of publications for authors who have the earliest publication record in DBLP.

-- Query: 
WITH earliest_pub as (
SELECT author.aid AS aid, author.authorname AS authorname
FROM publication, pub_author, author
WHERE publication.pubyear = (
SELECT MIN(pubyear) 
FROM publication)
   	AND publication.pubid = pub_author.pubid
AND pub_author.aid = author.aid
)

SELECT authorname, COUNT(*) AS cnt
FROM earliest_pub as t1, pub_author
WHERE t1.aid = pub_author.aid
GROUP BY t1.aid,authorname;
