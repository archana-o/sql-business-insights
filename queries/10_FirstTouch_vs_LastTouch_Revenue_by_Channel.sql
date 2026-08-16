-- Q10: How does revenue attribution change between first-touch and last-touch marketing channels?
-- Owner: Archana
-- Last updated: 2026-08-10
-- Sanity check: Total revenue under first_touch equals total under last_touch equals
                 total non-cancelled revenue in ecom.orders, within 0.5%. -> confirmed



WITH touches AS (
    SELECT
        o.order_id,
        o.total,
        t.touched_at,
        t.channel,

        ROW_NUMBER() OVER (
            PARTITION BY o.order_id
            ORDER BY t.touched_at ASC NULLS LAST
        ) AS first_touch,

        ROW_NUMBER() OVER (
            PARTITION BY o.order_id
            ORDER BY t.touched_at DESC NULLS LAST
        ) AS last_touch

    FROM ecom.orders o

    LEFT JOIN ecom.attribution_touches t
        ON o.session_id = t.session_id
        AND t.touched_at <= o.created_at

    WHERE LOWER(o.status) <> 'cancelled'
),

first_touch AS (
    SELECT
        'first_touch' AS attribution_model,
        COALESCE(channel, 'direct') AS channel,
        SUM(total) AS revenue,
        COUNT(order_id) AS orders

    FROM touches

    WHERE first_touch = 1

    GROUP BY
        COALESCE(channel, 'direct')
),

last_touch AS (
    SELECT
        'last_touch' AS attribution_model,
        COALESCE(channel, 'direct') AS channel,
        SUM(total) AS revenue,
        COUNT(order_id) AS orders

    FROM touches

    WHERE last_touch = 1

    GROUP BY
        COALESCE(channel, 'direct')
),

combined AS (
    SELECT *
    FROM first_touch

    UNION ALL

    SELECT *
    FROM last_touch
)

SELECT
    attribution_model,
    channel,
    revenue,
    orders,

    ROUND(
        100.0 * revenue
        / NULLIF(
            SUM(revenue) OVER (
                PARTITION BY attribution_model
            ),
            0
        ),
        2
    ) AS share_of_revenue

FROM combined

ORDER BY
    revenue DESC;
