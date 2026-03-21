select
   date_diff(order_delivered_customer_date, order_purchase_timestamp,day) as
   time_to_deliver,
   date_diff(order_delivered_customer_date,
   order_estimated_delivery_date, day) as diff_estimated_delivery
from target.orders