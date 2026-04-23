CREATE DATABASE  IF NOT EXISTS `car_rental` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `car_rental`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: car_rental
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (1,5,1,1,1,'2024-05-01 10:00:00','2024-05-05 10:00:00',NULL,'Completed'),(2,6,2,2,2,'2024-05-10 12:00:00','2024-05-15 12:00:00',NULL,'Active'),(3,7,3,3,3,'2024-05-20 09:00:00','2024-05-22 09:00:00',NULL,'Active'),(4,8,4,4,1,'2024-05-25 14:00:00','2024-05-28 14:00:00',NULL,'Pending'),(5,9,5,5,5,'2024-06-01 08:00:00','2024-06-03 08:00:00',NULL,'Confirmed'),(6,10,6,6,6,'2024-06-05 11:00:00','2024-06-10 11:00:00','2026-04-23 07:06:26','Completed'),(7,5,7,7,7,'2024-06-12 15:00:00','2024-06-14 15:00:00',NULL,'Cancelled'),(8,6,8,8,8,'2024-06-15 10:00:00','2024-06-16 10:00:00',NULL,'Confirmed'),(9,7,9,9,1,'2024-06-18 13:00:00','2024-06-20 13:00:00',NULL,'Confirmed'),(10,8,10,10,10,'2024-06-22 09:00:00','2024-06-25 09:00:00',NULL,'Confirmed'),(11,9,1,1,2,'2024-07-01 10:00:00','2024-07-03 10:00:00','2024-07-03 11:00:00','Completed'),(12,10,3,3,5,'2024-07-05 09:00:00','2024-07-07 09:00:00',NULL,'Confirmed'),(13,5,8,8,1,'2024-07-08 12:00:00','2024-07-09 12:00:00',NULL,'Pending'),(14,6,9,9,9,'2024-07-10 08:00:00','2024-07-12 08:00:00',NULL,'Active'),(15,7,10,10,4,'2024-07-15 14:00:00','2024-07-18 14:00:00',NULL,'Confirmed'),(17,5,3,2,5,'2026-04-19 00:00:00','2026-04-21 00:00:00',NULL,'Pending');
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
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `document_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `document_type` varchar(50) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES (2,6,'Driving License','uploads/sample.jpg','Verified','2027-12-31',4,'2026-04-23 12:09:09'),(3,6,'CNIC','uploads/sample.jpg','Verified','2030-06-30',4,'2026-04-23 12:10:04'),(4,7,'Driving License','uploads/sample.jpg','Verified','2026-08-15',4,'2026-04-23 12:09:56'),(5,7,'Driving License','uploads/sample.jpg','Verified','2025-01-01',4,'2026-04-23 12:09:52'),(6,8,'Driving License','uploads/sample.jpg','Verified','2028-03-20',4,'2026-04-23 12:09:49');
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inspections`
--

