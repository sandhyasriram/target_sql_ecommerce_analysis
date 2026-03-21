select
   count(distinct (c.customer_state)) as States,
   count(distinct(c.customer_city)) as Cities
from target.customers as c
     inner join
     `target.orders` as o
     on c.customer_id = o.customer_id

#Observations:
# .Total states are 27 and the cities are 4119 of customers ordered in the given
# period.