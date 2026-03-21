select c.customer_state,
     avg(date_diff(o.order_estimated_delivery_date, o.order_delivered_customer_date, day)) as
     avg_delivery,
   from target.orders as o
    inner join
    target.customers as c
    on o.customer_id = c.customer_id
   group by 1
   order by avg_delivery desc
  limit 5