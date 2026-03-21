select ((total_2018-total_2017)/total_2017)*100 as percentage_increase
  from
   (Select
    Sum(case when extract(year from order_purchase_timestamp) = 2017 then payment_value
    else 0 end) as total_2017,
    Sum(case when extract(year from order_purchase_timestamp) = 2018 then payment_value
    else 0 end) as total_2018
  from target.orders as o
   join target.payments as p
   on p.order_id = o.order_id
  where extract(month from o.order_purchase_timestamp) between 1 and 8)