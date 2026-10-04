-- Q1. Are poor-performing nodes actually overloaded, or are they performing poorly despite having available capacity?
WITH w AS (
    SELECT node_id,DATE_TRUNC('week',order_date)::date week,COUNT(*) orders
    FROM orders
    GROUP BY node_id,DATE_TRUNC('week',order_date)
),
u AS (
    SELECT n.node_id,n.node_name,n.node_type,n.capacity_units,
           ROUND(AVG(w.orders),2) avg_weekly_orders,
           ROUND(100*AVG(w.orders)/n.capacity_units,2) utilization_pct
    FROM w JOIN nodes n USING(node_id)
    GROUP BY n.node_id,n.node_name,n.node_type,n.capacity_units
),
o AS (
    SELECT node_id,COUNT(*) total_orders,
           ROUND(100*COUNT(*) FILTER(WHERE order_status='Delivered')/COUNT(*),2) delivered_pct,
           ROUND(100*COUNT(*) FILTER(WHERE order_status='Cancelled')/COUNT(*),2) cancelled_pct,
           ROUND(100*COUNT(*) FILTER(WHERE order_status='Returned')/COUNT(*),2) returned_pct,
           ROUND(100*COUNT(*) FILTER(WHERE actual_delivery>promised_delivery)/
                 NULLIF(COUNT(*) FILTER(WHERE actual_delivery IS NOT NULL),0),2) late_pct
    FROM orders GROUP BY node_id
)
SELECT u.*,o.total_orders,o.delivered_pct,o.cancelled_pct,o.returned_pct,o.late_pct,
       CASE
           WHEN utilization_pct>90 AND late_pct>15 THEN 'High Load + Poor SLA'
           WHEN utilization_pct<40 AND late_pct>15 THEN 'Low Load + Poor SLA'
           WHEN utilization_pct>90 THEN 'High Load'
           ELSE 'Normal'
       END performance
FROM u JOIN o USING(node_id)
ORDER BY utilization_pct DESC;



-- Q2. Are nodes with poor delivery performance also experiencing picking workload or quality problems?
WITH d AS (
    SELECT node_id,pick_start::date dt,COUNT(DISTINCT order_id) orders
    FROM picking
    GROUP BY node_id,pick_start::date
),
p AS (
    SELECT node_id,
           COUNT(DISTINCT worker_id) workers,
           ROUND(AVG(EXTRACT(EPOCH FROM(pick_end-pick_start))/60),2) avg_pick_min,
           ROUND(1000000.0*SUM(errors)/NULLIF(SUM(units_picked),0),2) dpmo
    FROM picking
    GROUP BY node_id
)
SELECT
    n.node_id,n.node_name,n.node_type,
    n.capacity_units weekly_capacity,
    ROUND(n.capacity_units/7.0,2) daily_capacity,
    ROUND(AVG(d.orders),2) avg_daily_orders,
    p.workers,
    ROUND(AVG(d.orders)/p.workers,2) orders_per_worker,
    ROUND(100*AVG(d.orders)/(n.capacity_units/7.0),2) utilization_pct,
    p.avg_pick_min,p.dpmo
FROM d
JOIN nodes n USING(node_id)
JOIN p USING(node_id)
GROUP BY n.node_id,n.node_name,n.node_type,n.capacity_units,
         p.workers,p.avg_pick_min,p.dpmo
ORDER BY utilization_pct DESC;



-- Q3. Which workers consistently generate the highest picking errors and DPMO?
SELECT
    n.node_id,n.node_name,p.worker_id,
    COUNT(*) picks,
    SUM(p.units_picked) units,
    SUM(p.errors) errors,
    ROUND(100*SUM(p.errors)/NULLIF(SUM(p.units_picked),0),2) error_pct,
    ROUND(1000000.0*SUM(p.errors)/NULLIF(SUM(p.units_picked),0),2) dpmo,
    ROUND(AVG(EXTRACT(EPOCH FROM(p.pick_end-p.pick_start))/60),2) avg_pick_min
FROM picking p
JOIN nodes n USING(node_id)
GROUP BY n.node_id,n.node_name,p.worker_id
HAVING SUM(p.units_picked)>=500
ORDER BY dpmo DESC;



-- Q4. Which nodes have the largest inventory shortages and accuracy problems?
SELECT
    n.node_id,n.node_name,n.node_type,
    SUM(i.system_qty) system_units,
    SUM(i.physical_qty) physical_units,
    SUM(GREATEST(i.system_qty-i.physical_qty,0)) shortage_units,
    SUM(GREATEST(i.physical_qty-i.system_qty,0)) excess_units,
    ROUND(100*SUM(i.physical_qty)/NULLIF(SUM(i.system_qty),0),2) accuracy_pct
FROM inventory i
JOIN nodes n USING(node_id)
GROUP BY n.node_id,n.node_name,n.node_type
ORDER BY shortage_units DESC;



-- Q5. Which carriers are good overall but perform poorly on specific Dark Store routes?
WITH c AS (
    SELECT carrier,COUNT(*) shipments,
           ROUND(100*COUNT(*) FILTER(WHERE status='Delayed')/COUNT(*),2) delay_pct
    FROM shipments
    GROUP BY carrier
),
l AS (
    SELECT carrier,to_node_id,COUNT(*) shipments,
           ROUND(100*COUNT(*) FILTER(WHERE status='Delayed')/COUNT(*),2) delay_pct
    FROM shipments
    GROUP BY carrier,to_node_id
)
SELECT
    l.carrier,n.node_id,n.node_name,
    l.shipments,l.delay_pct destination_delay_pct,
    c.delay_pct carrier_delay_pct
FROM l
JOIN c USING(carrier)
JOIN nodes n ON n.node_id=l.to_node_id
WHERE n.node_type='Dark Store'
  AND l.shipments>=20
  AND l.delay_pct>c.delay_pct+20
ORDER BY l.delay_pct DESC;



-- Q6. Which nodes have the highest operating cost per order?
WITH c AS (
    SELECT node_id,cost_type,
           SUM(amount) total_cost,
           SUM(amount)/COUNT(DISTINCT cost_date) avg_daily_cost
    FROM costs
    GROUP BY node_id,cost_type
),
r AS (
    SELECT *, ROW_NUMBER() OVER( PARTITION BY node_id ORDER BY total_cost DESC ) rn
    FROM c
),
o AS (
    SELECT node_id,COUNT(*) orders FROM orders
    GROUP BY node_id
)
SELECT
    n.node_id,n.node_name,n.node_type,
    o.orders,
    r.cost_type highest_cost_category,
    r.total_cost total_cost,
    r.avg_daily_cost avg_daily_cost,
    r.total_cost/o.orders cost_per_order
FROM r
JOIN nodes n USING(node_id)
JOIN o USING(node_id)
WHERE r.rn=1
ORDER BY cost_per_order DESC;