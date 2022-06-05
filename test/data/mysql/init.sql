--- MariaDB dump 10.19  Distrib 10.6.8-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: openvisu
-- ------------------------------------------------------
-- Server version	10.6.8-MariaDB-1:10.6.8+maria~focal

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_assignment`
--

DROP TABLE IF EXISTS `auth_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_assignment` (
  `item_name` varchar(64) COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_id` varchar(64) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`item_name`,`user_id`),
  KEY `idx-auth_assignment-user_id` (`user_id`),
  CONSTRAINT `auth_assignment_ibfk_1` FOREIGN KEY (`item_name`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_assignment`
--

LOCK TABLES `auth_assignment` WRITE;
/*!40000 ALTER TABLE `auth_assignment` DISABLE KEYS */;
INSERT INTO `auth_assignment` VALUES ('administrator','1',1654461602);
/*!40000 ALTER TABLE `auth_assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_item`
--

DROP TABLE IF EXISTS `auth_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_item` (
  `name` varchar(64) COLLATE utf8mb3_unicode_ci NOT NULL,
  `type` smallint(6) NOT NULL,
  `description` text COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rule_name` varchar(64) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `data` blob DEFAULT NULL,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `id` int(11) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `rule_name` (`rule_name`),
  KEY `idx-auth_item-type` (`type`),
  CONSTRAINT `auth_item_ibfk_1` FOREIGN KEY (`rule_name`) REFERENCES `auth_rule` (`name`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_item`
--

LOCK TABLES `auth_item` WRITE;
/*!40000 ALTER TABLE `auth_item` DISABLE KEYS */;
INSERT INTO `auth_item` VALUES ('administrator',1,'Administrator',NULL,NULL,1654461602,1654461602,NULL),('create:all:chart-page',2,'Can create any chart-page',NULL,NULL,1654461572,1654461572,3),('create:all:dashboard',2,'Can create any dashboard',NULL,NULL,1654461572,1654461572,11),('create:all:i-frame',2,'Can create any i-frame',NULL,NULL,1654461573,1654461573,100),('create:all:iframe-page',2,'Can create any iframe-page',NULL,NULL,1654461572,1654461572,19),('create:all:image-page',2,'Can create any image-page',NULL,NULL,1654461572,1654461572,27),('create:all:library-entry',2,'Can create any library-entry',NULL,NULL,1654461572,1654461572,91),('create:all:node',2,'Can create any node',NULL,NULL,1654461572,1654461572,67),('create:all:page',2,'Can create any page',NULL,NULL,1654461572,1654461572,35),('create:all:server',2,'Can create any server',NULL,NULL,1654461572,1654461572,75),('create:all:single-value-page',2,'Can create any single-value-page',NULL,NULL,1654461572,1654461572,43),('create:all:text-page',2,'Can create any text-page',NULL,NULL,1654461572,1654461572,51),('create:all:time-serial',2,'Can create any time-serial',NULL,NULL,1654461572,1654461572,83),('create:own:chart-page',2,'Can create own chart-page','isCreator',NULL,1654461572,1654461572,4),('create:own:dashboard',2,'Can create own dashboard','isCreator',NULL,1654461572,1654461572,12),('create:own:i-frame',2,'Can create own i-frame','isCreator',NULL,1654461573,1654461573,101),('create:own:iframe-page',2,'Can create own iframe-page','isCreator',NULL,1654461572,1654461572,20),('create:own:image-page',2,'Can create own image-page','isCreator',NULL,1654461572,1654461572,28),('create:own:library-entry',2,'Can create own library-entry','isCreator',NULL,1654461572,1654461572,92),('create:own:node',2,'Can create own node','isCreator',NULL,1654461572,1654461572,68),('create:own:page',2,'Can create own page','isCreator',NULL,1654461572,1654461572,36),('create:own:server',2,'Can create own server','isCreator',NULL,1654461572,1654461572,76),('create:own:single-value-page',2,'Can create own single-value-page','isCreator',NULL,1654461572,1654461572,44),('create:own:text-page',2,'Can create own text-page','isCreator',NULL,1654461572,1654461572,52),('create:own:time-serial',2,'Can create own time-serial','isCreator',NULL,1654461572,1654461572,84),('delete:all:chart-page',2,'Can delete any chart-page',NULL,NULL,1654461572,1654461572,7),('delete:all:dashboard',2,'Can delete any dashboard',NULL,NULL,1654461572,1654461572,15),('delete:all:i-frame',2,'Can delete any i-frame',NULL,NULL,1654461573,1654461573,104),('delete:all:iframe-page',2,'Can delete any iframe-page',NULL,NULL,1654461572,1654461572,23),('delete:all:image-page',2,'Can delete any image-page',NULL,NULL,1654461572,1654461572,31),('delete:all:library-entry',2,'Can delete any library-entry',NULL,NULL,1654461572,1654461572,95),('delete:all:node',2,'Can delete any node',NULL,NULL,1654461572,1654461572,71),('delete:all:page',2,'Can delete any page',NULL,NULL,1654461572,1654461572,39),('delete:all:server',2,'Can delete any server',NULL,NULL,1654461572,1654461572,79),('delete:all:single-value-page',2,'Can delete any single-value-page',NULL,NULL,1654461572,1654461572,47),('delete:all:text-page',2,'Can delete any text-page',NULL,NULL,1654461572,1654461572,55),('delete:all:time-serial',2,'Can delete any time-serial',NULL,NULL,1654461572,1654461572,87),('delete:own:chart-page',2,'Can delete own chart-page','isCreator',NULL,1654461572,1654461572,8),('delete:own:dashboard',2,'Can delete own dashboard','isCreator',NULL,1654461572,1654461572,16),('delete:own:i-frame',2,'Can delete own i-frame','isCreator',NULL,1654461573,1654461573,105),('delete:own:iframe-page',2,'Can delete own iframe-page','isCreator',NULL,1654461572,1654461572,24),('delete:own:image-page',2,'Can delete own image-page','isCreator',NULL,1654461572,1654461572,32),('delete:own:library-entry',2,'Can delete own library-entry','isCreator',NULL,1654461572,1654461572,96),('delete:own:node',2,'Can delete own node','isCreator',NULL,1654461572,1654461572,72),('delete:own:page',2,'Can delete own page','isCreator',NULL,1654461572,1654461572,40),('delete:own:server',2,'Can delete own server','isCreator',NULL,1654461572,1654461572,80),('delete:own:single-value-page',2,'Can delete own single-value-page','isCreator',NULL,1654461572,1654461572,48),('delete:own:text-page',2,'Can delete own text-page','isCreator',NULL,1654461572,1654461572,56),('delete:own:time-serial',2,'Can delete own time-serial','isCreator',NULL,1654461572,1654461572,88),('public',1,'Unauthenticated User',NULL,NULL,1654461572,1654461572,97),('update:all:chart-page',2,'Can update any chart-page',NULL,NULL,1654461572,1654461572,5),('update:all:dashboard',2,'Can update any dashboard',NULL,NULL,1654461572,1654461572,13),('update:all:i-frame',2,'Can update any i-frame',NULL,NULL,1654461573,1654461573,102),('update:all:iframe-page',2,'Can update any iframe-page',NULL,NULL,1654461572,1654461572,21),('update:all:image-page',2,'Can update any image-page',NULL,NULL,1654461572,1654461572,29),('update:all:library-entry',2,'Can update any library-entry',NULL,NULL,1654461572,1654461572,93),('update:all:node',2,'Can update any node',NULL,NULL,1654461572,1654461572,69),('update:all:page',2,'Can update any page',NULL,NULL,1654461572,1654461572,37),('update:all:server',2,'Can update any server',NULL,NULL,1654461572,1654461572,77),('update:all:single-value-page',2,'Can update any single-value-page',NULL,NULL,1654461572,1654461572,45),('update:all:text-page',2,'Can update any text-page',NULL,NULL,1654461572,1654461572,53),('update:all:time-serial',2,'Can update any time-serial',NULL,NULL,1654461572,1654461572,85),('update:own:chart-page',2,'Can update own chart-page','isCreator',NULL,1654461572,1654461572,6),('update:own:dashboard',2,'Can update own dashboard','isCreator',NULL,1654461572,1654461572,14),('update:own:i-frame',2,'Can update own i-frame','isCreator',NULL,1654461573,1654461573,103),('update:own:iframe-page',2,'Can update own iframe-page','isCreator',NULL,1654461572,1654461572,22),('update:own:image-page',2,'Can update own image-page','isCreator',NULL,1654461572,1654461572,30),('update:own:library-entry',2,'Can update own library-entry','isCreator',NULL,1654461572,1654461572,94),('update:own:node',2,'Can update own node','isCreator',NULL,1654461572,1654461572,70),('update:own:page',2,'Can update own page','isCreator',NULL,1654461572,1654461572,38),('update:own:server',2,'Can update own server','isCreator',NULL,1654461572,1654461572,78),('update:own:single-value-page',2,'Can update own single-value-page','isCreator',NULL,1654461572,1654461572,46),('update:own:text-page',2,'Can update own text-page','isCreator',NULL,1654461572,1654461572,54),('update:own:time-serial',2,'Can update own time-serial','isCreator',NULL,1654461572,1654461572,86),('user-management',2,'User Management',NULL,NULL,1654461602,1654461602,NULL),('view:all:chart-page',2,'Can view any chart-page',NULL,NULL,1654461572,1654461572,1),('view:all:dashboard',2,'Can view any dashboard',NULL,NULL,1654461572,1654461572,9),('view:all:i-frame',2,'Can view any i-frame',NULL,NULL,1654461573,1654461573,98),('view:all:iframe-page',2,'Can view any iframe-page',NULL,NULL,1654461572,1654461572,17),('view:all:image-page',2,'Can view any image-page',NULL,NULL,1654461572,1654461572,25),('view:all:library-entry',2,'Can view any library-entry',NULL,NULL,1654461572,1654461572,89),('view:all:node',2,'Can view any node',NULL,NULL,1654461572,1654461572,65),('view:all:page',2,'Can view any page',NULL,NULL,1654461572,1654461572,33),('view:all:server',2,'Can view any server',NULL,NULL,1654461572,1654461572,73),('view:all:single-value-page',2,'Can view any single-value-page',NULL,NULL,1654461572,1654461572,41),('view:all:text-page',2,'Can view any text-page',NULL,NULL,1654461572,1654461572,49),('view:all:time-serial',2,'Can view any time-serial',NULL,NULL,1654461572,1654461572,81),('view:own:chart-page',2,'Can view own chart-page','isCreator',NULL,1654461572,1654461572,2),('view:own:dashboard',2,'Can view own dashboard','isCreator',NULL,1654461572,1654461572,10),('view:own:i-frame',2,'Can view own i-frame','isCreator',NULL,1654461573,1654461573,99),('view:own:iframe-page',2,'Can view own iframe-page','isCreator',NULL,1654461572,1654461572,18),('view:own:image-page',2,'Can view own image-page','isCreator',NULL,1654461572,1654461572,26),('view:own:library-entry',2,'Can view own library-entry','isCreator',NULL,1654461572,1654461572,90),('view:own:node',2,'Can view own node','isCreator',NULL,1654461572,1654461572,66),('view:own:page',2,'Can view own page','isCreator',NULL,1654461572,1654461572,34),('view:own:server',2,'Can view own server','isCreator',NULL,1654461572,1654461572,74),('view:own:single-value-page',2,'Can view own single-value-page','isCreator',NULL,1654461572,1654461572,42),('view:own:text-page',2,'Can view own text-page','isCreator',NULL,1654461572,1654461572,50),('view:own:time-serial',2,'Can view own time-serial','isCreator',NULL,1654461572,1654461572,82);
/*!40000 ALTER TABLE `auth_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_item_child`
--

DROP TABLE IF EXISTS `auth_item_child`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_item_child` (
  `parent` varchar(64) COLLATE utf8mb3_unicode_ci NOT NULL,
  `child` varchar(64) COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`parent`,`child`),
  KEY `child` (`child`),
  CONSTRAINT `auth_item_child_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `auth_item_child_ibfk_2` FOREIGN KEY (`child`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_item_child`
--

LOCK TABLES `auth_item_child` WRITE;
/*!40000 ALTER TABLE `auth_item_child` DISABLE KEYS */;
INSERT INTO `auth_item_child` VALUES ('administrator','user-management'),('create:own:chart-page','create:all:chart-page'),('create:own:dashboard','create:all:dashboard'),('create:own:i-frame','create:all:i-frame'),('create:own:iframe-page','create:all:iframe-page'),('create:own:image-page','create:all:image-page'),('create:own:library-entry','create:all:library-entry'),('create:own:node','create:all:node'),('create:own:page','create:all:page'),('create:own:server','create:all:server'),('create:own:single-value-page','create:all:single-value-page'),('create:own:text-page','create:all:text-page'),('create:own:time-serial','create:all:time-serial'),('delete:own:chart-page','delete:all:chart-page'),('delete:own:dashboard','delete:all:dashboard'),('delete:own:i-frame','delete:all:i-frame'),('delete:own:iframe-page','delete:all:iframe-page'),('delete:own:image-page','delete:all:image-page'),('delete:own:library-entry','delete:all:library-entry'),('delete:own:node','delete:all:node'),('delete:own:page','delete:all:page'),('delete:own:server','delete:all:server'),('delete:own:single-value-page','delete:all:single-value-page'),('delete:own:text-page','delete:all:text-page'),('delete:own:time-serial','delete:all:time-serial'),('update:own:chart-page','update:all:chart-page'),('update:own:dashboard','update:all:dashboard'),('update:own:i-frame','update:all:i-frame'),('update:own:iframe-page','update:all:iframe-page'),('update:own:image-page','update:all:image-page'),('update:own:library-entry','update:all:library-entry'),('update:own:node','update:all:node'),('update:own:page','update:all:page'),('update:own:server','update:all:server'),('update:own:single-value-page','update:all:single-value-page'),('update:own:text-page','update:all:text-page'),('update:own:time-serial','update:all:time-serial'),('view:own:chart-page','view:all:chart-page'),('view:own:dashboard','view:all:dashboard'),('view:own:i-frame','view:all:i-frame'),('view:own:iframe-page','view:all:iframe-page'),('view:own:image-page','view:all:image-page'),('view:own:library-entry','view:all:library-entry'),('view:own:node','view:all:node'),('view:own:page','view:all:page'),('view:own:server','view:all:server'),('view:own:single-value-page','view:all:single-value-page'),('view:own:text-page','view:all:text-page'),('view:own:time-serial','view:all:time-serial');
/*!40000 ALTER TABLE `auth_item_child` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_rule`
--

DROP TABLE IF EXISTS `auth_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_rule` (
  `name` varchar(64) COLLATE utf8mb3_unicode_ci NOT NULL,
  `data` blob DEFAULT NULL,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_rule`
--

LOCK TABLES `auth_rule` WRITE;
/*!40000 ALTER TABLE `auth_rule` DISABLE KEYS */;
INSERT INTO `auth_rule` VALUES ('isCreator','O:21:\"app\\rules\\CreatorRule\":3:{s:4:\"name\";s:9:\"isCreator\";s:9:\"createdAt\";i:1654461572;s:9:\"updatedAt\";i:1654461572;}',1654461572,1654461572);
/*!40000 ALTER TABLE `auth_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_token`
--

DROP TABLE IF EXISTS `auth_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `expires_at` int(11) DEFAULT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-auth_token-user_id` (`user_id`),
  CONSTRAINT `fk-auth_token-user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_token`
--

LOCK TABLES `auth_token` WRITE;
/*!40000 ALTER TABLE `auth_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chart_page`
--

DROP TABLE IF EXISTS `chart_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chart_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `chart_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'line',
  `interval` int(11) NOT NULL DEFAULT 3600,
  PRIMARY KEY (`id`),
  KEY `idx-chart-created_by` (`created_by`),
  KEY `idx-chart-updated_by` (`updated_by`),
  CONSTRAINT `fk-chart-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-chart-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chart_page`
--

LOCK TABLES `chart_page` WRITE;
/*!40000 ALTER TABLE `chart_page` DISABLE KEYS */;
/*!40000 ALTER TABLE `chart_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dashboard`
--

DROP TABLE IF EXISTS `dashboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dashboard` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `sort` int(11) DEFAULT 0,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-dashboard-created_by` (`created_by`),
  KEY `idx-dashboard-updated_by` (`updated_by`),
  CONSTRAINT `fk-dashboard-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-dashboard-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dashboard`
--

LOCK TABLES `dashboard` WRITE;
/*!40000 ALTER TABLE `dashboard` DISABLE KEYS */;
INSERT INTO `dashboard` VALUES (1,1654461609,1654461609,1,1,1,'Dashboard 1');
/*!40000 ALTER TABLE `dashboard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delete_history`
--

DROP TABLE IF EXISTS `delete_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delete_history` (
  `id` int(11) DEFAULT NULL,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  KEY `idx-delete_history-created_by` (`created_by`),
  KEY `idx-delete_history-updated_by` (`updated_by`),
  CONSTRAINT `fk-delete_history-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-delete_history-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delete_history`
--

LOCK TABLES `delete_history` WRITE;
/*!40000 ALTER TABLE `delete_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `delete_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file`
--

DROP TABLE IF EXISTS `file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `related_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `extension` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-file-created_by` (`created_by`),
  KEY `idx-file-updated_by` (`updated_by`),
  CONSTRAINT `fk-file-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-file-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file`
--

LOCK TABLES `file` WRITE;
/*!40000 ALTER TABLE `file` DISABLE KEYS */;
/*!40000 ALTER TABLE `file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `i_frame`
--

DROP TABLE IF EXISTS `i_frame`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `i_frame` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-i_frame-created_by` (`created_by`),
  KEY `idx-i_frame-updated_by` (`updated_by`),
  CONSTRAINT `fk-i_frame-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-i_frame-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `i_frame`
--

LOCK TABLES `i_frame` WRITE;
/*!40000 ALTER TABLE `i_frame` DISABLE KEYS */;
/*!40000 ALTER TABLE `i_frame` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iframe_page`
--

DROP TABLE IF EXISTS `iframe_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iframe_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `src` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-iframe_page-created_by` (`created_by`),
  KEY `idx-iframe_page-updated_by` (`updated_by`),
  CONSTRAINT `fk-iframe_page-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-iframe_page-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iframe_page`
--

LOCK TABLES `iframe_page` WRITE;
/*!40000 ALTER TABLE `iframe_page` DISABLE KEYS */;
/*!40000 ALTER TABLE `iframe_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image_page`
--

DROP TABLE IF EXISTS `image_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `image_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-image_page-created_by` (`created_by`),
  KEY `idx-image_page-updated_by` (`updated_by`),
  CONSTRAINT `fk-image_page-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-image_page-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image_page`
--

LOCK TABLES `image_page` WRITE;
/*!40000 ALTER TABLE `image_page` DISABLE KEYS */;
/*!40000 ALTER TABLE `image_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `library_entry`
--

DROP TABLE IF EXISTS `library_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `library_entry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `sort` int(11) DEFAULT 0,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-library_entry-created_by` (`created_by`),
  KEY `idx-library_entry-updated_by` (`updated_by`),
  CONSTRAINT `fk-library_entry-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-library_entry-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library_entry`
--

LOCK TABLES `library_entry` WRITE;
/*!40000 ALTER TABLE `library_entry` DISABLE KEYS */;
/*!40000 ALTER TABLE `library_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migration`
--

DROP TABLE IF EXISTS `migration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migration` (
  `version` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apply_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migration`
--

LOCK TABLES `migration` WRITE;
/*!40000 ALTER TABLE `migration` DISABLE KEYS */;
INSERT INTO `migration` VALUES ('Da\\User\\Migration\\m000000_000001_create_user_table',1654461568),('Da\\User\\Migration\\m000000_000002_create_profile_table',1654461568),('Da\\User\\Migration\\m000000_000003_create_social_account_table',1654461568),('Da\\User\\Migration\\m000000_000004_create_token_table',1654461568),('Da\\User\\Migration\\m000000_000005_add_last_login_at',1654461568),('Da\\User\\Migration\\m000000_000006_add_two_factor_fields',1654461568),('Da\\User\\Migration\\m000000_000007_enable_password_expiration',1654461568),('Da\\User\\Migration\\m000000_000008_add_last_login_ip',1654461568),('Da\\User\\Migration\\m000000_000009_add_gdpr_consent_fields',1654461568),('m000000_000000_base',1654461567),('m140506_102106_rbac_init',1654461568),('m170907_052038_rbac_add_index_on_auth_assignment_user_id',1654461568),('m180523_151638_rbac_updates_indexes_without_prefix',1654461568),('m200409_110543_rbac_update_mssql_trigger',1654461568),('m210521_122950_create_file_table',1654461569),('m210706_181611_create_chart_page_table',1654461569),('m210706_181646_create_dashboard_table',1654461569),('m210706_181700_create_iframe_page_table',1654461569),('m210706_181742_create_image_page_table',1654461569),('m210706_181804_create_text_page_table',1654461569),('m210706_181944_create_page_table',1654461570),('m210707_080310_create_library_entry_table',1654461570),('m210707_080324_create_server_table',1654461570),('m210707_080336_create_endpoint_table',1654461570),('m210707_080348_create_node_table',1654461571),('m210707_080357_create_time_serial_table',1654461571),('m210707_080554_create_single_value_page_table',1654461571),('m210712_120322_create_auth_token_table',1654461572),('m210719_121552_create_delete_history_table',1654461572),('m210727_085221_create_settings_table',1654461572),('m210727_102722_seed_settings_table_with_file_sizes_table',1654461572),('m210728_140617_add_id_to_auth_item_name',1654461572),('m210730_154431_seed_auth_item_table',1654461572),('m210731_114003_seed_public_role_to_auth_item_table',1654461572),('m210803_135556_add_profile_collumns_to_user_table',1654461573),('m210812_085410_create_i_frame_table',1654461573),('m210812_133747_seed_iframe_permissions',1654461573),('m210812_133808_remove_webvisu_collumn_from_server_table',1654461573),('m210914_065725_add_root_node_column_to_server_table',1654461573),('m210917_153529_add_virtual_field_to_node_table',1654461573),('m210919_165517_delete_endpoint_table',1654461573),('m211201_132851_create_project_table',1654461573),('m220308_124041_add_style_type_and_style_configuration_columns_to_single_value_page_table',1654461574),('m220525_055814_add_min_value_and_max_value_columns_to_time_serial_table',1654461574),('m220526_105211_add_alert_column_to_time_serial_table',1654461574),('m220526_145911_add_value_change_columns_to_node_table',1654461574);
/*!40000 ALTER TABLE `migration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node`
--

DROP TABLE IF EXISTS `node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `server_id` int(11) NOT NULL,
  `identifier` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `checked_at` int(11) DEFAULT 0,
  `tracked` tinyint(1) DEFAULT 0,
  `path` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `readable` tinyint(1) DEFAULT NULL,
  `writable` tinyint(1) DEFAULT NULL,
  `virtual` tinyint(1) DEFAULT 0,
  `parent_identifier` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `change_value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `change_error_at` int(11) DEFAULT NULL,
  `change_error` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-node-created_by` (`created_by`),
  KEY `idx-node-updated_by` (`updated_by`),
  KEY `idx-node-server_id` (`server_id`),
  KEY `idx-node-parent_identifier` (`parent_identifier`(768)),
  CONSTRAINT `fk-node-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-node-server_id` FOREIGN KEY (`server_id`) REFERENCES `server` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-node-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node`
--

LOCK TABLES `node` WRITE;
/*!40000 ALTER TABLE `node` DISABLE KEYS */;
/*!40000 ALTER TABLE `node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page`
--

DROP TABLE IF EXISTS `page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `sort` int(11) DEFAULT 0,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dashboard_id` int(11) NOT NULL,
  `child_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `child_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-page-created_by` (`created_by`),
  KEY `idx-page-updated_by` (`updated_by`),
  KEY `idx-page-dashboard_id` (`dashboard_id`),
  CONSTRAINT `fk-page-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-page-dashboard_id` FOREIGN KEY (`dashboard_id`) REFERENCES `dashboard` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-page-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page`
--

LOCK TABLES `page` WRITE;
/*!40000 ALTER TABLE `page` DISABLE KEYS */;
INSERT INTO `page` VALUES (1,1654461634,1654461634,1,1,1,'Page 1',1,'single_value_page',1);
/*!40000 ALTER TABLE `page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile`
--

DROP TABLE IF EXISTS `profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile` (
  `user_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `public_email` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `gravatar_email` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `gravatar_id` varchar(32) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `timezone` varchar(40) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_profile_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile`
--

LOCK TABLES `profile` WRITE;
/*!40000 ALTER TABLE `profile` DISABLE KEYS */;
INSERT INTO `profile` VALUES (1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `imprint` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-project-created_by` (`created_by`),
  KEY `idx-project-updated_by` (`updated_by`),
  CONSTRAINT `fk-project-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-project-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project`
--

LOCK TABLES `project` WRITE;
/*!40000 ALTER TABLE `project` DISABLE KEYS */;
INSERT INTO `project` VALUES (1,1654461603,1654461603,1,1,'New OpenVisu installation','https://openvisu.org/');
/*!40000 ALTER TABLE `project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `server`
--

DROP TABLE IF EXISTS `server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `server` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `sort` int(11) DEFAULT 0,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `checked_at` int(11) DEFAULT 0,
  `scan_required` tinyint(1) DEFAULT 0,
  `has_connection_error` tinyint(1) DEFAULT 0,
  `connection_error` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `root_node` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx-server-created_by` (`created_by`),
  KEY `idx-server-updated_by` (`updated_by`),
  CONSTRAINT `fk-server-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-server-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server`
--

LOCK TABLES `server` WRITE;
/*!40000 ALTER TABLE `server` DISABLE KEYS */;
/*!40000 ALTER TABLE `server` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-settings-created_by` (`created_by`),
  KEY `idx-settings-updated_by` (`updated_by`),
  CONSTRAINT `fk-settings-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-settings-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,1654461572,1654461572,NULL,NULL,'image-page-file-size','1048576'),(2,1654461572,1654461572,NULL,NULL,'library-entry-file-size','1048576');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `single_value_page`
--

DROP TABLE IF EXISTS `single_value_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `single_value_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `server_id` int(11) DEFAULT NULL,
  `node_id` int(11) DEFAULT NULL,
  `unit` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `resolution` int(11) DEFAULT 2,
  `factor` double DEFAULT 1,
  `style_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'string',
  `style_configuration` text COLLATE utf8mb4_unicode_ci DEFAULT '{}',
  PRIMARY KEY (`id`),
  KEY `idx-single_value_page-created_by` (`created_by`),
  KEY `idx-single_value_page-updated_by` (`updated_by`),
  KEY `idx-single_value_page-server_id` (`server_id`),
  KEY `idx-single_value_page-node_id` (`node_id`),
  CONSTRAINT `fk-single_value_page-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-single_value_page-node_id` FOREIGN KEY (`node_id`) REFERENCES `node` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-single_value_page-server_id` FOREIGN KEY (`server_id`) REFERENCES `server` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-single_value_page-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `single_value_page`
--

LOCK TABLES `single_value_page` WRITE;
/*!40000 ALTER TABLE `single_value_page` DISABLE KEYS */;
INSERT INTO `single_value_page` VALUES (1,1654461634,1654461634,1,1,NULL,NULL,'',2,1,'string','{}');
/*!40000 ALTER TABLE `single_value_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_account`
--

DROP TABLE IF EXISTS `social_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `social_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `provider` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `client_id` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `code` varchar(32) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `username` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `data` text COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_social_account_provider_client_id` (`provider`,`client_id`),
  UNIQUE KEY `idx_social_account_code` (`code`),
  KEY `fk_social_account_user` (`user_id`),
  CONSTRAINT `fk_social_account_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_account`
--

LOCK TABLES `social_account` WRITE;
/*!40000 ALTER TABLE `social_account` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `text_page`
--

DROP TABLE IF EXISTS `text_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `text_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-text_page-created_by` (`created_by`),
  KEY `idx-text_page-updated_by` (`updated_by`),
  CONSTRAINT `fk-text_page-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-text_page-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `text_page`
--

LOCK TABLES `text_page` WRITE;
/*!40000 ALTER TABLE `text_page` DISABLE KEYS */;
/*!40000 ALTER TABLE `text_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_serial`
--

DROP TABLE IF EXISTS `time_serial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_serial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `chart_page_id` int(11) NOT NULL,
  `server_id` int(11) DEFAULT NULL,
  `node_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `aggregation_function` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'mean',
  `unit` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `resolution` int(11) DEFAULT 2,
  `factor` double DEFAULT 1,
  `min_value` double DEFAULT 0,
  `max_value` double DEFAULT 1,
  `alert` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx-time_serial-created_by` (`created_by`),
  KEY `idx-time_serial-updated_by` (`updated_by`),
  KEY `idx-time_serial-chart_page_id` (`chart_page_id`),
  KEY `idx-time_serial-server_id` (`server_id`),
  KEY `idx-time_serial-node_id` (`node_id`),
  CONSTRAINT `fk-time_serial-chart_page_id` FOREIGN KEY (`chart_page_id`) REFERENCES `chart_page` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-time_serial-created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-time_serial-node_id` FOREIGN KEY (`node_id`) REFERENCES `node` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-time_serial-server_id` FOREIGN KEY (`server_id`) REFERENCES `server` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk-time_serial-updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_serial`
--

LOCK TABLES `time_serial` WRITE;
/*!40000 ALTER TABLE `time_serial` DISABLE KEYS */;
/*!40000 ALTER TABLE `time_serial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `token` (
  `user_id` int(11) DEFAULT NULL,
  `code` varchar(32) COLLATE utf8mb3_unicode_ci NOT NULL,
  `type` smallint(6) NOT NULL,
  `created_at` int(11) NOT NULL,
  UNIQUE KEY `idx_token_user_id_code_type` (`user_id`,`code`,`type`),
  CONSTRAINT `fk_token_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token`
--

LOCK TABLES `token` WRITE;
/*!40000 ALTER TABLE `token` DISABLE KEYS */;
/*!40000 ALTER TABLE `token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `password_hash` varchar(60) COLLATE utf8mb3_unicode_ci NOT NULL,
  `auth_key` varchar(32) COLLATE utf8mb3_unicode_ci NOT NULL,
  `unconfirmed_email` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `registration_ip` varchar(45) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `flags` int(11) NOT NULL DEFAULT 0,
  `confirmed_at` int(11) DEFAULT NULL,
  `blocked_at` int(11) DEFAULT NULL,
  `updated_at` int(11) NOT NULL,
  `created_at` int(11) NOT NULL,
  `last_login_at` int(11) DEFAULT NULL,
  `last_login_ip` varchar(45) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `auth_tf_key` varchar(16) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `auth_tf_enabled` tinyint(1) DEFAULT 0,
  `password_changed_at` int(11) DEFAULT NULL,
  `gdpr_consent` tinyint(1) DEFAULT 0,
  `gdpr_consent_date` int(11) DEFAULT NULL,
  `gdpr_deleted` tinyint(1) DEFAULT 0,
  `status` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `timezone` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `locale` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `company` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_user_username` (`username`),
  UNIQUE KEY `idx_user_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','admin@example.com','$2y$10$T2KbugAXj5cDTenC.lEwRO9pqmTZzCt2eOTw2Da1a4zD0oTKKjIEG','tpnISmXE98Zdydp8l6RlMigWA-yThFJs',NULL,'172.22.0.6',0,1654461602,NULL,1654461603,1654461602,1654461603,'172.22.0.6','',0,1654461602,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-05 20:40:42
