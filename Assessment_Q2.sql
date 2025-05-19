-- Q2: Transaction Frequency Analysis
/*
Transaction Frequency Analysis
Scenario: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
Task: Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)
*/

WITH monthly_tx AS ( -- This Common Table Expression collects how many transactions each user made per month.Note: monthly_tx means monthly transanctions
    SELECT 
        owner_id, 
        DATE_FORMAT(created_on, '%Y-%m-01') AS tx_month,  -- Format date to first day of each month (e.g., '2025-05-01') to group by month
        COUNT(*) AS tx_count -- number of transactions by that user in that month
    FROM 
        savings_savingsaccount
    GROUP BY owner_id, tx_month  -- group transactions by user and month
),
avg_tx AS ( -- This takes the monthly transaction data and calculates the average number of transactions per month for each user.
    SELECT 
        owner_id,
        AVG(tx_count) AS avg_transactions_per_month
    FROM 
        monthly_tx -- from the first CTE
    GROUP BY owner_id
)
SELECT 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM avg_tx
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;