# (4a). All authors who published at least 10 PVLDB papers and published at least 10 SIGMOD papers. 

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
HAVING COUNT(*) > 9
),

 temp_sigmod AS (
 SELECT temp_pub_author.aid, temp_pub_author.authorname, count(*)
 FROM publication JOIN temp_pub_author ON publication.pubid = temp_pub_author.pubid
 WHERE pubkey LIKE ("conf/sigmod/%")
 GROUP BY temp_pub_author.aid, temp_pub_author.authorname
 HAVING COUNT(*) > 9
)

SELECT *
FROM temp_pvldb
WHERE temp_pvldb.authorname IN 
(SELECT authorname 
FROM temp_sigmod);
