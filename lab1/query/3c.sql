# (3c). Find authors who published at least 2 papers at conference “Z” (KDD) at year “Y” (2003). 

WITH temp_conference AS(
SELECT *
FROM publication
WHERE pubkey LIKE ("conf/kdd/%") and pubyear = 2003
)

SELECT author.authorname
FROM (temp_conference JOIN pub_author ON temp_conference.pubid = pub_author.pubid)
JOIN author ON pub_author.aid = author.aid
GROUP BY author.authorname
HAVING count(*) > 1;
