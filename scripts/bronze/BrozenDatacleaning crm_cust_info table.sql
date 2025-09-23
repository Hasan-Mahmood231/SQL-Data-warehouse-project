--the CRM_CUST_INFO table clean and then insert into silver layer.
SELECT
cst_id,
COUNT(*)
FROM brozen.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1

--this is name where the null spaces find.
select
cst_firstname
from brozen.crm_cust_info
where cst_firstname != TRIM(cst_firstname)

--now we convert the abrivate to full name so 
select distinct cst_martial_status
from brozen.crm_cust_info	

--======================================================================sliver layer checking.
--after cleaning the data check result in silver.
SELECT
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1


select
cst_firstname
from silver.crm_cust_info
where cst_firstname != TRIM(cst_firstname)

SELECT*
FROM silver.crm_cust_info