## Executive Summary
Our India supply-chain E-commerce fulfillment network is experiencing a 5.00% CPT (Customer Promise Time) breach rate across 10 nodes, with 3 Dark Stores (Rohini, Whitefield, Powai) showing critical late-delivery rates of 85–95% — while handling only 4.71–5.88% utilization of their capacity. This is not an overload problem; it is a process and staffing problem. I analyzed 40,000 orders, 10 nodes, 8 carriers, across a six-month period to identify the main operational bottlenecks. The analysis found that some Dark Stores have very high late-delivery rates despite relatively low order volumes, indicating that poor performance is not only caused by capacity. Further analysis of picking, workers, inventory, shipments, carriers, and costs helped identify potential root causes. I recommend improving picking performance, inventory accuracy, replenishment routes, carrier management, and node-level SLA monitoring.

## Business Problem:
On-time delivery is essential for this supply-chain company because delays directly affect customer satisfaction, cancellations, returns, and operating costs. Operations stakeholders need to understand which nodes are underperforming and why. How can we identify whether delays are caused by node workload, picking performance, inventory shortages, shipment/carrier issues, or operating costs?

## Methodology:
### 1. Data Pipeline
- Loaded 6 raw CSVs (50,000 orders, 10 nodes, 8 carriers)
- Cleaned in Python: standardized columns, fixed types, verified referential integrity
- Loaded into PostgreSQL via SQLAlchemy
- Built relationships between tables
### 2. SQL Analysis
PostgreSQL was used to investigate node capacity, daily workload, workers, DPMO, inventory shortages, carrier delays, shipments, and cost per order.

## Skills:
SQL: CTEs, Joins, CASE, aggregate functions, window functions, date/time analysis, KPI calculations
PostgreSQL: Data analysis, CPT/late-delivery analysis, DPMO, capacity utilization, inventory accuracy, carrier performance, cost analysis
Python: Pandas, NumPy, data cleaning, data validation, PostgreSQL connection

## Results & Business Recommendation:
### Key Findings
<img width="409" height="128" alt="image" src="https://github.com/user-attachments/assets/3d486214-edb6-4657-a520-3d1810c46bdf" />

Based on these findings, I recommend:
- Improve picking processes and monitor high-DPMO workers.
- Increase cycle counts at nodes with high inventory shortages.
- Review carrier performance by specific route, not only overall carrier performance.
- Investigate replenishment delays to problem Dark Stores.
- Monitor node-level CPT, workload, capacity, and cost per order through Power BI.
- Prioritize operational improvements at Whitefield, Rohini, and Powai because they have high SLA problems despite lower order volumes.

These changes should help reduce late deliveries, picking errors, inventory discrepancies, and unnecessary operating costs while improving customer experience.

## Next Steps:
1. **A/B test** peak-hour staffing at Whitefield for 2 weeks
2. **Train** warehouse managers on new SKU placement SOP
3. **Negotiate** with Carrier Ecom Express using this data
4. **Roll out** dashboard to all node managers
5. **Measure** impact after 30 days: CPT breach, cost per order, FTR
