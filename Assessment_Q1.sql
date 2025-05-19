-- Q1: High-Value Customers with Multiple Products

/* Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
Tables:
users_customuser
savings_savingsaccount
plans_plan 
*/

SELECT 
    u.id AS owner_id,
    u.first_name,
    u.last_name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    SUM(s.confirmed_amount) / 100 AS total_deposits -- Convert from Kobo to Naira
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s 
    ON u.id = s.owner_id AND s.confirmed_amount > 0
JOIN 
    plans_plan p 
    ON u.id = p.owner_id AND p.is_a_fund = 1 AND p.last_charge_date IS NOT NULL
WHERE 
-- Check if this user has at least one savings account with deposit > 0
    EXISTS (
        SELECT 1 FROM savings_savingsaccount s2 
        WHERE s2.owner_id = u.id AND s2.confirmed_amount > 0
    )
    AND EXISTS (
    -- Check if this user has at least one funded investment plan (is_a_fund = 1 and funded = TRUE)
        SELECT 1 FROM plans_plan p2 
        WHERE p2.owner_id = u.id AND p2.is_a_fund = 1 AND p.last_charge_date IS NOT NULL
    )
GROUP BY 
    u.id, u.first_name, u.last_name
ORDER BY 
    total_deposits DESC;