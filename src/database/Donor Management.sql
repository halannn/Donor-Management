-- CREATE database Donor_Management; 
-- use Donor_Management;
-- DROP database Donor_Management;

CREATE TABLE facilitator (
  facilitator_id int PRIMARY KEY AUTO_INCREMENT,
  facilitator_name varchar(255),
  facilitator_type enum("Hospital","Clinic"),
  address varchar(255),
  contact varchar(20)
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
  full_name varchar(255),
  age int,
  blood_type enum("A+","A-","B+","B-","AB+","AB-","O+","O-"),
  gender enum("Male","Female"),
  address varchar(255),
  contact varchar(20),
  account_id int
);

CREATE TABLE transfusion (
  transfusion_id int PRIMARY KEY AUTO_INCREMENT,
  transfusion_date date,
  volume_ml int,
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
  user_name varchar(255), 
  email varchar(255),
  password varchar(255),
  role_id int
);

CREATE TABLE role (
  role_id int PRIMARY KEY AUTO_INCREMENT,
  role_name VARCHAR(255)
);

ALTER TABLE account ADD FOREIGN KEY (role_id) REFERENCES role (role_id);

ALTER TABLE donor ADD FOREIGN KEY (person_id) REFERENCES person (person_id);

ALTER TABLE donor ADD FOREIGN KEY (facilitator_id) REFERENCES facilitator (facilitator_id);

ALTER TABLE person ADD FOREIGN KEY (account_id) REFERENCES account (account_id);

ALTER TABLE transfusion ADD FOREIGN KEY (donor_id) REFERENCES donor (donor_id);

ALTER TABLE transfusion ADD FOREIGN KEY (facilitator_id) REFERENCES facilitator (facilitator_id);

ALTER TABLE transfusion ADD FOREIGN KEY (person_id) REFERENCES person (person_id);

ALTER TABLE stock ADD FOREIGN KEY (facilitator_id) REFERENCES facilitator (facilitator_id);

-- Create Stock
DELIMITER //
CREATE PROCEDURE CreateStock(
    IN p_blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    IN p_volume_ml INT,
    IN p_facilitator_id INT
)
BEGIN
	START TRANSACTION
    INSERT INTO `stock` (`blood_type`, `volume_ml`, `facilitator_id`) 
    VALUES (p_blood_type, p_volume_ml, p_facilitator_id);
   	COMMIT;
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
-- Search fasilitator from stock

DELIMITER //
CREATE PROCEDURE GetFacilitatorStockDetails(IN facilitatorID INT)
BEGIN
    DECLARE total_stock VARCHAR(255);
    
    -- Call the SumStock function
    SET total_stock = SumStock();
    
    -- Select facilitator and stock details
    SELECT 
        f.facilitator_name, 
        f.facilitator_type, 
        s.blood_type, 
        s.volume_ml, 
        total_stock AS total_volume
    FROM 
        stock s
    JOIN 
        facilitator f 
    ON 
        f.facilitator_id = s.facilitator_id
    WHERE 
        s.facilitator_id = facilitatorID
    GROUP BY 
        s.blood_type;
END //
DELIMITER ;

-- Create Facilitator
DELIMITER //
CREATE PROCEDURE CreateFacilitator(
    IN p_facilitator_name VARCHAR(255),
    IN p_facilitator_type enum("Hospital","Clinic"),
    IN p_address VARCHAR(255),
    IN p_contact VARCHAR(255)
)
BEGIN
    INSERT INTO `facilitator` (`facilitator_name`, `facilitator_type`, `address`, `contact`) 
    VALUES (p_facilitator_name, p_facilitator_type, p_address, p_contact);
END //
DELIMITER ;

-- Read All Facilitator Data
DELIMITER //
CREATE PROCEDURE ReadAllFacilitator()
BEGIN
    SELECT * FROM `facilitator`;
END //
DELIMITER ;

-- Read All Facilitator Data
DELIMITER //
CREATE PROCEDURE ReadFacilitatorById(
	IN p_facilitator_id INT
)
BEGIN
    SELECT * FROM `facilitator`
    WHERE facilitator_id = p_facilitator_id;
