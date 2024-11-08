-- CREATE database Donor_Management; 
-- use Donor_Management;
-- DROP database Donor_Management;

CREATE TABLE facilitator (
  facilitator_id int PRIMARY KEY AUTO_INCREMENT,
  facilitator_name varchar(100),
  facilitator_type enum("Hospital","Clinic"),
  address varchar(100),
  contact varchar(15)
);

CREATE TABLE donor (
  donor_id int PRIMARY KEY AUTO_INCREMENT,
  donation_date date,
  volume_ml int,
  person_id int,
  facilitator_id int
);

CREATE TABLE person (
  person_id int PRIMARY KEY AUTO_INCREMENT,
  full_name varchar(100),
  age int,
  blood_type enum("A+","A-","B+","B-","AB+","AB-","O+","O-"),
  gender enum("Male","Female"),
  address varchar(100),
  contact varchar(15),
  account_id int
);

CREATE TABLE transfusion (
  transfusion_id int PRIMARY KEY AUTO_INCREMENT,
  transfusion_date date,
  volume_ml int,
  donor_id int,
  facilitator_id int,
  person_id int
);

CREATE TABLE stock (
  stock_id int PRIMARY KEY AUTO_INCREMENT,
  blood_type enum("A+","A-","B+","B-","AB+","AB-","O+","O-"),
  volume_ml int,
  facilitator_id int
);

CREATE TABLE account (
  account_id int PRIMARY KEY AUTO_INCREMENT,
  email varchar(255),
  password varchar(255),
  role_id int
);

CREATE TABLE role (
  role_id int PRIMARY KEY AUTO_INCREMENT,
  role_name enum("User","Admin")
);

ALTER TABLE donor ADD FOREIGN KEY (person_id) REFERENCES person (person_id);

ALTER TABLE donor ADD FOREIGN KEY (facilitator_id) REFERENCES facilitator (facilitator_id);

ALTER TABLE person ADD FOREIGN KEY (account_id) REFERENCES account (account_id);

ALTER TABLE transfusion ADD FOREIGN KEY (donor_id) REFERENCES donor (donor_id);

ALTER TABLE transfusion ADD FOREIGN KEY (facilitator_id) REFERENCES facilitator (facilitator_id);

ALTER TABLE transfusion ADD FOREIGN KEY (person_id) REFERENCES person (person_id);

ALTER TABLE stock ADD FOREIGN KEY (facilitator_id) REFERENCES facilitator (facilitator_id);

ALTER TABLE account ADD FOREIGN KEY (role_id) REFERENCES role (role_id);

-- Insert sample data into role
INSERT INTO `role` (`role_name`) VALUES
('User'),
('Admin');

-- Insert sample data into account
INSERT INTO `account` (`email`, `password`, `role_id`) VALUES
('user1@example.com', 'password1', 1),
('user2@example.com', 'password2', 1),
('user3@example.com', 'password3', 1),
('user4@example.com', 'password4', 1),
('user5@example.com', 'password5', 1),
('user6@example.com', 'password6', 1),
('user7@example.com', 'password7', 1),
('user8@example.com', 'password8', 1),
('user9@example.com', 'password9', 1),
('admin@example.com', 'adminpass', 2);

-- Insert sample data into facilitator
INSERT INTO `facilitator` (`facilitator_name`, `facilitator_type`, `address`, `contact`) VALUES
('General Hospital', 'Hospital', '123 Main St', '1234567890'),
('City Clinic', 'Clinic', '456 Elm St', '0987654321'),
('Regional Medical Center', 'Hospital', '789 Oak St', '1112223333'),
('Downtown Clinic', 'Clinic', '321 Pine St', '4445556666'),
('Valley Hospital', 'Hospital', '654 Maple St', '7778889999'),
('Greenwood Clinic', 'Clinic', '987 Cedar St', '1011121314'),
('Metro Hospital', 'Hospital', '159 Birch St', '1516171819'),
('Suburban Clinic', 'Clinic', '753 Walnut St', '2021222324'),
('Seaside Hospital', 'Hospital', '852 Cherry St', '2526272829'),
('Mountain Clinic', 'Clinic', '951 Ash St', '3031323334');

-- Insert sample data into person
INSERT INTO `person` (`full_name`, `age`, `blood_type`, `gender`, `address`, `contact`, `account_id`) VALUES
('John Doe', 30, 'A+', 'Male', '101 First St', '5555550001', 1),
('Jane Smith', 28, 'B-', 'Female', '202 Second St', '5555550002', 2),
('Alice Johnson', 35, 'O+', 'Female', '303 Third St', '5555550003', 3),
('Bob Brown', 40, 'AB-', 'Male', '404 Fourth St', '5555550004', 4),
('Charlie Davis', 45, 'A-', 'Male', '505 Fifth St', '5555550005', 5),
('Emily Clark', 25, 'B+', 'Female', '606 Sixth St', '5555550006', 6),
('George Miller', 50, 'O-', 'Male', '707 Seventh St', '5555550007', 7),
('Hannah Wilson', 32, 'AB+', 'Female', '808 Eighth St', '5555550008', 8),
('Isaac Martinez', 29, 'A+', 'Male', '909 Ninth St', '5555550009', 9),
('Sophia Lewis', 27, 'B-', 'Female', '1010 Tenth St', '5555550010', 10);

