-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 05, 2024 at 07:02 PM
-- Server version: 8.0.36
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `plum_v1`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addflat` (IN `u_username` VARCHAR(50), IN `u_flatno` VARCHAR(10), IN `role` VARCHAR(20))   BEGIN
    DECLARE id INT;

    -- Retrieve the new user's ID
    SELECT userid INTO id FROM user WHERE username = u_username;

    -- Update the flats table based on the role
    IF role = 'owner' THEN
        UPDATE flats SET owner = id WHERE flatno = u_flatno;
    ELSEIF role = 'tenant' THEN
        UPDATE flats SET tenant = id WHERE flatno = u_flatno;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `adduser` (IN `u_username` VARCHAR(50), IN `u_password` VARCHAR(50), IN `u_fname` VARCHAR(50), IN `u_lname` VARCHAR(50), IN `u_email` VARCHAR(50), IN `u_contact` LONG, IN `u_flatno` VARCHAR(10), IN `role` VARCHAR(20))   BEGIN
    DECLARE id INT;

    -- Insert new user
    INSERT INTO user (username, password, fname, lname, enmail, contact) 
    VALUES (u_username, u_password, u_fname, u_lname, u_email, u_contact);

    -- Retrieve the new user's ID
    SELECT userid INTO id FROM user WHERE username = u_username;

    -- Update the flats table based on the role
    IF role = 'owner' THEN
        UPDATE flats SET owner = id WHERE flatno = u_flatno;
    ELSEIF role = 'tenant' THEN
        UPDATE flats SET tenant = id WHERE flatno = u_flatno;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertComplaintByUsername` (IN `p_username` VARCHAR(50), IN `p_title` VARCHAR(255), IN `p_description` VARCHAR(1000))   BEGIN
    DECLARE v_userId INT;

    -- Retrieve the UserId based on the username
    SELECT UserId INTO v_userId
    FROM user
    WHERE username = p_username;

    -- Insert the complaint using the retrieved UserId
    INSERT INTO complaints (user_id, title, description)
    VALUES (v_userId, p_title, p_description);
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `count_owners` () RETURNS INT DETERMINISTIC BEGIN
    DECLARE owner_count INT;
    SELECT COUNT(*) INTO owner_count FROM flats WHERE owner IS NOT NULL;
    RETURN owner_count;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `count_tenants` () RETURNS INT DETERMINISTIC BEGIN
    DECLARE tenant_count INT;
    SELECT COUNT(*) INTO tenant_count FROM flats WHERE tenant IS NOT NULL;
    RETURN tenant_count;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `committee`
--

