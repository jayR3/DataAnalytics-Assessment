# DataAnalytics-Assessment - MySQL Assessment Queries 

## 👇 Overview
This project contains SQL queries to solve four real-world business problems using a relational database with customer, savings, plans, and withdrawals data.

## Contents

1. `Assessment_Q1.sql` — Identify high-value customers who use both savings and investment products.
2. `Assessment_Q2.sql` — Segment customers by average monthly transaction frequency.
3. `Assessment_Q3.sql` — Detect inactive plans based on transaction history.
4. `Assessment_Q4.sql` — Estimate Customer Lifetime Value (CLV) using transaction and tenure data.



---

## 🔍 Questions Breakdown

### Q1: High-Value Customers with Multiple Products
- **Approach**: I joined savings and plans tables with conditions to ensure one funded savings and one investment plan per user. Grouped by user and summed deposits.
- **Challenge**: Filtering for both product types without double-counting was tricky, i resolved this using `EXISTS` clauses.

### Q2: Transaction Frequency Analysis
- **Approach**: Counted monthly transactions per customer, averaged them, and grouped into frequency categories.
- **Challenge**: Adjusting for customers with short account history; used `AVG()` over per-month counts.

### Q3: Account Inactivity Alert
- **Approach**: Found latest transaction dates per plan. Calculated difference from today to find inactivity over 365 days.
- **Challenge**: Normalizing plan data across different types (savings/investment); solved using `UNION`.

### Q4: Customer Lifetime Value Estimation
- **Approach**: Used tenure in months and transaction data to compute CLV using a simplified formula.
- **Challenge**: Handling zero tenure to avoid divide-by-zero errors.
