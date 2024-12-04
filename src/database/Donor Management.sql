CREATE DATABASE Donor_Management; 
USE Donor_Management;

-- DROP DATABASE Donor_Management;

-- Create Table: account
CREATE TABLE account (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255), 
    email VARCHAR(255),
    password VARCHAR(255),
    is_admin BOOLEAN
);

-- Create Table: person
CREATE TABLE person (
    person_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255),
    age INT,
    blood_type ENUM("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"),
    gender ENUM("Male", "Female"),
    address VARCHAR(255),
    contact VARCHAR(20),
    account_id INT,
    FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE
);

-- Create Table: facilitator
CREATE TABLE facilitator (
    facilitator_id INT PRIMARY KEY AUTO_INCREMENT,
    facilitator_name VARCHAR(255),
    facilitator_type ENUM("Hospital", "Clinic"),
    address VARCHAR(255),
    contact VARCHAR(20)
);

-- Create Table: donor
CREATE TABLE donor (
    donor_id INT PRIMARY KEY AUTO_INCREMENT,
    donation_date DATE,
    volume_ml INT,
    person_id INT,
    facilitator_id INT,
    FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE CASCADE,
    FOREIGN KEY (facilitator_id) REFERENCES facilitator(facilitator_id) ON DELETE CASCADE
);

-- Create Table: transfusion
CREATE TABLE transfusion (
    transfusion_id INT PRIMARY KEY AUTO_INCREMENT,
    transfusion_date DATE,
    volume_ml INT,
    facilitator_id INT,
    person_id INT,
    FOREIGN KEY (facilitator_id) REFERENCES facilitator(facilitator_id) ON DELETE CASCADE,
    FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE CASCADE
);

-- Create Table: stock
CREATE TABLE stock (
    stock_id INT PRIMARY KEY AUTO_INCREMENT,
    blood_type ENUM("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"),
    volume_ml INT,
    facilitator_id INT,
    FOREIGN KEY (facilitator_id) REFERENCES facilitator(facilitator_id) ON DELETE CASCADE
);

DELIMITER //

-- Trigger: Delete donor after person delete
CREATE TRIGGER delete_donor_after_person_delete
AFTER DELETE ON person
FOR EACH ROW
BEGIN
    DELETE FROM donor WHERE person_id = OLD.person_id;
END //

-- Trigger: Delete transfusion after person delete
CREATE TRIGGER delete_transfusion_after_person_delete
AFTER DELETE ON person
FOR EACH ROW
BEGIN
    DELETE FROM transfusion WHERE person_id = OLD.person_id;
END //

-- Trigger: Delete stock, donor, transfusion after facilitator delete
CREATE TRIGGER delete_stock_after_facilitator_delete
AFTER DELETE ON facilitator
FOR EACH ROW
BEGIN
    DELETE FROM stock WHERE facilitator_id = OLD.facilitator_id;
    DELETE FROM donor WHERE facilitator_id = OLD.facilitator_id;
    DELETE FROM transfusion WHERE facilitator_id = OLD.facilitator_id;
END //

DELIMITER ;

-- Procedure: Read Facilitator Data (All or By ID)
DELIMITER //
CREATE PROCEDURE ReadFacilitator(
    IN p_facilitator_id INT
)
BEGIN
    START TRANSACTION;
    
    IF p_facilitator_id IS NULL THEN
        SELECT facilitator_id, facilitator_name, facilitator_type, address, contact 
        FROM facilitator;
    ELSE
        SELECT facilitator_id, facilitator_name, facilitator_type, address, contact 
        FROM facilitator
        WHERE facilitator_id = p_facilitator_id;
    END IF;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Read Facilitators by Type
DELIMITER //
CREATE PROCEDURE ReadFacilitatorByType(
    IN p_facilitator_type VARCHAR(255)
)
BEGIN
    START TRANSACTION;
    
    SELECT 
        f.facilitator_type,
        f.facilitator_name,
        COUNT(d.donor_id) AS TotalDonors,
        COUNT(t.transfusion_id) AS TotalTransfusions
    FROM facilitator f
    LEFT JOIN donor d ON f.facilitator_id = d.facilitator_id
    LEFT JOIN transfusion t ON f.facilitator_id = t.facilitator_id
    WHERE p_facilitator_type IS NULL 
       OR f.facilitator_type = p_facilitator_type
    GROUP BY f.facilitator_id, f.facilitator_name, f.facilitator_type;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Read Blood Stock by Facilitator