END //
DELIMITER ;

-- Update Specific Facilitator Data
DELIMITER //
CREATE PROCEDURE UpdateFacilitator(
	IN p_facilitator_id INT,
    IN p_facilitator_name VARCHAR(255),
    IN p_facilitator_type enum("Hospital","Clinic"),
    IN p_address VARCHAR(255),
    IN p_contact VARCHAR(255)
)
BEGIN
    UPDATE facilitator 
    SET 
    facilitator_name = p_facilitator_name ,
    facilitator_type = p_facilitator_type ,
    address = p_address ,
 	contact = p_contact 
    WHERE facilitator_id = p_facilitator_id;
END //
DELIMITER ;

-- Delete Specific Facilitator Data
DELIMITER //
CREATE PROCEDURE DeleteFacilitator(
    IN p_facilitator_id INT
)
BEGIN
    DELETE FROM `facilitator` WHERE `facilitator_id` = p_facilitator_id;
END //
DELIMITER ;

-- List Facilitators by Type
DELIMITER //
CREATE PROCEDURE ReadFacilitatorByType(IN p_facilitator_type ENUM('Hospital', 'Clinic'))
BEGIN
    SELECT 
        f.facilitator_type,
        f.facilitator_name,
        COUNT(d.donor_id) AS TotalDonors,
        COUNT(t.transfusion_id) AS TotalTransfusions
    FROM facilitator f
    LEFT JOIN donor d ON f.facilitator_id = d.facilitator_id
    LEFT JOIN transfusion t ON f.facilitator_id = t.facilitator_id
    WHERE f.facilitator_type = p_facilitator_type
    GROUP BY f.facilitator_id, f.facilitator_name, f.facilitator_type;
END //
DELIMITER ;

-- List All Blood Stock by Facilitator
DELIMITER //
CREATE PROCEDURE ReadFacilitatorStock()
BEGIN
    SELECT f.`facilitator_name`, s.`blood_type`, s.`volume_ml`
    FROM `stock` s
    JOIN `facilitator` f ON s.`facilitator_id` = f.`facilitator_id`;
END //
DELIMITER ;

-- List Donor Data
DELIMITER //
CREATE PROCEDURE ReadFacilitatorDonor()
BEGIN
    SELECT 
        f.`facilitator_name`, 
        d.`donation_date`, 
        p.`full_name` AS `donor_name`, 
        p.`blood_type`, 
        d.`volume_ml`
    FROM `donor` d
    JOIN `person` p ON d.`person_id` = p.`person_id`
    JOIN `facilitator` f ON d.`facilitator_id` = f.`facilitator_id`;
END //
DELIMITER ;

-- List Transfusion Data
DELIMITER //
CREATE PROCEDURE ReadFacilitatorTransfusion()
BEGIN
    SELECT 
        f.`facilitator_name`, 
        t.`transfusion_date`, 
        p.`full_name` AS `recipient_name`, 
        p.`blood_type`, 
        t.`volume_ml`
    FROM `transfusion` t
    JOIN `person` p ON t.`person_id` = p.`person_id`
    JOIN `facilitator` f ON t.`facilitator_id` = f.`facilitator_id`;
END //
DELIMITER ;

-- List Donor and Recipient Data by Year
DELIMITER //
CREATE PROCEDURE ReadFacilitatorCostumerByYear(IN p_year INT)
BEGIN
    SELECT 
        f.`facilitator_name`, 
        p1.`blood_type`, 
        d.`donation_date`, 
        p1.`full_name` AS `donor_name`, 
        d.`volume_ml` AS `donor_volume`, 
        t.`transfusion_date`, 
        p2.`full_name` AS `recipient_name`, 
        t.`volume_ml` AS `transfusion_volume`
    FROM `facilitator` f
    JOIN `donor` d ON d.`facilitator_id` = f.`facilitator_id`
    JOIN `person` p1 ON d.`person_id` = p1.`person_id`
    JOIN `transfusion` t ON t.`facilitator_id` = f.`facilitator_id`
    JOIN `person` p2 ON t.`person_id` = p2.`person_id`
    WHERE YEAR(d.`donation_date`) = p_year OR YEAR(t.`transfusion_date`) = p_year;
