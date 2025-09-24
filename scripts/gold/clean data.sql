--prepair the GOLD layer.
CREATE VIEW gold.dim_customer AS 
--give the clean name to the col. using crm_cust_info
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS  customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.CNTRY AS country,
	ci.cst_martial_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ci.cst_create_date AS create_date,
	ca.BDATE AS birth_date




FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_CUST_AZ12 AS ca
ON		ci.cst_key = ca.CID
LEFT JOIN silver.erp_LOC_A101 AS la
ON		ci.cst_key = la.CID




--prepair the table of prd_info 
CREATE VIEW gold.dim_products AS 
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt , pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS  product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS  category_id,
	pc.CAT AS  category,
	pc.SUBCATE AS subcategory,
	pc.MAINTENANCE ,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt as start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_PX_CAT_G1V2 AS  pc
ON pn.cat_id = pc.ID
WHERE pn.prd_end_dt IS NULL --Filter out the historical data.

 




 --sales detail table.
 
 CREATE VIEW gold.fact_sales AS 
 SELECT
    sd.sls_ord_num,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt,
    sd.sls_ship_dt,
    sd.sls_due_dt,
    sd.sls_sales,
    sd.sls_quantity,
    sd.sls_price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products pr
    ON LTRIM(RTRIM(sd.sls_prd_key)) = LTRIM(RTRIM(pr.product_number))
    OR TRY_CAST(LTRIM(RTRIM(sd.sls_prd_key)) AS INT) = pr.product_id
LEFT JOIN gold.dim_customer cu
    ON LTRIM(RTRIM(sd.sls_cust_id)) = LTRIM(RTRIM(cu.customer_number))
    OR TRY_CAST(LTRIM(RTRIM(sd.sls_cust_id)) AS INT) = cu.customer_id;
