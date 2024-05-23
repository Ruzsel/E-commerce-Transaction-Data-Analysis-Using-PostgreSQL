# E-commerce-Transaction-Data-Analysis-Using-PostgreSQL
This project focuses on analyzing e-commerce transaction data using PostgreSQL. The dataset includes detailed information about orders, products, customers, and payment methods, allowing for comprehensive analysis of sales performance, customer behavior, and product trends.
## Dataset Description
The project includes the following tables:
1. **order_detail**: Contains detailed information about each order, including order ID, customer ID, order date, product details, pricing, discounts, payment status, and payment method.
2. **sku_detail**: Contains information about the products, including SKU ID, product name, base price, cost of goods sold (COGS), and product category.
3. **customer_detail**: Contains information about the customers, including customer ID and registration date.
4. **payment_detail**: Contains information about the payment methods used, including payment method ID and name.

## Data Structure
- **order_detail**:
  - id: Unique number of the order / order ID.
  - customer_id: Unique number of the customer.
  - order_date: Date when the transaction was made.
  - sku_id: Unique number of the product.
  - price: Price listed on the price tag.
  - qty_ordered: Quantity of items purchased by the customer.
  - before_discount: Total price value of the product (price * qty_ordered).
  - discount_amount: Total discount amount of the product.
  - after_discount: Total price value of the product after discount.
  - is_gross: Indicates whether the customer has not paid the order.
  - is_valid: Indicates whether the customer has made the payment.
  - is_net: Indicates whether the transaction is completed.
  - payment_id: Unique number of the payment method.

- **sku_detail**:
  - id: Unique number of the product.
  - sku_name: Name of the product.
  - base_price: Price of the item listed on the price tag.
  - cogs: Cost of goods sold.
  - category: Product category.

- **customer_detail**:
  - id: Unique number of the customer.
  - registered_date: Date when the customer started registering as a member.

- **payment_detail**:
  - id: Unique number of the payment method.
  - payment_method: Payment method used.

## Bussines Questions
### 1. During transactions that occurred both in 2021 and 2022, in which month did the total transaction value (after discount) reach its highest?

```sql
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    ROUND(SUM(after_discount::numeric)) AS total_transaction_value
FROM 
    order_detail
WHERE 
    is_valid = TRUE
    AND EXTRACT(YEAR FROM order_date) IN (2021, 2022)
GROUP BY  
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY 
    total_transaction_value DESC;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/74358f3c-6e0c-4393-8871-0d940bd1430d)

---

### 2. During transactions in both year 2021 and 2022, which TOP 5 category generated the highest transaction value?

```sql
SELECT
    category,
    ROUND(SUM(after_discount)::numeric) AS total_transaction_value_2021_2022
FROM
    order_detail
INNER JOIN
    sku_detail
ON
    order_detail.sku_id = sku_detail.id
WHERE 
    order_detail.is_valid = true
    AND (EXTRACT(YEAR FROM order_date) = 2021 OR EXTRACT(YEAR FROM order_date) = 2022)
GROUP BY
    category
ORDER BY
    total_transaction_value_2021_2022 DESC
LIMIT 5;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/1d38a8ca-9461-4d5a-8bb7-15c589d50a39)

---

### 3. Compare the transaction values of each category in 2021 with 2022. Identify which categories experienced an increase and which categories experienced a decrease in transaction value from 2021 to 2022!

