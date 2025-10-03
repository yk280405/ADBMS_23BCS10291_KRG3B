-------------------------------- EXPERIMENT 06 (MEDIUM LEVEL) --------------------------------

CREATE TABLE employee_info (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    salary NUMERIC(10,2) NOT NULL,
    city VARCHAR(50) NOT NULL
);

INSERT INTO employee_info (name, gender, salary, city)
VALUES
('Akshara', 'Female', 50000.00, 'Delhi'),
('Ishika', 'Female', 60000.00, 'Mumbai'),
('Nikhil', 'Male', 45000.00, 'Bangalore'),
('Aarav', 'Male', 55000.00, 'Chennai'),
('Rohan', 'Male', 52000.00, 'Hyderabad'),
('Meera', 'Female', 48000.00, 'Kolkata'),
('Kabir', 'Male', 47000.00, 'Pune'),
('Ananya', 'Female', 62000.00, 'Ahmedabad'),
('Dev', 'Male', 51000.00, 'Jaipur');

CREATE OR REPLACE PROCEDURE sp_get_employees_by_gender(
    IN p_gender VARCHAR(50),
    OUT p_employee_count INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(id)
    INTO p_employee_count
    FROM employee_info
    WHERE gender = p_gender;

    RAISE NOTICE 'Total employees with gender %: %', p_gender, p_employee_count;
END;
$$;

CALL sp_get_employees_by_gender('Female', NULL);



-------------------------------- EXPERIMENT 06 (HARD LEVEL) --------------------------------

CREATE TABLE products (
    product_code VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    quantity_remaining INT NOT NULL,
    quantity_sold INT DEFAULT 0
);

CREATE TABLE sales (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    product_code VARCHAR(10) NOT NULL,
    quantity_ordered INT NOT NULL,
    sale_price NUMERIC(10,2) NOT NULL,
    FOREIGN KEY (product_code) REFERENCES products(product_code)
);

INSERT INTO products (product_code, product_name, price, quantity_remaining, quantity_sold)
VALUES
('P001', 'Dell XPS 15 Laptop', 149999.00, 10, 0),
('P002', 'Google Pixel 9 Pro', 89999.00, 8, 0),
('P003', 'iPad Pro 12.9"', 99999.00, 5, 0),
('P004', 'Asus ROG Strix Gaming Laptop', 199999.00, 3, 0),
('P005', 'Bose QuietComfort Ultra Headphones', 34999.00, 15, 0);

INSERT INTO sales (order_date, product_code, quantity_ordered, sale_price)
VALUES
('2025-09-15', 'P001', 1, 149999.00),
('2025-09-16', 'P002', 2, 179998.00),
('2025-09-17', 'P003', 1, 99999.00),
('2025-09-18', 'P005', 2, 69998.00),
('2025-09-19', 'P001', 1, 149999.00);

SELECT * FROM products;
SELECT * FROM sales;

CREATE OR REPLACE PROCEDURE pr_buy_products(
    IN p_product_name VARCHAR,
    IN p_quantity INT
)
LANGUAGE plpgsql
AS $$
DECLARE 
    v_product_code VARCHAR(20);
    v_price FLOAT;
    v_count INT;
BEGIN 
    SELECT COUNT(*)
    INTO v_count
    FROM products 
    WHERE product_name = p_product_name 
    AND quantity_remaining >= p_quantity;

    IF v_count > 0 THEN 
        SELECT product_code, price 
        INTO v_product_code, v_price
        FROM products 
        WHERE product_name = p_product_name;

        INSERT INTO sales (order_date, product_code, quantity_ordered, sale_price)
        VALUES (CURRENT_DATE, v_product_code, p_quantity, (v_price * p_quantity));

        UPDATE products 
        SET quantity_remaining = quantity_remaining - p_quantity,
            quantity_sold = quantity_sold + p_quantity
        WHERE product_code = v_product_code;

        RAISE NOTICE 'PRODUCT SOLD..! Order placed successfully for % unit(s) of %.', p_quantity, p_product_name;
    ELSE 
        RAISE NOTICE 'INSUFFICIENT QUANTITY..! Order cannot be processed for % unit(s) of %.', p_quantity, p_product_name;
    END IF;
END;
$$;

CALL pr_buy_products ('Asus ROG Strix Gaming Laptop', 1);
