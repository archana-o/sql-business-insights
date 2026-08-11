-- Q6: Which payment method fails most, and what are the most common reasons for those failures?
-- Owner: Archana
-- Last updated: 2026-08-10
-- Sanity check: failure_rate and top_error_share_of_failures both in [0, 1] -> confirmed


WITH payment_attempts AS(
      select pm.method_name                                                 as payment_method,
	    count(*)                                                              as attempts,
	    count( case when pt.status='failed' then pt.payment_intent_id end )   as failures
	 
    from ecom.payment_methods pm join ecom.payment_intents pi on pm.payment_method_id=pi.payment_method_id
    join ecom.payment_transactions pt on pt.payment_intent_id=pi.payment_intent_id
   group by pm.method_name
),
errorcode as(
            
         select 
         pm.method_name   as payment_method,
         pt.error_code,
		     pt.error_message,
         count(pt.error_code) as NoErrorcodes,
	       row_number() over(partition by pm.method_name order by count(pt.error_code) desc) as TopError,
	       count(pt.error_message) as NoErrorMessage,
	       row_number() over(partition by pm.method_name order by count(pt.error_message) desc) as TopErrorMessage
	
			 
			
       from ecom.payment_methods pm join ecom.payment_intents pi on pm.payment_method_id=pi.payment_method_id
      join ecom.payment_transactions pt on pt.payment_intent_id=pi.payment_intent_id
	  where pt.error_code is not null 
	  group by pm.method_name,pt.error_code,pt.error_message
	  order by pm.method_name
	  )
select 
        pa.payment_method,
		pa.attempts,
		pa.failures,
		pa.failures::numeric *100.00/nullif(pa.attempts,0) as failure_rate,
		e.error_code  as top_error_code,
		e.error_message as top_error_message,
		NoErrorcodes::numeric *100.00/nullif(pa.failures,0) as top_error_share_of_failures
		
		
		
		from
	  payment_attempts pa join errorcode e on pa.payment_method=e.payment_method
	  
	  where TopError=1 and TopErrorMessage=1
