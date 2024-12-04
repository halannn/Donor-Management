CREATE database Donor_Management; 
use Donor_Management;
-- DROP database Donor_Management;

CREATE TABLE account (
  account_id int PRIMARY KEY AUTO_INCREMENT,
  username varchar(255), 
  email varchar(255),
  password varchar(255),
  is_admin boolean
);

CREATE TABLE person (
  person_id int PRIMARY KEY AUTO_INCREMENT,
  full_name varchar(255),
  age int,
  blood_type enum("A+","A-","B+","B-","AB+","AB-","O+","O-"),
  gender enum("Male","Female"),
  address varchar(255),
  contact varchar(20),
  account_id int,
  FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE
);

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
  facilitator_id int,
  FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE CASCADE,
  FOREIGN KEY (facilitator_id) REFERENCES facilitator(facilitator_id) ON DELETE CASCADE
);

CREATE TABLE transfusion (
  transfusion_id int PRIMARY KEY AUTO_INCREMENT,
  transfusion_date date,
  volume_ml int,
  facilitator_id int,
  person_id int,
  FOREIGN KEY (facilitator_id) REFERENCES facilitator(facilitator_id) ON DELETE CASCADE,
  FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE CASCADE
);

CREATE TABLE stock (
  stock_id int PRIMARY KEY AUTO_INCREMENT,
  blood_type enum("A+","A-","B+","B-","AB+","AB-","O+","O-"),
  volume_ml int,
  facilitator_id int,
  FOREIGN KEY (facilitator_id) REFERENCES facilitator(facilitator_id) ON DELETE CASCADE
);

DELIMITER //

CREATE TRIGGER delete_donor_after_person_delete
AFTER DELETE ON person
FOR EACH ROW
BEGIN
    DELETE FROM donor WHERE person_id = OLD.person_id;
END //

CREATE TRIGGER delete_transfusion_after_person_delete
AFTER DELETE ON person
FOR EACH ROW
BEGIN
    DELETE FROM transfusion WHERE person_id = OLD.person_id;
END //

CREATE TRIGGER delete_stock_after_facilitator_delete
AFTER DELETE ON facilitator
FOR EACH ROW
BEGIN
    DELETE FROM stock WHERE facilitator_id = OLD.facilitator_id;
    DELETE FROM donor WHERE facilitator_id = OLD.facilitator_id;
    DELETE FROM transfusion WHERE facilitator_id = OLD.facilitator_id;
END //

DELIMITER ;

-- Read Facilitator Data (All or By ID)
DELIMITER //
CREATE PROCEDURE ReadFacilitator(
    IN p_facilitator_id INT
)
begin
	START TRANSACTION;
    IF p_facilitator_id IS NULL THEN
        SELECT facilitator_id, facilitator_name, facilitator_type, address, contact FROM `facilitator`;
    ELSE
        SELECT facilitator_id, facilitator_name, facilitator_type, address, contact FROM `facilitator`
        WHERE `facilitator_id` = p_facilitator_id;
    END IF;
   commit;
END //
DELIMITER ;

-- Read Facilitators by Type
DELIMITER //
CREATE PROCEDURE ReadFacilitatorByType(IN p_facilitator_type VARCHAR(255))
begin
	START TRANSACTION;
    SELECT 
        f.facilitator_type,
        f.facilitator_name,
        COUNT(d.donor_id) AS TotalDonors,
        COUNT(t.transfusion_id) AS TotalTransfusions
    FROM facilitator f
    left JOIN donor d ON f.facilitator_id = d.facilitator_id
    left JOIN transfusion t ON f.facilitator_id = t.facilitator_id
    WHERE p_facilitator_type IS NULL OR f.facilitator_type = p_facilitator_type
    GROUP BY f.facilitator_id, f.facilitator_name, f.facilitator_type;
   commit;
END //
DELIMITER ;

-- Read Blood Stock by Facilitator
DELIMITER //
CREATE PROCEDURE ReadFacilitatorStock()
BEGIN
    SELECT f.`facilitator_name`, s.`blood_type`, SUM(s.`volume_ml`) as total_volume
    FROM `stock` s
    JOIN `facilitator` f ON s.`facilitator_id` = f.`facilitator_id`
    GROUP BY f.`facilitator_name`, s.`blood_type`
    ORDER BY f.`facilitator_name`;
END //
DELIMITER ;

-- Read Donor Data
DELIMITER //
CREATE PROCEDURE ReadFacilitatorDonor()
begin
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

-- Read Transfusion Data
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

-- Create Facilitator
DELIMITER //
CREATE PROCEDURE CreateFacilitator(
    IN p_facilitator_name VARCHAR(255),
    IN p_facilitator_type enum("Hospital","Clinic"),
    IN p_address VARCHAR(255),
    IN p_contact VARCHAR(255)
)
begin
	START TRANSACTION;
    INSERT INTO `facilitator` (`facilitator_name`, `facilitator_type`, `address`, `contact`) 
    VALUES (p_facilitator_name, p_facilitator_type, p_address, p_contact);
   commit;
