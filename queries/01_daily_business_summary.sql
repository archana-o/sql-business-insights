-- Q1: Daily Business Summary + DoD / Same-Weekday WoW Comparisons
-- Owner: Archana  |  Last updated: 2026-08-10
-- Sanity check: paid_order_rate between 0 and 1 on every row;
-- sum(orders) across all days equals count(*) of ecom.orders for the same window.


with ordersummary as(
select 
       date_trunc('day',created_at::timestamp)                                                                                      as ordered_date,
	   sum(total)                                                                                                                     as revenue,
	   count(*)                                                                                                                       as orders,
	   sum(total)/count(*)                                                                                                            as AOV,
	   sum(case when payment_status='paid' then 1 else 0 end) *100.00/ nullif(count(*) ,0)                                                      as paid_order_rate,
	   sum (case when status='cancelled' then 1 else 0 end) * 100.00/nullif(count(*),0)                                                       as cancelled_order_rate
from ecom.orders 
group by date_trunc('day',created_at::timestamp)
order by date_trunc('day',created_at::timestamp) desc
),
refundsummary as (

select 
                date_trunc('day',created_at::timestamp)                                                                                    as refund_date,
                 sum(amount)                                                                                                               as refund_amount
from ecom.refunds
group by date_trunc('day',created_at::timestamp)
order by date_trunc('day',created_at::timestamp) desc
)

select 
      ordered_date, 
	  revenue,
	  orders,
	  aov,
	  paid_order_rate,
	  cancelled_order_rate,
	  coalesce(refund_amount,0)                                                                                        as refund_amount,
	  (revenue-lag(revenue) over(order by ordered_date )) * 100.00  / nullif(lag(revenue) over(order by ordered_date),0)          as revenue_vs_yesterday_pct,
	  (revenue- lag(revenue,7) over(order by ordered_date))*100.00/ nullif(lag(revenue,7) over(order by ordered_date),0)          as revenue_vs_last_weekday_pct       
from
ordersummary left join refundsummary ON
ordersummary.ordered_date=refundsummary.refund_date
order by ordered_date desc
