-- Q7: Which shipping carriers and methods deliver orders reliably, and where are delivery delays most common?
-- Owner: Archana
-- Last updated: 2026-08-10
-- Sanity check: avg_delivery_days <= p90_delivery_days on every row 
                 .late_rate ∈ [0, 1] -> confirmed

with carrier_summary as (
  SELECT
       sc.carrier_name as  carrier,
	   sm.method_name as  shipping_method,
	   count(case when s.status='delivered' then s.shipment_id end) as delivered_orders
	   
	   
	   
    from ecom.shipments s 
	join ecom.shipping_carriers  sc on s.carrier_id=sc.carrier_id join
	ecom.shipping_methods sm on s.shipping_method_id=sm.shipping_method_id
	
	group by sc.carrier_name,sm.method_name
	order by sc.carrier_name
),
delivery_days as (

select 
    sc.carrier_name as  carrier,
	   sm.method_name as  shipping_method,
	   avg(s.delivered_at::date - s.shipped_at::date)  as avg_delivery_days,
	   percentile_cont(0.5) within group(order by s.delivered_at::date - s.shipped_at::date) as median_delivery_days,
	   PERCENTILE_CONT(0.90) within group(order by s.delivered_at::date - s.shipped_at::date) as p90_delivery_days,
	   count (case when s.delivered_at::date - s.shipped_at::date >5 then s.shipment_id end ) as late_deliveries

from ecom.shipments s 
	join ecom.shipping_carriers  sc on s.carrier_id=sc.carrier_id join
	ecom.shipping_methods sm on s.shipping_method_id=sm.shipping_method_id
where s.status='delivered'
group by sc.carrier_name,sm.method_name
order by sc.carrier_name
)

	select 
            cs.carrier,
			cs.shipping_method,
			cs. delivered_orders,
			dd.avg_delivery_days,
			dd.median_delivery_days,
			dd.p90_delivery_days,
			dd.late_deliveries,
			dd.late_deliveries::numeric *100.00/nullif(cs. delivered_orders,0)  as late_rate

		  from carrier_summary cs join delivery_days dd on cs. carrier=dd.carrier and cs.shipping_method=dd.shipping_method
