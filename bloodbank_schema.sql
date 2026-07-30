-- ============================================================
-- Blood Bank Management System - Database Schema Initialization
-- Compatible with MySQL 8.x / MariaDB (XAMPP Environment)
-- ============================================================

CREATE DATABASE IF NOT EXISTS `bloodbank` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `bloodbank`;

-- ------------------------------------------------------------
-- Table 1: admin
-- Used by: net.javaguide.login.database.LoginDao
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_admin_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed default admin account
INSERT INTO `admin` (`email`, `password`) VALUES ('admin@gmail.com', 'admin123');

-- ------------------------------------------------------------
-- Table 2: user
-- Used by: UserRegisterServlet, DLoginServlet, RLoginServlet,
--          UpdateProfileServlet, RUpdateProfileServlet,
--          DonateBloodServlet, RequestBloodServlet,
--          donormanage.jsp, recipientmanage.jsp, manageProfile.jsp
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
    `u_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    `phone` VARCHAR(20) DEFAULT NULL,
    `address` TEXT DEFAULT NULL,
    `city` VARCHAR(100) DEFAULT NULL,
    `gender` VARCHAR(20) DEFAULT NULL,
    `dob` VARCHAR(50) DEFAULT NULL,
    `blood_group` VARCHAR(10) DEFAULT NULL,
    PRIMARY KEY (`u_id`),
    UNIQUE KEY `uk_user_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table 3: blood_camp
-- Used by: ArrangeCampServlet, DonateBloodServlet, camps.jsp
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `blood_camp`;
CREATE TABLE `blood_camp` (
    `c_id` INT NOT NULL AUTO_INCREMENT,
    `c_address` VARCHAR(255) NOT NULL,
    `c_city` VARCHAR(100) NOT NULL,
    `c_date` DATE NOT NULL,
    `c_time` TIME NOT NULL,
    PRIMARY KEY (`c_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table 4: donor
-- Used by: DonateBloodServlet, donatedUpdate.jsp, deleteDonor.jsp,
--          donormanage.jsp, Dviewhistory.jsp
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `donor`;
CREATE TABLE `donor` (
    `d_id` INT NOT NULL AUTO_INCREMENT,
    `u_id` INT NOT NULL,
    `d_at` VARCHAR(255) DEFAULT NULL,
    `d_date` DATE DEFAULT NULL,
    `donation_date` DATE DEFAULT NULL,
    `blood_units` INT NOT NULL DEFAULT 0,
    `d_age` INT DEFAULT NULL,
    `age` INT DEFAULT NULL,
    PRIMARY KEY (`d_id`),
    CONSTRAINT `fk_donor_user` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table 5: recipient
-- Used by: RequestBloodServlet, ConfirmRecipientServlet,
--          DeleteRecipientServlet, recipientmanage.jsp, Rviewhistory.jsp
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `recipient`;
CREATE TABLE `recipient` (
    `r_id` INT NOT NULL AUTO_INCREMENT,
    `u_id` INT NOT NULL,
    `r_bloodgroup` VARCHAR(10) NOT NULL,
    `r_date` DATE NOT NULL,
    `required_units` INT NOT NULL DEFAULT 1,
    `r_age` INT NOT NULL,
    `doctor_desc_pic` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`r_id`),
    CONSTRAINT `fk_recipient_user` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table 6: stock
-- Used by: ConfirmRecipientServlet, donatedUpdate.jsp,
--          admindesh.jsp, stock.jsp
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `stock`;
CREATE TABLE `stock` (
    `s_id` INT NOT NULL AUTO_INCREMENT,
    `blood_group` VARCHAR(10) NOT NULL,
    `units` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`s_id`),
    UNIQUE KEY `uk_stock_blood_group` (`blood_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed standard 8 blood groups in stock with initial 0 units
INSERT INTO `stock` (`blood_group`, `units`) VALUES
('A+', 0),
('A-', 0),
('B+', 0),
('B-', 0),
('AB+', 0),
('AB-', 0),
('O+', 0),
('O-', 0);
