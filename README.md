# E-commerce-Transaction-Data-Analysis-Using-PostgreSQL
This project focuses on analyzing e-commerce transaction data using PostgreSQL. The dataset includes detailed information about orders, products, customers, and payment methods, allowing for comprehensive analysis of sales performance, customer behavior, and product trends.

# Table of Contents
[Data Structure](#data-structure)
[Bussines Questions](#bussines-questions)
[Insight and Bussines Solution](#insight-and-bussines-solutions)

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

# Bussines Questions
## 1. During transactions that occurred both in 2021 and 2022, how did the discount amount value (discount_amount) perform in each month?

```sql
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    TO_CHAR(order_date, 'Month') AS month,
    ROUND(SUM(discount_amount::numeric)) AS total_discount_value,
    ROUND(SUM(discount_amount::numeric) / COUNT(discount_amount)) AS average_discount_value
FROM 
    order_detail
WHERE 
    is_valid = TRUE
    AND EXTRACT(YEAR FROM order_date) IN (2021, 2022)
GROUP BY  
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date),
	month
ORDER BY 
    total_discount_value DESC;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/eb293fd4-0098-47ef-b827-e212fc2015c3)

### Output : 
### Discount Amount Value

| year | month      | total_discount_value | average_discount_value |
|------|------------|----------------------|------------------------|
| 2021 | November   | 7,178,397            | 33,860                 |
| 2022 | December   | 1,658,148            | 19,978                 |
| 2022 | July       | 1,353,240            | 4,994                  |
| 2022 | May        | 884,502              | 3,567                  |
| 2022 | April      | 863,557              | 3,628                  |
| 2022 | June       | 858,297              | 3,716                  |
| 2022 | November   | 851,722              | 11,061                 |
| 2021 | September  | 598,258              | 2,462                  |
| 2022 | March      | 467,300              | 1,657                  |
| 2022 | January    | 304,707              | 1,019                  |
| 2022 | October    | 238,873              | 3,318                  |
| 2022 | August     | 207,768              | 2,361                  |
| 2022 | February   | 128,483              | 520                    |
| 2021 | July       | 98,066               | 395                    |
| 2022 | September  | 74,822               | 1,025                  |
| 2021 | June       | 58,000               | 1,000                  |
| 2021 | October    | 29,000               | 120                    |
| 2021 | May        | 29,000               | 518                    |
| 2021 | March      | 11,600               | 237                    |
| 2021 | December   | 5,800                | 22                     |
| 2021 | April      | 0                    | 0                      |
| 2021 | August     | 0                    | 0                      |
| 2021 | January    | 0                    | 0                      |
| 2021 | February   | 0                    | 0                      |


---

## 2. During transactions in both year 2021 and 2022, Explain how the TOP 5 category transaction value perform is?

```sql
SELECT
    category,
    ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM order_date) = 2021 THEN after_discount END)::numeric) AS average_transaction_value_2021,
    ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM order_date) = 2022 THEN after_discount END)::numeric) AS average_transaction_value_2022,
    ROUND(SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2021 THEN after_discount END)::numeric) AS total_transaction_value_2021,
    ROUND(SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2022 THEN after_discount END)::numeric) AS total_transaction_value_2022,
    ROUND(SUM(CASE WHEN EXTRACT(YEAR FROM order_date) IN (2021, 2022) THEN after_discount END)::numeric) AS total_transaction_value_2021_2022
FROM
    order_detail
INNER JOIN
    sku_detail ON order_detail.sku_id = sku_detail.id
WHERE 
    order_detail.is_valid = true
    AND EXTRACT(YEAR FROM order_date) IN (2021, 2022)
GROUP BY
    category
ORDER BY
    total_transaction_value_2021 DESC
LIMIT 5;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/13f27a5e-903c-437e-a961-c6faeab19b0e)

### Output : 

### Transaction Analysis per Category

| Category           | Average Transaction Value 2021 | Average Transaction Value 2022 | Total Transaction Value 2021 | Total Transaction Value 2022 | Total Transaction Value (2021-2022) |
|--------------------|---------------------------------|---------------------------------|------------------------------|------------------------------|------------------------------------|
| Mobiles & Tablets | 5,219,813                       | 11,625,969                      | 370,606,718                  | 918,451,576                  | 1,289,058,294                      |
| Appliances         | 2,207,578                       | 2,614,530                       | 218,550,177                  | 316,358,100                  | 534,908,277                        |
| Computing          | 1,879,118                       | 1,562,252                       | 172,878,860                  | 214,028,543                  | 386,907,403                        |
| Entertainment      | 2,387,152                       | 2,854,251                       | 162,326,357                  | 365,344,149                  | 527,670,506                        |
| Women Fashion      | 694,595                         | 650,454                         | 84,045,961                   | 93,014,971                   | 177,060,932                        |