CREATE TABLE `committee` (
  `memberid` int NOT NULL,
  `userid` int DEFAULT NULL,
  `designation` varchar(50) DEFAULT NULL,
  `createdate` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `complaints`
--

CREATE TABLE `complaints` (
  `complaint_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `create_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `complaints`
--

INSERT INTO `complaints` (`complaint_id`, `user_id`, `title`, `description`, `create_date`) VALUES
(1, 1, 'Water Leakage', 'There is water leakage in the kitchen.', '2024-06-29 17:10:22'),
(2, 2, 'Noisy Neighbors', 'The neighbors are making a lot of noise.', '2024-06-29 17:10:22'),
(3, 3, 'Broken Window', 'The window in the bedroom is broken.', '2024-06-29 17:10:22'),
(4, 4, 'Pest Control', 'We need pest control services.', '2024-06-29 17:10:22'),
(5, 5, 'Parking Issue', 'There is an issue with the parking space.', '2024-06-29 17:10:22'),
(6, 6, 'AC Not Working', 'The air conditioner is not working.', '2024-06-29 17:10:22'),
(7, 7, 'Internet Issue', 'There is an issue with the internet connection.', '2024-06-29 17:10:22'),
(8, 8, 'Electricity Problem', 'There is a problem with the electricity supply.', '2024-06-29 17:10:22'),
(9, 9, 'Water Shortage', 'There is a water shortage in the building.', '2024-06-29 17:10:22'),
(10, 10, 'Lift Not Working', 'The lift is not working.', '2024-06-29 17:10:22'),
(NULL, 4, 'Leakage problem', 'ABCDE\r\n', '2024-08-03 08:32:00'),
(NULL, 4, 'Leakage problem', 'XYZABC', '2024-08-05 14:32:11'),
(NULL, 4, 'Leakage problem', 'ADSRTS', '2024-08-05 14:37:58'),
(NULL, 4, 'Leakage problem', 'gDSHT', '2024-08-05 14:38:14');

-- --------------------------------------------------------

--
-- Table structure for table `complaints_resolved`
--

CREATE TABLE `complaints_resolved` (
  `resolveID` int DEFAULT NULL,
  `complaint_id` int DEFAULT NULL,
  `resolved_by` int DEFAULT NULL,
  `comments` varchar(1000) DEFAULT NULL,
  `resolved_date` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `flats`
--

CREATE TABLE `flats` (
  `flatno` varchar(10) NOT NULL,
  `owner` int DEFAULT NULL,
  `tenant` int DEFAULT NULL,
  `floor` int DEFAULT NULL,
  `wing` varchar(5) DEFAULT NULL,
  `carpet_area` float DEFAULT NULL,
  `flat_BHK` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `flats`
--

INSERT INTO `flats` (`flatno`, `owner`, `tenant`, `floor`, `wing`, `carpet_area`, `flat_BHK`) VALUES
('A101', NULL, 2, 1, 'A', 1000.5, 2),
('A102', 2, 3, 1, 'A', 900, 2),
('A201', 3, 4, 2, 'A', 1200.5, 3),
('A202', 4, 5, 2, 'A', 1150, 3),
('B101', 5, 6, 1, 'B', 1300.5, 3),
('B102', 6, 7, 1, 'B', 1250, 3),
('B201', 7, 8, 2, 'B', 1500.5, 4),
('B202', 8, 9, 2, 'B', 1400, 4),
('C101', 9, 10, 1, 'C', 1100.5, 2),
('C102', 10, 1, 1, 'C', 1000, 2);

--
-- Triggers `flats`
--
DELIMITER $$
CREATE TRIGGER `before_inserting_in_flats` BEFORE INSERT ON `flats` FOR EACH ROW BEGIN
    DECLARE owner_count INT DEFAULT 0;
    DECLARE tenant_count INT DEFAULT 0;

    -- Check if there is already an owner for the flat
    IF (NEW.owner IS NOT NULL) THEN
        SELECT COUNT(*) INTO owner_count FROM flats WHERE flatno = NEW.flatno AND owner IS NOT NULL;
        
        IF owner_count > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Owner already exists for this flat. Cannot update owner.';
        END IF;
    END IF;
    
    -- Check if there is already a tenant for the flat
    IF (NEW.tenant IS NOT NULL) THEN
        SELECT COUNT(*) INTO tenant_count FROM flats WHERE flatno = NEW.flatno AND tenant IS NOT NULL;
        
        IF tenant_count > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tenant already exists for this flat. Cannot update tenant.';
        END IF;
    END IF;

    -- Ensure a flat has an owner before assigning a tenant
    IF (NEW.tenant IS NOT NULL AND NEW.owner IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A flat must have an owner before assigning a tenant.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_cost`
--

CREATE TABLE `maintenance_cost` (
  `maintenance_cost_id` int NOT NULL,
  `carpet_area` float DEFAULT NULL,
  `cost` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `maintenance_cost`
--

INSERT INTO `maintenance_cost` (`maintenance_cost_id`, `carpet_area`, `cost`) VALUES
(1, 1000.5, 2000),
(2, 900, 1800),
(3, 1200.5, 2400),
(4, 1150, 2300),
(5, 1300.5, 2600),
(6, 1250, 2500),
(7, 1500.5, 3000),
(8, 1400, 2800),
(9, 1100.5, 2200),
(10, 1000, 2000);

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_payment`
--

CREATE TABLE `maintenance_payment` (
  `maintenanceid` int NOT NULL,
  `flatno` varchar(10) DEFAULT NULL,
  `paid_by` int DEFAULT NULL,
  `month_of_maintenance` int DEFAULT NULL,
  `year_of_maintenance` int DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `maintenance_payment`
--

INSERT INTO `maintenance_payment` (`maintenanceid`, `flatno`, `paid_by`, `month_of_maintenance`, `year_of_maintenance`, `status`) VALUES
(1, 'A101', 1, 6, 2024, 'Paid'),
(2, 'A102', 2, 6, 2024, 'Pending'),
(3, 'A201', 3, 6, 2024, 'Paid'),
(4, 'A202', 4, 6, 2024, 'Pending'),
(5, 'B101', 5, 6, 2024, 'Paid'),
(6, 'B102', 6, 6, 2024, 'Pending'),
(7, 'B201', 7, 6, 2024, 'Paid'),
(8, 'B202', 8, 6, 2024, 'Pending'),
(9, 'C101', 9, 6, 2024, 'Paid'),
(10, 'C102', 10, 6, 2024, 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `notices`
--

CREATE TABLE `notices` (
  `noticeId` int DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` varchar(1000) DEFAULT NULL,
  `createdby` int DEFAULT NULL,
  `createdate` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notices`
--

INSERT INTO `notices` (`noticeId`, `title`, `content`, `createdby`, `createdate`) VALUES
(1, 'Annual Meeting', 'The annual meeting will be held on July 5th.', 1, '2024-06-29 22:40:00'),
(2, 'Maintenance Notice', 'Scheduled maintenance on June 30th.', 2, '2024-06-29 22:40:00'),
(3, 'Fire Drill', 'Fire drill on July 1st.', 3, '2024-06-29 22:40:00'),
(4, 'Pool Closure', 'The pool will be closed for cleaning on July 2nd.', 4, '2024-06-29 22:40:00'),
(5, 'New Parking Rules', 'New parking rules will be enforced from July 3rd.', 5, '2024-06-29 22:40:00'),
(6, 'Water Supply Notice', 'Water supply will be disrupted on July 4th.', 6, '2024-06-29 22:40:00'),
(7, 'Gym Renovation', 'Gym renovation from July 6th to July 10th.', 7, '2024-06-29 22:40:00'),
(8, 'Elevator Maintenance', 'Elevator maintenance on July 7th.', 8, '2024-06-29 22:40:00'),
(9, 'Security Update', 'Security update meeting on July 8th.', 9, '2024-06-29 22:40:00'),
(10, 'Community Event', 'Community event on July 9th.', 10, '2024-06-29 22:40:00');

-- --------------------------------------------------------

--
-- Table structure for table `notice_send_to`
--

CREATE TABLE `notice_send_to` (
  `noticeId` int DEFAULT NULL,
  `userId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notice_send_to`
--

INSERT INTO `notice_send_to` (`noticeId`, `userId`) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10),
(6, 1),
(6, 2),
(7, 3),
(7, 4),
(8, 5),
(8, 6),
(9, 7),
(9, 8),
(10, 9),
(10, 10);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `UserId` int NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `fname` varchar(50) DEFAULT NULL,
  `lname` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `contact` mediumtext,
  `createdate` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`UserId`, `username`, `password`, `fname`, `lname`, `email`, `contact`, `createdate`) VALUES
(1, 'john_doe', '482c811da5d5b4bc6d497ffa98491e38', 'John', 'Doe', 'john.doe@example.com', '1234567890', '2024-06-29 22:39:13'),
(2, 'jane_smith', '482c811da5d5b4bc6d497ffa98491e38', 'Jane', 'Smith', 'jane.smith@example.com', '1234567891', '2024-06-29 22:39:13'),
(3, 'mike_jones', '482c811da5d5b4bc6d497ffa98491e38', 'Mike', 'Jones', 'mike.jones@example.com', '1234567892', '2024-06-29 22:39:13'),
(4, 'emily_davis', '482c811da5d5b4bc6d497ffa98491e38', 'Emily', 'Davis', 'emily.davis@example.com', '1234567893', '2024-06-29 22:39:13'),
(5, 'chris_brown', '482c811da5d5b4bc6d497ffa98491e38', 'Chris', 'Brown', 'chris.brown@example.com', '1234567894', '2024-06-29 22:39:13'),
(6, 'sarah_lee', '482c811da5d5b4bc6d497ffa98491e38', 'Sarah', 'Lee', 'sarah.lee@example.com', '1234567895', '2024-06-29 22:39:13'),
(7, 'david_miller', '482c811da5d5b4bc6d497ffa98491e38', 'David', 'Miller', 'david.miller@example.com', '1234567896', '2024-06-29 22:39:13'),
(8, 'lisa_wilson', '482c811da5d5b4bc6d497ffa98491e38', 'Lisa', 'Wilson', 'lisa.wilson@example.com', '1234567897', '2024-06-29 22:39:13'),
(9, 'james_taylor', '482c811da5d5b4bc6d497ffa98491e38', 'James', 'Taylor', 'james.taylor@example.com', '1234567898', '2024-06-29 22:39:13'),
(10, 'laura_moore', '482c811da5d5b4bc6d497ffa98491e38', 'Laura', 'Moore', 'laura.moore@example.com', '1234567899', '2024-06-29 22:39:13'),
(12, 'avishkar', '482c811da5d5b4bc6d497ffa98491e38', 'Avishkar', 'pawar', 'avishkar.pawar@gmail.com', '8623005430', '2024-07-06 10:07:06'),
(13, 'avishkar.004', '482c811da5d5b4bc6d497ffa98491e38', 'Avishkar', 'Pawar', 'avishkarp04@gmail.com', '8623005430', '2024-07-06 13:03:42');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `committee`
--
ALTER TABLE `committee`
  ADD PRIMARY KEY (`memberid`);

--
-- Indexes for table `flats`
--
ALTER TABLE `flats`
  ADD PRIMARY KEY (`flatno`);

--
-- Indexes for table `maintenance_cost`
--
ALTER TABLE `maintenance_cost`
  ADD PRIMARY KEY (`maintenance_cost_id`);

--
-- Indexes for table `maintenance_payment`
--
ALTER TABLE `maintenance_payment`
  ADD PRIMARY KEY (`maintenanceid`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`UserId`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `committee`
--
ALTER TABLE `committee`
  MODIFY `memberid` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `maintenance_cost`
--
ALTER TABLE `maintenance_cost`
  MODIFY `maintenance_cost_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `maintenance_payment`
--
ALTER TABLE `maintenance_payment`
  MODIFY `maintenanceid` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `UserId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
