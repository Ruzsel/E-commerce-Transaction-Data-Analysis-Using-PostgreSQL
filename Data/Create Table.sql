-- Create table customer_detail
CREATE TABLE customer_detail (
    id VARCHAR(50) PRIMARY KEY,
    registered_date DATE
);

-- Create table order_detail
CREATE TABLE order_detail (
    id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_date DATE,
    sku_id VARCHAR(50),
    price NUMERIC,
    qty_ordered INT,
    before_discount NUMERIC,
    discount_amount NUMERIC,
    after_discount NUMERIC,
    is_gross BOOLEAN,
    is_valid BOOLEAN,
    is_net BOOLEAN,
    payment_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer_detail(id),
    FOREIGN KEY (payment_id) REFERENCES payment_detail(id)
);

-- Create table payment_detail
CREATE TABLE payment_detail (
    id INT PRIMARY KEY,
    payment_method VARCHAR(50)
);

-- Create table sku_detail
CREATE TABLE sku_detail (
    id VARCHAR(50) PRIMARY KEY,
    sku_name VARCHAR(255),
    base_price NUMERIC,
    cogs NUMERIC,
    category VARCHAR(50)
);
