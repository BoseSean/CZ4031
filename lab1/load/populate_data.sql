LOAD DATA INFILE '/var/lib/mysql-files/author_update.txt'
IGNORE INTO TABLE author;

LOAD DATA INFILE '/var/lib/mysql-files/pub_author_update.txt'
INTO TABLE pub_author_temp;

LOAD DATA INFILE '/var/lib/mysql-files/pub_update.txt'
INTO TABLE pub_temp
IGNORE 1 LINES;

INSERT INTO pub_author (pubid, aid)
SELECT pub_author_temp.pubid, author.aid
FROM (SELECT DISTINCT * FROM pub_author_temp
) AS pub_author_temp, author
where pub_author_temp.a_name = author.authorname;

INSERT INTO article (pubid, pages, ee, url, journal)
SELECT pub.pubid, pub.pages, pub.ee, pub.url, pub.journal
FROM pub_temp
WHERE pubtype = 0;

INSERT INTO inproceedings (pubid, booktitle, pages, crossref, ee, url)
SELECT pub.pubid, pub.booktitle, pub.pages, pub.crossref, pub.ee, pub.url
FROM pub_temp
WHERE pubtype = 1;

INSERT INTO proceedings (pubid, series, crossref, pages, ee, url, booktitle, title)
SELECT pub.pubid, pub.pages, pub.crossref, pub.pages,pub.ee, pub.url, pub.booktitle, pub.title
FROM pub_temp
WHERE pubtype = 2;

INSERT INTO book (pubid, publisher, isbn, series, volume)
SELECT pub.pubid, pub.publisher, pub.isbn, pub.series, pub.volume
FROM pub_temp
WHERE pubtype = 3;

INSERT INTO incollection (pubid, booktitle, pages, crossref, url)
SELECT pub.pubid, pub.booktitle, pub.pages, pub.crossref, pub.url
FROM pub_temp
WHERE pubtype = 4;

INSERT INTO publication (pubid, pubkey, title, mdate, pubyear)
SELECT pub.pubid, pub.pubkey, pub.title, pub.mdate, IF(pub.pubyear='', NULL, pub.pubyear)
FROM pub_temp;

INSERT INTO `dblp`.`pubtype` (`pubtype_id`, `pubname`) VALUES ('0', 'article');
INSERT INTO `dblp`.`pubtype` (`pubtype_id`, `pubname`) VALUES ('1', 'inproceeding');
INSERT INTO `dblp`.`pubtype` (`pubtype_id`, `pubname`) VALUES ('2', 'proceeding');
INSERT INTO `dblp`.`pubtype` (`pubtype_id`, `pubname`) VALUES ('3', 'book');
INSERT INTO `dblp`.`pubtype` (`pubtype_id`, `pubname`) VALUES ('4', 'incollection');
INSERT INTO `dblp`.`pubtype` (`pubtype_id`, `pubname`) VALUES ('5', 'phdthesis');
INSERT INTO `dblp`.`pubtype` (`pubtype_id`, `pubname`) VALUES ('6', 'masterthesis');
INSERT INTO `dblp`.`pubtype` (`pubtype_id`, `pubname`) VALUES ('7', 'www');
