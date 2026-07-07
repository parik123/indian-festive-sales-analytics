-- ====================================================================
-- PROJECT: Indian Festive Season Sales Analytics Engine
-- DOMAIN: E-Commerce Retail (India Marketplace Focus)
-- TECH STACK: SQL (PostgreSQL / MySQL / BigQuery compatible)
-- ====================================================================

-- 1. SCHEMA SETUP & TABLE CREATION
CREATE TABLE regional_customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    state VARCHAR(50),
    tier_classification VARCHAR(10) -- Tier-1, Tier-2, Tier-3
);

CREATE TABLE festive_orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    gmv_amount_inr DECIMAL(10, 2), -- Gross Merchandise Value
    payment_mode VARCHAR(30), -- UPI, Cash on Delivery (COD), Credit Card
    product_category VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES regional_customers(customer_id)
);

-- 2. POPULATE COMPREHENSIVE MOCK DATA (Indian Retail Market Dynamics)
INSERT INTO regional_customers VALUES
(501, 'Amit Sharma', 'Maharashtra', 'Tier-1'),
(502, 'Priya Rao', 'Karnataka', 'Tier-1'),
(503, 'Rohan Verma', 'Delhi NCR', 'Tier-1'),
(504, 'Ananya Das', 'West Bengal', 'Tier-2'),
(505, 'Suresh Kumar', 'Bihar', 'Tier-3'),
(506, 'Megha Reddy', 'Telangana', 'Tier-1'),
(507, 'Vikram Singh', 'Rajasthan', 'Tier-2');

INSERT INTO festive_orders VALUES
('ZOM-8801', 501, '2025-09-15', 45000.00, 'UPI', 'Electronics'),       -- Pre-Festive baseline
('ZOM-8802', 502, '2025-10-12', 85000.00, 'UPI', 'Electronics'),       -- Festive Spike (Diwali window)
('ZOM-8803', 503, '2025-10-13', 12000.00, 'Credit Card', 'Apparel'),   -- Festive Spike
('ZOM-8804', 504, '2025-10-14', 3500.00,  'Cash on Delivery', 'Home'), -- Festive Spike Tier-2 COD
('ZOM-8805', 505, '2025-10-15', 1800.00,  'Cash on Delivery', 'Apparel'),-- Festive Spike Tier-3 COD
('ZOM-8806', 506, '2025-10-16', 95000.00, 'UPI', 'Electronics'),       -- High-value electronic purchase
('ZOM-8807', 502, '2025-11-05', 15000.00, 'UPI', 'Home'),              -- Post-Festive wrap-up
('ZOM-8808', 507, '2025-10-14', 6200.00,  'UPI', 'Apparel');

-- ====================================================================
-- 3. BUSINESS ANALYTICS QUERIES (Showcasing Core Portfolio Capabilities)
-- ====================================================================

-----------------------------------------------------------------------
-- QUERY 1: Regional Sales Velocity & GMV Tiers via Window Functions
-- Purpose: Ranks states based on total GMV contributions.
-----------------------------------------------------------------------
SELECT 
    c.state,
    c.tier_classification,
    SUM(o.gmv_amount_inr) AS total_gmv_inr,
    COUNT(DISTINCT o.order_id) AS total_orders,
    -- Window Function to rank state performance dynamically
    RANK() OVER (ORDER BY SUM(o.gmv_amount_inr) DESC) AS geographical_rank,
    -- Window Function to calculate cumulative running GMV contribution
    SUM(SUM(o.gmv_amount_inr)) OVER (ORDER BY SUM(o.gmv_amount_inr) DESC) AS running_total_gmv
FROM festive_orders o
JOIN regional_customers c ON o.customer_id = c.customer_id
GROUP BY c.state, c.tier_classification;


-----------------------------------------------------------------------
-- QUERY 2: Month-over-Month (MoM) Growth Analysis Using CTEs & LAG()
-- Purpose: Quantifies the extreme sales velocity spikes during peak festive cycles.
-----------------------------------------------------------------------
WITH MonthlyMetrics AS (
    SELECT 
        -- Extract timeline segments (Year-Month formatting)
        DATE_FORMAT(order_date, '%Y-%m') AS order_month,
        SUM(gmv_amount_inr) AS monthly_gmv,
        AVG(gmv_amount_inr) AS average_ticket_size
    FROM festive_orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT 
    order_month,
    monthly_gmv AS current_month_gmv,
    -- Window function to fetch previous month's value for comparison
    LAG(monthly_gmv) OVER (ORDER BY order_month) AS previous_month_gmv,
    average_ticket_size,
    ROUND(((monthly_gmv - LAG(monthly_gmv) OVER (ORDER BY order_month)) / 
           LAG(monthly_gmv) OVER (ORDER BY order_month)) * 100, 2) AS mom_growth_percentage
FROM MonthlyMetrics;


-----------------------------------------------------------------------
-- QUERY 3: Payment Preferences by Regional Demographic Tiers
-- Purpose: Evaluates the ratio of digital transactions (UPI) against risk assets (COD).
-----------------------------------------------------------------------
SELECT 
    c.tier_classification,
    o.payment_mode,
    COUNT(o.order_id) AS total_transactions,
    SUM(o.gmv_amount_inr) AS payment_mode_gmv,
    ROUND((COUNT(o.order_id) * 100.0 / SUM(COUNT(o.order_id)) OVER(PARTITION BY c.tier_classification)), 2) AS tier_percentage_share
FROM festive_orders o
JOIN regional_customers c ON o.customer_id = c.customer_id
GROUP BY c.tier_classification, o.payment_mode
ORDER BY c.tier_classification, payment_mode_gmv DESC;