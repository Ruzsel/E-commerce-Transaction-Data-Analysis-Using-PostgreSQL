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

### 6. What is the average transaction value (after discount) per order in 2021 and 2022?

```sql
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    ROUND(AVG(after_discount::numeric)) AS average_transaction_value
FROM
    order_detail
WHERE
    is_valid = TRUE
    AND EXTRACT(YEAR FROM order_date) IN (2021, 2022)
GROUP BY
    EXTRACT(YEAR FROM order_date)
ORDER BY
    year;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/3180046b-823d-4973-9d03-120bd2a23e22)

---

### 7. Find out which day of the week had the highest average transaction value in 2021 and 2022.

```sql
SELECT
    EXTRACT(DOW FROM order_date) AS day_of_week,
    TO_CHAR(order_date, 'Day') AS day_name,
    ROUND(AVG(after_discount::numeric)) AS average_transaction_value
FROM
    order_detail
WHERE
    is_valid = TRUE
    AND EXTRACT(YEAR FROM order_date) IN (2021, 2022)
GROUP BY
    EXTRACT(DOW FROM order_date),
    day_name
ORDER BY
    average_transaction_value DESC;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/1189923b-cd75-4456-a840-7fd8855d928f)

---

### 8. Analyze the most popular product category by month in 2021 and 2022.

```sql
WITH monthly_category_sales AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        EXTRACT(MONTH FROM order_date) AS month,
        sku_detail.category,
        SUM(after_discount) AS total_sales
    FROM
        order_detail
    INNER JOIN
        sku_detail
    ON
        order_detail.sku_id = sku_detail.id
    WHERE
        order_detail.is_valid = TRUE
        AND EXTRACT(YEAR FROM order_date) IN (2021, 2022)
    GROUP BY
        EXTRACT(YEAR FROM order_date),
        EXTRACT(MONTH FROM order_date),
        sku_detail.category
)
SELECT
    year,
    month,
    category,
    total_sales
FROM
    (
        SELECT
            year,
            month,
            category,
            total_sales,
            ROW_NUMBER() OVER (PARTITION BY year, month ORDER BY total_sales DESC) AS rank
        FROM
            monthly_category_sales
    ) ranked_categories
WHERE
    rank = 1
ORDER BY
    year, month;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/24a8ae15-c0d6-4241-9811-778e511d9d10)


### Output : 

| Year | Month | Category            | Total Sales   |
|------|-------|---------------------|---------------|
| 2021 | 1     | Mobiles & Tablets   | 13,252,594    |
| 2021 | 2     | Mobiles & Tablets   | 12,390,192    |
| 2021 | 3     | Appliances          | 5,932,530     |
| 2021 | 4     | Appliances          | 7,420,636     |
| 2021 | 5     | Computing           | 11,692,278    |
| 2021 | 6     | Mobiles & Tablets   | 14,137,384    |
| 2021 | 7     | Entertainment       | 36,058,658    |
| 2021 | 8     | Mobiles & Tablets   | 102,274,126   |
| 2021 | 9     | Mobiles & Tablets   | 35,939,468    |
| 2021 | 10    | Mobiles & Tablets   | 84,725,298    |
| 2021 | 11    | Computing           | 33,716,212    |
| 2021 | 12    | Computing           | 52,286,420    |
| 2022 | 1     | Entertainment       | 47,904,868    |
| 2022 | 2     | Mobiles & Tablets   | 44,601,536    |
| 2022 | 3     | Mobiles & Tablets   | 56,620,992    |
| 2022 | 4     | Entertainment       | 94,788,472    |
| 2022 | 5     | Mobiles & Tablets   | 44,915,432    |
| 2022 | 6     | Entertainment       | 26,440,286    |
| 2022 | 7     | Mobiles & Tablets   | 96,057,164    |
| 2022 | 8     | Mobiles & Tablets   | 20,960,504    |
| 2022 | 9     | Mobiles & Tablets   | 528,031,420   |
| 2022 | 10    | Entertainment       | 14,373,502    |
| 2022 | 11    | Mobiles & Tablets   | 10,726,926    |
| 2022 | 12    | Mobiles & Tablets   | 15,726,642    |

---

### 9. Calculate the total discount given on transactions in 2021 and 2022.

```sql
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    ROUND(SUM(before_discount - after_discount)::numeric) AS total_discount
FROM
    order_detail
WHERE
    is_valid = TRUE
    AND EXTRACT(YEAR FROM order_date) IN (2021, 2022)
