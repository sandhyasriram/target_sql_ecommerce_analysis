select Z.customer_state,
       Z.average_freight_value,
       Z.rank_highest,
       Z.rank_lowest
    from
    (select
     Y.customer_state,
     Y.average_freight_value,
     rank()over(order by average_freight_value desc) as rank_highest,
     rank() over(order by average_freight_value) as rank_lowest
   from
   (select
   c.customer_state,
   round(avg(o.freight_value),2) as average_freight_value
   from target.order_items o
   inner join
   target.orders x
   on o.order_id = x.order_id
   inner join
   target.customers c
   on x.customer_id = c.customer_id
  group by 1) Y
  )Z
  where Z.rank_highest <=5 or Z.rank_lowest <=5
  order by Z.rank_highest, Z.rank_lowest

#Observations:

 #• Top 5 states have high freight value it indicates geographical challenges or distance from distributed centers.
 #• Last 5 states have low average freight value it indicates they may be closer to distribution centers.

#Recommendations:

 #• For high freight value negotiate with shipping carriers and establish local distributional centers to minimize distance.
 #• For lower freight value introduce targeted promotions or discounts in regions.   