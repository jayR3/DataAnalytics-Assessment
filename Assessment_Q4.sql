-- 4. Customer Lifetime Value (CLV) Estimation

/* Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).
Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest */


WITH transactions AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) / 100 AS total_value,
        AVG(confirmed_amount) / 100 AS avg_value
    FROM 
        savings_savingsaccount
    GROUP BY owner_id
),
tenure AS (
    SELECT 
        id AS customer_id,
        name,
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months
    FROM users_customuser
)
SELECT 
    t.customer_id,
    t.name,
    t.tenure_months,
    COALESCE(s.total_transactions, 0) AS total_transactions,
    ROUND(
        (COALESCE(s.total_transactions, 0) / NULLIF(t.tenure_months, 0)) * 12 * COALESCE(s.avg_value, 0),
        2
    ) AS estimated_clv
FROM tenure t
LEFT JOIN transactions s ON s.owner_id = t.customer_id
ORDER BY estimated_clv DESC;