select
     c.customer_state as State,
     sum(o.freight_value) as Total,
     avg(o.freight_value) as Average
  from target.order_items as o
    inner join
    target.orders as x
    on o.order_id = x.order_id
    inner join
    target.customers c
    on x.customer_id = c.customer_id
  group by c.customer_state
  order by Total desc