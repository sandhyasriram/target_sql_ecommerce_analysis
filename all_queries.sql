——1. KPI  ANALYSIS
  select
    round(sum(p.payment_value),2) as total_revenue,
    count(distinct o.order_id) as total_orders,
    count(distinct o.customer_id) as total_customers,
    ROUND(SUM(p.payment_value)/count(distinct o.order_id),2) as aov
from target.payments p
join target.orders o
on p.order_id = o.order_id;


—- AVERAGE DELIVERY TIME
select 
 round(avg(date_diff(order_delivered_customer_date, order_purchase_timestamp, day)),2)      avg_delivery_time 
   from target.orders 
   where order_delivered_customer_date is not null; 


——-2.  MONTHLY REVENUE TREND
select format_date('%Y-%m', date(order_purchase_timestamp)) as year_month,
       round(sum(p.payment_value),2) Total_revenue
    from target.orders o
     join target.payments p
       on o.order_id = p.order_id
    group by 1
    order by Total_revenue ; 


—— Q3. MONTH OVER MONTH GROWTH
with monthly_growth  as
    (select format_date('%Y-%m', date(o.order_purchase_timestamp)) as Month,
            round(sum(p.payment_value),2) as Total_Revenue
            from target.orders o  
            join target.payments p  
            on o.order_id = p.order_id 
            group by 1
            order by 1 )    
  select 
     lag(Total_Revenue,1) over(order by Month) as previous_month_revenue
    from monthly_growth ;


——— 4. WHICH STATE CONTRIBUTES THE MORE REVENUE
with cte as 
  (select c.customer_state as State, round(sum(p.payment_value),2) as Total_revenue 
     from target.orders o 
      join target.customers c 
       on o.customer_id = c.customer_id 
      join target.payments p 
       on o.order_id = p.order_id group by 1 
  )   
  select *, 
  rank() over (order by Total_Revenue desc) as Top_Revenue_States 
  from cte ;

——-  5. TOTAL REVENUE COMES FROM THE TOP PERFORMING STATES
with state_revenue as (
    select
        c.customer_state as state,
        round(sum(p.payment_value), 2) as total_revenue
    from target.customers c
   join target.orders o
       on c.customer_id = o.customer_id
    join target.payments p
        on o.order_id = p.order_id
    group by 1
)

select
    state,
    total_revenue,
    round(
        total_revenue * 100 /
       sum(total_revenue) over(),
        2
    ) as revenue_percentage,
    rank() over(order by total_revenue desc) as revenue_rank
from state_revenue
order by revenue_rank; 


——- 6. ONE TIME CUSTOMERS 
select c.customer_unique_id,
       count(o.order_id) as no_of_orders
       from `target.customers` c       
         join target.orders  o   
         on c.customer_id = o.customer_id 
      group by 1
      having count(o.order_id) <= 1;


——- 7. REPEATED CUSTOMMERS
select c.customer_unique_id,
       count(o.order_id) as no_of_orders
       from `target.customers` c       
         join target.orders  o   
         on c.customer_id = o.customer_id 
      group by 1
      having count(o.order_id) > 1;


——— 8. REVENUE FROM REPEATED CUSTOMERS
with repeat_customers as (
    select
        c.customer_unique_id
   from target.customers c
    join target.orders o
        on c.customer_id = o.customer_id
    group by c.customer_unique_id
   having count(o.order_id) > 1
)

select
    round(sum(p.payment_value), 2) as repeat_customer_revenue
   from repeat_customers rc
    join target.customers c
      on rc.customer_unique_id = c.customer_unique_id
   join target.orders o
     on c.customer_id = o.customer_id
   join target.payments p
     on o.order_id = p.order_id;


—— #Q9. TOP 10 CUSTOMERS BY REVENUE
with top_customers as 
   (select c.customer_unique_id, 
           round(sum(p.payment_value),2) as customer_spent 
      from target.customers c 
         join target.orders o 
           on c.customer_id = o.customer_id 
         join target.payments p on o.order_id = p.order_id 
      group by 1) 
   select *, 
      from
      (
       select *, 
       rank() over(order by customer_spent desc) rank_customers 
     from top_customers 
   )
     where rank_customers <= 10;


——- Q10. REVENUE BY PAYMENT TYPE
select payment_type, 
      round(sum(payment_value),2) as revenue 
    from target.payments 
    group by 1 
    order by revenue desc;


——— Q11. MOST POPULUR PAYMENT TYPE
select payment_type, 
    count(order_id) as no_of_orders 
    from target.payments 
    group by payment_type 
    order by no_of_orders desc;

——- Q12. CUSTOMER CHOOSE INSTALLMENTS FOR HIGH ORDER VALUES 
  select
    p.payment_installments,
    round(avg(p.payment_value), 2) as avg_order_value,
    count(distinct p.order_id) as total_orders
  from target.payments p
  group by p.payment_installments
  order by p.payment_installments;

——- #Q13. HOW MANY DAYS DOES IT TAKE  ON AVERAGE TO DELIVER AN ORDER? 
with days_taken_to_order_deliver as
   (select order_purchase_timestamp,
       order_delivered_customer_date,
      date_diff(order_delivered_customer_date, order_purchase_timestamp,day) as diff_days
       from `target.orders`)   
  
 select 
    round(avg(diff_days),2) as avg_time
    from days_taken_to_order_deliver;