---

## 3. Compare the transaction values of each category in 2021 with 2022. Identify which categories experienced an increase and which categories experienced a decrease in transaction value from 2021 to 2022!

```sql
WITH transaction_cte AS (
    SELECT 
        sku_detail.category,
        EXTRACT(YEAR FROM order_detail.order_date) AS "year",
        ROUND(SUM(order_detail.after_discount)) AS transaction_value
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

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/9967e6e8-350a-4e66-8550-d52cb03b890d)

### Output :

### Transaction Analysis by Category

| Category           | Transaction Value 2021 | Transaction Value 2022 | Trend     |
|--------------------|------------------------|------------------------|-----------|
| Appliances         | 218,550,177            | 316,358,100            | Increased |
| Beauty & Grooming  | 46,047,360             | 46,211,019             | Increased |
| Books              | 10,124,596             | 6,792,519              | Decreased |
| Computing          | 172,878,860            | 214,028,543            | Increased |
| Entertainment      | 162,326,357            | 365,344,149            | Increased |
| Health & Sports    | 33,837,966             | 54,235,580             | Increased |
| Home & Living      | 45,797,873             | 79,483,716             | Increased |
| Kids & Baby        | 23,971,058             | 25,931,277             | Increased |
| Men Fashion        | 58,628,198             | 135,588,253            | Increased |
| Mobiles & Tablets  | 370,606,718            | 918,451,576            | Increased |
| Others             | 40,468,516             | 21,744,646             | Decreased |
| School & Education | 11,558,982             | 17,362,465             | Increased |
| Soghaat            | 15,056,203             | 17,658,332             | Increased |
| Superstore         | 28,828,088             | 32,643,267             | Increased |
| Women Fashion      | 84,045,961             | 93,014,971             | Increased |

---

## 4. Display the top 5 most popular payment methods used during 2021 and 2022 (based on total unique orders).

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

### Output : 

### Total Unique Orders per Payment Method

| Payment Method | Total Unique Orders 2021 | Total Unique Orders 2022 |
|----------------|--------------------------|--------------------------|
| cod            | 1,591                    | 1,828                    |
| Payaxis        | 79                       | 188                      |
| customercredit | 39                       | 78                       |
| Easypay        | 0                        | 70                       |
| jazzwallet     | 10                       | 26                       |

---

## 5. Sort these products based on their transaction values in 2021, 2022, and total transaction values from both year!
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

### Output : 

### Total Transaction Value per Product

| Product Names | Total Transaction Value 2021 | Total Transaction Value 2022 | Total Transaction Value |
|---------------|-------------------------------|-------------------------------|-------------------------|
| Samsung       | 176,406,304                   | 412,357,844                   | 588,764,148             |
| Apple         | 257,200,768                   | 187,654,592                   | 444,855,360             |
| Sony          | 31,617,540                    | 32,343,178                    | 63,960,718              |
| Huawei        | 32,217,434                    | 30,942,826                    | 63,160,260              |
| Lenovo        | 38,758,210                    | 23,621,590                    | 62,379,800              |

---

## 6. What is the average transaction value (after discount) per order in 2021 and 2022?

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

### Output : 

### Average Transaction Value per Year

| Year | Average Transaction Value |
|------|---------------------------|
| 2021 | 733,626                   |
| 2022 | 1,061,498                 |

---

## 7. Find out which day of the week had the highest average transaction value in 2021 and 2022.

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

### Output : 

### Daily Transaction Data

| Day of Week | Day Name   | Average Transaction Value |
|-------------|------------|---------------------------|
| 2           | Tuesday    | 1,626,241                 |
| 1           | Monday     | 869,605                   |
| 3           | Wednesday  | 862,673                   |
| 0           | Sunday     | 826,595                   |
| 4           | Thursday   | 799,814                   |
| 5           | Friday     | 731,191                   |
| 6           | Saturday   | 673,273                   |

---

## 8. Analyze the most popular product category by month in 2021 and 2022.

```sql
WITH monthly_category_value AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        EXTRACT(MONTH FROM order_date) AS month,
        sku_detail.category,
        SUM(after_discount) AS total_transaction_value
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
    total_transaction_value
FROM
    (
        SELECT
            year,
            month,
            category,
            total_transaction_value,
            ROW_NUMBER() OVER (PARTITION BY year, month ORDER BY total_transaction_value DESC) AS rank
        FROM
            monthly_category_value
    ) ranked_categories
WHERE
    rank = 1
ORDER BY
    year, month;
