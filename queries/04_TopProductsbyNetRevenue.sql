-- Q4: Which products are driving revenue, and how do returns and refunds affect their net revenue?
-- Owner: Archana
-- Last updated: 2026-08-10
-- Sanity check: sum(gross_revenue) across all products equals sum(qty * unit_price) 
                  from ecom.order_items for the same window, within 0.5%-> confirmed


WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        c.category_name AS category,
        SUM(oi.line_total) AS gross_revenue,
        COUNT(DISTINCT oi.order_id) AS orders_count,
        SUM(oi.qty) AS units_sold
    FROM ecom.orders o
    JOIN ecom.order_items oi
        ON o.order_id = oi.order_id
    JOIN ecom.product_variants v
        ON oi.variant_id = v.variant_id
    JOIN ecom.products p
        ON v.product_id = p.product_id
    JOIN ecom.categories c
        ON p.category_id = c.category_id
    WHERE o.payment_status = 'paid'
    GROUP BY
        p.product_id,
        p.product_name,
        c.category_name
),

product_returns AS (
    SELECT
        v.product_id,
        SUM(ri.qty) AS returns_count,

        SUM(
            ri.qty *
            COALESCE(pr.sale_price, pr.list_price)
        ) AS refund_amount

    FROM ecom.return_requests rr
    JOIN ecom.return_items ri
        ON rr.return_id = ri.return_id
    JOIN ecom.orders o
        ON rr.order_id = o.order_id
    JOIN ecom.product_variants v
        ON ri.variant_id = v.variant_id
    JOIN ecom.prices pr
        ON ri.variant_id = pr.variant_id

    WHERE o.payment_status = 'paid'

    GROUP BY
        v.product_id
)

SELECT
    pr.product_id,
    pr.product_name,
    pr.category,
    pr.gross_revenue,
    pr.orders_count,
    pr.units_sold,

    COALESCE(rt.returns_count, 0) AS returns_count,

    ROUND(
        COALESCE(rt.returns_count, 0) * 100.0
        / NULLIF(pr.units_sold, 0),
        2
    ) AS return_rate,

    ROUND(
        COALESCE(rt.refund_amount, 0),
        2
    ) AS refund_amount,

    ROUND(
        pr.gross_revenue
        - COALESCE(rt.refund_amount, 0),
        2
    ) AS net_revenue

FROM product_revenue pr

LEFT JOIN product_returns rt
    ON pr.product_id = rt.product_id


ORDER BY
    net_revenue DESC;
