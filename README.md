# Supply-Chain-Root-Cause-Analysis

## Executive Summary
Our India supply-chain E-commerce network has experienced inconsistent delivery performance, inventory discrepancies, picking errors, and increasing operational costs. Using Python for data cleaning, PostgreSQL for analysis, I analyzed 40,000 orders across a six-month period to identify the main operational bottlenecks. The analysis found that some Dark Stores have very high late-delivery rates despite relatively low order volumes, indicating that poor performance is not only caused by capacity. Further analysis of picking, workers, inventory, shipments, carriers, and costs helped identify potential root causes. I recommend improving picking performance, inventory accuracy, replenishment routes, carrier management, and node-level SLA monitoring.

## Business Problem:
On-time delivery is essential for this supply-chain company because delays directly affect customer satisfaction, cancellations, returns, and operating costs. Operations stakeholders need to understand which nodes are underperforming and why. How can we identify whether delays are caused by node workload, picking performance, inventory shortages, shipment/carrier issues, or operating costs?

## Methodology:
Python was used to clean and prepare the 40,000-order dataset and connect the cleaned data to PostgreSQL.
PostgreSQL was used to investigate node capacity, daily workload, workers, DPMO, inventory shortages, carrier delays, shipments, and cost per order.

## Skills:
SQL: CTEs, Joins, CASE, aggregate functions, window functions, date/time analysis, KPI calculations
PostgreSQL: Data analysis, CPT/late-delivery analysis, DPMO, capacity utilization, inventory accuracy, carrier performance, cost analysis
Python: Pandas, NumPy, data cleaning, data validation, PostgreSQL connection

## Results & Business Recommendation:
The analysis of 40,000 orders over six months showed an overall late-delivery rate of approximately 13.88%. The biggest issue was concentrated in three lower-volume Dark Stores: Whitefield DS had 93.49% late deliveries, Rohini DS 88.16%, and Powai DS 83.89%. This showed that poor SLA performance was not simply a result of high order volume or capacity utilization.

Further analysis identified operational issues across picking, workers, inventory, shipments, carriers, and costs. Some workers had consistently higher picking errors and DPMO, while the problem nodes also showed weaker inventory accuracy. Carrier analysis showed that some carriers performed well overall but experienced significantly higher delays on specific Dark Store routes.

Based on these findings, I recommend:
-Improve picking processes and monitor high-DPMO workers.
-Increase cycle counts at nodes with high inventory shortages.
-Review carrier performance by specific route, not only overall carrier performance.
-Investigate replenishment delays to problem Dark Stores.
-Monitor node-level CPT, workload, capacity, and cost per order through Power BI.
-Prioritize operational improvements at Whitefield, Rohini, and Powai because they have high SLA problems despite lower order volumes.

These changes should help reduce late deliveries, picking errors, inventory discrepancies, and unnecessary operating costs while improving customer experience.

## Next Steps:
Build node-level CPT/SLA alerts.
Review worker performance by shift and process.
Analyze SKU-level inventory shortages and defects.
Review carrier performance by route every week.
Validate operational findings with supply-chain teams.
Track before-and-after performance for the problem Dark Stores.
