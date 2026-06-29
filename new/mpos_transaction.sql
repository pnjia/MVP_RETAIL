-- Adminer 4.8.1 MySQL 11.4.2-MariaDB-ubu2404 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

CREATE DATABASE `mpos_transaction` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;
USE `mpos_transaction`;

DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `change_amount` double DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `guid` varchar(255) DEFAULT NULL,
  `notes` varchar(300) DEFAULT NULL,
  `paid` double DEFAULT NULL,
  `payment_methode` varchar(255) DEFAULT NULL,
  `sub_total` double DEFAULT NULL,
  `transaction_guid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKrgqxn64fojs5a58anfn3p0l` (`guid`),
  KEY `FKcdww9prd1q98yvhwiy2qpkjfx` (`transaction_guid`),
  CONSTRAINT `FKcdww9prd1q98yvhwiy2qpkjfx` FOREIGN KEY (`transaction_guid`) REFERENCES `transactions` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `guid` varchar(255) DEFAULT NULL,
  `invoice` varchar(255) DEFAULT NULL,
  `invoice_discount` double DEFAULT NULL,
  `invoice_ppn` double DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `sub_total` double DEFAULT NULL,
  `flag` varchar(20) NOT NULL DEFAULT 'done',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKrbkybdprqkd4nc0r6ps5gunr` (`guid`),
  UNIQUE KEY `UKpf7esdu07le5j38c15b7kv997` (`invoice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `transaction_details`;
CREATE TABLE `transaction_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `ppn` double DEFAULT NULL,
  `price` double DEFAULT NULL,
  `product_guid` varchar(255) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_sku` varchar(255) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `total_price` double DEFAULT NULL,
  `transaction_guid` varchar(255) DEFAULT NULL,
  `cost` decimal(10,2) NOT NULL,
  `stock_in_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKf457qf5ukdmtrnooa3080komw` (`transaction_guid`),
  CONSTRAINT `FKf457qf5ukdmtrnooa3080komw` FOREIGN KEY (`transaction_guid`) REFERENCES `transactions` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


-- 2026-06-26 06:23:19
