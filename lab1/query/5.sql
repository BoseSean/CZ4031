# (5). For each 10 consecutive years starting from 1970, compute the total number of conference publications in DBLP in that 10 years. 

-- Query: 
WITH year_temp AS(
 SELECT DISTINCT P.pubyear, FLOOR((P.pubyear-1970)/10) AS decade_no
 FROM pub AS P
 WHERE P.pubyear >= 1970
 ORDER BY P.pubyear ASC
),

pcount AS(
 SELECT P.pubyear, count(P.pubid) AS psum
 FROM pub AS P
 WHERE P.pubkey LIKE ("conf/%") and P.pubyear >= 1970
 GROUP BY P.pubyear
)

SELECT (decade_no * 10 + 1970) AS start, (decade_no * 10 + 1980) AS end, SUM(pcount.psum) AS total
FROM pcount JOIN year_temp ON pcount.pubyear = year_temp.pubyear
GROUP BY decade_no
ORDER BY decade_no ASC;
