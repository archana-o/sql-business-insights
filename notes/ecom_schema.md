





select table_name, column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_schema = 'ecom'
order by table_name, ordinal_position;


select relname as table_name, n_live_tup as approx_row_count
from pg_stat_user_tables
where schemaname = 'ecom'
order by n_live_tup desc;



select tc.table_name, kcu.column_name,
       ccu.table_name as foreign_table, ccu.column_name as foreign_column
from information_schema.table_constraints tc
join information_schema.key_column_usage    kcu on tc.constraint_name = kcu.constraint_name
join information_schema.constraint_column_usage ccu on ccu.constraint_name = tc.constraint_name
where tc.constraint_type = 'FOREIGN KEY' and tc.table_schema = 'ecom';



select status, count(*) as n from ecom.orders group by 1 order by n desc;



select TABLE_NAME, COLUMN_NAME
from 
    Information_schema.COLUMNS
	where table_schema='ecom'
	and data_type in ('text','character varying')
	
	
select TABLE_NAME, COLUMN_NAME
from 
    Information_schema.COLUMNS
	where table_schema='ecom'
	and data_type like '%timestamp%'
	

select * 
from 
  ecom.customers
  where  country is null or country='' or country='N/A'
	
	


-------------------------------------------------Adresses

select * from ecom.addresses

Grain :  One row = One unique physical address.

Rowcount:  16000

Purpose : Contains  address information with location details and latitude/longitude coordinates.


PK: adress_id


----------------------------------------------attribution_campaigns

select * from ecom.attribution_campaigns

Grain: One row = One  touch_id mapped to one campaign, with the attributed advertising cost.

Rowcount:  38405

Purpose : Stores which marketing campaign brought the customer and the advertising cost for that interaction.

FK : campaign_id, touch_id

-------------------------------------------attribution_touches

select * from ecom.attribution_touches


Grain: One row = One marketing touchpoint (interaction) during a user session.

Rowcount: 100000

Purpose: stores how customers reached the website through different marketing campaigns

PK: touch_id, session_id




-------------------------------------------------brands

select * from ecom.brands

Grain : One row = 1 BrandName

Rowcount:  120

Purpose :Stores the names of all product brands

PK: brand_id

-----------------------------------------------categories

select * from ecom.categories

Grain: One row represents one unique product category

Rowcount: 18

Purpose: It stores the product categories and subcategories

PK: category_id

------------------------------------------collection_products


select * from ecom.collection_products

Empty


--------------------------------------------collections

select * from ecom.collections

Empty

--------------------------------------------Consents

select * from ecom.consents

Empty



--------------------------------------------coupons

select * from ecom.coupons

Grain: One row = One unique coupon

Rowcount: 50

Purpose: This table stores coupon codes that customers can apply while placing an order.


PK: coupon_id

-------------------------------------------------customer_addresses

select * from ecom.customer_addresses

Grain:  One row = One address assigned to one customer for a specific address type.

Rowcount: 16000

Purpose: It links customers to their addresses.


FK : customer_id, address_id


------------------------------------------------customer_segments

select * from ecom.customer_segments

Grain: Onerow represents one customerSegmentName

Rowcount:  10

Purpose: This table is used for grouping customers based on their behavior.


PK: segment_id


---------------------------------------------------customers

select * from ecom.customers

Grain: One row represents one Customer details

Rowcount: 10000

Purpose:Store the customer Details

PK: customer_id

----------------------------------------------------devices

select * from ecom.devices

Grain : One row = One unique device.

Rowcount: 85168

Purpose: This table stores the device details customers used to visit the e-commerce website or app.


PK: device_id


---------------------------------------------------experiment_assignments

select * from ecom.experiment_assignments

Grain: One row = One experiment assignment of a session  to a specific experiment variant.

Rowcount : 140670

Purpose: Stores the A/B testing version assigned to each  session


FK: experiment_id, session_id, exp_variant_id



------------------------------------------------------experiment_variants

select * from ecom.experiment_variants

