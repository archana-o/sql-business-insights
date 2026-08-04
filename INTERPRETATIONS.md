## Q1 — Daily Business Summary with DoD and Same-Weekday WoW Analysis

### **What the query does**
Creates a daily business performance report by combining revenue, order volume, average order value (AOV), paid order rate, cancellation rate, refund amount, and revenue growth compared with the previous day (DoD) and the same weekday from the previous week (WoW).

### **Pattern choice**
The query uses separate Common Table Expressions (CTEs) to aggregate orders and refunds independently before joining them by date, keeping the logic modular and easy to maintain. Window functions (`LAG`) are used to calculate Day-over-Day (DoD) and Same-Weekday Week-over-Week (WoW) revenue growth without requiring expensive self-joins.

### **Business interpretation**
This report provides a daily snapshot of business performance and operational health. Revenue growth is most meaningful when accompanied by stable payment success rates and low cancellation and refund rates, indicating sustainable business growth. Conversely, rising cancellations or refunds alongside increasing revenue may signal fulfillment issues, product quality concerns, or customer dissatisfaction that require further investigation.

### **What I'd ask next**
- Is revenue growth driven primarily by higher order volume or an increase in Average Order Value (AOV)?
- Which products, categories, or customer segments contribute the most to cancellations and refunds?
- How do promotions, marketing campaigns, or seasonal trends influence revenue, payment success, and refund behavior over time?

----
  ## Q2 — Monthly Customer Cohort Retention Analysis

### **What the query does**
Groups customers into monthly signup cohorts and measures the percentage of customers who return to place a non-cancelled order in the first (M1), second (M2), and third (M3) months after signup.

### **Pattern choice**
The query uses a cohort-based approach by assigning each customer to a fixed signup month and joining it with the orders table. Conditional aggregation with `COUNT(DISTINCT CASE WHEN ...)` efficiently calculates retention for multiple months in a single query while preventing duplicate customers from being counted more than once.

### **Business interpretation**
This analysis measures customer retention and long-term engagement after acquisition. Higher retention rates indicate that customers continue to find value in the platform, while declining retention over time may suggest issues with customer satisfaction, onboarding, or repeat purchase behavior. Comparing retention across cohorts also helps evaluate whether newer customer cohorts are becoming more or less engaged than earlier ones.

### **What I'd ask next**
- Which acquisition channels (Organic, Paid Search, Social Media, Referral, etc.) produce the highest-retaining customer cohorts?
- At what point do customers drop off the most, and what initiatives could improve repeat purchases after signup?
----
## Q3 — Funnel Conversion by Acquisition Channel

### **What the query does**
Analyzes the customer purchase funnel by acquisition channel, measuring how many sessions progress through each stage of the buying journey—from product view to add-to-cart, checkout, and final purchase—and calculates conversion rates between each stage.

### **Pattern choice**
The query uses conditional aggregation with `COUNT(DISTINCT CASE WHEN ...)` to calculate each funnel stage in a single pass through the session events table. Grouping by acquisition channel allows direct comparison of funnel performance across different marketing sources without requiring multiple joins or separate queries.

### **Business interpretation**
This analysis identifies where customers drop off in the purchase journey for each acquisition channel. A channel with a high session-to-purchase rate attracts highly qualified traffic, while a channel with a large drop between stages may indicate friction in the user experience or lower-quality traffic. Comparing conversion rates across channels helps marketing teams optimize budget allocation toward channels that generate the highest return on investment.

### **What I'd ask next**
- At which funnel stage does each channel experience the greatest customer drop-off?
- How do funnel conversion rates change over time, especially during promotions or marketing campaigns?
----
## Q4 — Product Revenue, Returns, and Refund Analysis

### **What the query does**
Analyzes product-level business performance by calculating gross revenue, order count, units sold, return rate, refund amount, and net revenue, then ranks products based on net revenue.

### **Pattern choice**
The query separates revenue, returns, and refunds into independent Common Table Expressions (CTEs) before combining them at the product level. This modular approach keeps each business metric isolated, improves readability, and simplifies future enhancements. Aggregations are performed before the joins to avoid unnecessary row duplication and ensure accurate calculations.

### **Business interpretation**
This report identifies the products that contribute the most to revenue while accounting for returns and refunds. Products with high gross revenue but equally high return or refund rates may indicate quality issues, inaccurate product descriptions, sizing problems, or customer dissatisfaction. Net revenue provides a more realistic measure of product profitability than gross sales alone, helping prioritize products that generate sustainable business value.

### **What I'd ask next**
- Which product categories have the highest return and refund rates, and what are the common reasons?
- Do return and refund rates vary by customer segment, region, or sales channel?
-----
## Q5 — Category Sales and Return Rate Analysis

### **What the query does**
Summarizes sales performance by product category, reporting the number of paid orders, units sold, total revenue, total returns, and the return rate for each category.

### **Pattern choice**
The query uses separate CTEs to independently aggregate sales and returns before joining them at the category level. This approach keeps the calculations modular, improves readability, and avoids mixing sales and return logic in a single aggregation.

### **Business interpretation**
This analysis helps identify which product categories generate the most revenue while maintaining acceptable return rates. Categories with high revenue but also high return rates may indicate issues such as product quality, sizing inconsistencies, or inaccurate product descriptions. Categories with strong sales and low return rates are likely to be the most reliable contributors to business growth and customer satisfaction.

### **What I'd ask next**
- What are the primary reasons for returns (e.g., damaged items, wrong size, incorrect product)?
- How do return rates vary across customer segments, regions, or acquisition channels?
- Which categories deliver the highest profit after accounting for returns and refunds?
----
## Q6 — Payment Failure Analysis by Payment Method

