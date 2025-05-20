-- 4. Customer Lifetime Value (CLV) Estimation

/* Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).
Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
- Account tenure (months since signup)
- Total transactions
- Estimated CLV 
- Order by estimated CLV from highest to lowest 
CLV Formula Used:
CLV = (total_transactions / tenure_in_months) × 12 × average_transaction_profit */

-- --  Step 1: Calculate Transaction Summary for Each Customer using CTEs
WITH transactions AS (                                     
    SELECT 
        owner_id,                                          -- This is the customer ID from the savings_savingsaccount table.
        COUNT(*) AS total_transactions,                    -- How many transactions the customer made.
        SUM(confirmed_amount) / 100 AS total_value,        -- Total amount the customer has saved (amounts are in kobo, so I divide by 100 to get naira).
        AVG(confirmed_amount) / 100 AS avg_value           -- Average amount per transaction (again in naira)
    FROM 
        savings_savingsaccount
    GROUP BY owner_id                                      -- Grouping by each customer so we get per-customer stats.
),
    -- Step 2: Calculate How Long Each Customer Has Been with Us
tenure AS (
    SELECT 
        id AS customer_id,                                 -- Customer ID from the users_customuser table.
        first_name,                                        -- Customer's first name
        last_name,                                         -- Customer's last name
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months -- Calculates the number of months since the customer joined.
    FROM users_customuser
)
    -- Step 3: Bringing Both Tables Together
SELECT 
    t.customer_id,
    t.first_name,
    t.last_name,
    t.tenure_months,
    COALESCE(s.total_transactions, 0) AS total_transactions,    -- here, i'm saying If a customer has no transactions, set their transaction count to 0 using COALESCE
    ROUND(
        (COALESCE(s.total_transactions, 0) / NULLIF(t.tenure_months, 0)) --  I divide total transactions by tenure to get transactions per month
        * 12 * COALESCE(s.avg_value, 0), 2                               -- Multiply by 12 to estimate yearly transaction frequency and also by average transaction value.
    ) AS estimated_clv                                -- I finally round to 2 dp. I assume profit per transaction is already factored in to avg_value here for simplicity.
FROM tenure t
LEFT JOIN transactions s ON s.owner_id = t.customer_id -- I used LEFT JOIN here to ensures that all customers are included in the final result, even if they’ve never made a transaction.
ORDER BY estimated_clv DESC;

/* Chima Ataman with the customer_id of '1909df3eba2548cfa3b9c270112bd262' is the most important customer for Cowrywise. he has spent a total of '33' months with us,
made a total transactions of '2383', and has a customer lifetime value of '323749896.54'
BONUS TIP: CLTV is a very important metric for any profit-oriented compnay so my recommendation is to reward and retain customers with high CLTV probably top 10 and 
Customers with CLTV of 0 should be targeted by the marketing team with potential rewards if they can make transactions. With a strong online presence, they'll probably see
what other customers received as rewards and that can motivate them to give it a try. 
