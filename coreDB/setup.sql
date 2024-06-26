-- Initializing Database

DROP DATABASE IF EXISTS dbms_project;
CREATE DATABASE dbms_project;
USE dbms_project;

-- Creating Tables

CREATE TABLE support_ticket (
ticket_id INT PRIMARY KEY NOT NULL,
description TEXT,
status VARCHAR(20) CHECK (status IN ('Open', 'Closed'))
);

CREATE TABLE customer (
customer_email VARCHAR(100) PRIMARY KEY NOT NULL,
customer_password VARCHAR(20),
first_name VARCHAR(25),
last_name VARCHAR(25),
phone_number BIGINT,
date_of_birth DATE,
gender CHAR(1),
membership CHAR(1) CHECK (membership IN ('Y', 'N')),
address_line TEXT,
pincode INT
);

CREATE TABLE support_executive (
executive_id INT PRIMARY KEY NOT NULL,
executive_password VARCHAR(20),
executive_first_name VARCHAR(25),
executive_last_name VARCHAR(25),
executive_phone_number BIGINT,
executive_gender CHAR(1),
executive_address_line TEXT,
executive_pincode INT
);

CREATE TABLE pharmacy (
branch_id INT PRIMARY KEY NOT NULL,
phone_number BIGINT,
pharmacy_address_line TEXT,
pharmacy_pincode INT
);



CREATE TABLE pharmacist (
pharmacist_id INT PRIMARY KEY NOT NULL,
pharmacy_id INT NOT NULL,
pharmacist_password VARCHAR(20),
pharmacist_first_name VARCHAR(25),
pharmacist_last_name VARCHAR(25),
pharmacist_phone_number BIGINT,
pharmacist_gender CHAR(1),
pharmacist_address_line TEXT,
pharmacist_pincode INT,
FOREIGN KEY (pharmacy_id) REFERENCES pharmacy(branch_id)
);

CREATE TABLE prescription (
prescription_id INT PRIMARY KEY NOT NULL,
image BLOB
);

CREATE TABLE rider (
rider_id INT PRIMARY KEY NOT NULL,
rider_password VARCHAR(20),
rider_phone_number BIGINT,
rider_first_name VARCHAR(25),
rider_last_name VARCHAR(25),
total_earnings DECIMAL(10, 2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY NOT NULL,
    customer_email VARCHAR(100) NOT NULL,
    status VARCHAR(20) CHECK(status IN ('Received', 'Shipped', 'Delivered', 'Processing', 'Cancelled', 'Packed','Pending')),
    rider_id INT NOT NULL,
    ordered_at DATETIME,
    amount DECIMAL(10, 2) NOT NULL, 
    commission DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_email) REFERENCES customer(customer_email),
    FOREIGN KEY (rider_id) REFERENCES rider(rider_id)
);

CREATE TABLE tech_manager (
manager_id INT PRIMARY KEY NOT NULL,
manager_password VARCHAR(20),
manager_phone_number BIGINT,
manager_first_name VARCHAR(25),
manager_last_name VARCHAR(25),
manager_address_line TEXT,
manager_pincode INT,
manager_gender CHAR(1)
);

CREATE TABLE product (
product_id INT PRIMARY KEY NOT NULL,
name VARCHAR(50),
price DECIMAL(10, 2),
stock INT DEFAULT 0,
main_ingredient VARCHAR(50),
mode_of_taking VARCHAR(50),
drug CHAR(1) CHECK (drug IN ('Y', 'N')),
image_path VARCHAR(255)
);

CREATE TABLE ticket_resolution (
solution TEXT,
ticket_id INT NOT NULL,
customer_email VARCHAR(100) NOT NULL,
executive_id INT NOT NULL,
PRIMARY KEY (ticket_id, customer_email, executive_id),
FOREIGN KEY (ticket_id) REFERENCES support_ticket(ticket_id),
FOREIGN KEY (customer_email) REFERENCES customer(customer_email),
FOREIGN KEY (executive_id) REFERENCES support_executive(executive_id)
);

CREATE TABLE payment (
mode VARCHAR(20),
status BOOLEAN DEFAULT FALSE,
order_id INT NOT NULL,
customer_email VARCHAR(100) NOT NULL,
PRIMARY KEY (order_id, customer_email),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (customer_email) REFERENCES customer(customer_email)
);

