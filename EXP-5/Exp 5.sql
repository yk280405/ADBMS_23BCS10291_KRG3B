-------------------------------- MEDIUM LEVEL PROBLEM --------------------------------------------


CREATE TABLE TRANSACTION_DATA(
    id INT,
    val DECIMAL
);


INSERT INTO TRANSACTION_DATA(ID,VAL)
SELECT 1, RANDOM()
FROM GENERATE_SERIES(1,1000000);


INSERT INTO TRANSACTION_DATA(ID,VAL)
SELECT 2, RANDOM()
FROM GENERATE_SERIES(1,1000000);


SELECT * FROM TRANSACTION_DATA;


CREATE OR REPLACE VIEW SALES_SUMMARY AS
SELECT 
    ID,
    COUNT(*) AS total_quantity_sold,
    SUM(val) AS total_sales,
    COUNT(DISTINCT id) AS total_orders
FROM TRANSACTION_DATA
GROUP BY ID;


EXPLAIN ANALYZE
SELECT * FROM SALES_SUMMARY;


CREATE MATERIALIZED VIEW SALES_SUMM_MV AS
SELECT 
    ID,
    COUNT(*) AS total_quantity_sold,
    SUM(val) AS total_sales,
    COUNT(DISTINCT id) AS total_orders
FROM TRANSACTION_DATA
GROUP BY ID;


EXPLAIN ANALYZE
SELECT * FROM SALES_SUMM_MV;  


------------------------------------ HARD PROBLEM -------------------------------------


CREATE TABLE customer_data (
    transaction_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    payment_info VARCHAR(50), 
    order_value DECIMAL,
    order_date DATE DEFAULT CURRENT_DATE
);


INSERT INTO customer_data (customer_name, email, phone, payment_info, order_value)
VALUES
('Akshara', 'akshara@example.com', '9040122324', '1234-5678-9012-3456', 500),
('Akshara', 'akshara@example.com', '9040122324', '1234-5678-9012-3456', 1000),
('Ishika', 'ishika@example.com', '9876543210', '9876-5432-1098-7654', 700),
('Ishika', 'ishika@example.com', '9876543210', '9876-5432-1098-7654', 300),
('Nikhil', 'nikhil@example.com', '9123456780', '4567-8910-1112-1314', 1200),
('Nikhil', 'nikhil@example.com', '9123456780', '4567-8910-1112-1314', 800);


CREATE OR REPLACE VIEW RESTRICTED_SALES_DATA AS
SELECT
    CUSTOMER_NAME,
    COUNT(*) AS total_orders,
    SUM(order_value) AS total_sales
FROM customer_data
GROUP BY customer_name;


SELECT * FROM RESTRICTED_SALES_DATA;


CREATE USER CLIENT1 WITH PASSWORD 'REPORT1234';
GRANT SELECT ON RESTRICTED_SALES_DATA TO CLIENT1;
REVOKE SELECT ON RESTRICTED_SALES_DATA FROM CLIENT1;
