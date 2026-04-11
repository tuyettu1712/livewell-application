-- MySQL dump 10.13  Distrib 8.0.41, for macos15 (arm64)
--
-- Host: localhost    Database: livewell
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Assessment_Session`
--

DROP TABLE IF EXISTS `Assessment_Session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Assessment_Session` (
  `session_id` int NOT NULL AUTO_INCREMENT,
  `user_email` varchar(255) NOT NULL,
  `started_at` datetime NOT NULL,
  `predicted_obesity_level` varchar(50) DEFAULT NULL,
  `status` enum('in-progress','completed') NOT NULL DEFAULT 'in-progress',
  `calories` decimal(8,2) DEFAULT NULL,
  `protein_g` decimal(8,2) DEFAULT NULL,
  `carbs_g` decimal(8,2) DEFAULT NULL,
  `fat_g` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `user_email` (`user_email`,`started_at`),
  KEY `predicted_obesity_level` (`predicted_obesity_level`),
  CONSTRAINT `assessment_session_ibfk_1` FOREIGN KEY (`user_email`) REFERENCES `User` (`user_email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assessment_session_ibfk_2` FOREIGN KEY (`predicted_obesity_level`) REFERENCES `Recommendation_Rule` (`obesity_level`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assessment_session_chk_1` CHECK ((`calories` >= 0)),
  CONSTRAINT `assessment_session_chk_2` CHECK ((`protein_g` >= 0)),
  CONSTRAINT `assessment_session_chk_3` CHECK ((`carbs_g` >= 0)),
  CONSTRAINT `assessment_session_chk_4` CHECK ((`fat_g` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Assessment_Session`
--

LOCK TABLES `Assessment_Session` WRITE;
/*!40000 ALTER TABLE `Assessment_Session` DISABLE KEYS */;
INSERT INTO `Assessment_Session` VALUES (6,'neha1@gmail.com','2026-04-10 09:00:00','Normal Weight','completed',1282.00,66.00,127.25,33.93),(7,'tuyet1@gmail.com','2026-04-10 11:00:00','Overweight Level I','completed',1389.60,108.75,95.46,31.82),(8,'neha1@gmail.com','2026-04-12 08:30:00','Obesity Type I','completed',1025.70,99.00,47.23,20.99),(9,'tuyet1@gmail.com','2026-04-13 02:00:00','Insufficient Weight','completed',1775.60,116.00,180.35,36.43),(10,'alex1@gmail.com','2026-04-14 10:15:00','Obesity Type II','completed',1125.19,116.80,41.12,21.93),(11,'tuyet1712@gmail.com','2026-04-10 21:09:49','Normal Weight','completed',1315.25,80.40,86.95,33.12);
/*!40000 ALTER TABLE `Assessment_Session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Consultant`
--

DROP TABLE IF EXISTS `Consultant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Consultant` (
  `consultant_email` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `description` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`consultant_email`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Consultant`
--

LOCK TABLES `Consultant` WRITE;
/*!40000 ALTER TABLE `Consultant` DISABLE KEYS */;
INSERT INTO `Consultant` VALUES ('ananya.shah@livewell.com','6175551001','Ananya','Shah','Consultant specializing in evidence-based nutrition and long-term weight management.'),('david.kim@livewell.com','6175551004','David','Kim','Consultant supporting balanced lifestyle change through holistic nutrition strategies.'),('michael.lee@livewell.com','6175551002','Michael','Lee','Consultant focused on clinical nutrition planning and metabolic health support.'),('priya.nair@livewell.com','6175551005','Priya','Nair','Consultant with interest in pediatric nutrition and family-centered wellness planning.'),('sofia.martin@livewell.com','6175551003','Sofia','Martin','Consultant experienced in sports nutrition and performance-focused meal guidance.');
/*!40000 ALTER TABLE `Consultant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Consultant_Availability`
--

DROP TABLE IF EXISTS `Consultant_Availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Consultant_Availability` (
  `consultant_email` varchar(255) NOT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `slot_date` date NOT NULL,
  `slot_time` enum('8-9','9-10','10-11','11-12','1-2','2-3','3-4') NOT NULL,
  `booking_status` enum('open','booked') NOT NULL DEFAULT 'open',
  PRIMARY KEY (`consultant_email`,`slot_date`,`slot_time`),
  KEY `user_email` (`user_email`),
  CONSTRAINT `consultant_availability_ibfk_1` FOREIGN KEY (`consultant_email`) REFERENCES `Consultant` (`consultant_email`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `consultant_availability_ibfk_2` FOREIGN KEY (`user_email`) REFERENCES `User` (`user_email`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Consultant_Availability`
--

LOCK TABLES `Consultant_Availability` WRITE;
/*!40000 ALTER TABLE `Consultant_Availability` DISABLE KEYS */;
INSERT INTO `Consultant_Availability` VALUES ('ananya.shah@livewell.com',NULL,'2026-04-09','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-09','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-09','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-10','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-10','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-10','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-13','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-13','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-13','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-14','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-14','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-14','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-15','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-15','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-15','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-16','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-16','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-16','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-17','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-17','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-17','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-20','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-20','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-20','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-21','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-21','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-21','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-22','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-22','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-22','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-23','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-23','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-23','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-24','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-24','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-24','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-27','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-27','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-27','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-28','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-28','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-28','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-29','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-29','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-29','10-11','open'),('ananya.shah@livewell.com',NULL,'2026-04-30','8-9','open'),('ananya.shah@livewell.com',NULL,'2026-04-30','9-10','open'),('ananya.shah@livewell.com',NULL,'2026-04-30','10-11','open'),('david.kim@livewell.com',NULL,'2026-04-09','8-9','open'),('david.kim@livewell.com',NULL,'2026-04-09','11-12','open'),('david.kim@livewell.com',NULL,'2026-04-09','2-3','open'),('david.kim@livewell.com',NULL,'2026-04-09','3-4','open'),('david.kim@livewell.com',NULL,'2026-04-14','8-9','open'),('david.kim@livewell.com',NULL,'2026-04-14','11-12','open'),('david.kim@livewell.com',NULL,'2026-04-14','2-3','open'),('david.kim@livewell.com',NULL,'2026-04-14','3-4','open'),('david.kim@livewell.com',NULL,'2026-04-16','8-9','open'),('david.kim@livewell.com',NULL,'2026-04-16','11-12','open'),('david.kim@livewell.com',NULL,'2026-04-16','2-3','open'),('david.kim@livewell.com',NULL,'2026-04-16','3-4','open'),('david.kim@livewell.com',NULL,'2026-04-21','8-9','open'),('david.kim@livewell.com',NULL,'2026-04-21','11-12','open'),('david.kim@livewell.com',NULL,'2026-04-21','2-3','open'),('david.kim@livewell.com',NULL,'2026-04-21','3-4','open'),('david.kim@livewell.com',NULL,'2026-04-23','8-9','open'),('david.kim@livewell.com',NULL,'2026-04-23','11-12','open'),('david.kim@livewell.com',NULL,'2026-04-23','2-3','open'),('david.kim@livewell.com',NULL,'2026-04-23','3-4','open'),('david.kim@livewell.com',NULL,'2026-04-28','8-9','open'),('david.kim@livewell.com',NULL,'2026-04-28','11-12','open'),('david.kim@livewell.com',NULL,'2026-04-28','2-3','open'),('david.kim@livewell.com',NULL,'2026-04-28','3-4','open'),('david.kim@livewell.com','tuyet1712@gmail.com','2026-04-30','8-9','booked'),('david.kim@livewell.com',NULL,'2026-04-30','11-12','open'),('david.kim@livewell.com',NULL,'2026-04-30','2-3','open'),('david.kim@livewell.com',NULL,'2026-04-30','3-4','open'),('michael.lee@livewell.com',NULL,'2026-04-09','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-09','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-09','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-10','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-10','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-10','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-13','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-13','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-13','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-14','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-14','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-14','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-15','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-15','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-15','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-16','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-16','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-16','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-17','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-17','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-17','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-20','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-20','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-20','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-21','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-21','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-21','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-22','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-22','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-22','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-23','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-23','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-23','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-24','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-24','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-24','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-27','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-27','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-27','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-28','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-28','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-28','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-29','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-29','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-29','1-2','open'),('michael.lee@livewell.com',NULL,'2026-04-30','9-10','open'),('michael.lee@livewell.com',NULL,'2026-04-30','11-12','open'),('michael.lee@livewell.com',NULL,'2026-04-30','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-09','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-09','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-09','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-09','2-3','open'),('priya.nair@livewell.com',NULL,'2026-04-13','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-13','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-13','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-13','2-3','open'),('priya.nair@livewell.com',NULL,'2026-04-14','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-14','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-14','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-14','2-3','open'),('priya.nair@livewell.com',NULL,'2026-04-15','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-15','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-15','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-15','2-3','open'),('priya.nair@livewell.com',NULL,'2026-04-16','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-16','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-16','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-16','2-3','open'),('priya.nair@livewell.com',NULL,'2026-04-20','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-20','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-20','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-20','2-3','open'),('priya.nair@livewell.com',NULL,'2026-04-21','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-21','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-21','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-21','2-3','open'),('priya.nair@livewell.com',NULL,'2026-04-22','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-22','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-22','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-22','2-3','open'),('priya.nair@livewell.com',NULL,'2026-04-23','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-23','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-23','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-23','2-3','open'),('priya.nair@livewell.com',NULL,'2026-04-27','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-27','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-27','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-27','2-3','open'),('priya.nair@livewell.com',NULL,'2026-04-28','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-28','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-28','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-28','2-3','open'),('priya.nair@livewell.com',NULL,'2026-04-29','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-29','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-29','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-29','2-3','open'),('priya.nair@livewell.com',NULL,'2026-04-30','9-10','open'),('priya.nair@livewell.com',NULL,'2026-04-30','10-11','open'),('priya.nair@livewell.com',NULL,'2026-04-30','1-2','open'),('priya.nair@livewell.com',NULL,'2026-04-30','2-3','open'),('sofia.martin@livewell.com',NULL,'2026-04-09','10-11','open'),('sofia.martin@livewell.com',NULL,'2026-04-09','1-2','open'),('sofia.martin@livewell.com',NULL,'2026-04-09','2-3','open'),('sofia.martin@livewell.com',NULL,'2026-04-10','10-11','open'),('sofia.martin@livewell.com',NULL,'2026-04-10','1-2','open'),('sofia.martin@livewell.com',NULL,'2026-04-10','2-3','open'),('sofia.martin@livewell.com',NULL,'2026-04-13','10-11','open'),('sofia.martin@livewell.com',NULL,'2026-04-13','1-2','open'),('sofia.martin@livewell.com',NULL,'2026-04-13','2-3','open'),('sofia.martin@livewell.com',NULL,'2026-04-15','10-11','open'),('sofia.martin@livewell.com',NULL,'2026-04-15','1-2','open'),('sofia.martin@livewell.com',NULL,'2026-04-15','2-3','open'),('sofia.martin@livewell.com',NULL,'2026-04-17','10-11','open'),('sofia.martin@livewell.com',NULL,'2026-04-17','1-2','open'),('sofia.martin@livewell.com',NULL,'2026-04-17','2-3','open'),('sofia.martin@livewell.com',NULL,'2026-04-20','10-11','open'),('sofia.martin@livewell.com',NULL,'2026-04-20','1-2','open'),('sofia.martin@livewell.com',NULL,'2026-04-20','2-3','open'),('sofia.martin@livewell.com',NULL,'2026-04-22','10-11','open'),('sofia.martin@livewell.com',NULL,'2026-04-22','1-2','open'),('sofia.martin@livewell.com',NULL,'2026-04-22','2-3','open'),('sofia.martin@livewell.com',NULL,'2026-04-24','10-11','open'),('sofia.martin@livewell.com',NULL,'2026-04-24','1-2','open'),('sofia.martin@livewell.com',NULL,'2026-04-24','2-3','open'),('sofia.martin@livewell.com',NULL,'2026-04-27','10-11','open'),('sofia.martin@livewell.com',NULL,'2026-04-27','1-2','open'),('sofia.martin@livewell.com',NULL,'2026-04-27','2-3','open'),('sofia.martin@livewell.com',NULL,'2026-04-29','10-11','open'),('sofia.martin@livewell.com',NULL,'2026-04-29','1-2','open'),('sofia.martin@livewell.com',NULL,'2026-04-29','2-3','open'),('sofia.martin@livewell.com',NULL,'2026-04-30','10-11','open'),('sofia.martin@livewell.com',NULL,'2026-04-30','1-2','open'),('sofia.martin@livewell.com',NULL,'2026-04-30','2-3','open');
/*!40000 ALTER TABLE `Consultant_Availability` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `t_sync_booking_status_on_insert` BEFORE INSERT ON `consultant_availability` FOR EACH ROW BEGIN
    IF NEW.user_email IS NOT NULL THEN
        SET NEW.booking_status = 'booked';
    ELSE
        SET NEW.booking_status = 'open';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `t_sync_booking_status_on_update` BEFORE UPDATE ON `consultant_availability` FOR EACH ROW BEGIN
    IF NEW.user_email IS NOT NULL THEN
        SET NEW.booking_status = 'booked';
    ELSE
        SET NEW.booking_status = 'open';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Obtains`
--

DROP TABLE IF EXISTS `Obtains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Obtains` (
  `consultant_email` varchar(255) NOT NULL,
  `specialization_name` varchar(100) NOT NULL,
  PRIMARY KEY (`consultant_email`,`specialization_name`),
  KEY `specialization_name` (`specialization_name`),
  CONSTRAINT `obtains_ibfk_1` FOREIGN KEY (`consultant_email`) REFERENCES `Consultant` (`consultant_email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `obtains_ibfk_2` FOREIGN KEY (`specialization_name`) REFERENCES `Specialization` (`specialization_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Obtains`
--

LOCK TABLES `Obtains` WRITE;
/*!40000 ALTER TABLE `Obtains` DISABLE KEYS */;
INSERT INTO `Obtains` VALUES ('ananya.shah@livewell.com','Clinical Nutrition'),('david.kim@livewell.com','Clinical Nutrition'),('michael.lee@livewell.com','Clinical Nutrition'),('priya.nair@livewell.com','Clinical Nutrition'),('david.kim@livewell.com','Holistic Nutrition'),('priya.nair@livewell.com','Pediatric Nutrition'),('sofia.martin@livewell.com','Sports Nutrition'),('ananya.shah@livewell.com','Weight Management'),('michael.lee@livewell.com','Weight Management'),('sofia.martin@livewell.com','Weight Management');
/*!40000 ALTER TABLE `Obtains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Question`
--

DROP TABLE IF EXISTS `Question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Question` (
  `question_id` int NOT NULL AUTO_INCREMENT,
  `question_text` varchar(1000) NOT NULL,
  `question_type` enum('boolean','single_choice','multiple_choice') NOT NULL,
  `is_required` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Question`
--

LOCK TABLES `Question` WRITE;
/*!40000 ALTER TABLE `Question` DISABLE KEYS */;
INSERT INTO `Question` VALUES (1,'Do you have a family history of being overweight?','boolean',1,1),(2,'Do you frequently consume high-calorie foods?','boolean',1,1),(3,'How often do you consume vegetables?','single_choice',1,1),(4,'How many main meals do you have per day?','single_choice',1,1),(5,'How often do you eat food between meals?','single_choice',1,1),(6,'How much water do you drink daily?','single_choice',1,1),(7,'Do you monitor your calorie intake?','boolean',1,1),(8,'How often do you engage in physical activity?','single_choice',1,1),(9,'How much time do you spend using technology?','single_choice',1,1),(10,'How often do you consume alcohol?','single_choice',1,1),(11,'Do you smoke?','boolean',1,1),(12,'What is your main mode of transportation?','single_choice',1,1),(13,'How would you describe your overall stress level?','single_choice',0,1),(14,'How many hours do you sleep per night?','single_choice',0,0);
/*!40000 ALTER TABLE `Question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Question_Option`
--

DROP TABLE IF EXISTS `Question_Option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Question_Option` (
  `question_id` int NOT NULL,
  `option_text` varchar(255) NOT NULL,
  `option_value` varchar(100) NOT NULL,
  `display_order` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`question_id`,`option_text`),
  CONSTRAINT `question_option_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `Question` (`question_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Question_Option`
--

LOCK TABLES `Question_Option` WRITE;
/*!40000 ALTER TABLE `Question_Option` DISABLE KEYS */;
INSERT INTO `Question_Option` VALUES (1,'No','no',2,1),(1,'Yes','yes',1,1),(2,'No','no',2,1),(2,'Yes','yes',1,1),(3,'1','1',1,1),(3,'2','2',2,1),(3,'3','3',3,1),(4,'1','1',1,1),(4,'2','2',2,1),(4,'3','3',3,1),(4,'4','4',4,1),(5,'Always','Always',4,1),(5,'Frequently','Frequently',3,1),(5,'Never','no',1,1),(5,'Sometimes','Sometimes',2,1),(6,'1','1',1,1),(6,'2','2',2,1),(6,'3','3',3,1),(7,'No','no',2,1),(7,'Yes','yes',1,1),(8,'0','0',1,1),(8,'1','1',2,1),(8,'2','2',3,1),(8,'3','3',4,1),(9,'0','0',1,1),(9,'1','1',2,1),(9,'2','2',3,1),(9,'3','3',4,1),(10,'Always','Always',4,1),(10,'Frequently','Frequently',3,1),(10,'Never','no',1,1),(10,'Sometimes','Sometimes',2,1),(11,'No','no',2,1),(11,'Yes','yes',1,1),(12,'Automobile','Automobile',1,1),(12,'Bike','Bike',2,1),(12,'Motorbike','Motorbike',3,1),(12,'Public Transportation','Public_Transportation',4,1),(12,'Walking','Walking',5,1),(13,'High','high',3,1),(13,'Low','low',1,1),(13,'Moderate','moderate',2,1),(14,'6-8 hours','6_to_8',2,1),(14,'Less than 6 hours','less_than_6',1,1),(14,'More than 8 hours','more_than_8',3,1);
/*!40000 ALTER TABLE `Question_Option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Recommendation_Rule`
--

DROP TABLE IF EXISTS `Recommendation_Rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Recommendation_Rule` (
  `obesity_level` varchar(50) NOT NULL,
  `description` varchar(2000) NOT NULL,
  `message` varchar(2000) NOT NULL,
  `calorie_adjustment_factor` decimal(5,2) NOT NULL,
  `protein_per_kg` decimal(5,2) NOT NULL,
  `carbs_ratio` decimal(5,2) NOT NULL,
  `fat_ratio` decimal(5,2) NOT NULL,
  PRIMARY KEY (`obesity_level`),
  CONSTRAINT `recommendation_rule_chk_1` CHECK ((`protein_per_kg` >= 0)),
  CONSTRAINT `recommendation_rule_chk_2` CHECK ((`carbs_ratio` >= 0)),
  CONSTRAINT `recommendation_rule_chk_3` CHECK ((`fat_ratio` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Recommendation_Rule`
--

LOCK TABLES `Recommendation_Rule` WRITE;
/*!40000 ALTER TABLE `Recommendation_Rule` DISABLE KEYS */;
INSERT INTO `Recommendation_Rule` VALUES ('Insufficient Weight','Guidance for healthy weight gain with a moderate calorie surplus and balanced nutrition.','Your result suggests you may be underweight. Focus on nourishing meals, adequate protein, and gradual healthy weight gain.',0.15,1.60,0.55,0.25),('Normal Weight','Guidance for weight maintenance with balanced calorie intake and healthy habits.','Your result suggests a healthy weight range. Maintain your current habits with balanced nutrition and regular activity.',0.00,1.20,0.50,0.30),('Obesity Type I','Guidance for sustained weight reduction with a stronger calorie deficit and lifestyle support.','Your result suggests obesity type I. A structured nutrition plan and regular lifestyle changes are recommended.',-0.20,1.80,0.30,0.30),('Obesity Type II','Guidance for significant weight reduction with careful calorie management and higher protein intake.','Your result suggests obesity type II. A more disciplined nutrition approach and professional support may be helpful.',-0.25,2.00,0.25,0.30),('Obesity Type III','Guidance for intensive weight management with close monitoring and strong nutritional support.','Your result suggests obesity type III. Please consider professional medical and nutritional guidance for safe progress.',-0.30,2.20,0.20,0.30),('Overweight Level I','Guidance for gradual fat loss with a mild calorie deficit and increased physical activity.','Your result suggests mild overweight. A small calorie deficit and regular exercise can help improve your health.',-0.10,1.50,0.40,0.30),('Overweight Level II','Guidance for moderate fat loss with structured calorie control and higher protein intake.','Your result suggests moderate overweight. Focus on portion control, protein-rich meals, and consistent activity.',-0.15,1.60,0.35,0.30);
/*!40000 ALTER TABLE `Recommendation_Rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Selects`
--

DROP TABLE IF EXISTS `Selects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Selects` (
  `session_id` int NOT NULL,
  `question_id` int NOT NULL,
  `option_text` varchar(255) NOT NULL,
  PRIMARY KEY (`session_id`,`question_id`,`option_text`),
  KEY `question_id` (`question_id`,`option_text`),
  CONSTRAINT `selects_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `Assessment_Session` (`session_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `selects_ibfk_2` FOREIGN KEY (`question_id`, `option_text`) REFERENCES `Question_Option` (`question_id`, `option_text`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Selects`
--

LOCK TABLES `Selects` WRITE;
/*!40000 ALTER TABLE `Selects` DISABLE KEYS */;
INSERT INTO `Selects` VALUES (11,1,'No'),(11,2,'No'),(11,3,'1'),(11,4,'3'),(11,5,'Sometimes'),(11,6,'2'),(11,7,'No'),(11,8,'2'),(11,9,'2'),(11,10,'Frequently'),(11,11,'No'),(11,12,'Motorbike'),(11,13,'Low');
/*!40000 ALTER TABLE `Selects` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `t_before_insert_selects` BEFORE INSERT ON `selects` FOR EACH ROW BEGIN
    DECLARE v_question_type ENUM('boolean', 'single_choice', 'multiple_choice');
    DECLARE v_question_active BOOLEAN;
    DECLARE v_option_active BOOLEAN;
    DECLARE v_existing_count INT DEFAULT 0;
    SELECT q.question_type, q.is_active, qo.is_active
    INTO v_question_type, v_question_active, v_option_active
    FROM Question_Option qo
    JOIN Question q ON q.question_id = qo.question_id
    WHERE qo.question_id = NEW.question_id
      AND qo.option_text = NEW.option_text;
    IF v_question_active IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Option not found for this question';
    END IF;
    IF v_question_active = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Question is inactive';
    END IF;
    IF v_option_active = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Selected option is inactive';
    END IF;
    IF v_question_type IN ('boolean', 'single_choice') THEN
        SELECT COUNT(*)
        INTO v_existing_count
        FROM Selects
        WHERE session_id = NEW.session_id
          AND question_id = NEW.question_id;
        IF v_existing_count > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only one option allowed for this question type';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Specialization`
--

DROP TABLE IF EXISTS `Specialization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Specialization` (
  `specialization_name` varchar(100) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`specialization_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Specialization`
--

LOCK TABLES `Specialization` WRITE;
/*!40000 ALTER TABLE `Specialization` DISABLE KEYS */;
INSERT INTO `Specialization` VALUES ('Clinical Nutrition','Provides nutrition support for medical conditions and overall metabolic health.'),('Holistic Nutrition','Emphasizes whole-food based nutrition and balanced lifestyle habits for overall wellness.'),('Pediatric Nutrition','Focuses on nutrition guidance for children and adolescents at different growth stages.'),('Sports Nutrition','Supports exercise performance, recovery, and nutrition planning for active lifestyles.'),('Weight Management','Focuses on healthy weight loss, weight gain, and long-term weight maintenance strategies.');
/*!40000 ALTER TABLE `Specialization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `user_email` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `dob` date NOT NULL,
  `height` decimal(5,2) NOT NULL,
  `weight` decimal(5,2) NOT NULL,
  PRIMARY KEY (`user_email`),
  UNIQUE KEY `phone` (`phone`),
  CONSTRAINT `user_chk_1` CHECK ((`height` > 0)),
  CONSTRAINT `user_chk_2` CHECK ((`weight` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES ('alex1@gmail.com','1234567893','Alex','Thomas','Other','2000-02-15',170.80,68.90),('max1@gmail.com','1234567892','Max','Allen','Male','2001-11-03',165.00,58.40),('neha1@gmail.com','1234567890','Neha','BK','Female','2003-05-12',160.50,55.00),('tuyet1@gmail.com','1234567891','Tuyet','Tu','Female','2002-08-20',175.20,72.50),('tuyet1712@gmail.com','6176666666','TUYET','TU','Female','1950-04-18',189.00,67.00);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `t_before_insert_user` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
    IF NEW.dob >= CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Date of birth must be before today';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'livewell'
--

--
-- Dumping routines for database 'livewell'
--
/*!50003 DROP FUNCTION IF EXISTS `calculate_age` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_age`(p_dob DATE) RETURNS int
    READS SQL DATA
BEGIN
    IF p_dob >= CURDATE() THEN
        RETURN NULL;
    END IF;
    RETURN TIMESTAMPDIFF(YEAR, p_dob, CURDATE());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calculate_bmi` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_bmi`(
    p_height_cm DECIMAL(5,2),
    p_weight_kg DECIMAL(5,2)) RETURNS decimal(6,2)
    DETERMINISTIC
BEGIN
    IF p_height_cm <= 0 OR p_weight_kg <= 0 THEN
        RETURN NULL;
    END IF;
    RETURN ROUND(p_weight_kg / POW(p_height_cm / 100, 2), 2);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calculate_calories` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_calories`(
    p_weight_kg DECIMAL(5,2),
    p_height_cm DECIMAL(5,2),
    p_dob DATE,
    p_gender VARCHAR(20),
    p_calorie_adjustment_factor DECIMAL(5,2)) RETURNS decimal(8,2)
    READS SQL DATA
BEGIN
    DECLARE v_age INT;
    DECLARE v_tdee DECIMAL(8,2);
    IF p_weight_kg <= 0 OR p_height_cm <= 0 OR p_dob >= CURDATE() THEN
        RETURN NULL;
    END IF;
    SET v_age = calculate_age(p_dob); -- using function here
    IF p_gender = 'Male' THEN
        SET v_tdee = 10 * p_weight_kg + 6.25 * p_height_cm - 5 * v_age + 5;
    ELSEIF p_gender = 'Female' THEN
        SET v_tdee = 10 * p_weight_kg + 6.25 * p_height_cm - 5 * v_age - 161;
    ELSE
        SET v_tdee = 10 * p_weight_kg + 6.25 * p_height_cm - 5 * v_age - 78;
    END IF;
    RETURN ROUND(v_tdee * (1 + p_calorie_adjustment_factor), 2);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calculate_carbs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_carbs`(
    p_calories DECIMAL(8,2),
    p_protein_g DECIMAL(8,2),
    p_fat_g DECIMAL(8,2),
    p_carbs_ratio DECIMAL(5,2)) RETURNS decimal(8,2)
    DETERMINISTIC
BEGIN
    DECLARE v_remaining DECIMAL(8,2);
    IF p_carbs_ratio < 0 THEN
        RETURN NULL;
    END IF;
    SET v_remaining = p_calories - (p_protein_g * 4) - (p_fat_g * 9);
    IF v_remaining < 0 THEN
        RETURN NULL;
    END IF;
    RETURN ROUND((v_remaining * p_carbs_ratio) / 4, 2);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calculate_fat` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_fat`(
    p_calories DECIMAL(8,2),
    p_protein_g DECIMAL(8,2),
    p_fat_ratio DECIMAL(5,2)) RETURNS decimal(8,2)
    DETERMINISTIC
BEGIN
    DECLARE v_remaining DECIMAL(8,2);
    IF p_fat_ratio < 0 THEN
        RETURN NULL;
    END IF;
    SET v_remaining = p_calories - (p_protein_g * 4);
    IF v_remaining < 0 THEN
        RETURN NULL;
    END IF;
    RETURN ROUND((v_remaining * p_fat_ratio) / 9, 2);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calculate_protein` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_protein`(
    p_weight_kg DECIMAL(5,2),
    p_protein_per_kg DECIMAL(5,2)) RETURNS decimal(8,2)
    DETERMINISTIC
BEGIN
    IF p_weight_kg <= 0 OR p_protein_per_kg < 0 THEN
        RETURN NULL;
    END IF;
    RETURN ROUND(p_weight_kg * p_protein_per_kg, 2);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `book_slot` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `book_slot`(
    IN p_user_email VARCHAR(255),
    IN p_consultant_email VARCHAR(255),
    IN p_slot_date DATE,
    IN p_slot_time VARCHAR(10))
BEGIN
    DECLARE v_status ENUM('open', 'booked');
    IF NOT EXISTS (SELECT 1 FROM User WHERE user_email = p_user_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User not found';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM Consultant WHERE consultant_email = p_consultant_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Consultant not found';
    END IF;
    START TRANSACTION;
    -- Lock row to prevent race condition
    SELECT booking_status INTO v_status
    FROM Consultant_Availability
    WHERE consultant_email = p_consultant_email
      AND slot_date = p_slot_date
      AND slot_time = p_slot_time
    FOR UPDATE;
    IF v_status IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Slot not found';
    END IF;
    IF v_status = 'booked' THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Slot is no longer available';
    END IF;
    -- Check user not already booked at same date and time with any consultant
    IF EXISTS (
        SELECT 1 FROM Consultant_Availability
        WHERE user_email = p_user_email
          AND slot_date = p_slot_date
          AND slot_time = p_slot_time
    ) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You already have a booking at this date and time';
    END IF;
    -- Check user not already booked with same consultant on same date
    IF EXISTS (
        SELECT 1 FROM Consultant_Availability
        WHERE consultant_email = p_consultant_email
          AND slot_date = p_slot_date
          AND user_email = p_user_email
    ) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You already have a booking with this consultant on this date';
    END IF;
    UPDATE Consultant_Availability
    SET user_email = p_user_email
    WHERE consultant_email = p_consultant_email
      AND slot_date = p_slot_date
      AND slot_time = p_slot_time;
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cancel_booking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cancel_booking`(
    IN p_user_email VARCHAR(255),
    IN p_consultant_email VARCHAR(255),
    IN p_slot_date DATE,
    IN p_slot_time VARCHAR(10))
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Consultant_Availability
        WHERE consultant_email = p_consultant_email
          AND slot_date = p_slot_date
          AND slot_time = p_slot_time
          AND user_email = p_user_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking not found or does not belong to this user';
    END IF;
    UPDATE Consultant_Availability
    SET user_email = NULL
    WHERE consultant_email = p_consultant_email
      AND slot_date = p_slot_date
      AND slot_time = p_slot_time;
    -- t_sync_booking_status_on_update
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_available_slots` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_available_slots`(IN p_consultant_email VARCHAR(255))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Consultant WHERE consultant_email = p_consultant_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Consultant not found';
    END IF;
    SELECT slot_date, slot_time, booking_status
    FROM Consultant_Availability
    WHERE consultant_email = p_consultant_email
      AND booking_status = 'open'
      AND slot_date >= CURDATE()
    ORDER BY slot_date, slot_time;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_user_by_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_by_email`(IN p_email VARCHAR(255))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM User WHERE user_email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User not found';
    END IF;
    SELECT
        user_email, phone, first_name, last_name, gender, dob, height, weight,
        calculate_age(dob) AS age,
        calculate_bmi(height, weight) AS bmi
    FROM User
    WHERE user_email = p_email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_user`(
    IN p_email VARCHAR(255),
    IN p_phone VARCHAR(20),
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_gender ENUM('Male', 'Female', 'Other'),
    IN p_dob DATE,
    IN p_height DECIMAL(5,2),
    IN p_weight DECIMAL(5,2))
BEGIN
    IF EXISTS (SELECT 1 FROM User WHERE user_email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already exists';
    END IF;
    IF EXISTS (SELECT 1 FROM User WHERE phone = p_phone) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Phone already exists';
    END IF;
    INSERT INTO User (user_email, phone, first_name, last_name, gender, dob, height, weight)
    VALUES (p_email, p_phone, p_first_name, p_last_name, p_gender, p_dob, p_height, p_weight);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `search_consultants_by_specialization` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_consultants_by_specialization`(
    IN p_specialization_name VARCHAR(100))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Specialization WHERE specialization_name = p_specialization_name) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specialization not found';
    END IF;
    SELECT
        c.consultant_email,
        c.first_name,
        c.last_name,
        c.description,
        GROUP_CONCAT(o.specialization_name ORDER BY o.specialization_name SEPARATOR ', ') AS specializations
    FROM Consultant c
    JOIN Obtains o ON c.consultant_email = o.consultant_email
    WHERE c.consultant_email IN (
        SELECT consultant_email FROM Obtains
        WHERE specialization_name = p_specialization_name)
    GROUP BY c.consultant_email, c.first_name, c.last_name, c.description;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_booking_history` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_booking_history`(
    IN p_user_email VARCHAR(255))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM User WHERE user_email = p_user_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User not found';
    END IF;
    SELECT
        ca.consultant_email,
        c.first_name,
        c.last_name,
        c.description,
        GROUP_CONCAT(o.specialization_name ORDER BY o.specialization_name SEPARATOR ', ') AS specializations,
        ca.slot_date,
        ca.slot_time,
        ca.booking_status
    FROM Consultant_Availability ca
    JOIN Consultant c ON c.consultant_email = ca.consultant_email
    JOIN Obtains o ON o.consultant_email = c.consultant_email
    WHERE ca.user_email = p_user_email
    GROUP BY ca.consultant_email, c.first_name, c.last_name,
             c.description, ca.slot_date, ca.slot_time, ca.booking_status
    ORDER BY ca.slot_date, ca.slot_time;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `start_assessment_session` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `start_assessment_session`(
    IN p_email VARCHAR(255),
    OUT p_session_id INT)
BEGIN
    DECLARE v_existing_session INT;
    IF NOT EXISTS (SELECT 1 FROM User WHERE user_email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User not found';
    END IF;
    -- Check if there is an existing in-progress session
    SELECT session_id INTO v_existing_session
    FROM Assessment_Session
    WHERE user_email = p_email AND status = 'In-progress'
    ORDER BY started_at DESC
    LIMIT 1;
    IF v_existing_session IS NOT NULL THEN
        -- Resume existing session
        SET p_session_id = v_existing_session;
    ELSE
        -- Create new session
        INSERT INTO Assessment_Session (user_email, started_at, status)
        VALUES (p_email, NOW(), 'In-progress');
        SET p_session_id = LAST_INSERT_ID();
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `submit_assessment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `submit_assessment`(
    IN p_session_id INT,
    IN p_predicted_obesity_level VARCHAR(50))
BEGIN
    DECLARE v_user_email VARCHAR(255);
    DECLARE v_dob DATE;
    DECLARE v_gender VARCHAR(20);
    DECLARE v_height DECIMAL(5,2);
    DECLARE v_weight DECIMAL(5,2);
    DECLARE v_calorie_adj DECIMAL(5,2);
    DECLARE v_protein_per_kg DECIMAL(5,2);
    DECLARE v_carbs_ratio DECIMAL(5,2);
    DECLARE v_fat_ratio DECIMAL(5,2);
    DECLARE v_calories DECIMAL(8,2);
    DECLARE v_protein DECIMAL(8,2);
    DECLARE v_fat DECIMAL(8,2);
    DECLARE v_carbs DECIMAL(8,2);
    DECLARE v_required_count INT;
    DECLARE v_answered_count INT;
    -- check session exists
    IF NOT EXISTS (SELECT 1 FROM Assessment_Session WHERE session_id = p_session_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Session not found';
    END IF;
    -- check not already submitted
    IF EXISTS (
        SELECT 1 FROM Assessment_Session
        WHERE session_id = p_session_id
          AND predicted_obesity_level IS NOT NULL
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Assessment result already exists for this session';
    END IF;
    -- check obesity level valid
    IF NOT EXISTS (
        SELECT 1 FROM Recommendation_Rule
        WHERE obesity_level = p_predicted_obesity_level
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unknown obesity level';
    END IF;
    -- check all required questions answered
    SELECT COUNT(*) INTO v_required_count
    FROM Question
    WHERE is_required = TRUE AND is_active = TRUE;
    SELECT COUNT(DISTINCT s.question_id) INTO v_answered_count
    FROM Selects s
    JOIN Question q ON q.question_id = s.question_id
    WHERE s.session_id = p_session_id
      AND q.is_required = TRUE
      AND q.is_active = TRUE;
    IF v_answered_count < v_required_count THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not all required questions have been answered';
    END IF;
    -- get user biometrics
    SELECT u.user_email, u.dob, u.gender, u.height, u.weight
    INTO v_user_email, v_dob, v_gender, v_height, v_weight
    FROM Assessment_Session a
    JOIN User u ON u.user_email = a.user_email
    WHERE a.session_id = p_session_id;
    -- get recommendation rule factors
    SELECT calorie_adjustment_factor, protein_per_kg, carbs_ratio, fat_ratio
    INTO v_calorie_adj, v_protein_per_kg, v_carbs_ratio, v_fat_ratio
    FROM Recommendation_Rule
    WHERE obesity_level = p_predicted_obesity_level;
    -- compute nutrition plan using UDFs
    SET v_calories = calculate_calories(v_weight, v_height, v_dob, v_gender, v_calorie_adj);
    SET v_protein  = calculate_protein(v_weight, v_protein_per_kg);
    SET v_fat      = calculate_fat(v_calories, v_protein, v_fat_ratio);
    SET v_carbs    = calculate_carbs(v_calories, v_protein, v_fat, v_carbs_ratio);
    -- update session with result
    UPDATE Assessment_Session
    SET predicted_obesity_level = p_predicted_obesity_level,
        status = 'completed',
        calories = v_calories,
        protein_g = v_protein,
        carbs_g = v_carbs,
        fat_g = v_fat
    WHERE session_id = p_session_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `submit_response` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `submit_response`(
    IN p_session_id INT,
    IN p_question_id INT,
    IN p_option_text VARCHAR(255))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Assessment_Session WHERE session_id = p_session_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Session not found';
    END IF;
    IF NOT EXISTS (
        SELECT 1 FROM Question_Option qo
        JOIN Question q ON q.question_id = qo.question_id
        WHERE qo.question_id = p_question_id
          AND qo.option_text = p_option_text
          AND q.is_active = TRUE
          AND qo.is_active = TRUE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Option not found or belongs to inactive question';
    END IF;
    -- trigger t_before_insert_selects handles duplicate + single_choice enforcement
    INSERT INTO Selects (session_id, question_id, option_text)
    VALUES (p_session_id, p_question_id, p_option_text);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_booking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_booking`(
    IN p_user_email VARCHAR(255),
    IN p_old_consultant_email VARCHAR(255),
    IN p_old_slot_date DATE,
    IN p_old_slot_time VARCHAR(10),
    IN p_new_consultant_email VARCHAR(255),
    IN p_new_slot_date DATE,
    IN p_new_slot_time VARCHAR(10))
BEGIN
    DECLARE v_new_status ENUM('open', 'booked');
    -- check old booking exists and belongs to user
    IF NOT EXISTS (
        SELECT 1 FROM Consultant_Availability
        WHERE consultant_email = p_old_consultant_email
          AND slot_date = p_old_slot_date
          AND slot_time = p_old_slot_time
          AND user_email = p_user_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Original booking not found or does not belong to this user';
    END IF;
    START TRANSACTION;
    -- lock new slot
    SELECT booking_status INTO v_new_status
    FROM Consultant_Availability
    WHERE consultant_email = p_new_consultant_email
      AND slot_date = p_new_slot_date
      AND slot_time = p_new_slot_time
    FOR UPDATE;
    IF v_new_status IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'New slot not found';
    END IF;
    IF v_new_status = 'booked' THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'New slot is not available';
    END IF;
    IF EXISTS (
        SELECT 1 FROM Consultant_Availability
        WHERE user_email = p_user_email
          AND slot_date = p_new_slot_date
          AND slot_time = p_new_slot_time
          AND NOT (consultant_email = p_old_consultant_email
              AND slot_date = p_old_slot_date
              AND slot_time = p_old_slot_time)) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User already has a booking at the new date and time';
    END IF;
    -- release old slot
    UPDATE Consultant_Availability
    SET user_email = NULL
    WHERE consultant_email = p_old_consultant_email
      AND slot_date = p_old_slot_date
      AND slot_time = p_old_slot_time;
    -- book new slot
    UPDATE Consultant_Availability
    SET user_email = p_user_email
    WHERE consultant_email = p_new_consultant_email
      AND slot_date = p_new_slot_date
      AND slot_time = p_new_slot_time;
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-10 21:13:41
