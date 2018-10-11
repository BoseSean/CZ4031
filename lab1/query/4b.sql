# (4b). all authors who published at least 15 PVLDB papers but never published a KDD paper.  

-- Query: 
WITH temp_pub_author AS (
SELECT pub_author.aid, pub_author.pubid, author.authorname
FROM pub_author JOIN author ON pub_author.aid = author.aid
),

temp_pvldb AS (
SELECT temp_pub_author.aid, temp_pub_author.authorname, count(*)
FROM publication JOIN temp_pub_author ON publication.pubid = temp_pub_author.pubid
WHERE pubkey LIKE ("conf/vldb/%")
GROUP BY temp_pub_author.aid, temp_pub_author.authorname
HAVING COUNT(*) > 14
),

 temp_kdd AS (
 SELECT DISTINCT temp_pub_author.aid, temp_pub_author.authorname
 FROM publication JOIN temp_pub_author ON publication.pubid = temp_pub_author.pubid
 WHERE pubkey LIKE ("conf/kdd/%")
)

SELECT *
FROM temp_pvldb
WHERE temp_pvldb.authorname NOT IN (
SELECT authorname 
FROM temp_kdd);
