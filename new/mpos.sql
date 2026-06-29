-- Adminer 5.4.0 MariaDB 11.8.3-MariaDB-ubu2404 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

CREATE DATABASE `mpos` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;
USE `mpos`;

DROP TABLE IF EXISTS `affiliators`;
CREATE TABLE `affiliators` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `referral_code` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKl9talc3p8hdeigpjljmm1iofj` (`referral_code`),
  KEY `IDXl9talc3p8hdeigpjljmm1iofj` (`referral_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `cash_categories`;
CREATE TABLE `cash_categories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `store_id` bigint(20) NOT NULL,
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cash_categories_store_id` (`store_id`),
  KEY `idx_cash_categories_store_deleted` (`store_id`,`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `cash_periods`;
CREATE TABLE `cash_periods` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `end_date` date NOT NULL,
  `start_date` date NOT NULL,
  `store_id` bigint(20) NOT NULL,
  `transactions_ids` text NOT NULL,
  `cash_transaction_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cash_periods_store_date` (`store_id`,`start_date`,`end_date`),
  KEY `idx_cash_periods_store_deleted` (`store_id`,`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `cash_transactions`;
CREATE TABLE `cash_transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `debit` decimal(15,2) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `kredit` decimal(15,2) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `store_id` bigint(20) NOT NULL,
  `transaction_date` date NOT NULL,
  `category_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cash_transactions_store_date` (`store_id`,`transaction_date`),
  KEY `idx_cash_transactions_store_deleted` (`store_id`,`deleted`),
  KEY `idx_cash_transactions_category` (`category_id`),
  CONSTRAINT `FKngag8gntxjmswsvvj94wi1wso` FOREIGN KEY (`category_id`) REFERENCES `cash_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `cities`;
CREATE TABLE `cities` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `code` varchar(255) NOT NULL,
  `meta` text DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `province_code` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKqww1g66rmhx352jxut53oqh3y` (`code`),
  KEY `province_code` (`province_code`),
  CONSTRAINT `province_code` FOREIGN KEY (`province_code`) REFERENCES `provinces` (`code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `contact_us`;
CREATE TABLE `contact_us` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `business_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `address` varchar(250) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(14) DEFAULT NULL,
  `store_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKfo2nbino9sutm98o6hbac74ue` (`store_id`),
  CONSTRAINT `FKfo2nbino9sutm98o6hbac74ue` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `districts`;
CREATE TABLE `districts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `code` varchar(255) NOT NULL,
  `meta` text DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `city_code` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKgkpvb55aiiyu9n55qoxcwmkds` (`code`),
  KEY `FK4851qs7qegiujcq093f8hdlih` (`city_code`),
  CONSTRAINT `FK4851qs7qegiujcq093f8hdlih` FOREIGN KEY (`city_code`) REFERENCES `cities` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `faqs`;
CREATE TABLE `faqs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `description` text NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `category` enum('MOBILE','WEB') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `file_uploads`;
CREATE TABLE `file_uploads` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `guides`;
CREATE TABLE `guides` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `category` enum('MOBILE','WEB') NOT NULL,
  `description` text NOT NULL,
  `step_order` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `otp_verifications`;
CREATE TABLE `otp_verifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `attemptCount` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `expiresAt` datetime(6) NOT NULL,
  `ipAddress` varchar(255) DEFAULT NULL,
  `isUsed` bit(1) NOT NULL,
  `otpCode` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKfpgiit0i40arv0kvwm8gaylwy` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `cost` decimal(10,2) NOT NULL,
  `guid` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `price` double NOT NULL,
  `sku` varchar(255) DEFAULT NULL,
  `store_id` bigint(20) NOT NULL,
  `product_category_id` bigint(20) DEFAULT NULL,
  `parent_id` varchar(255) DEFAULT NULL,
  `is_stock` tinyint(1) NOT NULL DEFAULT 0,
  `last_stock_sync_at` datetime(6) DEFAULT NULL,
  `qty` int(11) NOT NULL,
  `unit` varchar(20) DEFAULT NULL,
  `is_use_stock` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK61e53qqtjxf7l3qav8k2o3fm9` (`guid`),
  UNIQUE KEY `UKoie313ijvf9pttp4x7mru4oa3` (`store_id`,`sku`),
  KEY `FK6owcuvsxh28icwrbnpubn1ykj` (`product_category_id`),
  KEY `FKtg6wn5mwlsrvgrm09gds7leox` (`parent_id`),
  CONSTRAINT `FK6owcuvsxh28icwrbnpubn1ykj` FOREIGN KEY (`product_category_id`) REFERENCES `product_cats` (`id`),
  CONSTRAINT `FKtg6wn5mwlsrvgrm09gds7leox` FOREIGN KEY (`parent_id`) REFERENCES `products` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `product_cats`;
CREATE TABLE `product_cats` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `category_name` varchar(255) NOT NULL,
  `store_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `provinces`;
CREATE TABLE `provinces` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `code` varchar(255) NOT NULL,
  `meta` text DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKdalikev902uvkpwn632apqe1k` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `referrals`;
CREATE TABLE `referrals` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `referral_code` varchar(20) NOT NULL,
  `referred_user_id` bigint(20) NOT NULL,
  `referrer_affiliator_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKb1jxe2jtijo29pbjnvb3cb1g2` (`referred_user_id`),
  KEY `FK3gnvfqox8uod6n7vhhlge0lce` (`referrer_affiliator_id`),
  CONSTRAINT `FK3gnvfqox8uod6n7vhhlge0lce` FOREIGN KEY (`referrer_affiliator_id`) REFERENCES `affiliators` (`id`),
  CONSTRAINT `FKj2olu4j15ay3h74kaycue2ptx` FOREIGN KEY (`referred_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `meta_key` varchar(255) NOT NULL,
  `meta_name` varchar(255) NOT NULL,
  `meta_value` varchar(255) NOT NULL,
  `store_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKmnsm95blhmn8yxjlwoasftxpi` (`store_id`),
  CONSTRAINT `FKmnsm95blhmn8yxjlwoasftxpi` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `stocks`;
CREATE TABLE `stocks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `product_guid` varchar(50) NOT NULL,
  `qty` int(11) NOT NULL,
  `stock_in_detail_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKgyyl8jexq4qhnja1sohj639p8` (`stock_in_detail_id`),
  KEY `idx_stocks_product_created` (`product_guid`,`createdAt`),
  CONSTRAINT `FKdijuytuiujr2wsyfno5o631oo` FOREIGN KEY (`stock_in_detail_id`) REFERENCES `stock_in_details` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `stock_in_details`;
CREATE TABLE `stock_in_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `batch_number` varchar(50) DEFAULT NULL,
  `cost` decimal(10,2) NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `product_guid` varchar(50) NOT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `qty` int(11) NOT NULL,
  `stock_in_header_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKariwfcrb1v2kdfd0gfs4km2p0` (`stock_in_header_id`),
  CONSTRAINT `FKariwfcrb1v2kdfd0gfs4km2p0` FOREIGN KEY (`stock_in_header_id`) REFERENCES `stock_in_headers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `stock_in_headers`;
CREATE TABLE `stock_in_headers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `date` datetime(6) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `store_id` bigint(20) NOT NULL,
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `stock_out_details`;
CREATE TABLE `stock_out_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `cost` decimal(10,2) NOT NULL,
  `product_guid` varchar(50) NOT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `qty` int(11) NOT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `stock_id` bigint(20) DEFAULT NULL,
  `stock_out_header_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK71lp6hdkyk6xr4b869ex4g5fg` (`stock_id`),
  KEY `FKaychye6n47rd2l68obho5kfw3` (`stock_out_header_id`),
  CONSTRAINT `FK71lp6hdkyk6xr4b869ex4g5fg` FOREIGN KEY (`stock_id`) REFERENCES `stocks` (`id`),
  CONSTRAINT `FKaychye6n47rd2l68obho5kfw3` FOREIGN KEY (`stock_out_header_id`) REFERENCES `stock_out_headers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `stock_out_headers`;
CREATE TABLE `stock_out_headers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `date` datetime(6) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `store_id` bigint(20) NOT NULL,
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `stores`;
CREATE TABLE `stores` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `currency` enum('IDR','USD') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `tokens`;
CREATE TABLE `tokens` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `refreshToken` varchar(255) DEFAULT NULL,
  `revoked` bit(1) NOT NULL,
  `userAgent` varchar(255) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2dylsfo39lgjyqml2tbe0b0ss` (`user_id`),
  CONSTRAINT `FK2dylsfo39lgjyqml2tbe0b0ss` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `is_verified` bit(1) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `profile_path` varchar(255) DEFAULT NULL,
  `role` enum('Administrator','Kasir','Owner') DEFAULT NULL,
  `user_token` varchar(255) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  `user_data_id` bigint(20) DEFAULT NULL,
  `isEmailVerified` bit(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`),
  UNIQUE KEY `UKr43af9ap4edm43mmtq01oddj6` (`username`),
  UNIQUE KEY `UK7a849kccj7lwk5od479xdcp38` (`user_data_id`),
  CONSTRAINT `FKakgvxgowqbd2cuhfyx2kyfu0u` FOREIGN KEY (`user_data_id`) REFERENCES `user_data` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `user_data`;
CREATE TABLE `user_data` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `date_of_birth` datetime(6) DEFAULT NULL,
  `district` varchar(50) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `is_verified` bit(1) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `place_of_birth` varchar(50) DEFAULT NULL,
  `provice` varchar(50) DEFAULT NULL,
  `village` varchar(50) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `village_code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKdhxuydjj5l1vds6s9eex23dcr` (`email`),
  KEY `village_code` (`village_code`),
  CONSTRAINT `village_code` FOREIGN KEY (`village_code`) REFERENCES `villages` (`code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `user_has_store`;
CREATE TABLE `user_has_store` (
  `user_id` bigint(20) NOT NULL,
  `store_id` bigint(20) NOT NULL,
  KEY `FK6qiqxoom5n1caybxysjpwqc0i` (`store_id`),
  KEY `FKba463r99mupsplme2dxrkn1ds` (`user_id`),
  CONSTRAINT `FK6qiqxoom5n1caybxysjpwqc0i` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`),
  CONSTRAINT `FKba463r99mupsplme2dxrkn1ds` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


DROP TABLE IF EXISTS `villages`;
CREATE TABLE `villages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `updatedAt` datetime(6) DEFAULT NULL,
  `updatedBy` varchar(255) DEFAULT NULL,
  `code` varchar(255) NOT NULL,
  `meta` text DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `district_code` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKmf99e00e17ph6wpbs8sqskp6j` (`code`),
  KEY `FK1kbctl5s9tgap8yinl37nsb3n` (`district_code`),
  CONSTRAINT `FK1kbctl5s9tgap8yinl37nsb3n` FOREIGN KEY (`district_code`) REFERENCES `districts` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;


-- 2026-06-26 06:20:22 UTC
