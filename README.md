# Indian Festive Season Sales Analytics Dashboard (SQL Engine)

## 📌 Business Scenario
During the annual Indian festive season window (September–November), e-commerce transaction frequencies spike drastically. This project engineers a robust relational database schema to monitor and evaluate **Gross Merchandise Value (GMV)** distribution channels, determine Average Ticket Sizes, rank geographical performance thresholds, and isolate regional payment mode trends (UPI vs. Cash on Delivery) using advanced analytical querying.

## 🛠️ Technical Concepts Demonstrated
* **Advanced Analytical Window Functions:** Implemented `RANK()`, `SUM() OVER()`, and `LAG()` metrics to structure operational running totals and handle transactional temporal sequences over multi-week sales timelines.
* **Complex Data Aggregations & CTEs:** Used Common Table Expressions (CTEs) to segment database querying paths into clean, high-performance logic flows.
* **Relational Schema Integrity:** Engineered proper primary-to-foreign key mappings across consumer demographic tiers and transactional purchase structures.

## 📈 Strategic Data Insights Found
* **Geographical Concentration:** High-value product transactions (Electronics) remained concentrated within Tier-1 metropolitan markets like Maharashtra and Karnataka.
* **Payment Architecture Nuances:** While Tier-1 zones display a heavy structural preference toward immediate digital settlements via UPI, remote Tier-2 and Tier-3 markets show a lingering reliance on Cash on Delivery (COD) for transactional security.
* **Festive Multiplier Effect:** The Month-over-Month calculation captures a definitive multi-fold revenue jump during the October festive peak relative to baseline operational months.
### 📊 Query Execution Output
<img width="897" height="405" alt="Screenshot 2026-07-08 163837" src="https://github.com/user-attachments/assets/ef2223cd-d435-4f3b-87cd-8e0e62ade6fd" />
<img width="887" height="402" alt="Screenshot 2026-07-08 163847" src="https://github.com/user-attachments/assets/572995ed-5a6c-447d-8abd-133e886d4b6a" />
<img width="896" height="377" alt="Screenshot 2026-07-08 163854" src="https://github.com/user-attachments/assets/408b2456-f4ca-4d3d-88b2-28aab7fb2c81" />


