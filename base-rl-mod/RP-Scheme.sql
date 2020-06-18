-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: test
-- ------------------------------------------------------
-- Server version	5.5.5-10.1.21-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `group`
--

DROP TABLE IF EXISTS `group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group` (
  `GroupId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(25) NOT NULL,
  `Type` tinyint(4) NOT NULL DEFAULT '3',
  `Groupleader` int(11) NOT NULL,
  `IconStyle` tinyint(4) NOT NULL DEFAULT '1',
  `IconColor` tinyint(4) NOT NULL DEFAULT '1',
  `Info` text NOT NULL,
  `Messageotd` varchar(128) NOT NULL DEFAULT 'none',
  `StoredMoney` bigint(21) NOT NULL DEFAULT '0',
  PRIMARY KEY (`GroupId`),
  UNIQUE KEY `groupid_UNIQUE` (`GroupId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='		';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group`
--

LOCK TABLES `group` WRITE;
/*!40000 ALTER TABLE `group` DISABLE KEYS */;
INSERT INTO `group` VALUES (1,'Police',1,1,1,1,'Test','Test',50000),(2,'Mafia',1,1,1,1,'test','test',25000);
/*!40000 ALTER TABLE `group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_member`
--

DROP TABLE IF EXISTS `group_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_member` (
  `GroupId` int(11) NOT NULL,
  `Id` int(11) NOT NULL,
  `Rank` tinyint(3) NOT NULL DEFAULT '1',
  `Privatenote` varchar(32) NOT NULL DEFAULT 'none',
  `Leadernote` varchar(32) NOT NULL DEFAULT 'none',
  PRIMARY KEY (`GroupId`,`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_member`
--

LOCK TABLES `group_member` WRITE;
/*!40000 ALTER TABLE `group_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_permission`
--

DROP TABLE IF EXISTS `group_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_permission` (
  `GroupId` int(11) NOT NULL,
  `PermissionId` int(11) NOT NULL,
  PRIMARY KEY (`GroupId`,`PermissionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_permission`
--

LOCK TABLES `group_permission` WRITE;
/*!40000 ALTER TABLE `group_permission` DISABLE KEYS */;
INSERT INTO `group_permission` VALUES (1,1),(1,4),(2,2),(2,4);
/*!40000 ALTER TABLE `group_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_permission_info`
--

DROP TABLE IF EXISTS `group_permission_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_permission_info` (
  `PermissionId` int(11) NOT NULL,
  `Description` varchar(45) NOT NULL,
  PRIMARY KEY (`PermissionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_permission_info`
--

LOCK TABLES `group_permission_info` WRITE;
/*!40000 ALTER TABLE `group_permission_info` DISABLE KEYS */;
INSERT INTO `group_permission_info` VALUES (1,'Good Gang'),(2,'Evil Gang'),(3,'Neutral Gang'),(4,'Offical Faction');
/*!40000 ALTER TABLE `group_permission_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventory` (
  `Id` int(12) NOT NULL AUTO_INCREMENT,
  `owner` varchar(22) NOT NULL,
  `inventory` int(1) NOT NULL,
  `slot` tinyint(3) NOT NULL,
  `item` int(11) NOT NULL,
  `serverId` int(10) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_instance`
--

DROP TABLE IF EXISTS `item_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item_instance` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `itemId` int(11) NOT NULL,
  `owner` varchar(22) NOT NULL,
  `creator` varchar(22) NOT NULL,
  `gift` varchar(22) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT '0',
  `flags` varchar(24) NOT NULL DEFAULT '0',
  `conditionflags` varchar(24) NOT NULL DEFAULT '0',
  `durability` smallint(5) NOT NULL DEFAULT '100',
  `played` int(10) NOT NULL DEFAULT '0',
  `specialtext` varchar(255) NOT NULL DEFAULT 'none',
  PRIMARY KEY (`uid`),
  UNIQUE KEY `uid_UNIQUE` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_instance`
--

LOCK TABLES `item_instance` WRITE;
/*!40000 ALTER TABLE `item_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_template`
--

DROP TABLE IF EXISTS `item_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item_template` (
  `itementry` int(11) NOT NULL DEFAULT '0',
  `class` tinyint(3) NOT NULL DEFAULT '0',
  `subclass` int(11) NOT NULL DEFAULT '0',
  `nameDE` varchar(45) NOT NULL DEFAULT '"',
  `nameEN` varchar(45) NOT NULL DEFAULT '"',
  `displayPicture` varchar(45) NOT NULL DEFAULT 'items/barricade.png',
  `quality` tinyint(3) NOT NULL DEFAULT '0',
  `flags` varchar(24) NOT NULL DEFAULT '0',
  `conditionFlags` varchar(24) NOT NULL DEFAULT '0',
  `allowedFactions` int(11) NOT NULL DEFAULT '-1',
  `stackable` int(11) NOT NULL DEFAULT '1',
  `maxdurability` int(11) NOT NULL DEFAULT '0',
  `duration` int(11) NOT NULL DEFAULT '0',
  `specialscript` varchar(45) NOT NULL DEFAULT '"',
  `descriptionDE` text NOT NULL,
  `descriptionEN` text NOT NULL,
  PRIMARY KEY (`itementry`),
  UNIQUE KEY `itementry_UNIQUE` (`itementry`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_template`
--

LOCK TABLES `item_template` WRITE;
/*!40000 ALTER TABLE `item_template` DISABLE KEYS */;
INSERT INTO `item_template` VALUES (1,2,1337,'asd','asd','items/barricade.png',1,'1','0000000100000002',1,1,100,0,'1422','Wird verwendet um ein Hinderniss zu erschaffen.','Is used to create a obstacle'),(2,2,1459,'Biene','Bee','items/bee.png',1,'1','0',1,1,100,0,'1337','Aids','Aids'),(3,1,30,'AK-47','AK-47','items/ak-47.png',1,'1','00000001',1,0,100,0,'0','AK-47','Ak-47'),(4,3,0,'Personalausweis','Identity Card','items/barricade.png',1,'1','0',-1,0,100,0,'0','Dient zur Verifizierung ihrer Staatsbürgerschaft.','	4	3	0	Personalausweis	Identity Card	items/barricade.png	1	1	0	1	0	100	0	0	Dient zur Verifizierung ihrer Staatsbürgerschaft.	Used to varify your citizenship.	4	3	0	Personalausweis	Identity Card	items/barricade.png	1	1	0	1	0	100	0	0	Dient zur Verifizierung ihrer Staatsbürgerschaft.	Used to varify your citizenship.'),(5,3,0,'GWD-Bescheinigung','GWD-Certificate','items/barricade.png',0,'0','0',-1,1,0,0,'\"','',''),(6,1,31,'M4A1','M4A1','items/m4.png',0,'0','0',-1,1,0,0,'\"','',''),(7,2,1459,'Polizeibarrikade','Police Barricade','items/bee.png',1,'1','00000001',-1,1,100,0,'2301','Place','Place'),(8,1,31,'M4 - Police','M4 - Police','items/m4.png',1,'1','00000002',1,1,100,0,'2301','m4','m4');
/*!40000 ALTER TABLE `item_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `server_category`
--

DROP TABLE IF EXISTS `server_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `server_category` (
  `ID` int(11) NOT NULL,
  `CategoryName` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID_UNIQUE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_category`
--

LOCK TABLES `server_category` WRITE;
/*!40000 ALTER TABLE `server_category` DISABLE KEYS */;
INSERT INTO `server_category` VALUES (1,'Roleplay'),(2,'Tactics'),(3,'Work in Progress');
/*!40000 ALTER TABLE `server_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `server_last_visit`
--

DROP TABLE IF EXISTS `server_last_visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `server_last_visit` (
  `user_Id` int(11) NOT NULL,
  `ServerType` int(11) NOT NULL,
  `ServerId` int(11) NOT NULL,
  PRIMARY KEY (`user_Id`,`ServerType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_last_visit`
--

LOCK TABLES `server_last_visit` WRITE;
/*!40000 ALTER TABLE `server_last_visit` DISABLE KEYS */;
INSERT INTO `server_last_visit` VALUES (1,1,1);
/*!40000 ALTER TABLE `server_last_visit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `server_object`
--

DROP TABLE IF EXISTS `server_object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `server_object` (
  `object_id` bigint(20) NOT NULL,
  `server_id` tinyint(4) NOT NULL,
  `object_type` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`object_id`,`server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_object`
--

LOCK TABLES `server_object` WRITE;
/*!40000 ALTER TABLE `server_object` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_object` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servers`
--

DROP TABLE IF EXISTS `servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servers` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Designation` varchar(45) NOT NULL,
  `MaxPlayers` varchar(45) NOT NULL,
  `Type` tinyint(4) NOT NULL,
  `Dimension` int(11) NOT NULL,
  `Category` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Id_UNIQUE` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servers`
--

LOCK TABLES `servers` WRITE;
/*!40000 ALTER TABLE `servers` DISABLE KEYS */;
INSERT INTO `servers` VALUES (1,'Roleplay','200',1,1,1),(2,'Business','200',3,2,3),(3,'Tactics','200',2,3,2),(4,'Roleplay','200',1,4,1);
/*!40000 ALTER TABLE `servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userdata_general`
--

DROP TABLE IF EXISTS `userdata_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userdata_general` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) NOT NULL,
  `DisplayName` varchar(45) NOT NULL,
  `Password` varchar(128) NOT NULL,
  `Salt` varchar(45) NOT NULL,
  `Serial` varchar(45) NOT NULL,
  `Adminlevel` int(11) NOT NULL DEFAULT '0',
  `SubAdminlevel` int(11) NOT NULL DEFAULT '1',
  `Money` int(11) NOT NULL DEFAULT '350',
  `Playtime` int(11) NOT NULL DEFAULT '0',
  `Bonus` int(11) NOT NULL DEFAULT '0',
  `LastLogin` int(11) NOT NULL,
  `RegisterDate` int(11) NOT NULL,
  `Language` varchar(45) NOT NULL DEFAULT 'German',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Id_UNIQUE` (`Id`),
  UNIQUE KEY `Name_UNIQUE` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userdata_general`
--

LOCK TABLES `userdata_general` WRITE;
/*!40000 ALTER TABLE `userdata_general` DISABLE KEYS */;
/*!40000 ALTER TABLE `userdata_general` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userdata_rp`
--

DROP TABLE IF EXISTS `userdata_rp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userdata_rp` (
  `RP_Id` int(11) NOT NULL AUTO_INCREMENT,
  `RP_Job` int(11) NOT NULL DEFAULT '0',
  `RP_STVO` int(11) NOT NULL DEFAULT '0',
  `RP_Level` int(11) NOT NULL DEFAULT '1',
  `RP_SpawnX` float NOT NULL DEFAULT '0',
  `RP_SpawnY` float NOT NULL DEFAULT '0',
  `RP_SpawnZ` float NOT NULL DEFAULT '10',
  `RP_SpawnInt` int(11) NOT NULL DEFAULT '0',
  `RP_SpawnDim` int(11) NOT NULL DEFAULT '65000',
  `RP_CurrentX` float NOT NULL DEFAULT '0',
  `RP_CurrentY` float NOT NULL DEFAULT '0',
  `RP_CurrentZ` float NOT NULL DEFAULT '10',
  `RP_CurrentInt` int(11) NOT NULL DEFAULT '0',
  `RP_CurrentDim` int(11) NOT NULL DEFAULT '65000',
  `RP_Wanteds` int(11) NOT NULL DEFAULT '0',
  `RP_Skin` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`RP_Id`),
  UNIQUE KEY `RP_Id_UNIQUE` (`RP_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userdata_rp`
--

LOCK TABLES `userdata_rp` WRITE;
/*!40000 ALTER TABLE `userdata_rp` DISABLE KEYS */;
/*!40000 ALTER TABLE `userdata_rp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_general`
--

DROP TABLE IF EXISTS `vehicle_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vehicle_general` (
  `vehicle_id` int(11) NOT NULL,
  `model` int(11) DEFAULT NULL,
  `currentX` float DEFAULT NULL,
  `currentY` float DEFAULT NULL,
  `currentZ` float DEFAULT NULL,
  `currentRotX` float DEFAULT NULL,
  `currentRotY` float DEFAULT NULL,
  `currentRotZ` float DEFAULT NULL,
  `spawnX` float DEFAULT NULL,
  `spawnY` float DEFAULT NULL,
  `spawnZ` float DEFAULT NULL,
  `spawnRotX` float DEFAULT NULL,
  `spawnRotY` float DEFAULT NULL,
  `spawnRotZ` float DEFAULT NULL,
  `color1` varchar(20) DEFAULT NULL,
  `color2` varchar(20) DEFAULT NULL,
  `color3` varchar(20) DEFAULT NULL,
  `color4` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`vehicle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_general`
--

LOCK TABLES `vehicle_general` WRITE;
/*!40000 ALTER TABLE `vehicle_general` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_general` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-08-25 19:20:55