-- Insert sample data into donor
INSERT INTO `donor` (`donation_date`, `volume_ml`, `person_id`, `facilitator_id`) VALUES
('2024-10-01', 500, 1, 1),
('2024-10-02', 450, 2, 2),
('2024-10-03', 550, 3, 3),
('2024-10-04', 600, 4, 4),
('2024-10-05', 500, 5, 5),
('2024-10-06', 450, 6, 6),
('2024-10-07', 500, 7, 7),
('2024-10-08', 550, 8, 8),
('2024-10-09', 600, 9, 9),
('2024-10-10', 500, 10, 10);

-- Insert sample data into transfusion
INSERT INTO `transfusion` (`transfusion_date`, `volume_ml`, `donor_id`, `facilitator_id`, `person_id`) VALUES
('2024-10-11', 300, 1, 1, 2),
('2024-10-12', 250, 2, 2, 3),
('2024-10-13', 350, 3, 3, 4),
('2024-10-14', 400, 4, 4, 5),
('2024-10-15', 300, 5, 5, 6),
('2024-10-16', 250, 6, 6, 7),
('2024-10-17', 300, 7, 7, 8),
('2024-10-18', 350, 8, 8, 9),
('2024-10-19', 400, 9, 9, 10),
('2024-10-20', 300, 10, 10, 1);

-- Insert sample data into stock
INSERT INTO `stock` (`blood_type`, `volume_ml`, `facilitator_id`) VALUES
('A+', 1000, 1),
('B-', 800, 2),
('O+', 1200, 3),
('AB-', 900, 4),
('A-', 950, 5),
('B+', 1100, 6),
('O-', 850, 7),
('AB+', 1000, 8),
('A+', 1150, 9),
('B-', 900, 10);

-- Create Stock
DELIMITER //
CREATE PROCEDURE CreateStock(
    IN p_blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    IN p_volume_ml INT,
    IN p_facilitator_id INT
)
BEGIN
    INSERT INTO `stock` (`blood_type`, `volume_ml`, `facilitator_id`) 
    VALUES (p_blood_type, p_volume_ml, p_facilitator_id);
END //
DELIMITER ;

-- Read All Stock Data
DELIMITER //
CREATE PROCEDURE ReadAllStock()
BEGIN
    SELECT * FROM `stock`;
END //
DELIMITER ;

-- Read Stock Data By Id
DELIMITER //
CREATE PROCEDURE ReadStockById(
	IN p_stock_id INT
)
BEGIN
    SELECT * FROM `stock`
    WHERE `stock_id` = p_stock_id;
END //
DELIMITER ;

-- Update Specific Stock Data

DELIMITER //
CREATE PROCEDURE UpdateStock(
    IN p_stock_id INT,
    IN p_blood_type enum("A+","A-","B+","B-","AB+","AB-","O+","O-"), 
    IN p_volume_ml INT
)
BEGIN
    UPDATE `stock`
    SET 
    `blood_type` = p_blood_type,
    `volume_ml` = p_volume_ml
    WHERE `stock_id` = p_stock_id;
END //
DELIMITER ;

-- Delete Specific Stock Data
DELIMITER //
CREATE PROCEDURE DeleteStock(
    IN p_stock_id INT
)
BEGIN
    DELETE FROM `stock` WHERE `stock_id` = p_stock_id;
END //
DELIMITER ;

-- Sum Stock
DELIMITER //
CREATE FUNCTION SumStock() 
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE total_volume INT;
    DECLARE result VARCHAR(255);
    
    SELECT SUM(volume_ml) INTO total_volume FROM stock;
    SET result = CONCAT('Total Volume: ', total_volume);
    RETURN result;
END //
DELIMITER ;

-- SELECT SumStock();

-- Update Stock on Donor Addition
DELIMITER //
CREATE TRIGGER UpdateStockOnDonor
AFTER INSERT ON `donor`
FOR EACH ROW
BEGIN
    UPDATE `stock`
    SET `volume_ml` = `volume_ml` + NEW.`volume_ml`
    WHERE `blood_type` = (SELECT `blood_type` FROM `person` WHERE `person_id` = NEW.`person_id`)
      AND `facilitator_id` = NEW.`facilitator_id`;
END //
DELIMITER ;

-- Update Stock on Transfusion Addition
DELIMITER //
CREATE TRIGGER UpdateStockOnTransfusion
AFTER INSERT ON `transfusion`
FOR EACH ROW
BEGIN
    UPDATE `stock`
    SET `volume_ml` = `volume_ml` - NEW.`volume_ml`
    WHERE `blood_type` = (SELECT `blood_type` FROM `person` WHERE `person_id` = NEW.`person_id`)
      AND `facilitator_id` = NEW.`facilitator_id`;
END //
DELIMITER ;
