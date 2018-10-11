# (3b) Find the publications of author = “X” (Chun Tang) at year “Y” (2003) at conference “Z” (KDD).  

-- Query: 
WITH temp_conference AS(
SELECT *
FROM publication
WHERE pubkey LIKE ("conf/kdd/%") and pubyear = 2003
)

SELECT *
FROM (temp_conference JOIN pub_author ON temp_conference.pubid = pub_author.pubid)
JOIN author ON pub_author.aid = author.aid
WHERE author.authorname = "Chun Tang";
