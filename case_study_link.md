# What 10 SQL Queries Told Me About This Business

## Insight 1 — Daily Business Performance

**SQL Query:** [View Daily Business Summary SQL](queries/01_daily_business_summary.sql)

### 1. What I observed

The business shows a sharp decline in revenue on the latest available date, June 14, compared with the previous day. This is important because the objective of a daily business performance analysis is to understand the current direction of the business. The decline also needs to be understood in terms of order volume and customer spending, rather than looking at revenue alone.

### 2. The specific number

Revenue fell from **₹1,698,832.78 on June 13** to **₹437,376.60 on June 14**, a **74.25% day-over-day decline**. Orders also fell from **216 to 75**, while AOV decreased from **₹7,864.97 to ₹5,831.69**.

### 3. Why it matters commercially

This is a significant drop in both order volume and average order value, suggesting that the decline is not caused by just one factor. If this trend continues, it could materially affect overall revenue.

### 4. What I'd do about it on Monday

I would first verify that June 14 contains a complete day's data. If confirmed, I would investigate why orders dropped from 216 to 75, then break the orders down by product/category, customer source, and payment status to identify whether the decline is caused by reduced demand, a specific product issue, or an operational/payment problem.

---

## Insight 2 — Customer Retention

**SQL Query:** [View Monthly Cohort Retention SQL](queries/02_monthly_cohort_retention.sql)

### 1. What I observed

Customer retention drops significantly as the time from the initial signup increases. The March 2026 customer cohort started with 1,664 customers. After their first month, only half of the cohort returned and placed a non-cancelled order. Retention then declined further in the following months, with only a small proportion of the original customers remaining active by month three. This indicates that while the business is able to bring customers back shortly after signup, it is struggling to convert those customers into long-term repeat customers.

### 2. The specific number

The March 2026 cohort had **1,664 customers**. Of these:

- **836 customers (50%)** returned in Month 1
- **697 customers (42%)** returned in Month 2
- **320 customers (19%)** returned in Month 3

So, by Month 3, the business retained only **19% of the original March cohort**.

### 3. Why it matters commercially

This is important because acquiring a new customer generally requires more effort and cost than generating another purchase from an existing customer. Although the business retains 50% of customers in the first month, retention falls to 19% by Month 3. If customers do not return, the business must continuously acquire new customers just to maintain its customer base, which can make sustainable growth more difficult.

### 4. What I'd do about it on Monday

I would investigate why customers are not returning after their first few purchases. I would segment the March cohort by product/category purchased, order value, acquisition source and customer behavior to identify which customer groups have the highest and lowest retention. Based on those findings, I would test targeted re-engagement campaigns, personalised offers, product recommendations or loyalty incentives before the customer reaches the point where they become inactive.

---

## Insight 3 — Payment Failure Analysis

**SQL Query:** [View Payment Failure Analysis SQL](queries/Payment%20Failure%20Analysis%20%28Method%20%C3%97%20Top%20Error%20Code%29)

### 1. What I observed

Payment failures are not evenly distributed across payment methods. UPI has the highest failure rate among the available payment methods and also contributes the largest number of failed transactions. Since UPI is a high-volume payment channel, even a relatively small increase in its failure rate can result in a meaningful number of unsuccessful transactions.

The error analysis also shows that gateway-related failures are a major contributor to UPI failures, suggesting that the problem may not be customer behavior alone but could involve payment infrastructure. This makes payment reliability an important operational issue to investigate, particularly because failed payments can directly translate into lost orders and revenue.

### 2. The specific number

UPI recorded **12,835 payment attempts**, of which **711 failed**, giving it a **5.54% failure rate** — the highest among the payment methods shown.

Its most common error was `GATEWAY_TIMEOUT`, accounting for **23.63% of UPI failures**.

For comparison:

- Card failure rate: **4.18%**
- Net banking failure rate: **4.17%**

### 3. Why it matters commercially

