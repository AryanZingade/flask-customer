-- MySQL dump 10.13  Distrib 9.1.0, for macos14.7 (arm64)
--
-- Host: localhost    Database: hotel
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `F_Name` varchar(255) DEFAULT NULL,
  `L_Name` varchar(255) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (101,'Jane','Doe','1992-05-23'),(102,'David','Smith','1985-11-11'),(103,'Sarah','Johnson','1996-07-06'),(104,'Robert','Garcia','1988-03-15'),(105,'Emily','Kim','1999-09-12'),(106,'Michael','Lee','1991-02-28'),(107,'Catherine','Wong','1993-08-22'),(108,'Daniel','Taylor','1987-12-31'),(109,'Amanda','Nguyen','1994-06-14'),(110,'Matthew','Gonzalez','1989-10-09'),(111,'Samantha','Chen','1997-04-03'),(112,'Andrew','Jackson','1995-08-17'),(113,'Stephanie','Kim','1998-12-20'),(114,'Nicholas','Lee','1992-02-06'),(115,'Linda','Wang','1986-06-30'),(116,'Anthony','Rivera','1993-11-25'),(117,'Jennifer','Nguyen','1984-07-21'),(118,'Jane','Smith','1985-02-15'),(119,'Michelle','Kwok','1999-01-05'),(120,'Gordon','Ramsay','1994-02-02'),(121,'John','Doe','1990-01-01');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `E_ID` varchar(255) NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Role` varchar(255) DEFAULT NULL,
  `Mobile` int DEFAULT NULL,
  PRIMARY KEY (`E_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES ('A101','John Smith','Front Desk Receptionist',1234567),('B102','Jane Doe','Housekeeping Supervisor',2345678),('C103','David Lee','Concierge',3456789),('D104','Sarah Johnson','Marketing Manager',4567890),('E105','Robert Brown','Chef',5678901),('F106','Mary Wilson','Bartender',9098078),('G107','William Chen','Waiter',7890123),('H108','Lisa Wong','Security Officer',8901234),('I109','Mike Davis','Event Coordinator',9012345),('J110','Karen Kim','Housekeeping Staff',1234567);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotel`
--

DROP TABLE IF EXISTS `hotel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel` (
  `Name` varchar(255) DEFAULT NULL,
  `H_ID` int NOT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Mobile` int DEFAULT NULL,
  `Dept_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`H_ID`),
  KEY `Dept_ID` (`Dept_ID`),
  CONSTRAINT `hotel_ibfk_1` FOREIGN KEY (`Dept_ID`) REFERENCES `employee` (`E_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel`
--

LOCK TABLES `hotel` WRITE;
/*!40000 ALTER TABLE `hotel` DISABLE KEYS */;
INSERT INTO `hotel` VALUES ('Hotel Highside',8,'Mountainview USA',5559898,'I109'),('Hotel Bravo',22,'ShelbyvillE USA',5555678,'E105'),('Hotel Alpha',31,'Springfield USA',5551234,'B102'),('Hotel Echo',35,'Oceanview USA',5553434,'G107'),('Hotel Delta',64,'Smallville USA',5551212,'F106'),('Hotel Foxtrot',76,'Hillside USA',5555656,'A101'),('Hotel Golf',97,'Riverside USA',5557878,'C103'),('Hotel Charlie',113,'Capital City USA',5559101,'J110'),('Hotel Juliet',141,'Sunrise USA',5554545,'D104'),('Hotel Insight',219,'Lakeside USA',5552323,'H108');
/*!40000 ALTER TABLE `hotel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `P_ID` varchar(255) NOT NULL,
  `Date` date DEFAULT NULL,
  `Method` varchar(255) DEFAULT NULL,
  `Amount` int DEFAULT NULL,
  `P_Number` int DEFAULT NULL,
  PRIMARY KEY (`P_ID`),
  KEY `P_Number` (`P_Number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES ('PY11','2022-12-20','CARD',50,119),('PY12','2023-01-04','CARD',50,101),('PY13','2023-01-09','CASH',50,102),('PY14','2023-02-10','CARD',65,100),('PY15','2023-02-01','CASH',80,103),('PY16','2022-11-11','CASH',45,104),('PY17','2022-11-12','CASH',45,105),('PY18','2023-01-31','CHEQUE',50,106),('PY19','2023-01-15','CHEQUE',80,107),('PY20','2023-02-19','CARD',60,108),('PY21','2023-02-23','CARD',60,109),('PY22','2022-12-25','CARD',100,110),('PY23','2022-12-30','CARD',120,111),('PY24','2023-03-14','CASH',115,112),('PY25','2023-03-10','CASH',130,113),('PY26','2023-02-21','CHEQUE',130,114),('PY27','2023-03-03','CHEQUE',150,115),('PY28','2023-03-08','CARD',150,116),('PY29','2022-11-18','CARD',170,117),('PY30','2022-12-19','CHEQUE',170,118);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `R_ID` int NOT NULL,
  `Type` varchar(255) DEFAULT NULL,
  `Price` int DEFAULT NULL,
  `Bedrooms` int DEFAULT NULL,
  `Terrace` varchar(5) DEFAULT NULL,
  `Number` int DEFAULT NULL,
  `H_Number` int DEFAULT NULL,
  PRIMARY KEY (`R_ID`),
  KEY `Number` (`Number`),
  KEY `H_Number` (`H_Number`),
  CONSTRAINT `rooms_ibfk_2` FOREIGN KEY (`H_Number`) REFERENCES `hotel` (`H_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (3001,'Standard',50,1,'NO',119,22),(3002,'Standard',50,1,'NO',101,31),(3003,'Standard',50,1,'NO',102,219),(3004,'Standard',65,2,'NO',100,8),(3005,'Standard',80,2,'YES',103,8),(3006,'Joint',45,2,'NO',104,22),(3007,'Joint',45,2,'NO',105,31),(3008,'Joint',50,1,'YES',106,35),(3009,'Standard',80,2,'YES',107,35),(3010,'Joint',60,2,'YES',108,64),(3011,'Joint',60,2,'YES',109,76),(3012,'Deluxe',100,2,'NO',110,97),(3013,'Deluxe',120,3,'NO',111,113),(3014,'Deluxe',115,2,'YES',112,141),(3015,'Deluxe',130,3,'YES',113,219),(3016,'Deluxe',130,3,'YES',114,64),(3017,'Suite',150,2,'YES',115,76),(3018,'Suite',150,2,'YES',116,97),(3019,'Suite',170,3,'YES',117,113),(3020,'Suite',170,3,'YES',118,141);
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-02 16:17:56