```

![image](https://github.com/Ruzsel/E-commerce-Transaction-Data-Analysis-Using-PostgreSQL/assets/150054552/fd469a01-e71d-4cb7-af08-db9995aaf1d6)

### Output : 

| Year | Month | Category            | Total transaction value   |
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

## 9. Calculate the total discount given on transactions in 2021 and 2022.

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

## 10. Identify the percentage of transactions that were valid in 2021 and 2022.

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

### Orders Data

| Year | Valid Orders | Total Orders | Percentage Valid |
|------|--------------|--------------|------------------|
| 2021 | 1,803        | 2,623        | 68.74%           |
| 2022 | 2,209        | 3,261        | 67.74%           |

---

## 11. Analyze the correlation between the number of orders and the total transaction value for each month in 2021 and 2022.

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

### Orders and Transaction Data

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

# Insight and Bussines Solutions
### Insight 1: Monthly Discount Performance
- **Years 2021 and 2022**:
  - The highest discount occurred in November 2021, with a total discount value of 7,178,397 and an average of 33,860.
  - Discounts in December 2022 were also significant, with a total of 1,658,148 and an average of 19,978.

### Solution:
1. **Seasonal Promotions**: Utilize this pattern to plan major promotional and discount campaigns in November and December each year. This will help maximize sales and attract more customers during these periods.

### Insight 2: Top Performing Categories
- **Top 5 Categories**:
  - `Mobiles & Tablets` had the highest combined transaction value in 2021 and 2022.
  - `Appliances` and `Entertainment` also showed strong performance across both years.

### Solution:
2. **Focus on Key Categories**: Prioritize inventory and marketing campaigns for `Mobiles & Tablets`, `Appliances`, and `Entertainment`. This can help drive further sales in already popular categories.

### Insight 3: Transaction Value Comparison by Category
- Most categories experienced an increase in transaction value from 2021 to 2022, except for `Books` and `Others`.

### Solution:
3. **Targeted Sales Strategies**: Reevaluate sales strategies for categories that saw a decline, like `Books` and `Others`. Consider bundling offers, special promotions, or enhancing product visibility within these categories.

### Insight 4: Popular Payment Methods
- `COD` (Cash on Delivery) is the most popular payment method in both 2021 and 2022.

### Solution:
4. **Payment Options**: Ensure that the `COD` method is easily accessible and optimized, as many customers prefer this method. Additionally, promote other payment methods like `Payaxis` and `customercredit` to diversify payment options and reduce risks associated with cash transactions.

### Insight 5: Transaction Values by Product
- `Samsung` and `Apple` showed the highest transaction values during 2021 and 2022.

### Solution:
5. **Brand Partnerships**: Consider forming partnerships or collaborations with popular brands like `Samsung` and `Apple` for exclusive promotions, which can attract more buyers.

### Insight 6: Average Transaction Value
- The average transaction value increased from 733,626 in 2021 to 1,061,498 in 2022.

### Solution:
6. **Upselling and Cross-selling**: Leverage this increase with more aggressive upselling and cross-selling strategies, such as offering additional products or premium services to customers.

### Insight 7: Highest Transaction Value Days
- **Tuesday** had the highest average transaction value.

### Solution:
7. **Special Day Promotions**: Utilize Tuesdays for running daily promotional campaigns or special offers to drive more transactions.

### Insight 8: Most Popular Product Category by Month
- `Mobiles & Tablets` frequently emerged as the most popular category, especially in certain months.

### Solution:
8. **Stock Adjustment**: Ensure to adjust stock and promotional campaigns based on monthly trends for popular categories like `Mobiles & Tablets`, to ensure sufficient product availability and avoid stockouts.

### Insight 9: Total Discounts Given
- Total discounts given in 2021 and 2022 were nearly balanced.

### Solution:
9. **Discount Optimization**: Evaluate the effectiveness of given discounts and consider optimizing discount strategies to increase ROI. Focus on discounts that have proven to attract more buyers without compromising profit margins.

### Insight 10: Percentage of Valid Transactions
- The percentage of valid transactions was high in both years but slightly decreased from 68.74% in 2021 to 67.74% in 2022.

### Solution:
10. **Improving Transaction Validity**: Enhance the transaction verification process and order management to increase the percentage of valid transactions. This can involve staff training, using fraud detection technology, and improving payment processing systems.

### Insight 11: Correlation Between Orders and Transaction Value
- There are months with high transaction values despite fewer orders, indicating high-value transactions.

### Solution:
11. **High-Value Transaction Analysis**: Conduct in-depth analysis to understand the patterns and characteristics of high-value transactions. Focus on customers making these transactions for more effective retention and loyalty strategies.

By implementing these solutions, businesses can improve sales performance, refine marketing strategies, and enhance overall operational efficiency.
