# E-commerce-Transaction-Data-Analysis-Using-PostgreSQL
This project focuses on analyzing e-commerce transaction data using PostgreSQL. The dataset includes detailed information about orders, products, customers, and payment methods, allowing for comprehensive analysis of sales performance, customer behavior, and product trends.
### Dataset Description
The project includes the following tables:
1. **order_detail**: Contains detailed information about each order, including order ID, customer ID, order date, product details, pricing, discounts, payment status, and payment method.
2. **sku_detail**: Contains information about the products, including SKU ID, product name, base price, cost of goods sold (COGS), and product category.
3. **customer_detail**: Contains information about the customers, including customer ID and registration date.
4. **payment_detail**: Contains information about the payment methods used, including payment method ID and name.

### Sample Data
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

### Objectives
1. Analyze sales performance by product category and time period.
2. Evaluate customer purchasing behavior and trends.
3. Identify the most popular payment methods.
4. Determine the impact of discounts on sales.
5. Assess the profitability of products by comparing sales price and cost of goods sold.
