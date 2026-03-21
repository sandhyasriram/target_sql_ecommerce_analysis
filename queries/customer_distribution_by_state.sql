select
   c.customer_state as state,
   count(distinct(c.customer_id))as total_customers,
  from target.customers as c
 group by 1
 order by total_customers desc