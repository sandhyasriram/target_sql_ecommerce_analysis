select
  extract (year from o.order_purchase_timestamp) as order_year,
  extract (month from o.order_purchase_timestamp) as order_month,
  c.customer_state as state,
  count(o.order_id) as total_orders
 from target.orders as o
  inner join
  target.customers as c
  on o.customer_id = c.customer_id
 group by 1, 2,3
 order by order_year, order_month, state