select
     min(order_purchase_timestamp) as earliest_order,
     max(order_purchase_timestamp) as letest_order
 from target.orders

 # observations:
#• The first order was placed on 2016-09-04 21:15:19 UTC
#• The last order was placed on 2018-10-17 17:30:18 UT