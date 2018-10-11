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