END //
DELIMITER ;

-- Update Specific Facilitator Data with Transaction
DELIMITER //
CREATE PROCEDURE UpdateFacilitator(
    IN p_facilitator_id INT,
    IN p_facilitator_name VARCHAR(255),
    IN p_facilitator_type ENUM('Hospital', 'Clinic'),
    IN p_address VARCHAR(255),
    IN p_contact VARCHAR(255)
)
BEGIN
    START TRANSACTION;
    UPDATE `facilitator` 
    SET 
        `facilitator_name` = p_facilitator_name,
        `facilitator_type` = p_facilitator_type,
        `address` = p_address,
        `contact` = p_contact
    WHERE 
        `facilitator_id` = p_facilitator_id;
        commit;
    END IF;
END //
DELIMITER ;

-- Delete Specific Facilitator
DELIMITER //
CREATE PROCEDURE DeleteFacilitator(
    IN p_facilitator_id INT
)
BEGIN
    START TRANSACTION;
    DELETE FROM `facilitator` 
    WHERE `facilitator_id` = p_facilitator_id;
        COMMIT;
    END IF;
END //
DELIMITER ;

-- Read Stock Data (All or By ID)
DELIMITER //
CREATE PROCEDURE ReadStock(
    IN p_stock_id INT
)
begin
	START transaction;
    IF p_stock_id IS NULL THEN
        SELECT stock_id, blood_type, volume_ml, facilitator_id FROM `stock`;
    ELSE
        SELECT stock_id, blood_type, volume_ml, facilitator_id FROM `stock` WHERE `stock_id` = p_stock_id;
    END IF;
   COMMIT;
END //
DELIMITER ;

-- Create Stock
DELIMITER //
CREATE PROCEDURE CreateStock(
    IN p_blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    IN p_volume_ml INT,
    IN p_facilitator_id INT
)
BEGIN
	START transaction;
    INSERT INTO `stock` (`blood_type`, `volume_ml`, `facilitator_id`) 
    VALUES (p_blood_type, p_volume_ml, p_facilitator_id);
   	COMMIT;
END //
DELIMITER ;

-- Update Specific Stock Data
DELIMITER //
CREATE PROCEDURE UpdateStock(
    IN p_stock_id INT,
    IN p_blood_type enum("A+","A-","B+","B-","AB+","AB-","O+","O-"), 
    IN p_volume_ml INT
)
begin
	START transaction;
    UPDATE `stock`
    SET 
    `blood_type` = p_blood_type,
    `volume_ml` = p_volume_ml
    WHERE `stock_id` = p_stock_id;
    COMMIT;
END //
DELIMITER ;

-- Delete Specific Stock Data
DELIMITER //
CREATE PROCEDURE DeleteStock(
    IN p_stock_id INT
)
begin
	START TRANSACTION;
    DELETE FROM `stock` WHERE `stock_id` = p_stock_id;
    COMMIT;
END //
DELIMITER ; 

-- Update Stock on Donor Addition
DELIMITER //
CREATE TRIGGER UpdateStockAfterDonor
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
CREATE TRIGGER UpdateStockAfterTransfusion
AFTER INSERT ON `transfusion`
FOR EACH ROW
BEGIN
    UPDATE `stock`
    SET `volume_ml` = `volume_ml` - NEW.`volume_ml`
    WHERE `blood_type` = (SELECT `blood_type` FROM `person` WHERE `person_id` = NEW.`person_id`)
      AND `facilitator_id` = NEW.`facilitator_id`;
END //
DELIMITER ;



-- Create Donor
DELIMITER //
CREATE PROCEDURE CreateDonor(
	IN p_donation_date DATE,
	IN p_volume_ml INT,
	IN p_person_id INT,
	IN p_facilitator_id INT
)
begin
	START transaction;
	INSERT INTO donor (donation_date, volume_ml, person_id, facilitator_id)
	VALUES (p_donation_date , p_volume_ml, p_person_id, p_facilitator_id);
	commit;
END // 
DELIMITER ;

-- Read All Donor
DELIMITER //
create procedure ReadDonor(
	in p_donor_id INT
)
BEGIN
    IF p_donor_id IS NULL THEN
        SELECT donor_id, donation_date, volume_ml, person_id, facilitator_id FROM `donor`;
    ELSE
        SELECT donor_id, donation_date, volume_ml, person_id, facilitator_id FROM `donor`
        WHERE `donor_id` = p_donor_id;
    END IF;
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
begin
	start transaction;
	UPDATE donor SET
	donation_date = p_donation_date,
	volume_ml = p_volume_ml,
	person_id = p_person_id,
	facilitator_id = p_facilitator_id
	WHERE donor_id = p_donor_id;
commit;
END //
DELIMITER ;

-- Delete Spesific Donor Data
DELIMITER //
CREATE PROCEDURE DeleteDonor(
	IN p_donor_id INT
)
begin
	start transaction;
	DELETE FROM donor
	WHERE donor_id = p_donor_id;
	commit;
