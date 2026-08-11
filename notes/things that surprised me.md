
## Five Things That Surprised Me

- **`orders.total`** is the headline total; **`SUM(order_items.line_total)`** should match it for the same **`order_id`**. Where it diverges, decide which is canonical and document the rule.

- **`orders.status`** has mixed case — **`'shipped'`**, **`'SHIPPED'`**, **`'Shipped'`**, **`'delivered'`**, **`'DELIVERED'`** all coexist. Lowercase before grouping or filtering.

- **`orders.payment_status`** is the "did it convert" column (**`paid`**/**`failed`**). **`orders.status`** is fulfillment state. Don't confuse them.

- **`customers.country`** has three null-variants: **`NULL`**, **`''`**, and **`'N/A'`**. Treat all three as missing.

- **`attribution_touches.utm_campaign`** uses the old slug format; **`marketing_campaigns.campaign_id`** uses the new **`CAMP-2026-NNNN`** format. Bridge via **`attribution_campaigns`** for campaign-level joins.
