CREATE DATABASE  IF NOT EXISTS `car_rental` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `car_rental`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: car_rental
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Temporary view structure for view `availablefleet`
--

DROP TABLE IF EXISTS `availablefleet`;
/*!50001 DROP VIEW IF EXISTS `availablefleet`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `availablefleet` AS SELECT 
 1 AS `vehicle_id`,
 1 AS `make`,
 1 AS `model`,
 1 AS `color`,
 1 AS `category`,
 1 AS `daily_rate`,
 1 AS `branch_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `vehicle_id` int DEFAULT NULL,
  `pickup_location_id` int DEFAULT NULL,
  `dropoff_location_id` int DEFAULT NULL,
  `pickup_date` datetime NOT NULL,
  `return_date` datetime NOT NULL,
  `actual_return_date` datetime DEFAULT NULL,
  `status` enum('Pending','Confirmed','Active','Completed','Cancelled') DEFAULT 'Pending',
  PRIMARY KEY (`booking_id`),
  KEY `user_id` (`user_id`),
  KEY `vehicle_id` (`vehicle_id`),
  KEY `pickup_location_id` (`pickup_location_id`),
  KEY `dropoff_location_id` (`dropoff_location_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`),
  CONSTRAINT `bookings_ibfk_3` FOREIGN KEY (`pickup_location_id`) REFERENCES `locations` (`location_id`),
  CONSTRAINT `bookings_ibfk_4` FOREIGN KEY (`dropoff_location_id`) REFERENCES `locations` (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (1,5,1,1,3,'2026-01-10 09:00:00','2026-01-13 09:00:00','2026-01-13 10:00:00','Completed'),(2,5,8,3,1,'2026-02-20 10:00:00','2026-02-22 10:00:00',NULL,'Cancelled'),(3,5,9,2,5,'2026-05-10 08:00:00','2026-05-13 08:00:00',NULL,'Confirmed'),(4,6,5,4,6,'2026-02-01 11:00:00','2026-02-04 11:00:00','2026-02-04 12:30:00','Completed'),(5,6,2,6,4,'2026-04-20 09:00:00','2026-04-25 09:00:00',NULL,'Active'),(6,6,10,1,7,'2026-05-15 10:00:00','2026-05-17 10:00:00',NULL,'Pending'),(7,7,6,5,2,'2026-01-25 14:00:00','2026-01-28 14:00:00','2026-01-28 15:00:00','Completed'),(8,7,8,7,9,'2026-05-08 08:00:00','2026-05-10 08:00:00',NULL,'Confirmed'),(9,7,1,3,6,'2026-03-05 12:00:00','2026-03-07 12:00:00',NULL,'Cancelled'),(10,8,9,6,8,'2026-02-10 09:00:00','2026-02-13 09:00:00','2026-02-13 10:30:00','Completed'),(11,8,3,8,6,'2026-04-18 10:00:00','2026-04-23 10:00:00',NULL,'Active'),(12,8,6,9,1,'2026-05-20 08:00:00','2026-05-23 08:00:00',NULL,'Pending'),(13,9,10,7,10,'2026-01-30 13:00:00','2026-02-01 13:00:00','2026-02-01 14:00:00','Completed'),(14,9,5,10,3,'2026-03-15 09:00:00','2026-03-17 09:00:00',NULL,'Cancelled'),(15,9,1,4,8,'2026-05-25 10:00:00','2026-05-27 10:00:00',NULL,'Confirmed'),(16,10,6,11,12,'2026-02-05 08:00:00','2026-02-08 08:00:00','2026-02-08 09:00:00','Completed'),(17,10,7,12,13,'2026-04-15 11:00:00','2026-04-20 11:00:00',NULL,'Active'),(18,10,9,5,2,'2026-05-28 09:00:00','2026-05-30 09:00:00',NULL,'Confirmed');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `customerbookingsummary`
--

DROP TABLE IF EXISTS `customerbookingsummary`;
/*!50001 DROP VIEW IF EXISTS `customerbookingsummary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `customerbookingsummary` AS SELECT 
 1 AS `booking_id`,
 1 AS `user_id`,
 1 AS `make`,
 1 AS `model`,
 1 AS `license_plate`,
 1 AS `pickup_location`,
 1 AS `dropoff_location`,
 1 AS `pickup_date`,
 1 AS `return_date`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `customerdetails`
--

DROP TABLE IF EXISTS `customerdetails`;
/*!50001 DROP VIEW IF EXISTS `customerdetails`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `customerdetails` AS SELECT 
 1 AS `user_id`,
 1 AS `full_name`,
 1 AS `email`,
 1 AS `phone_number`,
 1 AS `document_id`,
 1 AS `document_number`,
 1 AS `verification_status`,
 1 AS `expiry_date`,
 1 AS `verified_by_employee`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `document_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `document_type` varchar(50) DEFAULT NULL,
  `document_number` varchar(50) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `verification_status` enum('Pending','Verified','Rejected') DEFAULT 'Pending',
  `expiry_date` date DEFAULT NULL,
  `verified_by` int DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  PRIMARY KEY (`document_id`),
  KEY `fk_doc_user` (`user_id`),
  KEY `fk_doc_employee` (`verified_by`),
  CONSTRAINT `fk_doc_employee` FOREIGN KEY (`verified_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_doc_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES (1,5,'Driving License','DL-SA-9875','uploads/5-1778406428477.png','Verified','2030-05-20',11,'2026-05-10 14:48:47'),(2,5,'CNIC','42101-1234567-1','uploads/sample.jpg','Pending','2031-12-31',NULL,NULL),(3,6,'Driving License','DL-ZS-8812','uploads/sample.jpg','Verified','2027-09-15',4,'2026-01-20 11:00:00'),(4,6,'CNIC','42201-9876543-2','uploads/sample.jpg','Verified','2030-06-30',11,'2026-01-21 10:00:00'),(5,6,'Passport','AA-3345678','uploads/sample.jpg','Pending','2029-03-20',NULL,NULL),(6,7,'Driving License','DL-HF-3301','uploads/sample.jpg','Verified','2026-08-15',11,'2026-02-01 14:00:00'),(7,7,'CNIC','42301-1122334-5','uploads/sample.jpg','Rejected','2030-01-01',11,'2026-02-02 09:00:00'),(8,8,'Driving License','DL-BS-7751','uploads/sample.jpg','Verified','2028-03-20',4,'2026-02-10 10:30:00'),(9,8,'CNIC','42401-5566778-9','uploads/sample.jpg','Verified','2032-08-01',4,'2026-02-11 11:00:00'),(10,9,'Driving License','DL-DA-6643','uploads/sample.jpg','Pending','2028-11-30',NULL,NULL),(11,9,'CNIC','42501-3344556-7','uploads/sample.jpg','Verified','2033-01-15',11,'2026-03-01 13:00:00'),(12,10,'Driving License','DL-OM-9923','uploads/sample.jpg','Verified','2027-05-10',4,'2026-03-05 15:00:00'),(13,10,'Passport','BB-7789012','uploads/sample.jpg','Verified','2031-07-22',11,'2026-03-06 09:30:00');
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_details`
--

DROP TABLE IF EXISTS `employee_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_details` (
  `user_id` int NOT NULL,
  `location_id` int DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_empdetail_location` (`location_id`),
  CONSTRAINT `fk_empdetail_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`),
  CONSTRAINT `fk_empdetail_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_details`
--

LOCK TABLES `employee_details` WRITE;
/*!40000 ALTER TABLE `employee_details` DISABLE KEYS */;
INSERT INTO `employee_details` VALUES (4,5,'2000-05-03',55000.00),(11,2,'2009-05-12',50000.00),(15,12,'2026-05-10',50000.00),(16,1,'2023-03-15',65000.00),(17,4,'2023-07-01',58000.00),(18,6,'2022-11-20',72000.00),(19,12,'2024-01-10',60000.00),(20,13,'2024-04-05',62000.00),(21,2,'2023-09-18',55000.00);
/*!40000 ALTER TABLE `employee_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inspections`
--

DROP TABLE IF EXISTS `inspections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inspections` (
  `inspection_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `employee_id` int DEFAULT NULL,
  `inspection_type` enum('Check-Out','Check-In') DEFAULT NULL,
  `fuel_level` varchar(20) DEFAULT NULL,
  `mileage_reading` int DEFAULT NULL,
  `damage_notes` text,
  `inspection_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`inspection_id`),
  KEY `booking_id` (`booking_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `inspections_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`),
  CONSTRAINT `inspections_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inspections`
--

LOCK TABLES `inspections` WRITE;
/*!40000 ALTER TABLE `inspections` DISABLE KEYS */;
INSERT INTO `inspections` VALUES (1,1,4,'Check-Out','Full',15000,'No damage, clean interior','2026-01-10 09:30:00'),(2,1,4,'Check-In','Half',15280,'Minor dust on exterior','2026-01-13 10:00:00'),(3,4,11,'Check-Out','Full',5000,'Perfect condition','2026-02-01 11:30:00'),(4,4,11,'Check-In','3/4',5290,'Small scuff on rear bumper','2026-02-04 12:30:00'),(5,7,4,'Check-Out','Full',4,'Brand new, no issues','2026-01-25 14:30:00'),(6,7,11,'Check-In','Quarter',455,'Returned late, fuel low','2026-01-28 15:00:00'),(7,10,11,'Check-Out','Full',7500,'Clean, tyres good','2026-02-10 09:30:00'),(8,10,4,'Check-In','Full',7820,'No damage','2026-02-13 10:30:00'),(9,13,4,'Check-Out','Full',4000,'Good condition','2026-01-30 13:30:00'),(10,13,11,'Check-In','Half',4190,'Returned late, minor dirt inside','2026-02-01 14:00:00'),(11,16,4,'Check-Out','Full',455,'Clean after previous return','2026-02-05 08:30:00'),(12,16,11,'Check-In','3/4',745,'No damage, slight dust','2026-02-08 09:00:00'),(13,5,11,'Check-Out','Full',8000,'Clean, full tank','2026-04-20 09:30:00'),(14,11,4,'Check-Out','Full',344,'Good condition, low mileage','2026-04-18 10:30:00'),(15,17,11,'Check-Out','3/4',18000,'Slight wear on front tyres noted','2026-04-15 11:30:00');
/*!40000 ALTER TABLE `inspections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `invoice_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `base_amount` decimal(10,2) DEFAULT NULL,
  `late_fees` decimal(10,2) DEFAULT NULL,
  `security_deposit` decimal(10,2) DEFAULT NULL,
  `payment_status` enum('Unpaid','Paid') DEFAULT 'Unpaid',
  `issued_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`invoice_id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
INSERT INTO `invoices` VALUES (1,1,15000.00,0.00,500.00,'Paid','2026-01-10 09:00:00'),(2,2,5000.00,0.00,500.00,'Unpaid','2026-02-20 10:00:00'),(3,3,33000.00,0.00,500.00,'Unpaid','2026-05-10 08:00:00'),(4,4,28500.00,0.00,500.00,'Paid','2026-02-01 11:00:00'),(5,5,32500.00,0.00,500.00,'Unpaid','2026-04-20 09:00:00'),(6,6,9600.00,0.00,500.00,'Unpaid','2026-05-15 10:00:00'),(7,7,45000.00,2000.00,500.00,'Paid','2026-01-25 14:00:00'),(8,8,5000.00,0.00,500.00,'Unpaid','2026-05-08 08:00:00'),(9,9,10000.00,0.00,500.00,'Unpaid','2026-03-05 12:00:00'),(10,10,33000.00,0.00,500.00,'Paid','2026-02-10 09:00:00'),(11,11,17500.00,0.00,500.00,'Unpaid','2026-04-18 10:00:00'),(12,12,45000.00,0.00,500.00,'Unpaid','2026-05-20 08:00:00'),(13,13,9600.00,1500.00,500.00,'Paid','2026-01-30 13:00:00'),(14,14,19000.00,0.00,500.00,'Unpaid','2026-03-15 09:00:00'),(15,15,10000.00,0.00,500.00,'Unpaid','2026-05-25 10:00:00'),(16,16,45000.00,0.00,500.00,'Paid','2026-02-05 08:00:00'),(17,17,22500.00,0.00,500.00,'Unpaid','2026-04-15 11:00:00'),(18,18,22000.00,0.00,500.00,'Unpaid','2026-05-28 09:00:00');
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `location_id` int NOT NULL AUTO_INCREMENT,
  `branch_name` varchar(100) NOT NULL,
  `address` varchar(255) NOT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'Downtown Hub','123 Main St, Karachi','021-34567890'),(2,'Airport Terminal 1','Jinnah Int Airport','021-39998887'),(3,'North Nazimabad Branch','Block H, North Nazimabad','021-36665554'),(4,'Clifton Office','Marine Promenade, Clifton','021-32221110'),(5,'Gulshan Base','University Road, Gulshan','021-34443332'),(6,'Defence Hub','Phase 6, DHA','021-35554443'),(7,'Saddar Point','Preedy St, Saddar','021-37776665'),(8,'Malir Station','Malir Cantt Road','021-38887776'),(9,'Bahria Office','Super Highway, Bahria Town','021-31110009'),(10,'Korangi Industrial','Sector 15, KIA','021-30009998'),(11,'Karachi Main Branch','Plot 10, Shahrah-e-Faisal, Karachi','021-11122233'),(12,'Lahore Branch','45 MM Alam Road, Gulberg, Lahore','042-33344455'),(13,'Islamabad Branch','Blue Area, Jinnah Avenue, Islamabad','051-55566677');
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenancelogs`
--

DROP TABLE IF EXISTS `maintenancelogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenancelogs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `vehicle_id` int DEFAULT NULL,
  `service_type` varchar(100) DEFAULT NULL,
  `service_date` date DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`log_id`),
  KEY `vehicle_id` (`vehicle_id`),
  CONSTRAINT `maintenancelogs_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenancelogs`
--

LOCK TABLES `maintenancelogs` WRITE;
/*!40000 ALTER TABLE `maintenancelogs` DISABLE KEYS */;
INSERT INTO `maintenancelogs` VALUES (1,4,'Oil Change','2024-04-15',5000.00,'Regular service'),(2,7,'Deep Clean','2024-05-20',2500.00,'Routine detailing'),(3,1,'Brake Replacement','2024-03-10',12000.00,'Front pads replaced'),(4,2,'Tyre Rotation','2024-04-01',3000.00,'All four tyres'),(5,3,'AC Repair','2024-02-28',15000.00,'Gas leakage fixed'),(6,6,'Engine Tune-up','2024-01-15',25000.00,'Major service'),(7,5,'Battery Change','2024-05-05',8500.00,'Dry battery installed'),(8,9,'Wheel Alignment','2024-05-12',4000.00,'Slight pull to left fixed'),(9,8,'Oil Change','2024-04-20',4500.00,'Synthetic oil used'),(10,10,'First Service','2024-05-25',0.00,'Free first service');
/*!40000 ALTER TABLE `maintenancelogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Admin','Employee','Customer') NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Syeda Neamah','neamah@driveflow.com','admin','Admin','0300-1112223',1),(2,'Pareena Kumari','pareena@driveflow.com','admin','Admin','0300-4445556',1),(3,'Aila Naeem','aila@driveflow.com','admin','Admin','0300-7778889',1),(4,'Ahmed Khan','ahmed.e@driveflow.com','emp_pass_1','Employee','0312-5556667',1),(5,'Sara Ali','sara.customer@gmail.com','123','Customer','03082903174',1),(6,'Zain Sheikh','zain.m@yahoo.com','cust_pass_2','Customer','0333-1234567',1),(7,'Hina Fatima','hina.m@outlook.com','cust_pass_3','Customer','0345-7654321',1),(8,'Bilal Sheikh','bilal.s@gmail.com','cust_pass_4','Customer','0311-2223334',1),(9,'Dania Ali','dania@gmail.com','cust_pass_5','Customer','0322-4445556',1),(10,'Omar Mansoor','omar.f@protonmail.com','cust_pass_6','Customer','0301-6667778',1),(11,'Ameen Rashid','ameen.e@driveflow.com','123','Employee','0300-4582388',1),(12,'Saad Khan','saad.k@gmail.com','password123','Customer','0300-9998887',1),(14,'Fatima Hasan','fatima.h@gmail.com','password123','Customer','0300-9998887',1),(15,'Mariam Hasan','mariam.e@driveflow.com','123','Employee','03082863834',1),(16,'Kamran Hussain','kamran.e@driveflow.com','emp_pass_2','Employee','0312-1112223',1),(17,'Sana Mirza','sana.e@driveflow.com','emp_pass_3','Employee','0333-2223334',1),(18,'Tariq Mehmood','tariq.e@driveflow.com','emp_pass_4','Employee','0345-3334445',1),(19,'Rabia Noor','rabia.e@driveflow.com','emp_pass_5','Employee','0311-4445556',0),(20,'Faisal Qureshi','faisal.e@driveflow.com','emp_pass_6','Employee','0322-5556667',1),(21,'Nadia Iqbal','nadia.e@driveflow.com','emp_pass_7','Employee','0301-6667778',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_profile_update` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
    IF (OLD.full_name <> NEW.full_name OR
        IFNULL(OLD.phone_number, '') <> IFNULL(NEW.phone_number, '')) THEN
        INSERT INTO Users_backup (user_id, old_full_name, old_phone_number)
        VALUES (OLD.user_id, OLD.full_name, OLD.phone_number);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users_backup`
--

DROP TABLE IF EXISTS `users_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_backup` (
  `u_backup_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `old_full_name` varchar(100) DEFAULT NULL,
  `old_phone_number` varchar(20) DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`u_backup_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_backup`
--

LOCK TABLES `users_backup` WRITE;
/*!40000 ALTER TABLE `users_backup` DISABLE KEYS */;
INSERT INTO `users_backup` VALUES (1,5,'Sara Ali','0321-9998888','2026-04-19 08:02:59'),(2,5,'Sara Ali',NULL,'2026-04-23 09:38:30'),(3,15,'Mariam','03082863834','2026-05-10 10:01:41'),(4,14,'Postman Test User','0300-9998887','2026-05-10 10:02:32'),(5,12,'Postman Test User','0300-9998887','2026-05-10 10:03:05');
/*!40000 ALTER TABLE `users_backup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `vehicle_id` int NOT NULL AUTO_INCREMENT,
  `make` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `year` int DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `license_plate` varchar(20) DEFAULT NULL,
  `daily_rate` decimal(10,2) DEFAULT NULL,
  `status` enum('Available','Rented','Maintenance','Cleaning') DEFAULT 'Available',
  `current_mileage` int DEFAULT NULL,
  `current_location_id` int DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`vehicle_id`),
  UNIQUE KEY `license_plate` (`license_plate`),
  KEY `current_location_id` (`current_location_id`),
  CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`current_location_id`) REFERENCES `locations` (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` VALUES (1,'Toyota','Corolla','Black',2022,'Sedan','ABC-123',5000.00,'Available',15000,1,1),(2,'Honda','Civic','White',2023,'Sedan','XYZ-789',6500.00,'Rented',8000,2,1),(3,'Suzuki','Cultus','Red',2021,'Hatchback','LHR-456',3500.00,'Rented',344,3,1),(4,'Kia','Sportage','Black',2022,'SUV','KHI-001',9000.00,'Maintenance',12000,4,1),(5,'Hyundai','Tucson','White',2023,'SUV','ISB-002',9500.00,'Available',5000,5,1),(6,'Toyota','Fortuner','Black',2022,'SUV','PQR-321',15000.00,'Available',4,6,0),(7,'Honda','City','Red',2021,'Sedan','MNO-654',4500.00,'Cleaning',18000,7,1),(8,'Suzuki','Alto','Black',2023,'Hatchback','STU-987',2500.00,'Available',3000,8,1),(9,'MG','HS','Black',2022,'SUV','VWX-111',11000.00,'Available',7500,9,1),(10,'Changan','Alsvin','White',2023,'Sedan','YZA-222',4800.00,'Available',4000,10,1),(11,'Toyota','Yaris','Silver',2023,'Sedan','KHI-201',4200.00,'Available',6200,11,1),(12,'Honda','BR-V','White',2022,'SUV','LHR-302',8500.00,'Available',11000,12,1),(13,'Suzuki','Swift','Blue',2023,'Hatchback','ISB-403',3800.00,'Rented',4500,13,1),(14,'Kia','Stonic','Red',2023,'SUV','KHI-504',7800.00,'Available',3200,3,1),(15,'MG','ZS','Black',2022,'SUV','LHR-605',9200.00,'Maintenance',15600,5,1),(16,'Changan','Oshan X7','White',2023,'SUV','ISB-706',12000.00,'Available',2100,7,1),(17,'Toyota','Hilux','Grey',2022,'Pickup','KHI-807',18000.00,'Available',9800,9,1),(18,'Honda','HR-V','Silver',2023,'SUV','LHR-908',10500.00,'Rented',5300,11,1),(19,'Hyundai','Elantra','Black',2022,'Sedan','ISB-009',6800.00,'Cleaning',13400,12,1),(20,'Prince','DFSK Glory','White',2023,'SUV','KHI-110',7500.00,'Available',1800,13,1);
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `availablefleet`
--

/*!50001 DROP VIEW IF EXISTS `availablefleet`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `availablefleet` AS select `v`.`vehicle_id` AS `vehicle_id`,`v`.`make` AS `make`,`v`.`model` AS `model`,`v`.`color` AS `color`,`v`.`category` AS `category`,`v`.`daily_rate` AS `daily_rate`,`l`.`branch_name` AS `branch_name` from (`vehicles` `v` join `locations` `l` on((`v`.`current_location_id` = `l`.`location_id`))) where ((`v`.`status` = 'Available') and (`v`.`is_active` = 1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `customerbookingsummary`
--

/*!50001 DROP VIEW IF EXISTS `customerbookingsummary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `customerbookingsummary` AS select `b`.`booking_id` AS `booking_id`,`b`.`user_id` AS `user_id`,`v`.`make` AS `make`,`v`.`model` AS `model`,`v`.`license_plate` AS `license_plate`,`pl`.`branch_name` AS `pickup_location`,`dl`.`branch_name` AS `dropoff_location`,`b`.`pickup_date` AS `pickup_date`,`b`.`return_date` AS `return_date`,`b`.`status` AS `status` from (((`bookings` `b` join `vehicles` `v` on((`b`.`vehicle_id` = `v`.`vehicle_id`))) join `locations` `pl` on((`b`.`pickup_location_id` = `pl`.`location_id`))) join `locations` `dl` on((`b`.`dropoff_location_id` = `dl`.`location_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `customerdetails`
--

/*!50001 DROP VIEW IF EXISTS `customerdetails`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `customerdetails` AS select `u`.`user_id` AS `user_id`,`u`.`full_name` AS `full_name`,`u`.`email` AS `email`,`u`.`phone_number` AS `phone_number`,`d`.`document_id` AS `document_id`,`d`.`document_number` AS `document_number`,`d`.`verification_status` AS `verification_status`,`d`.`expiry_date` AS `expiry_date`,`e`.`full_name` AS `verified_by_employee` from ((`users` `u` left join `documents` `d` on(((`d`.`user_id` = `u`.`user_id`) and (`d`.`document_type` = 'Driving License')))) left join `users` `e` on((`e`.`user_id` = `d`.`verified_by`))) where ((`u`.`role` = 'Customer') and (`u`.`is_active` = 1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-11 14:44:35
