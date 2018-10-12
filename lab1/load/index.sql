CREATE UNIQUE INDEX author_authorname_uindex 
ON author (authorname);

CREATE UNIQUE INDEX inproceedings_crossref_pubid 
ON inproceedings (crossref_pubid);

CREATE UNIQUE INDEX pub_author_aid 
ON pub_author (aid);

CREATE INDEX publication_pubtype_id
ON publication (pubtype_id);

CREATE INDEX publication_pubyear
ON publication (pubyear);

CREATE INDEX publication_pubkey
ON publication (pubkey);