# (1) For each type of publication, count the total number of publications of that type between 2000- 2017. 

-- Query: 
WITH temp_count AS(
SELECT pubtype_id, COUNT(*) AS count
FROM publication
GROUP BY pubtype_id
)

SELECT pubtype.pubname, temp_count.count
FROM temp_count JOIN pubtype
WHERE temp_count.pubtype_id = pubtype.pubtype_id; 
# (2) Find all the conferences that have ever published more than 200 papers in one year and are held in July.  

-- Query: 
WITH count_greater_than_200 AS (
 SELECT crossref_pubid AS pubid, COUNT(*) AS count
 FROM inproceedings
 GROUP BY crossref_pubid
 HAVING COUNT(*) > 200
),

conf_in_JULY AS (
 SELECT pubid, pubkey, title
 FROM publication
 WHERE title LIKE "%JULY%" and pubtype_id = 2
),

required_conf_dup AS (
SELECT C1.pubid
FROM count_greater_than_200 AS C1
INNER JOIN conf_in_JULY AS C2 on C1.pubid = C2.pubid
)

SELECT DISTINCT P.conf
FROM proceedings AS P INNER JOIN required_conf_dup AS R ON P.pubid = R.pubid;
# (3a) Find the publications of author = “X” ( Rolf Hennicker ) at year 2015. 

-- Query: 
WITH temp_publication AS(
SELECT P.*, A.authorname
FROM (pub_author AS PA 
INNER JOIN publication AS P ON PA.pubid = P.pubid)
INNER JOIN author AS A ON PA.aid = A.aid
)

SELECT *
FROM temp_publication 
WHERE temp_publication.authorname = "Rolf Hennicker" and temp_publication.pubyear = 2015; 
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

# (8). List the name of the conferences such that it has ever been held in June, and the corresponding proceedings contain more than 100 publications. 

-- Query:
WITH count_greater_than_100 AS (
 SELECT crossref_pubid AS pubid, COUNT(*) AS count
 FROM inproceedings
 GROUP BY crossref_pubid
 HAVING COUNT(*) > 200
),

conf_in_june AS (
 SELECT pubid, pubkey, title
 FROM publication
 WHERE title LIKE "%june%" and pubtype_id = 2
),

required_conf_dup AS (
SELECT C1.pubid
FROM count_greater_than_100 AS C1 
INNER JOIN conf_in_june AS C2 ON C1.pubid = C2.pubid
)

SELECT DISTINCT P.conf
FROM proceedings AS P INNER JOIN required_conf_dup AS R ON P.pubid = R.pubid;
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

