-- Sample: Row Count Validation Query
-- Purpose: Compare table row counts between legacy and cloud systems
-- Anonymized for public sharing

-- Legacy system count
SELECT 
    'customer_orders' AS table_name,
    'legacy_db' AS source_system,
    COUNT(*) AS row_count,
    CURRENT_TIMESTAMP AS validation_timestamp
FROM legacy_db.customer_orders
WHERE order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);

-- Cloud system count
SELECT 
    'customer_orders' AS table_name,
    'cloud_warehouse' AS source_system,
    COUNT(*) AS row_count,
    CURRENT_TIMESTAMP AS validation_timestamp
FROM cloud_warehouse.transformed_orders
WHERE DATE(order_timestamp) >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);

-- Reconciliation query
WITH legacy_counts AS (
    SELECT COUNT(*) AS legacy_count FROM legacy_db.customer_orders
    WHERE order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
),
cloud_counts AS (
    SELECT COUNT(*) AS cloud_count FROM cloud_warehouse.transformed_orders
    WHERE DATE(order_timestamp) >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
)
SELECT 
    legacy_count,
    cloud_count,
    legacy_count - cloud_count AS difference,
    CASE 
        WHEN ABS(legacy_count - cloud_count) = 0 THEN 'PASS'
        ELSE 'FAIL - Investigate missing rows'
    END AS validation_status
FROM legacy_counts, cloud_counts;