DELIMITER //
CREATE PROCEDURE ReadFacilitatorStock()
BEGIN
    START TRANSACTION;
    
    SELECT 
        f.facilitator_name, 
        s.blood_type, 
        SUM(s.volume_ml) AS total_volume
    FROM stock s
    JOIN facilitator f ON s.facilitator_id = f.facilitator_id
    GROUP BY f.facilitator_name, s.blood_type
    ORDER BY f.facilitator_name;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Read Donor Data by Facilitator
DELIMITER //
CREATE PROCEDURE ReadFacilitatorDonor()
BEGIN
    START TRANSACTION;
    
    SELECT 
        f.facilitator_name, 
        d.donation_date, 
        p.full_name AS donor_name, 
        p.blood_type, 
        d.volume_ml
    FROM donor d
    JOIN person p ON d.person_id = p.person_id
    JOIN facilitator f ON d.facilitator_id = f.facilitator_id;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Read Transfusion Data by Facilitator
DELIMITER //
CREATE PROCEDURE ReadFacilitatorTransfusion()
BEGIN
    START TRANSACTION;
    
    SELECT 
        f.facilitator_name, 
        t.transfusion_date, 
        p.full_name AS recipient_name, 
        p.blood_type, 
        t.volume_ml
    FROM transfusion t
    JOIN person p ON t.person_id = p.person_id
    JOIN facilitator f ON t.facilitator_id = f.facilitator_id;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Create Facilitator
DELIMITER //
CREATE PROCEDURE CreateFacilitator(
    IN p_facilitator_name VARCHAR(255),
    IN p_facilitator_type ENUM("Hospital", "Clinic"),
    IN p_address VARCHAR(255),
    IN p_contact VARCHAR(255)
)
BEGIN
    START TRANSACTION;
    
    INSERT INTO facilitator (facilitator_name, facilitator_type, address, contact) 
    VALUES (p_facilitator_name, p_facilitator_type, p_address, p_contact);
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Update Specific Facilitator Data
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
    
    UPDATE facilitator 
    SET 
        facilitator_name = p_facilitator_name,
        facilitator_type = p_facilitator_type,
        address = p_address,
        contact = p_contact
    WHERE facilitator_id = p_facilitator_id;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Delete Specific Facilitator
DELIMITER //
CREATE PROCEDURE DeleteFacilitator(
    IN p_facilitator_id INT
)
BEGIN
    START TRANSACTION;
    
    DELETE FROM facilitator 
    WHERE facilitator_id = p_facilitator_id;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Read Stock Data (All or By ID)
DELIMITER //
CREATE PROCEDURE ReadStock(
    IN p_stock_id INT
)
BEGIN
    START TRANSACTION;
    
    IF p_stock_id IS NULL THEN
        SELECT stock_id, blood_type, volume_ml, facilitator_id 
        FROM stock;
    ELSE
        SELECT stock_id, blood_type, volume_ml, facilitator_id 
        FROM stock 
        WHERE stock_id = p_stock_id;
    END IF;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Create Stock
DELIMITER //
CREATE PROCEDURE CreateStock(
    IN p_blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    IN p_volume_ml INT,
    IN p_facilitator_id INT
)
BEGIN
    START TRANSACTION;
    
    INSERT INTO stock (blood_type, volume_ml, facilitator_id) 
    VALUES (p_blood_type, p_volume_ml, p_facilitator_id);
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Update Specific Stock Data
DELIMITER //
CREATE PROCEDURE UpdateStock(
    IN p_stock_id INT,
    IN p_blood_type ENUM("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"), 
    IN p_volume_ml INT
)
BEGIN
    START TRANSACTION;
    
    UPDATE stock
    SET 
        blood_type = p_blood_type,
        volume_ml = p_volume_ml
    WHERE stock_id = p_stock_id;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Delete Specific Stock Data
