-- Q10: How does revenue attribution change between first-touch and last-touch marketing channels?
-- Owner: Archana
-- Last updated: 2026-08-10
-- Sanity check: Total revenue under first_touch equals total under last_touch equals
                 total non-cancelled revenue in ecom.orders, within 0.5%. -> confirmed



WITH touches  as (
SELECT
      o.order_id,
                 o.customer_id,
                 o.session_id,
                 o.total,
                 t.touched_at,
                 t.channel,
				 Row_number() OVER(PARTITION BY o.customer_id ORDER BY t.touched_at)      AS first_touch,
                 Row_number() OVER(PARTITION BY o.customer_id ORDER BY t.touched_at DESC) AS last_touch
	from ecom.orders o left join ecom.attribution_touches t on o.session_id=t.session_id
	 where Lower(status) != 'cancelled' 
	order by o.customer_id
 ),
first_touch as (
 select 
        'First Touch'   as Attribution_Model,
		sum(total)    as Revenue,
		count(order_id)   as Orders,
		coalesce(channel,'Direct')           as channel 
		from touches
		where first_touch=1
		group by channel

		),
last_touch as (
       select 
	    'Last Touch' as AttributionModel,
        sum(total)    as Revenue,
		count(order_id)   as Orders,
		coalesce(channel,'Direct')           as channel 
		from touches
		where last_touch=1
		group by channel

)
select *, 
     revenue*100.00 ::numeric/ nullif(sum(revenue) over(),0)  as share_of_revenue
	 from first_touch ft 

union
select * ,
     revenue*100.00::numeric/ nullif(sum(revenue) over(),0) as share_of_revenue
	 from last_touch ft 
order by channel
