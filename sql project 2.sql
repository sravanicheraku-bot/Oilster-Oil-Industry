CREATE DATABASE olist_db;
USE olist_db;
-- 1. customers
create table customers (
customer_id varchar(50) primary key,
customer_unique_id varchar(50) not null,
customer_zip_code_prefix varchar(10),
customer_city varchar(100),
customer_state varchar(2)
);

 describe  customers;
 
 -- 2. products 
create table products (
    product_id varchar(32) primary key,
    product_category_name varchar(100),
    product_name_lenght int,
    product_description_lenght int,
    product_photos_qty int,
    product_weight_g int,
    product_length_cm int,
    product_height_cm int,
    product_width_cm int
);
select * from products;
-- 3. product category translation
create table product_translation (
    product_category_name varchar(100) primary key,
    product_category_name_english varchar(100) not null
); 

select * from product_translation;

-- 4. sellers
create table sellers (
    seller_id varchar(32) primary key,
    seller_zip_code_prefix int not null,
    seller_city varchar(100),
    seller_state varchar(5)
);  

select * from sellers;

-- 5. geolocation
create table geolocation (
    geolocation_zip_code_prefix int not null,
    geolocation_lat numeric(10, 8),
    geolocation_lng numeric(11, 8),
    geolocation_city varchar(100),
    geolocation_state varchar(5)
);

describe geolocation;
select * from geolocation;
-- 6. orders
create table orders (
    order_id varchar(32) primary key,
    customer_id varchar(32) not null,
    order_status varchar(20) not null,
    order_purchase_timestamp timestamp not null,
    order_approved_at timestamp,
    order_delivered_carrier_date timestamp,
    order_delivered_customer_date timestamp,
    order_estimated_delivery_date timestamp
    
);

select * from orders; 

-- 7. Order Items

CREATE TABLE order_items (
    order_id VARCHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(32) NOT NULL,
    seller_id VARCHAR(32) NOT NULL,
    shipping_limit_date DATETIME,
    price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2) NOT NULL);
    
   select * from order_items; 
    
    -- 8.order_payments 
    create table order_payments (
    order_id text,
    payment_sequential int,
    payment_type text,
    payment_installments int,
    payment_value decimal(10, 2)
);
 
  select * from order_payments; 
    
    -- 9.order_reviews
    create table order_reviews (
    review_id text,
    order_id text,
    review_score int,
    review_comment_title text,
    review_comment_message text,
    review_creation_date datetime,
    review_answer_timestamp datetime
);

select * from order_reviews; 

USE olist_db;

-- check total row counts all table
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'product_translation', COUNT(*) FROM product_translation
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews;


SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'olist_db'
AND TABLE_NAME IN (
    'customers',
    'product_translation',
    'products',
    'sellers',
    'geolocation',
    'orders',
    'order_items',
    'order_payments',
    'order_reviews'
)
ORDER BY TABLE_NAME;

-- check for null values in each row
SELECT
    COUNT(*) AS total_rows,
    SUM(customer_id IS NULL) AS customer_id_null,
    SUM(customer_unique_id IS NULL) AS unique_id_null,
    SUM(customer_zip_code_prefix IS NULL) AS zip_code_null,
    SUM(customer_city IS NULL) AS city_null,
    SUM(customer_state IS NULL) AS state_null
FROM customers;

SELECT
    COUNT(*) AS total_rows,
    SUM(product_id IS NULL) AS product_id_null,
    SUM(product_category_name IS NULL) AS category_null,
    SUM(product_name_lenght IS NULL) AS name_length_null,
    SUM(product_description_lenght IS NULL) AS description_length_null,
    SUM(product_photos_qty IS NULL) AS photos_qty_null,
    SUM(product_weight_g IS NULL) AS weight_null,
    SUM(product_length_cm IS NULL) AS length_null,
    SUM(product_height_cm IS NULL) AS height_null,
    SUM(product_width_cm IS NULL) AS width_null
FROM products;
-- check the duplicate records
SELECT 'customers' AS table_name,
       COUNT(*) AS duplicate_records
FROM (
    SELECT customer_id
    FROM customers
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) t

