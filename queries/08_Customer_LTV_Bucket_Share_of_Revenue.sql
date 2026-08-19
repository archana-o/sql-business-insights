-- Q8: How is customer lifetime value distributed across customers, and which LTV segments contribute the most revenue?
-- Owner: Archana
-- Last updated: 2026-08-10
-- Sanity check: sum(total_revenue) across all customers equals revenue from ecom.orders (excluding cancelled),within 0.5%. ltv_bucket_share_of_revenue summed across distinct buckets equals 1.0 -> confirmed


with customer_ltv as (
SELECT
      c.customer_id                                               as customer_id,
	  min(o.created_at)                                           as first_order_date,
	  max(o.created_at)                                           as last_order_date,
	  count(o.order_id)                                           as total_orders,
	  sum(o.total)                                                as total_revenue,
	  sum(o.total)::integer/nullif(count(o.order_id),0)           as aov,
	  CASE
                     WHEN Sum(o.total) <= 999
                     THEN '0-999'
                     WHEN Sum(o.total) <= 4999
                     THEN '1000-4999'
                     WHEN Sum(o.total) <= 19999
                     THEN '5000-19999'
                     ELSE '20000+'
                   END                                   AS ltv_bucket


  from ecom.customers c join ecom.orders o on c.customer_id=o.customer_id
  where o.status <>'cancelled'
  group by c.customer_id
  order by c.customer_id
  )

  select *,  sum(total_revenue) over (partition by ltv_bucket)::numeric *100.00/ nullif( sum(total_revenue) over(),0)   as ltv_bucket_share_of_revenue
  from customer_ltv
    ORDER BY total_revenue DESC
