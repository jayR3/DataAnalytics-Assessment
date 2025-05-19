-- Q3: Account Inactivity Alert

/* Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) . */

WITH all_tx_dates AS (
    SELECT 
        id AS plan_id,
        owner_id,
        'Savings' AS type,
        MAX(created_on) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY id, owner_id

    UNION

    SELECT 
        id AS plan_id,
        owner_id,
        'Investment' AS type,
        MAX(created_on) AS last_transaction_date
    FROM plans_plan
    WHERE is_a_fund = 1 AND amount > 0
    GROUP BY id, owner_id
)
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM 
    all_tx_dates
WHERE 
    last_transaction_date < (CURDATE() - INTERVAL 365 DAY);