GROUP BY
    EXTRACT(YEAR FROM order_date)
ORDER BY
    year;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/b6fb5209-d28f-4498-9f6f-aecccbf3b693)

### Output : 

| Year | Total Discount |
|------|----------------|
| 2021 | 8,008,122      |
| 2022 | 7,891,420      |

---

### 10. Identify the percentage of transactions that were valid in 2021 and 2022.

```sql
WITH total_transactions AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        COUNT(*) AS total_orders
    FROM
        order_detail
    WHERE
        EXTRACT(YEAR FROM order_date) IN (2021, 2022)
    GROUP BY
        EXTRACT(YEAR FROM order_date)
),
valid_transactions AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        COUNT(*) AS valid_orders
    FROM
        order_detail
    WHERE
        is_valid = TRUE
        AND EXTRACT(YEAR FROM order_date) IN (2021, 2022)
    GROUP BY
        EXTRACT(YEAR FROM order_date)
)
SELECT
    total_transactions.year,
    valid_transactions.valid_orders,
    total_transactions.total_orders,
    ROUND((valid_transactions.valid_orders * 100.0 / total_transactions.total_orders)::numeric, 2) AS percentage_valid
FROM
    total_transactions
INNER JOIN
    valid_transactions
ON
    total_transactions.year = valid_transactions.year
ORDER BY
    total_transactions.year;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/ff637007-c30c-459e-a251-d3982f42c140)

### Output : 

## Orders Data

| Year | Valid Orders | Total Orders | Percentage Valid |
|------|--------------|--------------|------------------|
| 2021 | 1,803        | 2,623        | 68.74%           |
| 2022 | 2,209        | 3,261        | 67.74%           |

---

### 11. Analyze the correlation between the number of orders and the total transaction value for each month in 2021 and 2022.

```sql
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    TO_CHAR(order_date, 'FMMonth') AS month,
    COUNT(*) AS total_orders,
    ROUND(SUM(after_discount::numeric)) AS total_transaction_value,
    ROUND(AVG(after_discount::numeric)) AS average_transaction_value
FROM
    order_detail
WHERE
    is_valid = TRUE
    AND EXTRACT(YEAR FROM order_date) IN (2021, 2022)
GROUP BY
    EXTRACT(YEAR FROM order_date),
    TO_CHAR(order_date, 'FMMonth')
ORDER BY
    total_transaction_value DESC;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/2b746231-d884-4366-8071-573fd6c83305)

### Output :

## Orders and Transaction Data

| Year | Month      | Total Orders | Total Transaction Value | Average Transaction Value |
|------|------------|--------------|-------------------------|---------------------------|
| 2022 | September  | 73           | 559,290,228             | 7,661,510                 |
| 2022 | April      | 238          | 276,472,259             | 1,161,648                 |
| 2022 | July       | 271          | 267,110,983             | 985,649                   |
| 2022 | March      | 282          | 262,738,614             | 931,697                   |
| 2022 | January    | 299          | 238,541,883             | 797,799                   |
| 2021 | August     | 267          | 227,862,744             | 853,419                   |
| 2021 | December   | 258          | 217,309,963             | 842,287                   |
| 2022 | May        | 248          | 210,799,584             | 849,998                   |
| 2021 | October    | 242          | 207,603,260             | 857,865                   |
| 2021 | November   | 212          | 180,396,010             | 850,925                   |
| 2022 | February   | 247          | 173,937,985             | 704,202                   |
| 2021 | July       | 248          | 148,007,735             | 596,805                   |
| 2021 | September  | 243          | 145,943,335             | 600,590                   |
| 2022 | June       | 231          | 117,950,824             | 510,610                   |
| 2022 | August     | 88           | 76,025,460              | 863,926                   |
| 2022 | December   | 83           | 57,809,020              | 696,494                   |
| 2022 | October    | 72           | 56,247,211              | 781,211                   |
| 2022 | November   | 77           | 47,924,364              | 622,394                   |
| 2021 | June       | 58           | 43,154,552              | 744,044                   |
| 2021 | January    | 56           | 36,822,127              | 657,538                   |
| 2021 | February   | 57           | 35,611,797              | 624,768                   |
| 2021 | May        | 56           | 34,163,856              | 610,069                   |
| 2021 | March      | 49           | 23,643,062              | 482,511                   |
| 2021 | April      | 57           | 22,208,473              | 389,622                   |

---