```sql
WITH transaction_cte AS (
    SELECT 
        sku_detail.category,
        EXTRACT(YEAR FROM order_detail.order_date) AS "year",
        SUM(order_detail.after_discount) AS transaction_value
    FROM 
        order_detail
    INNER JOIN 
        sku_detail
    ON order_detail.sku_id = sku_detail.id
    WHERE 
        order_detail.is_valid = TRUE
        AND EXTRACT(YEAR FROM order_detail.order_date) IN (2021, 2022)
    GROUP BY  
        sku_detail.category, 
        "year"
)
SELECT
    category,
    MAX(CASE WHEN "year" = 2021 THEN transaction_value END) AS transaction_value_2021,
    MAX(CASE WHEN "year" = 2022 THEN transaction_value END) AS transaction_value_2022,
    CASE
        WHEN MAX(CASE WHEN "year" = 2022 THEN transaction_value END) > MAX(CASE WHEN "year" = 2021 THEN transaction_value END) THEN 'Increased'
        WHEN MAX(CASE WHEN "year" = 2022 THEN transaction_value END) < MAX(CASE WHEN "year" = 2021 THEN transaction_value END) THEN 'Decreased'
        ELSE 'No Change'
    END AS trend
FROM
    transaction_cte
GROUP BY
    category
;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/ba0842e0-0082-4095-93f6-42efe3efdb2d)

---

### 4. Display the top 5 most popular payment methods used during 2021 and 2022 (based on total unique orders).

```sql
SELECT
    payment_method,
    COUNT(DISTINCT CASE WHEN EXTRACT(YEAR FROM order_detail.order_date) = 2021 THEN CONCAT(order_detail.id, '-', order_detail.sku_id, '-', order_detail.customer_id) END) AS total_unique_orders_2021,
    COUNT(DISTINCT CASE WHEN EXTRACT(YEAR FROM order_detail.order_date) = 2022 THEN CONCAT(order_detail.id, '-', order_detail.sku_id, '-', order_detail.customer_id) END) AS total_unique_orders_2022
FROM
    order_detail
INNER JOIN
    payment_detail
ON
    order_detail.payment_id = payment_detail.id
WHERE
    order_detail.is_valid = true
    AND (EXTRACT(YEAR FROM order_detail.order_date) = 2021 OR EXTRACT(YEAR FROM order_detail.order_date) = 2022)
GROUP BY
    payment_method
ORDER BY
    total_unique_orders_2022 DESC
LIMIT 5;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/cba3c76b-105b-45ef-9243-27657fdc7174)

---

### 5. Sort these products based on their transaction values in 2021, 2022, and total transaction values from both year!
- Lenovo
- Huawei
- Sony
- Apple
- Samsung

```sql
WITH sku_sales AS (
    SELECT
        CASE 
            WHEN UPPER(sku_detail.sku_name) LIKE '%SAMSUNG%' THEN 'Samsung'
            WHEN UPPER(sku_detail.sku_name) LIKE '%IPHONE%'
                OR UPPER(sku_detail.sku_name) LIKE '%MACBOOK%'
                OR UPPER(sku_detail.sku_name) LIKE '%APPLE%' THEN 'Apple'
			WHEN UPPER(sku_detail.sku_name) LIKE '%SONY%' THEN 'Sony'
			WHEN UPPER(sku_detail.sku_name) LIKE '%HUAWEI%' THEN 'Huawei'
			WHEN UPPER(sku_detail.sku_name) LIKE '%LENOVO%' THEN 'Lenovo'
        END AS product_names,
        order_detail.after_discount,
        EXTRACT(YEAR FROM order_detail.order_date) AS year
    FROM
        sku_detail
    JOIN
        order_detail ON sku_detail.id = order_detail.sku_id
    WHERE
        order_detail.is_valid = TRUE
        AND sku_detail.sku_name IS NOT NULL
)
SELECT
    product_names,
    SUM(CASE WHEN year = 2021 THEN ROUND(after_discount) ELSE 0 END) AS total_transaction_value_2021,
    SUM(CASE WHEN year = 2022 THEN ROUND(after_discount) ELSE 0 END) AS total_transaction_value_2022,
    SUM(ROUND(after_discount)) AS total_transaction_value
FROM 
    sku_sales
GROUP BY
    product_names
HAVING
    product_names IS NOT NULL
ORDER BY
    total_transaction_value_2022 DESC;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/675489cb-2707-4e9c-98d0-0b51b2b54642)

---