Grain: One row = One variant of an experiment.

Rowcount: 12

Purpose: This tells us the different versions of that experiment.


 

FK: experiment_id, variant_id



-------------------------------------------------------experiments

select * from ecom.experiments

Grain: One record= unique experiments

Rowcount :6

This is the main table for A/B testing. It tells us what experiment the company is running and why.


PK: experiment_id


------------------------------------------------------inventory_items

select * from ecom.inventory_items

Grain: One row = available and reserved stock of each product variant

Rowcount: 2000

Stores the available and reserved stock of each product variant in different warehouses.

FK: Variant_id

--------------------------------------------------------inventory_movements

select * from ecom.inventory_movements

Grain: One row = One inventory movement  for a product variant in a warehouse.

Rowcount: 30207

Purpose:Stores the transaction history of the warehouse inventory.


PK: movement_id

FK: varint_id

------------------------------------------------------------loyalty_accounts

select * from ecom.loyalty_accounts

Grain: One Row represents the tier of one customer

Rowcount: 3000

Purpose: It stores which loyalty membership tier a customer belongs to.


FK: customer_id

-----------------------------------------------------------loyalty_transactions

select * from ecom.loyalty_transactions

Grain: One row = One loyalty points transaction for a customer.

Rowcount: 

Purpose: stores the history of loyalty points earned  by customers.

FK: customer_id


-------------------------------------------------------marketing_campaigns

select * from ecom.marketing_campaigns

Grain: One row = One marketing campaign.

Rowcount: 100

Purpose: This table stores marketing campaigns run by the company.

PK: campaign_id

----------------------------------------------------notifications

select * from ecom.notifications

Grain: One row = One notification sent to a customer.

Rowcount: 6856

Purpose: This table stores notifications sent to customers.


PK: notification_id

FK: customer_id, related_session_id 


-----------------------------------------------------order_items

select * from ecom.order_items

Grain: One row = One product variant (line item) within an order.

Rowcount: 81806

Purpose: It stores each product inside an order.

FK: order_id, variant_id


-----------------------------------------------------order_refunds

select * from ecom.order_refunds


Grain: One row= refundamount for aan order

Rowcount: 260

Purpose: It stores how much money was refunded for an order.

FK: order_id


---------------------------------------------------------order_status_history

select * from ecom.order_status_history

Grain: One row = One status change event for an order.

Rowcount: 158414

Purpose: This table stores the history of an order's status.


FK : orderid 

----------------------------------------------------------------orders

select * from ecom.orders

Grain: One row=one order

Rowcount: 40000

Purpose:It stores one row per order.

PK: order_id

FK: customer_id, session_id


Case drift ( 'shipped', 'Shipped', 'SHIPPED')  in orders.status

---------------------------------------------------------------payment_intents

select * from ecom.payment_intents


Grain: One row = One payment intent  for an order.

Rowcount: 40000

Stores how the customer paid and whether the payment was successful.


PK: payment_intent_id

FK: order_id, payment_method_id

------------------------------------------------------------payment_methods

select * from ecom.payment_methods

Grain: One row=one payemtMethod

Rowcount: 5

It stores the list of payment methods available on the e-commerce website.


Pk: payment_method_id


---------------------------------------------------------payment_transactions

select * from ecom.payment_transactions


Grain: One row represents one payment gateway transaction for a payment intent

Rowcount: 40034

Purpose: This table stores the actual payment transaction attempts with the payment gateway.


PK: txn_id

Fk: payment_intent_id


------------------------------------------------------------price_lists

select * from ecom.price_lists

Grain : One row= one currency list/pricelist

Rowcount: 2

Purpose: It stores different price lists for different countries or currencies.

PK: price_list_id



------------------------------------------------------------prices

select * from ecom.prices

Grain: One row represents one pricing record for a product variant in a specific price list during a defined validity period.

Rowcount: 2

Purpose: This table stores the price of each product variant.


FK: price_list_id, variant_id

-----------------------------------------------------product_images

