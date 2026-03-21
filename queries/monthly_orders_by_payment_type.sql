select
   format_timestamp('%Y-%m',o.order_purchase_timestamp) as year_month,
   count(o.order_id) as total_orders,
   p.payment_type
  from target.orders as o
  inner join
  target.payments as p
  on o.order_id = p.order_id
group by 1,3
order by year_month 

#Insights:

 #• Most customers used credit card payment types.
 #• The fewest customers used debit card payment types.
 
#Recommendations:

 #• Improve debit card offerings.