DELIMITER //
CREATE PROCEDURE DeleteStock(
    IN p_stock_id INT
)
BEGIN
    START TRANSACTION;
    
    DELETE FROM stock 
    WHERE stock_id = p_stock_id;
    
    COMMIT;
END //
DELIMITER ; 

-- Trigger: Update Stock on Donor Addition
DELIMITER //
CREATE TRIGGER UpdateStockAfterDonor
AFTER INSERT ON donor
FOR EACH ROW
BEGIN
    UPDATE stock
    SET volume_ml = volume_ml + NEW.volume_ml
    WHERE blood_type = (
        SELECT blood_type FROM person WHERE person_id = NEW.person_id
    )
    AND facilitator_id = NEW.facilitator_id;
END //
DELIMITER ;

-- Trigger: Update Stock on Transfusion Addition
DELIMITER //
CREATE TRIGGER UpdateStockAfterTransfusion
AFTER INSERT ON transfusion
FOR EACH ROW
BEGIN
    UPDATE stock
    SET volume_ml = volume_ml - NEW.volume_ml
    WHERE blood_type = (
        SELECT blood_type FROM person WHERE person_id = NEW.person_id
    )
    AND facilitator_id = NEW.facilitator_id;
END //
DELIMITER ;

-- Procedure: Read All Donor
DELIMITER //
CREATE PROCEDURE ReadDonor(
    IN p_donor_id INT
)
BEGIN
    START TRANSACTION;
    
    IF p_donor_id IS NULL THEN
        SELECT donor_id, donation_date, volume_ml, person_id, facilitator_id 
        FROM donor;
    ELSE
        SELECT donor_id, donation_date, volume_ml, person_id, facilitator_id 
        FROM donor
        WHERE donor_id = p_donor_id;
    END IF;
    
    COMMIT;
END //
DELIMITER ; 

-- Procedure: Create Donor
DELIMITER //
CREATE PROCEDURE CreateDonor(
    IN p_donation_date DATE,
    IN p_volume_ml INT,
    IN p_person_id INT,
    IN p_facilitator_id INT
)
BEGIN
    START TRANSACTION;
    
    INSERT INTO donor (donation_date, volume_ml, person_id, facilitator_id)
    VALUES (p_donation_date, p_volume_ml, p_person_id, p_facilitator_id);
    
    COMMIT;
END // 
DELIMITER ;

-- Procedure: Update Specific Donor Data
DELIMITER //
CREATE PROCEDURE UpdateDonor(
    IN p_donor_id INT,
    IN p_donation_date DATE,
    IN p_volume_ml INT,
    IN p_person_id INT,
    IN p_facilitator_id INT
)
BEGIN
    START TRANSACTION;
    
    UPDATE donor 
    SET
        donation_date = p_donation_date,
        volume_ml = p_volume_ml,
        person_id = p_person_id,
        facilitator_id = p_facilitator_id
    WHERE donor_id = p_donor_id;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Delete Specific Donor Data
DELIMITER //
CREATE PROCEDURE DeleteDonor(
    IN p_donor_id INT
)
BEGIN
    START TRANSACTION;
    
    DELETE FROM donor
    WHERE donor_id = p_donor_id;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Create Transfusion
DELIMITER //
CREATE PROCEDURE CreateTransfusion(
    IN p_transfusion_date DATE,
    IN p_volume_ml INT,
    IN p_facilitator_id INT,
    IN p_person_id INT
)
BEGIN
    START TRANSACTION;
    
    INSERT INTO transfusion (transfusion_date, volume_ml, facilitator_id, person_id)
    VALUES (p_transfusion_date, p_volume_ml, p_facilitator_id, p_person_id);
    
    COMMIT;
END // 
DELIMITER ;

-- Procedure: Read All Transfusion
DELIMITER //
CREATE PROCEDURE ReadTransfusion(
    IN p_transfusion_id INT
)
BEGIN
    START TRANSACTION;
    
    IF p_transfusion_id IS NULL THEN
        SELECT transfusion_id, transfusion_date, volume_ml, facilitator_id, person_id 
        FROM transfusion;
    ELSE
        SELECT transfusion_id, transfusion_date, volume_ml, facilitator_id, person_id 
        FROM transfusion
        WHERE transfusion_id = p_transfusion_id;
    END IF;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Update Specific Transfusion Data
