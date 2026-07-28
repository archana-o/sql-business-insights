with ordersummary as(
select 
       date_trunc('day',created_at::timestamp)                                                                                      as ordered_date,
	   sum(total)                                                                                                                     as revenue,
	   count(*)                                                                                                                       as orders,
	   sum(total)/count(*)                                                                                                            as AOV,
	   sum(case when payment_status='paid' then 1 else 0 end) *100.00/ count(*)                                                       as paid_order_rate,
	   sum (case when status='cancelled' then 1 else 0 end) * 100.00/count(*)                                                       as cancelled_order_rate
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
	  (revenue-lag(revenue) over(order by ordered_date )) * 100.00  / lag(revenue) over(order by ordered_date)          as revenue_vs_yesterday_pct,
	  (revenue- lag(revenue,7) over(order by ordered_date))*100.00/ lag(revenue,7) over(order by ordered_date)            as revenue_vs_last_weekday_pct       
from
ordersummary left join refundsummary ON
ordersummary.ordered_date=refundsummary.refund_date
order by ordered_date desc