END //
DELIMITER ;

-- call ReadFacilitatorCostumerByYear(2024);

-- Create Donor
DELIMITER //
CREATE PROCEDURE CreateDonor(
	IN p_donation_date DATE,
	IN p_volume_ml INT,
	IN p_person_id INT,
	IN p_facilitator_id INT
)
BEGIN
	INSERT INTO donor (donation_date, volume_ml, person_id, facilitator_id)
	VALUES (p_donation_date , p_volume_ml, p_person_id, p_facilitator_id);
END // 
DELIMITER ;

-- Read All Donor
DELIMITER //
CREATE PROCEDURE ReadDonor()
BEGIN
	SELECT * FROM donor;
END //
DELIMITER ;

-- Read Donor By Id
DELIMITER //
CREATE PROCEDURE ReadDonorById(
	IN p_donor_id INT
)
BEGIN
	SELECT * FROM donor
	WHERE donor_id = p_donor_id;
END //
DELIMITER ;

-- Update Specific Donor Data
DELIMITER //
CREATE PROCEDURE UpdateDonor(
	IN p_donor_id INT,
	IN p_donation_date DATE,
	IN p_volume_ml INT,
	IN p_person_id INT,
	IN p_facilitator_id INT
)
BEGIN
	UPDATE donor SET
	donation_date = p_donation_date,
	volume_ml = p_volume_ml,
	person_id = p_person_id,
	facilitator_id = p_facilitator_id
	WHERE donor_id = p_donor_id;
END //
DELIMITER ;

-- Delete Spesific Donor Data
CREATE PROCEDURE DeleteDonor(
	IN p_donor_id INT
)
BEGIN
	DELETE FROM donor
	WHERE donor_id = p_donor_id;
END //
DELIMITER ;

-- Sum Donor
DELIMITER //
CREATE FUNCTION SumDonor()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_volume INT;  
    	SELECT SUM(volume_ml) INTO total_volume FROM donor;
	RETURN total_volume;
END //
DELIMITER ;

-- Create Transfusion
SELECT * from transfusion;
DELIMITER //
CREATE PROCEDURE CreateTransfusion(
	IN p_transfusion_date DATE,
	IN p_volume_ml INT,
	In p_donor_id INT,
	IN p_facilitator_id INT,
	IN p_person_id INT
)
BEGIN
	INSERT INTO transfusion (transfusion_date, volume_ml, donor_id, facilitator_id, person_id)
	VALUES (p_transfusion_date , p_volume_ml, p_donor_id, p_facilitator_id, p_person_id);
END // 
DELIMITER ;

-- Read All Transfusion
DELIMITER //
CREATE PROCEDURE ReadTransfusion()
BEGIN
	SELECT * FROM transfusion;
END //
DELIMITER ;

-- Read Transfusion By Id
DELIMITER //
CREATE PROCEDURE ReadTransfusionById(
	IN p_transfusion_id INT
)
BEGIN
	SELECT * FROM transfusion
	WHERE transfusion_id = p_transfusion_id;
END //
DELIMITER ;

-- Update Specific Transfusion Data
DELIMITER //
CREATE PROCEDURE UpdateTransfusion(
	IN p_transfusion_id INT,
	IN p_transfusion_date DATE,
	IN p_volume_ml INT,
	In p_donor_id INT,
	IN p_facilitator_id INT,
	IN p_person_id INT
)
BEGIN
	UPDATE transfusion SET
	transfusion_date = p_transfusion_date,
	volume_ml = p_volume_ml,
	donor_id = p_donor_id,
	facilitator_id = p_facilitator_id,
	person_id = p_person_id
	WHERE transfusion_id = p_transfusion_id;
END //
DELIMITER ;

-- Delete Spesific Transfusion Data
CREATE PROCEDURE DeleteTransfusion(
	IN p_transfusion_id INT
)
BEGIN
	DELETE FROM transfusion
	WHERE transfusion_id = p_transfusion_id;
