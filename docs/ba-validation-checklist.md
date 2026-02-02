# Business Analyst Validation Checklist for Cloud Migration
## Pre Migration Preparation
- [ ] Identify critical business tables (start with 5-10 most important)
- [ ] Document key metrics for each table (row count, totals, averages)
- [ ] Identify critical business columns (customer email, order amount etc)
- [ ] Set acceptable variance thresholds with business stakeholders

## SQL validation queries to run
### 1. Row count check (run before and after migration)
'''sql
-- Before migration (legacy system)
SELECT 'customers' AS table_name, COUNT* AS row_count FROM legacy.customers;

-- After migration (Cloud System)
SELECT 'customers' AS table_name, COUNT * AS row_count FROM cloud
