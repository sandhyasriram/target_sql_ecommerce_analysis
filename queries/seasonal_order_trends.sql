select
    extract(month from order_purchase_timestamp) as month,
    case
    when extract (month from order_purchase_timestamp) in(12,1,2) then "Winter"
    when extract (month from order_purchase_timestamp) in(6,7,8) then "Summer"
    when extract (month from order_purchase_timestamp) in(3,4,5) then "Spring"
    else "Fall"
    end as season,
    count(order_id) as num_of_orders
  from target.orders
  group by 1, season
  order by num_of_orders desc 