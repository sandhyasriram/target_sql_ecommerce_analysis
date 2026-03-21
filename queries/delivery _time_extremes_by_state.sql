(
  select c.customer_state,
  avg(date_diff(o.order_delivered_customer_date, o.order_purchase_timestamp, day)) as
  avg_delivery_time,
  'highest' as category
  from target.orders as o
  inner join
  target.customers as c
  on o.customer_id = c.customer_id
  group by c.customer_state
  order by avg_delivery_time desc
  limit 5 )
union all
   ( select c.customer_state,
   avg(date_diff(o.order_delivered_customer_date, o.order_purchase_timestamp, day)) as
   avg_delivery_time,
   'lowest' as category
   from target.orders as o
   inner join
   target.customers as c
  on o.customer_id = c.customer_id
  group by c.customer_state
  order by avg_delivery_time
  limit 5 )

#Observations:

 #• Investigate for highest average delivery time geographical challenges, infrastructure issues.
 #• Analyse lowest average delivery time presence of warehouses, efficient logistics and delivery routes.

#Recommendations:

 #• For highest delivery time increase distribution centers near demand heavy areas.
 #• Partner with local delivery services for last mile delivery.  