END //
DELIMITER ;

-- Sum Transfusion
DELIMITER //
CREATE FUNCTION SumTransfusion()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_volume INT;  
    	SELECT SUM(volume_ml) INTO total_volume FROM transfusion;
	RETURN total_volume;
END //
DELIMITER ;

-- Create Person
DELIMITER //
CREATE PROCEDURE CreatePerson(
    IN p_full_name VARCHAR(255),
    IN p_age INT,
    IN p_blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    IN p_gender ENUM('Male', 'Female'),
    IN p_address VARCHAR(255),
    IN p_contact VARCHAR(255),
    IN p_account_id INT
)
BEGIN
    -- Start transaction to ensure atomicity
    START TRANSACTION;

    -- Check age eligibility
    IF p_age >= 18 AND p_age <= 60 THEN
        -- If eligible, insert data
        INSERT INTO person (full_name, age, blood_type, gender, address, contact, account_id)
        VALUES (p_full_name, p_age, p_blood_type, p_gender, p_address, p_contact, p_account_id);

        -- Commit transaction
        COMMIT;
    ELSE
        -- Rollback for invalid age
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Age must be between 18 and 60.';
    END IF;
END //
DELIMITER ;
CALL CreatePerson("John Doe",42, "O+","Male","606 Six St","6969696969",null);

-- Read Person
DELIMITER //
CREATE PROCEDURE ReadPerson()
BEGIN
	SELECT * FROM person;
END //
DELIMITER ;

-- Read Person By Id
CREATE PROCEDURE ReadPersonById(
	IN p_person_id INT
)
BEGIN
	SELECT * FROM person
	WHERE person_id = p_person_id;
END //
DELIMITER ;

-- Update Person By Id
DELIMITER //
CREATE PROCEDURE UpdatePerson(
	IN p_person_id INT,
	IN p_full_name VARCHAR(255),
    IN p_age INT,
    IN p_blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    IN p_gender ENUM('Male', 'Female'),
    IN p_address VARCHAR(255),
    IN p_contact VARCHAR(255),
    IN p_account_id INT
)
BEGIN
	UPDATE person SET
	full_name  = p_full_name,
    age = p_age,
    blood_type = p_blood_type,
    gender = p_gender ,
    address  = p_address,
    contact = p_contact
    WHERE person_id = p_person_id;
END //
DELIMITER ;

-- Delete Person By Id
DELIMITER //
CREATE PROCEDURE DeletePerson(
	IN p_person_id INT
)
BEGIN
	DELETE FROM person
	WHERE person_id = p_person_id;
END //
DELIMITER ;

-- Create User
DELIMITER //
CREATE PROCEDURE CreateAccount(
	IN p_email VARCHAR(255),
	IN p_password VARCHAR(255),
	IN p_role_id INT
)
BEGIN
	INSERT INTO account (email, password, role_id)
	VALUES (p_email, p_password, p_role_id);
END //
DELIMITER ;

-- Read User 
DELIMITER //
CREATE PROCEDURE ReadAccount()
BEGIN
	SELECT * FROM account;
END //
DELIMITER ;

-- Read User By Id 
DELIMITER //
CREATE PROCEDURE ReadAccountById(
	IN p_account_id INT
)
BEGIN
	SELECT * FROM account
	WHERE account_id = p_account_id;
END //
DELIMITER ;

-- Update User 
DELIMITER //
CREATE PROCEDURE UpdateAccount(
	IN p_account_id INT,
	IN p_email VARCHAR(255),
	IN p_password VARCHAR(255),
	IN p_role_id INT
)
BEGIN
	UPDATE account SET
	p_email = email,
	p_password = password,
	role_id = p_role_id
	WHERE account_id = p_account_id;
END //
DELIMITER ;

-- Delete User
DELIMITER //
CREATE PROCEDURE DeleteAccount(
	IN p_account_id INT
)
BEGIN
	DELETE FROM account
	WHERE account_id = p_account_id;
END //
DELIMITER ;

SELECT * FROM account;