### **What the query does**
Analyzes payment performance by payment method, reporting the total number of payment attempts, failed transactions, failure rate, the most common error code and error message, and the percentage of failures attributed to the top error.

### **Pattern choice**
The query separates payment performance and error analysis into two CTEs. The first CTE calculates payment attempts and failures, while the second aggregates payment errors and uses the `ROW_NUMBER()` window function to identify the most frequent error code and message for each payment method. This modular design keeps the logic easy to understand and maintain.

### **Business interpretation**
This analysis helps identify payment methods with poor transaction success rates and highlights the primary reasons for payment failures. A high failure rate concentrated around a single error code often indicates a systematic issue, such as gateway downtime, authentication failures, or payment provider configuration problems. Resolving the most common failure reason can significantly improve payment success rates, customer experience, and overall revenue.

### **What I'd ask next**
- Are payment failure rates increasing or decreasing over time?
- Which customer segments, devices, or regions experience the highest payment failures?
- What percentage of failed payments are successfully completed after a retry?
----
## Q7 — Shipping Carrier Performance Analysis

### **What the query does**
Evaluates the performance of each shipping carrier and shipping method by reporting delivered orders, average delivery time, median delivery time, 90th percentile (P90) delivery time, late deliveries, and the percentage of late deliveries.

### **Pattern choice**
The query separates shipment volume and delivery performance into two Common Table Expressions (CTEs). Aggregate functions are used to calculate delivery metrics, while percentile functions (`PERCENTILE_CONT`) provide a more robust view of delivery performance by measuring the typical (median) and worst-case (P90) delivery times. The results are then combined at the carrier and shipping method level.

### **Business interpretation**
This analysis helps compare shipping carriers based on both efficiency and reliability. While the average delivery time provides an overall performance measure, the median and P90 delivery times reveal whether a small number of delayed shipments are impacting customer experience. A high late delivery rate may indicate operational inefficiencies, logistics bottlenecks, or carrier performance issues that could negatively affect customer satisfaction and repeat purchases.

### **What I'd ask next**
- Do late deliveries vary by shipping method (Standard, Express, Same-Day) or destination region?
- Are delivery delays seasonal, or are they concentrated during promotional events and peak sales periods?
- How do late deliveries impact customer ratings, return rates, and repeat purchase behavior?
----
## Q8 — Customer Lifetime Value (LTV) Segmentation

### **What the query does**
Calculates each customer's Lifetime Value (LTV) by summarizing their completed purchase history, including first and last order dates, total orders, total revenue, Average Order Value (AOV), and assigns each customer to an LTV bucket. It also calculates the percentage of total revenue contributed by each LTV segment.

### **Pattern choice**
The query first aggregates customer-level purchase metrics and uses a `CASE` expression to segment customers into predefined LTV buckets. Window functions (`SUM() OVER`) are then used to calculate each bucket's share of total revenue without requiring additional aggregation or subqueries.

### **Business interpretation**
This analysis helps identify which customer segments contribute the most to overall revenue. Although high-value customers typically represent a smaller portion of the customer base, they often account for a disproportionately large share of revenue, making them ideal candidates for loyalty programs and personalized marketing. Conversely, low-LTV customers may benefit from targeted campaigns aimed at increasing repeat purchases and improving customer lifetime value.

### **What I'd ask next**
- Do high-LTV customers have higher retention rates and purchase frequencies than low-LTV customers?
- Which acquisition channels are responsible for acquiring the highest-value customers?
- How does Average Order Value (AOV) and purchase frequency vary across different LTV segments?
----
## Q9 — Repeat Purchase Interval Analysis

### **What the query does**
Analyzes repeat purchase behavior by calculating the average, median, and 90th percentile (P90) number of days between consecutive non-cancelled orders. It also reports the number of customers who placed more than one completed order.

### **Pattern choice**
The query uses the `LEAD()` window function to identify each customer's next purchase date and calculate the time between consecutive orders without requiring a self-join. A separate CTE identifies repeat customers, while percentile functions (`PERCENTILE_CONT`) provide a more robust measure of customer repurchase behavior than relying solely on the average.

### **Business interpretation**
This analysis measures how frequently customers return to make another purchase, providing insight into customer loyalty and purchasing habits. Shorter intervals between purchases generally indicate stronger customer engagement, while longer intervals may suggest opportunities for re-engagement campaigns. The median and P90 metrics help distinguish typical customer behavior from customers who take significantly longer to return.

### **What I'd ask next**
- How does the repeat purchase interval vary across customer segments, acquisition channels, or regions?
- Which product categories encourage customers to make repeat purchases more quickly?
- What percentage of first-time customers make a second purchase within 30, 60, or 90 days?
-----
## Q10 — Marketing Attribution: First Touch vs. Last Touch

### **What the query does**
Compares two attribution models—First Touch and Last Touch—by assigning revenue and orders to marketing channels based on the customer's first interaction and most recent interaction before purchase. It also calculates each channel's share of total attributed revenue under both models.

### **Pattern choice**
The query uses the `ROW_NUMBER()` window function to identify the first and last marketing touchpoints for each customer without requiring complex self-joins. Separate CTEs aggregate revenue and orders for each attribution model, making it easy to compare how channel performance changes depending on the attribution methodology.

### **Business interpretation**
This analysis demonstrates how marketing channel performance varies under different attribution models. First Touch highlights the channels most effective at acquiring new customers, while Last Touch identifies the channels that ultimately influence conversions. Comparing both models helps marketing teams understand the customer journey and allocate budgets more effectively across awareness and conversion-focused campaigns.

### **What I'd ask next**
- Which channels consistently perform well in both First Touch and Last Touch attribution?
- Which acquisition channels generate the highest Customer Lifetime Value (LTV), not just the highest attributed revenue?
