with max_payment as(
  select max(payment_installments) as max_installments
   from target.payments)
  select
   case
    when p.payment_installments = mp.max_installments then "Fully paid"
    when p.payment_installments > 0 then "Partially paid"
    else "Not paid"
    end as payment_status,
    count(o.order_id) as num_of_orders
   from target.payments as p
    inner join
    target.orders as o
    on p.order_id = o.order_id
    cross join max_payment as mp
   group by
   case
    when p.payment_installments = mp.max_installments then "Fully paid"
    when p.payment_installments > 0 then "Partially paid"
    else "Not paid"
    end

# Observations:
 #• The highest number of customers have partially paid.
 #• There are 18 fully paid customers.
 #• Only 2 customers have not paid.

#Recommendations:
 #• Sending reminders or incentives to the two customers who have not paid.
 #• The high number of partially paid customers may indicate a need for flexible
 #.payment option or follow up to encourage full payment.    