DELIMITER //
CREATE PROCEDURE UpdateTransfusion(
    IN p_transfusion_id INT,
    IN p_transfusion_date DATE,
    IN p_volume_ml INT,
    IN p_facilitator_id INT,
    IN p_person_id INT
)
BEGIN
    START TRANSACTION;
    
    UPDATE transfusion 
    SET
        transfusion_date = p_transfusion_date,
        volume_ml = p_volume_ml,
        facilitator_id = p_facilitator_id,
        person_id = p_person_id
    WHERE transfusion_id = p_transfusion_id;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Delete Specific Transfusion Data
DELIMITER //
CREATE PROCEDURE DeleteTransfusion(
    IN p_transfusion_id INT
)
BEGIN
    START TRANSACTION;
    
    DELETE FROM transfusion
    WHERE transfusion_id = p_transfusion_id;
    
    COMMIT;
END //
DELIMITER ;

-- Function: Check Age
DELIMITER //
CREATE FUNCTION CheckAge(p_age INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN p_age >= 18 AND p_age <= 60;
END //
DELIMITER ;

-- Procedure: Create Person
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
        INSERT INTO person (
            full_name, 
            age, 
            blood_type, 
            gender, 
            address, 
            contact, 
            account_id
        )
        VALUES (
            p_full_name, 
            p_age, 
            p_blood_type, 
            p_gender, 
            p_address, 
            p_contact, 
            p_account_id
        );

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

-- Procedure: Read Person
DELIMITER //
CREATE PROCEDURE ReadPerson(
    IN p_person_id INT
)
BEGIN
    START TRANSACTION;
    
    IF p_person_id IS NULL THEN
        SELECT 
            person_id, 
            full_name, 
            age, 
            blood_type, 
            gender, 
            address, 
            contact, 
            account_id 
        FROM person;
    ELSE 
        SELECT 
            person_id, 
            full_name, 
            age, 
            blood_type, 
            gender, 
            address, 
            contact, 
            account_id 
        FROM person
        WHERE person_id = p_person_id;
    END IF;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Update Person By Id
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
        UPDATE person 
        SET
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

-- Procedure: Delete Person By Id
DELIMITER //
CREATE PROCEDURE DeletePerson(
    IN p_person_id INT
)
BEGIN
    START TRANSACTION;
    
    DELETE FROM person
    WHERE person_id = p_person_id;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Create Account (User)
DELIMITER //
CREATE PROCEDURE CreateAccount(
    IN p_username VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(255)
)
BEGIN
    START TRANSACTION;
    
    INSERT INTO account (username, email, password)
    VALUES (p_username, p_email, p_password);
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Read Account (User)
DELIMITER //
CREATE PROCEDURE ReadAccount(
    IN p_account_id INT
)
BEGIN
    START TRANSACTION;
    
    IF p_account_id IS NULL THEN
        SELECT 
            account_id, 
            username, 
            email, 
            password, 
            is_admin 
        FROM account;
    ELSE
        SELECT 
            account_id, 
            username, 
            email, 
            password, 
            is_admin 
        FROM account
        WHERE account_id = p_account_id;
    END IF;
    
    COMMIT;
END //
DELIMITER ;

-- Example Call to ReadAccount Procedure
-- CALL ReadAccount(NULL);

-- Procedure: Update Account (User)
DELIMITER //
CREATE PROCEDURE UpdateAccount(
    IN p_account_id INT,
    IN p_username VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(255)
)
BEGIN
    START TRANSACTION;
    
    UPDATE account 
    SET
        username = p_username,
        email = p_email,
        password = p_password
    WHERE account_id = p_account_id;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Delete Account (User)
DELIMITER //
CREATE PROCEDURE DeleteAccount(
    IN p_account_id INT
)
BEGIN
    START TRANSACTION;
    
    DELETE FROM account
    WHERE account_id = p_account_id;
    
    COMMIT;
END //
DELIMITER ;
