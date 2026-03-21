select extract(hour from order_purchase_timestamp) as hour,
  case
    when extract(hour from order_purchase_timestamp) between 0 and 6 then "Dawn"
    when extract(hour from order_purchase_timestamp) between 7 and 12 then "Mornings"
    when extract(hour from order_purchase_timestamp) between 13 and 18 then "Afternoon"
    else "Night"
    end as sessions,
    count(order_id) as total_orders
  from target.orders
  group by 1, sessions
  order by total_orders desc
  limit 1

# Insights:
#• Brazilian customers mostly placed their orders in the Afternoon.

#Recommendations:
#• Introduce rewards or points for shopping at less popular times to encourage engagement.
  
 