UPI has a large transaction volume, so its **711 failed attempts** represent a significant opportunity for recovery. More importantly, the fact that 23.63% of UPI failures are associated with gateway timeouts suggests that some customers may be unable to complete payments because of technical reliability rather than lack of purchase intent.

Every failed payment is a potential lost order and lost revenue.

### 4. What I'd do about it on Monday

I would first investigate the UPI gateway timeout issue with the payment/engineering team and check whether failures are concentrated around particular times, gateways, banks or transaction amounts.

I would also compare successful versus failed UPI attempts to estimate the potential revenue being lost. If gateway timeouts are confirmed as the main issue, improving gateway reliability or introducing a fallback payment route could directly improve payment conversion.

---

## Insight 4 — Delivery Performance

**SQL Query:** [View Delivery SLA Breach SQL](queries/Delivery%20SLA%20Breach%20by%20Carrier%20%C3%97%20Shipping%20Method)

### 1. What I observed

Delivery performance varies significantly by carrier, particularly for EcomExpress. While its standard shipping method performs reasonably well, its express and same-day deliveries have substantially higher delivery times and late-delivery rates.

This suggests that the issue may be related to the carrier's ability to handle faster shipping commitments rather than simply overall delivery volume. Since delivery experience directly affects customer satisfaction and repeat purchases, consistently late deliveries could also contribute to customer complaints, cancellations, refunds, and lower retention.

### 2. The specific number

For **EcomExpress Express**, there were **2,182 delivered orders**, with an average delivery time of **4.14 days** and a **21.45% late-delivery rate**, meaning **468 orders** were delivered late.

EcomExpress same-day also had a **19.74% late rate**, with **447 late deliveries out of 2,264 orders**.

In comparison, **Bluedart Standard had only a 5.66% late rate**.

### 3. Why it matters commercially

The difference is significant. Customers choosing express or same-day delivery are paying for speed and reliability. A late rate above 20% means roughly **1 in every 5 EcomExpress express deliveries misses the expected delivery timeline**.

This can damage customer trust and potentially lead to cancellations, refunds, complaints, and lower repeat purchases.

### 4. What I'd do about it on Monday

I would investigate EcomExpress performance by location, delivery region, warehouse, and shipment date to identify where the delays are concentrated.

I would also compare the cost of using EcomExpress against better-performing carriers such as Bluedart.

---

## Insight 5 — Customer Repeat Purchase Behavior

**SQL Query:** [View Repeat Purchase Interval SQL](queries/Repeat%20Purchase%20Interval)

### 1. What I observed

The business has a meaningful base of repeat customers, but there is a relatively long gap between a customer's purchases.

Among customers who placed more than one non-cancelled order, the typical customer took 6 days to place their next order, while the average gap was almost 11 days.

The difference between the median and average suggests that although many customers return relatively quickly, a smaller group takes considerably longer to make another purchase.

This gives the business an opportunity to understand what drives customers to return sooner and whether targeted engagement can shorten the repeat-purchase cycle.

### 2. The specific number

The analysis identified **3,418 customers with repeat orders**.

For these repeat customers:

- **Median time to next order:** 6 days
- **Average time to next order:** 10.58 days
- **90th percentile:** 27 days

This means 50% of repeat purchases happen within 6 days, while customers at the slower end can take up to around 27 days or more before their next purchase.

### 3. Why it matters commercially

Repeat customers are important because they generate additional revenue without requiring the business to acquire a completely new customer each time.

A long gap between purchases can indicate that the business is missing opportunities to encourage customers to buy again. If the business can bring customers back even a few days earlier, it could increase purchase frequency, customer lifetime value, and overall revenue.

### 4. What I'd do about it on Monday

I would analyse the **3,418 repeat customers** based on their first product/category purchased, AOV, customer segment and acquisition source.

I would then identify which groups naturally return within 6 days and which take 20–27+ days.

For customers approaching their typical repurchase window, I would test personalised recommendations, reminders, bundles or targeted offers to encourage an earlier second purchase.