LOCK TABLES `inspections` WRITE;
/*!40000 ALTER TABLE `inspections` DISABLE KEYS */;
INSERT INTO `inspections` VALUES (1,1,4,'Check-Out','Full',15000,'No damage','2026-04-18 11:19:39'),(2,1,4,'Check-In','Half',15400,'Small scratch on bumper','2026-04-18 11:19:39'),(3,2,4,'Check-Out','Full',8000,'Clean interior','2026-04-18 11:19:39'),(4,6,4,'Check-Out','75%',20000,'Tyres slightly worn','2026-04-18 11:19:39'),(5,3,4,'Check-Out','Full',25000,'Perfect condition','2026-04-18 11:19:39'),(6,10,4,'Check-Out','Full',4000,'Brand new smell','2026-04-18 11:19:39'),(7,2,4,'Check-In','Full',8500,'No issues','2026-04-18 11:19:39'),(8,5,4,'Check-Out','50%',5000,'Needs fuel soon','2026-04-18 11:19:39'),(9,9,4,'Check-Out','Full',7500,'No damage','2026-04-18 11:19:39'),(10,8,4,'Check-Out','Full',3000,'Clean','2026-04-18 11:19:39'),(11,11,4,'Check-Out','Full',15500,'Clean','2026-04-18 11:22:32'),(12,11,4,'Check-In','Quarter',15800,'Minor dirt','2026-04-18 11:22:32'),(13,12,4,'Check-Out','Full',26000,'Good condition','2026-04-18 11:22:32'),(14,14,4,'Check-Out','Half',8000,'Fuel low warning','2026-04-18 11:22:32'),(15,15,4,'Check-Out','Full',4500,'No issues','2026-04-18 11:22:32'),(16,3,4,'Check-Out','3/4',344,'','2026-04-23 12:05:57'),(17,6,4,'Check-In','3/4',4,'','2026-04-23 12:06:26');
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
INSERT INTO `invoices` VALUES (1,1,20000.00,0.00,5000.00,'Paid','2026-04-18 11:13:26'),(2,2,32500.00,1000.00,10000.00,'Paid','2026-04-18 11:13:26'),(3,3,7000.00,0.00,3000.00,'Unpaid','2026-04-18 11:13:26'),(4,4,27000.00,0.00,15000.00,'Unpaid','2026-04-18 11:13:26'),(5,5,19000.00,0.00,8000.00,'Paid','2026-04-18 11:13:26'),(6,6,75000.00,341500.01,20000.00,'Unpaid','2026-04-18 11:13:26'),(7,7,0.00,0.00,0.00,'Unpaid','2026-04-18 11:13:26'),(8,8,2500.00,0.00,2000.00,'Paid','2026-04-18 11:13:26'),(9,9,22000.00,0.00,10000.00,'Paid','2026-04-18 11:13:26'),(10,10,14400.00,0.00,5000.00,'Unpaid','2026-04-18 11:13:26'),(11,11,10000.00,500.00,4000.00,'Paid','2026-04-18 11:21:59'),(12,12,7000.00,0.00,3000.00,'Unpaid','2026-04-18 11:21:59'),(13,13,2500.00,0.00,2000.00,'Unpaid','2026-04-18 11:21:59'),(14,14,22000.00,0.00,10000.00,'Paid','2026-04-18 11:21:59'),(15,15,14400.00,0.00,5000.00,'Paid','2026-04-18 11:21:59'),(16,17,7000.00,NULL,500.00,'Unpaid','2026-04-19 13:13:40');
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
  `license_number` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Syeda Neamah','neamah@driveflow.com','admin','Admin','0300-1112223',NULL),(2,'Pareena Kumari','pareena@driveflow.com','admin','Admin','0300-4445556',NULL),(3,'Aila Naeem','aila@driveflow.com','admin','Admin','0300-7778889',NULL),(4,'Ahmed Khan','ahmed.e@driveflow.com','emp_pass_1','Employee','0312-5556667',NULL),(5,'Sara Ali','sara.customer@gmail.com','123','Customer','0321-9998887',NULL),(6,'Zain Sheikh','zain.m@yahoo.com','cust_pass_2','Customer','0333-1234567',NULL),(7,'Hina Fatima','hina.m@outlook.com','cust_pass_3','Customer','0345-7654321',NULL),(8,'Bilal Sheikh','bilal.s@gmail.com','cust_pass_4','Customer','0311-2223334',NULL),(9,'Dania Ali','dania@gmail.com','cust_pass_5','Customer','0322-4445556',NULL),(10,'Omar Mansoor','omar.f@protonmail.com','cust_pass_6','Customer','0301-6667778',NULL),(11,'Ameen Rashid','ameen.e@driveflow.com','123','Employee','0300-4582388',NULL),(12,'Postman Test User','postman@test.com','password123','Customer','0300-9998887',NULL),(14,'Postman Test User','postman2@test.com','password123','Customer','0300-9998887',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

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
  `old_license_number` varchar(50) DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`u_backup_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_backup`
--

LOCK TABLES `users_backup` WRITE;
/*!40000 ALTER TABLE `users_backup` DISABLE KEYS */;
INSERT INTO `users_backup` VALUES (1,5,'Sara Ali','0321-9998888','LIC-998877','2026-04-19 08:02:59');
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
  PRIMARY KEY (`vehicle_id`),
  UNIQUE KEY `license_plate` (`license_plate`),
  KEY `current_location_id` (`current_location_id`),
  CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`current_location_id`) REFERENCES `locations` (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` VALUES (1,'Toyota','Corolla','Black',2022,'Sedan','ABC-123',5000.00,'Available',15000,1),(2,'Honda','Civic','White',2023,'Sedan','XYZ-789',6500.00,'Rented',8000,2),(3,'Suzuki','Cultus','Red',2021,'Hatchback','LHR-456',3500.00,'Rented',344,3),(4,'Kia','Sportage','Black',2022,'SUV','KHI-001',9000.00,'Maintenance',12000,4),(5,'Hyundai','Tucson','White',2023,'SUV','ISB-002',9500.00,'Available',5000,5),(6,'Toyota','Fortuner','Black',2022,'SUV','PQR-321',15000.00,'Available',4,6),(7,'Honda','City','Red',2021,'Sedan','MNO-654',4500.00,'Cleaning',18000,7),(8,'Suzuki','Alto','Black',2023,'Hatchback','STU-987',2500.00,'Available',3000,8),(9,'MG','HS','Black',2022,'SUV','VWX-111',11000.00,'Available',7500,9),(10,'Changan','Alsvin','White',2023,'Sedan','YZA-222',4800.00,'Available',4000,10);
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
/*!50001 VIEW `availablefleet` AS select `v`.`vehicle_id` AS `vehicle_id`,`v`.`make` AS `make`,`v`.`model` AS `model`,`v`.`color` AS `color`,`v`.`category` AS `category`,`v`.`daily_rate` AS `daily_rate`,`l`.`branch_name` AS `branch_name` from (`vehicles` `v` join `locations` `l` on((`v`.`current_location_id` = `l`.`location_id`))) where (`v`.`status` = 'Available') */;
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-23 12:46:50
