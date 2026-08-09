with customer_signup as (
      select 
	        customer_id,
			date_trunc('month',created_at::timestamp)  as cohort_month
			from ecom.customers
),
retention_summary as(
SELECT
      cs. cohort_month,
	  count(distinct cs.customer_id) as cohort_size,
	  count(
                distinct 
				case when date_trunc('month',o.created_at::timestamp) = cs.cohort_month + INTERVAL '1 month' and o.status<>'cancelled' 
				then cs.customer_id end
	  )                                                                                                                                    as m1_retention,
	  count (
               DISTINCT
			   case when date_trunc('month',o.created_at::timestamp) =cs.cohort_month+ INTERVAL '2 month' and o.status <>'cancelled' 
		       then cs.customer_id end
	  )                                                                                                                                  as m2_retention,
	  count (
               DISTINCT
			   case when date_trunc('month',o.created_at::timestamp) =cs.cohort_month+ INTERVAL '3 month' and o.status <>'cancelled' 
		       then cs.customer_id end
	  )                                                                                                                                  as m3_retention
	  
	  


from customer_signup cs 
 left join ecom.orders o
   on cs.customer_id=o.customer_id
group by cohort_month
)

SELECT
      cohort_month,
	  cohort_size,
	  m1_retention,
	  m2_retention,
	  m3_retention,
	  m1_retention::numeric/nullif(cohort_size,0)  as m1_retention_rate,
	  m2_retention::numeric/nullif(cohort_size,0)   as m2_retention_rate,
	  m3_retention::numeric/nullif(cohort_size,0)   as m3_retention_rate
from retention_summary