——— 14. FASTEST AND SLOWEST AVG DELIVERY TIME BY STATES
select c.customer_state as State, 
       round(avg(date_diff(o.order_delivered_customer_date,o.order_purchase_timestamp, day)),0) as avg_delivery_time 
   from target.customers c 
      join target.orders o 
        on c.customer_id = o.customer_id 
   group by 1 
   order by avg_delivery_time;

——- 15. COUNT OF LATE DELIVERIES
select
    count(*) as no_of_late_deliveries
  from target.orders
  where date_diff( order_delivered_customer_date,order_estimated_delivery_date,day) > 0;


——— 16.  CLEANING THE TABLE
create or replace table target.products_clean as
select 
    product_id,
    products category as product_category_name,
    product_name_length ,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
from target.products; 


——— 17.  PRODUCT CATEGORY BY HIGH REVENUE
select pc.product_category_name,
       round(sum(oi.price),2) as category_sales_value
       from `target.products_clean` pc 
         join `target.order_items`  oi 
           on pc.product_id = oi.product_id
       group by 1
       order by category_sales_value desc
       limit 10;

——-18. PRODUCT CATEGORY BY HIGH ORDERS
select
    pc.product_category_name,
    count(distinct oi.order_id) as total_orders,
    round(SUM(oi.price),2)as category_sales_value
from `target.products_clean` pc
join `target.order_items` oi
    on pc.product_id = oi.product_id
group by 1
order by category_sales_value DESC
limit 10;


——— 19. WHICH PRODUCT CATEGORIES HAVE THE HIGHEST AVG ITEMM PRICE?
select pc.product_category_name,
       round(avg(oi.price),2) as avg_sales_value
       from `target.products_clean` pc 
         join `target.order_items`  oi 
           on pc.product_id = oi.product_id
       group by 1
       order by avg_sales_value desc;


——— 20. HIGHEST SALES VALUE BY SELLER
select distinct s.seller_id,
        round(sum(price)) as sales_value
        from target.sellers s  
          join target.order_items oi 
            on s.seller_id = oi.seller_id
        group by 1
        order by sales_value desc
        limit 10;


——- 21. WHICH SELLER PROCESS THE HIGHEST NUMBER OF ORDERS
select distinct s.seller_id,
        count(distinct oi.order_id) as no_of_orders
        from target.sellers s  
          join target.order_items oi 
            on s.seller_id = oi.seller_id
        group by 1
        order by no_of_orders desc
        limit 10;


—— 22. WHICH SELLER HAS THE FASTEST AVG DELIVERY TIME
with cte as 
 (select s.seller_id,
         count(distinct o.order_id) as no_of_orders,
         round(avg(date_diff(o.order_delivered_customer_date, o.order_purchase_timestamp, day)),2) as avg_delivery_time
       from `target.sellers` s  
         join target.order_items oi  
           on s.seller_id = oi.seller_id
         join target.orders o   
           on oi.order_id = o.order_id
        group by s.seller_id)
  select * 
    from cte
      where no_of_orders > 20;


———23. WHICH SELLERS HAS THE HIGHEST LATE DELIVERY RATE
with seller_delivery as (
    select
        s.seller_id,
       count(distinct o.order_id) as total_orders,
        count(distinct case
            when o.order_delivered_customer_date > o.order_estimated_delivery_date
            then o.order_id
        end)as late_orders
    from target.sellers s
    join target.order_items oi
        on s.seller_id = oi.seller_id
    join target.orders o
        on oi.order_id = o.order_id
    where o.order_status = 'delivered'
    group by s.seller_id
)

 select
    seller_id,
    total_orders,
    late_orders,
    round((late_orders * 100.0) / total_orders, 2) as late_delivery_rate
 from seller_delivery
 where total_orders > 20
 order by late_delivery_rate desc;


———24. RFM SEGMENTATION
with rfm as (
    select
        c.customer_unique_id,
        date_diff(
            (select date(max(order_purchase_timestamp))
             from target.orders),
            date(max(o.order_purchase_timestamp)),
            DAY
        ) as recency,
        count(distinct o.order_id) as frequency,
        round(sum(p.payment_value), 2) as monetary
    from target.customers c
    join target.orders o
        on c.customer_id = o.customer_id
    join target.payments p
        on o.order_id = p.order_id
    group by c.customer_unique_id
),

rfm_scores as (
    select *,
        6 - ntile(5) over (order by recency asc) as r_score,
        ntile(5) over (order by frequency desc) as f_score,
        ntile(5) over (order by monetary desc) as m_score
    from rfm
),

segments as (
    select *,
        case
            when r_score >= 4 and f_score >= 4 and m_score >= 4
                then 'Champions'
            when r_score >= 4 and f_score >= 3
                then 'Loyal Customers'
            when r_score >= 3 and m_score >= 3
                THEN 'Potential Loyalists'
            when r_score <= 2 and f_score <= 2
                then 'At Risk'
            else 'Regular Customers'
        end as customer_segment
    from rfm_scores
)
select
    customer_segment,
    count(*) as customer_count
from segments
group by customer_segment
order by customer_count desc;

	
	




























 

