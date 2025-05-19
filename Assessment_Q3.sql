-- Q3: Account Inactivity Alert

/* Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) . */

-- this begins a Common Table Expression (CTE) named all_tx_dates.
-- you can think of this like a temporary table that i'm building for reuse in the main query.

WITH all_tx_dates AS (
-- PART 1: Getting Latest Savings Transaction Dates
    SELECT 
        id AS plan_id,                            -- Renaming id to plan_id for uniformity across both savings and investment.
        owner_id,                                 -- Refers to the user who owns this savings plan
        'Savings' AS type,                        -- Adds a label to indicate this row is a savings plan
        MAX(created_on) AS last_transaction_date  -- Finds the most recent transaction date (last activity)
    FROM savings_savingsaccount                   -- Group by unique savings plans per user.
    GROUP BY id, owner_id

   -- PART 2: Getting Latest Investment Transaction Dates
    UNION

    SELECT 
        id AS plan_id,
        owner_id,
        'Investment' AS type,
        MAX(created_on) AS last_transaction_date
    FROM plans_plan
    WHERE is_a_fund = 1 AND amount > 0            -- Filters only actual investment plans (not savings, donations, or empty plans).
    GROUP BY id, owner_id
)
    -- Final SELECT: Analyze Inactivity
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days    -- Calculates how many days have passed since the last activity.
FROM 
    all_tx_dates -- Uses the combined savings + investment data.
WHERE 
    last_transaction_date < (CURDATE() - INTERVAL 365 DAY)           -- Filters to only include plans inactive for over 365 days.
ORDER BY inactivity_days;
