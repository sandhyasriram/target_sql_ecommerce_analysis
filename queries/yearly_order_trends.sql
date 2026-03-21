select
   extract(year from order_purchase_timestamp) as order_year,
   count(order_id) as total_orders
   from target.orders
   group by order_year
   order by order_year

  