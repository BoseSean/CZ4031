-- MySQL dump 10.13  Distrib 8.0.12, for Linux (x86_64)
--
-- Host: localhost    Database: dblp
-- ------------------------------------------------------
-- Server version	8.0.12

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8mb4 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `article`
--

DROP TABLE IF EXISTS `article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `article` (
  `pubid` int(11) NOT NULL,
  `pages` varchar(255) DEFAULT NULL,
  `ee` varchar(255) DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `journal` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pubid`),
  CONSTRAINT `article_publication_pubid_fk` FOREIGN KEY (`pubid`) REFERENCES `publication` (`pubid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `author` (
  `aid` int(11) NOT NULL,
  `authorname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`aid`),
  UNIQUE KEY `author_authorname_uindex` (`authorname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `book` (
  `pubid` int(11) NOT NULL,
  `publisher` varchar(255) DEFAULT NULL,
  `isbn` varchar(255) DEFAULT NULL,
  `series` varchar(255) DEFAULT NULL,
  `volume` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pubid`),
  CONSTRAINT `book_publication_pubid_fk` FOREIGN KEY (`pubid`) REFERENCES `publication` (`pubid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `incollection`
--

DROP TABLE IF EXISTS `incollection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `incollection` (
  `pubid` int(11) NOT NULL,
  `booktitle` varchar(255) DEFAULT NULL,
  `pages` varchar(255) DEFAULT NULL,
  `crossref` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pubid`),
  CONSTRAINT `incollection_publication_pubid_fk` FOREIGN KEY (`pubid`) REFERENCES `publication` (`pubid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inproceedings`
--

DROP TABLE IF EXISTS `inproceedings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `inproceedings` (
  `pubid` int(11) NOT NULL,
  `booktitle` varchar(300) DEFAULT NULL,
  `pages` varchar(255) DEFAULT NULL,
  `crossref_pubid` int(11) DEFAULT NULL,
  `ee` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pubid`),
  KEY `inproceedings_crossref_pubid_fk` (`crossref_pubid`),
  CONSTRAINT `inproceedings_crossref_pubid_fk` FOREIGN KEY (`crossref_pubid`) REFERENCES `proceedings` (`pubid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proceedings`
--

DROP TABLE IF EXISTS `proceedings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `proceedings` (
  `pubid` int(11) NOT NULL,
  `conf` varchar(255) DEFAULT NULL,
  `ee` varchar(255) DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `booktitle` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pubid`),
  CONSTRAINT `proceedings_publication_pubid_fk` FOREIGN KEY (`pubid`) REFERENCES `publication` (`pubid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pub`
--

DROP TABLE IF EXISTS `pub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `pub` (
  `pubid` int(11) NOT NULL,
  `pubtype` varchar(255) DEFAULT NULL,
  `mdate` varchar(255) DEFAULT NULL,
  `pubkey` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `booktitle` varchar(300) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `cdrom` varchar(255) DEFAULT NULL,
  `chapter` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `crossref` varchar(255) DEFAULT NULL,
  `cite` varchar(255) DEFAULT NULL,
  `editor` varchar(255) DEFAULT NULL,
  `ee` varchar(255) DEFAULT NULL,
  `isbn` varchar(255) DEFAULT NULL,
  `journal` varchar(255) DEFAULT NULL,
  `pubmonth` varchar(255) DEFAULT NULL,
  `note` varchar(500) DEFAULT NULL,
  `pubnumber` varchar(255) DEFAULT NULL,
  `pages` varchar(255) DEFAULT NULL,
  `publisher` varchar(255) DEFAULT NULL,
  `publnr` varchar(255) DEFAULT NULL,
  `school` varchar(255) DEFAULT NULL,
  `series` varchar(255) DEFAULT NULL,
  `title` varchar(1660) DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `volume` varchar(255) DEFAULT NULL,
  `pubyear` varchar(255) DEFAULT NULL,
  `incollection` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pubid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pub_author`
--

DROP TABLE IF EXISTS `pub_author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `pub_author` (
  `pubid` int(11) NOT NULL,
  `aid` int(11) NOT NULL,
  PRIMARY KEY (`pubid`,`aid`),
  KEY `pub_author_aid_fk` (`aid`),
  CONSTRAINT `pub_author_aid_fk` FOREIGN KEY (`aid`) REFERENCES `author` (`aid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publication`
--

DROP TABLE IF EXISTS `publication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `publication` (
  `pubid` int(11) NOT NULL,
  `pubkey` varchar(255) DEFAULT NULL,
  `pubtype_id` int(11) DEFAULT NULL,
  `title` varchar(1660) DEFAULT NULL,
  `mdate` date DEFAULT NULL,
  `pubyear` year(4) DEFAULT NULL,
  PRIMARY KEY (`pubid`),
  KEY `publication_pubyear_index` (`pubyear`),
  KEY `publication_pubtype__fk` (`pubtype_id`),
  CONSTRAINT `publication_pubtype__fk` FOREIGN KEY (`pubtype_id`) REFERENCES `pubtype` (`pubtype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pubtype`
--

DROP TABLE IF EXISTS `pubtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `pubtype` (
  `pubtype_id` int(11) NOT NULL,
  `pubname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pubtype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-10-11 15:42:59