CREATE TABLE cart (
quantity INT DEFAULT 0,
customer_email VARCHAR(100) NOT NULL,
product_id INT NOT NULL,
PRIMARY KEY (product_id, customer_email),
FOREIGN KEY (product_id) REFERENCES product(product_id),FOREIGN KEY (customer_email) REFERENCES customer(customer_email)
);

CREATE TABLE order_approval (
order_id INT NOT NULL,
prescription_id INT NOT NULL,
pharmacist_id INT NOT NULL,
PRIMARY KEY (order_id, prescription_id, pharmacist_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (prescription_id) REFERENCES prescription(prescription_id),
FOREIGN KEY (pharmacist_id) REFERENCES pharmacist(pharmacist_id)
);

CREATE TABLE order_details (
quantity INT NOT NULL,
order_id INT NOT NULL,
product_id INT NOT NULL,
PRIMARY KEY (order_id, product_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Inserting sample data

INSERT INTO support_ticket (ticket_id, description, status) VALUES
(1, 'Issue with login credentials', 'Open'),
(2, 'Payment processing error', 'Open'),
(3, 'Product not delivered', 'Closed'),
(4, 'Faulty product received', 'Open'),
(5, 'Request for refund', 'Open'),
(6, 'Technical support needed', 'Open'),
(7, 'Account access problem', 'Closed'),
(8, 'Upgrade membership request', 'Open'),
(9, 'Inquiry about product availability', 'Open'),
(10, 'Delivery delay', 'Open');

INSERT INTO customer (customer_email, customer_password, first_name,
last_name, phone_number, date_of_birth, gender, membership, address_line,
pincode) VALUES
('rajan@example.com', 'pass123', 'Rajan', 'Sharma', 9812345678,
'1990-01-15', 'M', 'Y', '123 Green Park', 110016),('neha@example.com', 'secure456', 'Neha', 'Kapoor', 9876543210,
'1985-05-20', 'F', 'N', '456 Lajpat Nagar', 110024),
('anil@example.com', 'password789', 'Anil', 'Gupta', 9555555555,
'1978-08-03', 'M', 'N', '789 Greater Kailash', 110048),
('priya@example.com', 'pass567', 'Priya', 'Verma', 9111111111,
'1995-03-10', 'F', 'Y', '101 Saket', 110017),
('vikas@example.com', 'secure890', 'Vikas', 'Singh', 9999888877,
'1980-12-25', 'M', 'N', '333 Malviya Nagar', 110017),
('sneha@example.com', 'password246', 'Sneha', 'Rajput', 9555666777,
'1987-07-17', 'F', 'Y', '555 Vasant Vihar', 110057),
('mohit@example.com', 'pass234', 'Mohit', 'Chopra', 9555443322,
'1992-06-28', 'M', 'N', '777 Connaught Place', 110001),
('pooja@example.com', 'secure123', 'Pooja', 'Dhillon', 9555888899,
'1975-09-05', 'F', 'N', '888 Karol Bagh', 110005),
('ravi@example.com', 'password678', 'Ravi', 'Malhotra', 9777777777,
'1983-04-12', 'M', 'Y', '999 Rajouri Garden', 110027),
('swati@example.com', 'pass901', 'Swati', 'Gulati', 9555333344,
'1998-11-30', 'F', 'N', '1212 Paharganj', 110055);

INSERT INTO support_executive (executive_id, executive_password,
executive_first_name, executive_last_name, executive_phone_number,
executive_gender, executive_address_line, executive_pincode) VALUES
(1, 'exec1', 'Amit', 'Kumar', 9812345678, 'M', '123 Green Park', 110016),
(2, 'exec2', 'Priya', 'Sharma', 9876543210, 'F', '456 Lajpat Nagar',
110024),
(3, 'exec3', 'Vikram', 'Gupta', 9555555555, 'M', '789 Greater Kailash',
110048),
(4, 'exec4', 'Meena', 'Verma', 9111111111, 'F', '101 Saket', 110017),
(5, 'exec5', 'Rahul', 'Singh', 9999888877, 'M', '333 Malviya Nagar',
110017),
(6, 'exec6', 'Anu', 'Rajput', 9555666777, 'F', '555 Vasant Vihar', 110057),
(7, 'exec7', 'Deepak', 'Chopra', 9555443322, 'M', '777 Connaught Place',
110001),
(8, 'exec8', 'Neha', 'Dhillon', 9555888899, 'F', '888 Karol Bagh', 110005),
(9, 'exec9', 'Sanjay', 'Malhotra', 9777777777, 'M', '999 Rajouri Garden',
110027),
(10, 'exec10', 'Kavita', 'Gulati', 9555333344, 'F', '1212 Paharganj',
110055);

INSERT INTO pharmacy (branch_id, phone_number, pharmacy_address_line,
pharmacy_pincode) VALUES
(1, 9876543210, '12 Green Park', 110016),
(2, 9988776655, '45 Lajpat Nagar', 110024),(3, 9988776655, '78 Greater Kailash', 110048),
(4, 9988776655, '34 Saket', 110017),
(5, 9988776655, '67 Malviya Nagar', 110017),
(6, 9988776655, '90 Vasant Vihar', 110057),
(7, 9988776655, '23 Connaught Place', 110001),
(8, 9988776655, '56 Karol Bagh', 110005),
(9, 9988776655, '89 Rajouri Garden', 110027),
(10, 9988776655, '45 Paharganj', 110055);


INSERT INTO pharmacist (pharmacist_id, pharmacy_id, pharmacist_password,
pharmacist_first_name, pharmacist_last_name, pharmacist_phone_number,
pharmacist_gender, pharmacist_address_line, pharmacist_pincode) VALUES
(1, 1, 'pharm1', 'Raj', 'Kumar', 9812345678, 'M', '123 Green Park',
110016),
(2, 2, 'pharm2', 'Sunita', 'Sharma', 9876543210, 'F', '456 Lajpat Nagar',
110024),
(3, 3, 'pharm3', 'Vikas', 'Gupta', 9555555555, 'M', '789 Greater Kailash',
110048),
(4, 4, 'pharm4', 'Kavita', 'Verma', 9111111111, 'F', '101 Saket', 110017),
(5, 5, 'pharm5', 'Sohan', 'Singh', 9999888877, 'M', '333 Malviya Nagar',
110017),
(6, 6, 'pharm6', 'Poonam', 'Rajput', 9555666777, 'F', '555 Vasant Vihar',
110057),
(7, 7, 'pharm7', 'Deepak', 'Chopra', 9555443322, 'M', '777 Connaught
Place', 110001),
(8, 8, 'pharm8', 'Neha', 'Dhillon', 9555888899, 'F', '888 Karol Bagh',
110005),
(9, 9, 'pharm9', 'Sanjay', 'Malhotra', 9777777777, 'M', '999 Rajouri
Garden', 110027),
(10, 10, 'pharm10', 'Kavita', 'Gulati', 9555333344, 'F', '1212 Paharganj',
110055);

INSERT INTO prescription (prescription_id, image) VALUES
(1, LOAD_FILE('C:/prescription.jpg')),
(2, LOAD_FILE('C:/prescription.jpg')),
(3, LOAD_FILE('C:/prescription.jpg')),
(4, LOAD_FILE('C:/prescription.jpg')),
(5, LOAD_FILE('C:/prescription.jpg')),
(6, LOAD_FILE('C:/prescription.jpg')),
(7, LOAD_FILE('C:/prescription.jpg')),
(8, LOAD_FILE('C:/prescription.jpg')),
(9, LOAD_FILE('C:/prescription.jpg')),
(10, LOAD_FILE('C:/prescription.jpg'));

INSERT INTO rider (rider_id, rider_password, rider_phone_number,
rider_first_name, rider_last_name, total_earnings) VALUES
(1, 'rider1', 9812345678, 'Rajesh', 'Kumar', 500.00),
(2, 'rider2', 9876543210, 'Ritu', 'Sharma', 750.00),
(3, 'rider3', 9555555555, 'Vijay', 'Gupta', 900.00),
(4, 'rider4', 9111111111, 'Komal', 'Verma', 600.00),
(5, 'rider5', 9999888877, 'Suresh', 'Singh', 850.00),
(6, 'rider6', 9555666777, 'Sunita', 'Rajput', 700.00),
(7, 'rider7', 9555443322, 'Vikram', 'Chopra', 550.00),
(8, 'rider8', 9555888899, 'Neelam', 'Dhillon', 480.00),
(9, 'rider9', 9777777777, 'Sanjay', 'Malhotra', 625.00),
(10, 'rider10', 9555333344, 'Kavita', 'Gulati', 720.00);

INSERT INTO product (product_id, name, price, stock, main_ingredient,
mode_of_taking, drug, image_path) VALUES
(1, 'Pain Relief Tablets', 10.99, 100, 'Ibuprofen', 'Oral', 'Y', '../static/assets/tablet.jpg'),
(2, 'Antihistamine Syrup', 15.50, 50, 'Diphenhydramine', 'Oral', 'Y', '../static/assets/syrup.jpg'),
(3, 'Cough Syrup', 8.75, 75, 'Dextromethorphan', 'Oral', 'N', '../static/assets/syrup.jpg'),
(4, 'Vitamin C Tablets', 5.99, 200, 'Ascorbic Acid', 'Oral', 'N', '../static/assets/tablet.jpg'),
(5, 'Antibacterial Ointment', 12.25, 30, 'Neomycin', 'Topical', 'N', '../static/assets/ointment.jpg'),
(6, 'Allergy Relief Tablets', 18.50, 40, 'Loratadine', 'Oral', 'Y', '../static/assets/tablet.jpg'),
(7, 'Eye Drops', 9.99, 60, 'Naphazoline', 'Ophthalmic', 'N', '../static/assets/eyeDrop.jpg'),
(8, 'Antacid Chewable Tablets', 7.50, 80, 'Calcium Carbonate', 'Oral',
'N', '../static/assets/tablet.jpg'),
(9, 'Sunscreen Lotion', 14.75, 25, 'Avobenzone', 'Topical', 'N', '../static/assets/ointment.jpg'),
(10, 'Analgesic Cream', 11.25, 35, 'Menthol', 'Topical', 'N', '../static/assets/ointment.jpg');


INSERT INTO orders (order_id, customer_email, status, rider_id, ordered_at, amount, commission) VALUES
(1, 'rajan@example.com', 'Received', 1, '2024-03-06 10:00:00', 100.00, 0.00), 
(2, 'neha@example.com', 'Delivered', 2, '2024-03-06 11:00:00', 150.00, 0.00),
(3, 'anil@example.com', 'Processing', 3, '2024-03-06 12:00:00', 200.00, 0.00),
(4, 'priya@example.com', 'Cancelled', 4, '2024-03-06 13:00:00', 50.00, 0.00),
(5, 'vikas@example.com', 'Shipped', 1, '2024-03-06 14:00:00', 75.00, 0.00),
(6, 'rajan@example.com', 'Packed', 6, '2024-03-06 15:00:00', 120.00, 0.00),
(7, 'neha@example.com', 'Pending', 7, '2024-03-06 16:00:00', 90.00, 0.00),
(8, 'anil@example.com', 'Processing', 8, '2024-03-06 17:00:00', 80.00, 0.00),
(9, 'priya@example.com', 'Delivered', 9, '2024-03-06 18:00:00', 160.00, 0.00),
(10, 'vikas@example.com', 'Pending', 10, '2024-03-06 19:00:00', 110.00, 0.00);

INSERT INTO tech_manager (manager_id, manager_password, manager_first_name,
manager_last_name, manager_phone_number, manager_gender,
manager_address_line, manager_pincode) VALUES(1, 'mng1', 'Raj', 'Kumar', 9812345678, 'M', '123 Green Park', 110016),
(2, 'mng2', 'Sunita', 'Sharma', 9876543210, 'F', '456 Lajpat Nagar',
110024);

INSERT INTO ticket_resolution (solution, ticket_id, customer_email,
executive_id) VALUES
('Issue resolved', 1, 'rajan@example.com', 1),
('Payment processed successfully', 2, 'neha@example.com', 2),
('Product delivered on time', 3, 'anil@example.com', 3),
('Replacement product sent', 4, 'priya@example.com', 4),
('Refund processed', 5, 'vikas@example.com', 5),
('Issue resolved', 6, 'rajan@example.com', 1),
('Issue resolved', 7, 'neha@example.com', 2),
('Membership upgraded', 8, 'anil@example.com', 3),
('Inquiry solved', 9, 'priya@example.com', 4),
('Issue resolved', 10, 'vikas@example.com', 5);

INSERT INTO payment (mode, status, order_id, customer_email) VALUES
('Credit Card', TRUE, 1, 'rajan@example.com'),
('Cash on Delivery', FALSE, 2, 'neha@example.com'),
('Debit Card', TRUE, 3, 'anil@example.com'),
('Net Banking', FALSE, 4, 'priya@example.com'),
('Wallet', TRUE, 5, 'vikas@example.com'),
('Credit Card', TRUE, 6, 'rajan@example.com'),
('Cash on Delivery', FALSE, 7, 'neha@example.com'),
('Debit Card', TRUE, 8, 'anil@example.com'),
('Net Banking', FALSE, 9, 'priya@example.com'),
('Wallet', TRUE, 10, 'vikas@example.com');

INSERT INTO cart (quantity, customer_email, product_id) VALUES
(2, 'rajan@example.com', 1),
(1, 'neha@example.com', 3),
(3, 'anil@example.com', 5),
(1, 'priya@example.com', 7),
(2, 'vikas@example.com', 9),
(2, 'rajan@example.com', 8),
(1, 'neha@example.com', 1),
(3, 'anil@example.com', 8),
(1, 'priya@example.com', 6),
(2, 'vikas@example.com', 8),
(2, 'rajan@example.com', 10),
(1, 'neha@example.com', 9),
(3, 'anil@example.com', 6),(1, 'priya@example.com', 2),
(2, 'vikas@example.com', 1);

INSERT INTO order_approval (order_id, prescription_id, pharmacist_id)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10);

INSERT INTO order_details (quantity, order_id, product_id) VALUES
(2, 1, 1),
(1, 2, 3),
(3, 3, 5),
(1, 4, 7),
(2, 5, 9),
(2, 6, 1),
(1, 7, 3),
(3, 8, 5),
(1, 9, 7),
(2, 10, 9);


-- Trigger to automatically assign a pharmacist to an order whenever a new one is placed 
SET GLOBAL general_log = 'ON';

DELIMITER //
CREATE TRIGGER automatic_pharmacist_assignment
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE new_pharmacist_id INT;
    DECLARE new_order_id INT;
    DECLARE new_prescription_id INT;

    SELECT pharmacist_id INTO new_pharmacist_id
    FROM pharmacist
    ORDER BY RAND()
    LIMIT 1;
    
    SELECT MAX(order_id) INTO new_order_id 
    FROM orders;
    
    INSERT INTO order_approval (order_id, prescription_id, pharmacist_id)
    VALUES (new_order_id, 1, new_pharmacist_id);
END//
DELIMITER ;

-- second trigger
DELIMITER //
CREATE TRIGGER new_lock_row
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE new_order_id INT;

    SELECT MAX(order_id) INTO new_order_id 
    FROM orders;
    
    INSERT INTO lock_order (order_id, r, w)
    VALUES (new_order_id, 0, 0);
END//
DELIMITER ;

/*
SET @o_id = -1;

DELIMITER //
CREATE TRIGGER update_inventory_after_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE new_oid INT;

    SELECT MAX(order_id) INTO new_oid 
    FROM orders;
    
    SET @o_id = new_oid;
END;

BEGIN    
	DECLARE new_oid INT;
	DECLARE new_pid INT;
    DECLARE new_qty INT;
    DECLARE is_done INT DEFAULT 0;

	DECLARE products CURSOR FOR  
		SELECT product.product_id, order_details.quantity
		FROM orders, order_details, product
		WHERE orders.order_id = @o_id and orders.order_id = order_details.order_id and order_details.product_id = product.product_id; 
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_done = 1;

    
    OPEN products;
    
    fetch_loop: LOOP
		FETCH products INTO new_pid, new_qty;
        
        IF is_done = 1 THEN	
			LEAVE fetch_loop;
		END IF;
        
        UPDATE product SET product.stock = product.stock - new_qty where product.product_id = new_pid;
        
	END LOOP fetch_loop;
    
	CLOSE products;

END //
DELIMITER ;
*/


CREATE TABLE lock_stock (
	id INT PRIMARY KEY NOT NULL,
	r BOOLEAN DEFAULT FALSE,
	w BOOLEAN DEFAULT FALSE
);

INSERT INTO lock_stock (id, r, w) VALUES
(1, False, False);

-- need to check only for row lock, no use of table lock
CREATE TABLE lock_order (
	order_id INT PRIMARY KEY NOT NULL,
	r BOOLEAN DEFAULT FALSE,
	w BOOLEAN DEFAULT FALSE,
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO lock_order (order_id, r, w) VALUES
(1, False, False),
(2, False, False),
(3, False, False),
(4, False, False),
(5, False, False),
(6, False, False),
(7, False, False),
(8, False, False),
(9, False, False),
(10, False, False);