END //
DELIMITER ;

-- Create Transfusion
DELIMITER //
CREATE PROCEDURE CreateTransfusion(
	IN p_transfusion_date DATE,
	IN p_volume_ml INT,
	IN p_facilitator_id INT,
	IN p_person_id INT
)
begin
	start transaction;
	INSERT INTO transfusion (transfusion_date, volume_ml, facilitator_id, person_id)
	VALUES (p_transfusion_date , p_volume_ml, p_facilitator_id, p_person_id);
	commit;
END // 
DELIMITER ;

-- Read All Transfusion
DELIMITER //
CREATE PROCEDURE ReadTransfusion(
	in p_transfusion_id INT
)
begin
	if p_transfusion_id is null then
	SELECT transfusion_id, transfusion_date, volume_ml, facilitator_id, person_id FROM transfusion;
	else
	SELECT transfusion_id, transfusion_date, volume_ml, facilitator_id, person_id FROM transfusion
	where transfusion_id = p_transfusion_id;
	end if;
END //
DELIMITER ;

-- Update Specific Transfusion Data
DELIMITER //
CREATE PROCEDURE UpdateTransfusion(
	IN p_transfusion_id INT,
	IN p_transfusion_date DATE,
	IN p_volume_ml INT,
	IN p_facilitator_id INT,
	IN p_person_id INT
)
begin
	start transaction;
	UPDATE transfusion SET
	transfusion_date = p_transfusion_date,
	volume_ml = p_volume_ml,
	facilitator_id = p_facilitator_id,
	person_id = p_person_id
	WHERE transfusion_id = p_transfusion_id;
	commit;
END //
DELIMITER ;

-- Delete Spesific Transfusion Data
DELIMITER //
CREATE PROCEDURE DeleteTransfusion(
	IN p_transfusion_id INT
)
begin
	start transaction;
	DELETE FROM transfusion
	WHERE transfusion_id = p_transfusion_id;
	commit;
END //
DELIMITER ;

-- Check Age
DELIMITER //
CREATE FUNCTION CheckAge(p_age INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN p_age >= 18 AND p_age <= 60;
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

    -- Check age eligibility using CheckAge function
    IF CheckAge(p_age) THEN
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

-- Read Person
DELIMITER //
CREATE PROCEDURE ReadPerson(IN p_person_id INT)
begin
	if p_person_id is null then
	SELECT person_id, full_name, age, blood_type, gender, address, contact, account_id FROM person;
	else 
	SELECT person_id, full_name, age, blood_type, gender, address, contact, account_id FROM person
	WHERE person_id = p_person_id;
	end if;
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
    -- Start transaction to ensure atomicity
    START TRANSACTION;

    -- Check age eligibility using CheckAge function
    IF CheckAge(p_age) THEN
        -- If eligible, update data
        UPDATE person SET
            full_name = p_full_name,
            age = p_age,
            blood_type = p_blood_type,
            gender = p_gender,
            address = p_address,
            contact = p_contact,
            account_id = p_account_id
        WHERE person_id = p_person_id;

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


-- Delete Person By Id
DELIMITER //
CREATE PROCEDURE DeletePerson(
	IN p_person_id INT
)
begin
	start transaction;
	DELETE FROM person
	WHERE person_id = p_person_id;
	commit;
END //
DELIMITER ;

-- Create User
DELIMITER //
CREATE PROCEDURE CreateAccount(
	in p_username VARCHAR(255),
	IN p_email VARCHAR(255),
	IN p_password VARCHAR(255),
	IN p_is_admin boolean
)
begin
	start transaction;
	INSERT INTO account (username, email, password, is_admin)
	VALUES (p_username, p_email, p_password, p_is_admin);
commit;
END //
DELIMITER ;

call CreateAccount("Halan", "halan@testing.ccom", "91893208192038120", false);

-- Read User 
DELIMITER //
CREATE PROCEDURE ReadAccount(IN p_account_id INT)
begin
	if p_account_id is null then
	SELECT account_id, username, email, password, is_admin FROM account;
	else
	SELECT account_id, username, email, password, is_admin FROM account
	WHERE account_id = p_account_id;
	end if;
END //
DELIMITER ;

call ReadAccount(NULL);

-- Update User 
DELIMITER //
CREATE PROCEDURE UpdateAccount(
	IN p_account_id INT,
	IN p_username VARCHAR(255),
	IN p_email VARCHAR(255),
	IN p_password VARCHAR(255)
)
begin
	start transaction;
	UPDATE account set
	p_username = username,
	p_email = email,
	p_password = password
	WHERE account_id = p_account_id;
	commit;
END //
DELIMITER ;

-- Delete User
DELIMITER //
CREATE PROCEDURE DeleteAccount(
	IN p_account_id INT
)
begin
	start transaction;
	DELETE FROM account
	WHERE account_id = p_account_id;
	commit;
END //
DELIMITER ;