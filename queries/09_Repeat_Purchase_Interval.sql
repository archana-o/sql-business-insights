-- Q9: How frequently do customers make repeat purchases, and how long does it take them to place their next order?
-- Owner: Archana
-- Last updated: 2026-08-10
-- Sanity check: days_to_next_order >= 0 on every row. median <= p90 in the summary -> confirmed





----1.. Rowlevel----------------
select 
       customer_id                                                                                                        as customer_id,
       order_id                                                                                                            as  order_id,
	   date(created_at)                                                                                                          as order_date,
	   lead(date(created_at)) over(partition by customer_id order by customer_id,created_at)                                     as next_order_date,
	   lead(date(created_at)) over(partition by customer_id order by customer_id,created_at) ::date - created_at::date          as  days_to_next_order
   from  ecom.orders 
   
   where Lower(status) != 'cancelled'
   order by customer_id  ;


---------2. summary-----------------

with order_summary as (
select 
       customer_id                                                                                                        as customer_id,
       order_id                                                                                                            as  order_id,
	   date(created_at)                                                                                                          as order_date,
	   lead(date(created_at)) over(partition by customer_id order by customer_id,created_at)                                     as next_order_date,
	   lead(date(created_at)) over(partition by customer_id order by customer_id,created_at) ::date - created_at::date          as  days_to_next_order
   from  ecom.orders 
   
   where Lower(status) != 'cancelled'
   order by customer_id  
   
   ),
   Repeated_customers as (
                        select 
                               customer_id
	                        from ecom.orders
							where lower(status) != 'cancelled'
						group by customer_id
			            having count(order_id)>1
   )
                 select 
				           
                           avg(os.days_to_next_order)                       as   avg_days_to_next_order,
						   PERCENTILE_CONT(0.5)
						   within group(order by os.days_to_next_order)     as   median_days_to_next_order,
						   PERCENTILE_CONT(0.9)
						   within group(order by os.days_to_next_order)        as   p90_days_to_next_order,
						   count(distinct rc.customer_id)                               as   customers_with_repeat_order
                        
		 
              from order_summary os
			  join Repeated_customers rc 
			  on os.customer_id=rc.customer_id
			   WHERE  os.next_order_date IS NOT NULL
         AND os.next_order_date != os.order_date 