UNION ALL

SELECT 'products', COUNT(*)
FROM (
    SELECT product_id
    FROM products
    WHERE product_id IS NOT NULL
    GROUP BY product_id
    HAVING COUNT(*) > 1
) t

UNION ALL

SELECT 'sellers', COUNT(*)
FROM (
    SELECT seller_id
    FROM sellers
    WHERE seller_id IS NOT NULL
    GROUP BY seller_id
    HAVING COUNT(*) > 1
) t

UNION ALL

SELECT 'orders', COUNT(*)
FROM (
    SELECT order_id
    FROM orders
    WHERE order_id IS NOT NULL
    GROUP BY order_id
    HAVING COUNT(*) > 1
) t

UNION ALL

SELECT 'order_items', COUNT(*)
FROM (
    SELECT order_id, order_item_id
    FROM order_items
    GROUP BY order_id, order_item_id
    HAVING COUNT(*) > 1
) t

UNION ALL

SELECT 'order_payments', COUNT(*)
FROM (
    SELECT order_id, payment_sequential
    FROM order_payments
    GROUP BY order_id, payment_sequential
    HAVING COUNT(*) > 1
) t

UNION ALL

SELECT 'order_reviews', COUNT(*)
FROM (
    SELECT review_id, order_id
    FROM order_reviews
    GROUP BY review_id, order_id
    HAVING COUNT(*) > 1
) t

UNION ALL

SELECT 'product_translation', COUNT(*)
FROM (
    SELECT product_category_name
    FROM product_translation
    WHERE product_category_name IS NOT NULL
    GROUP BY product_category_name
    HAVING COUNT(*) > 1
) t;
    
    

    




-- 1. Customer Analysis
-- Find the total number of unique customers.
SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;

-- Find the total number of customers in each state.
SELECT customer_state,
       COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

-- 2. Order Analysis
-- Find the total number of orders by order status.

SELECT order_status,
       COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- Find the monthly order trend.
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
       COUNT(*) AS total_orders
FROM orders
GROUP BY order_month
ORDER BY order_month;

-- Find the top 10 product categories by revenue.
SELECT pt.product_category_name_english,
       SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN product_translation pt
ON p.product_category_name = pt.product_category_name
GROUP BY pt.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;

DESCRIBE product_translation;
DESCRIBE products;

alter table product_translation change column `ï»¿product_category_name` product_category_name varchar(100);

-- Find the top 10 products by revenue.
SELECT product_id,
       SUM(price) AS total_revenue
FROM order_items
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Find the top 10 states by sales revenue.
SELECT c.customer_state,
       SUM(oi.price) AS total_sales
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_sales DESC
LIMIT 10;

-- Calculate the Average Order Value (AOV).
SELECT ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT order_id,
           SUM(price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS order_sales;


-- 4. Customer Retention Analysis
-- Find customers who placed more than one order.
SELECT c.customer_unique_id,
       COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;

--  Payment Analysis
--  Find the most popular payment method.
SELECT payment_type,
       COUNT(*) AS total_transactions
FROM order_payments
GROUP BY payment_type
ORDER BY total_transactions DESC;

-- Calculate total payment amount by payment type.
SELECT payment_type,
       SUM(payment_value) AS total_payment
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment DESC;

-- Seller Analysis
-- Find the top 10 sellers based on revenue.
SELECT seller_id,
       SUM(price) AS total_revenue
FROM order_items
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Delivery Analysis
--  Calculate the average delivery time in days. 
SELECT ROUND(
    AVG(
        TIMESTAMPDIFF(
            SECOND,
            order_purchase_timestamp,
            order_delivered_customer_date
        ) / 86400
    ), 2
) AS average_delivery_days
FROM orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL;  

-- Calculate the percentage of late deliveries.
 SELECT ROUND(
    SUM(
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*), 2
) AS late_delivery_percentage
FROM orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL
AND order_estimated_delivery_date IS NOT NULL;

-- Review Analysis
-- Calculate the average customer review score.
SELECT ROUND(AVG(review_score), 2) AS average_review_score,
       COUNT(*) AS total_reviews
FROM order_reviews;


    
    

    