select * from ecom.product_images

Grain: One row = One image associated with a specific product.

Rowcount: 7188

Purpose: It stores the images of each product.


PK: image_id

FK: product_id

-------------------------------------------------------product_reviews

select * from ecom.product_reviews

Grain: One row=One product Review

Rowcount: 8000

Purpose:This table stores customer reviews for products.


PK: review_id

Fk: product_id, customer_id, order_id


--------------------------------------------------------------product_variants

select * from ecom.product_variants

Grain: One row = One unique  product variant

Rowcount: 12090

Purpose: stores different versions of the same product

PK: variant_id

Fk: product_id


---------------------------------------------------------products

select * from ecom.products

Grain: One row=one unique product and its description

Rowcount: 4000

Purpose: The products table stores the main information about each product.

Pk: product_id

Fk: brand_id, category_id


------------------------------------------------------------promotion_rules

select * from ecom.promotion_rules

Grain: One row = One eligibility rule for a promotion.

Rowcount: 30

Purpose: This table stores the rules for applying a promotion or discount.

Pk: rule_id

Fk: product_id,category_id, promo_id


-----------------------------------------------------------------promotions

select * from ecom.promotions

Grain: One row = One promotion.

Rowcount: 20

Purpose: This table stores the details of promotions

Pk: promo_id



-----------------------------------------------------------------refunds

select * from ecom.refunds


Grain: One row = One refund issued for an order.

Rowcount: 260

Purpose: It stores every refund transaction


Pk: refund_id

Fk: order_id

------------------------------------------------------------------return_items

select * from ecom.return_items


Grain: One row = One product variant returned as part of a return.

Rowcount: 2004

Purpose: This table stores which products were returned by the customer.


Fk: variant_id, reason_id,return_id


------------------------------------------------------------------------return_reasons

select * from ecom.return_reasons

Grain: Onerow= one return reason

Rowcount: 8

Purpose: stores the reason  for returning

PK: reason_id

-------------------------------------------------------------------------return_requests

select * from ecom.return_requests

Grain: One row = One return request.

Rowcount: 1603

Purpose: This table stores the overall return request made by a customer.

Pk: return_id



--------------------------------------------------------------------segment_memberships


select * from ecom.segment_memberships

Grain: One row = One customer's membership in a specific customer segment during a defined validity period.

Rowcount: 16461

Purpose: Which customer belongs to which segment, and for how long?


Fk: segment_id, customer_id


-----------------------------------------------------------------------session_channels

select * from ecom.session_channels

Grain: One row=one channel through which customer visited the ecommerce website/app  for a session

Rowcount: 100000

Purpose: Stores How did this visitor reach the website?


Fk: session_id

--------------------------------------------------------------------session_events

select * from ecom.session_events


Grain: One row = One user interaction during a session.

Rowcount: 292903

Purpose: It stores every action  a customer performs during a session.


Pk: event_id

Fk: session_id, customer_id, product_id, variant_id, order_id


-----------------------------------------------------------------------sessions

select * from ecom.sessions

Grain: One row = One user browsing session.

Rowcount: 100000

Purpose: The sessions table stores information about each visit to the e-commerce website or app.


PK : session_id

Fk: device_id, customer_id

--------------------------------------------------------------------------shipments

select * from ecom.shipments


Grain: One row = One shipment for an order.

Rowcount: 32089

Purpose: The shipments table stores the delivery details of an order after it has been placed.


Pk: shipment_id

Fk: order_id, Carrier_id, shipping_method_id

-----------------------------------------------------------------------shipping_carriers

select * from ecom.shipping_carriers

Grain: one row=one shipping carrier

Rowcount: 3

Purpose: Stores the courier companies used for order deliveries.


Pk: carrier_id

--------------------------------------------------------------------shipping_methods

select * from ecom.shipping_methods

Grain: One row= one shipping methods

Rowcount: 3

Purpose: Stores available shipping methods and their base shipping charges

Pk: shipping_method_id
