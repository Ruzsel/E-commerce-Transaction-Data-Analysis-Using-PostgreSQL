SELECT order_detail.id, order_detail.customer_id, order_detail.sku_id, order_detail.payment_id, 
       order_detail.order_date, order_detail.price, order_detail.qty_ordered, 
       order_detail.before_discount, order_detail.discount_amount, order_detail.after_discount, 
       order_detail.is_gross, order_detail.is_valid, order_detail.is_net, 
       sku_detail.sku_name, sku_detail.cogs, sku_detail.category, 
       payment_detail.payment_method
FROM order_detail
JOIN sku_detail ON order_detail.sku_id = sku_detail.id
JOIN customer_detail ON customer_detail.id = order_detail.customer_id
JOIN payment_detail ON payment_detail.id = order_detail.payment_id;
