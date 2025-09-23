--the sales_detail table clean and then insert into silver layer.
INSERT INTO silver.crm_sales_details(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)

select
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
	 ELSE CAST(CAST(sls_order_dt AS varchar) AS DATE)
END AS sls_order_dt, --clean the order_date.
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	 ELSE CAST(CAST(sls_ship_dt AS NVARCHAR) AS DATE)
END AS sls_ship_dt,	--clean the ship_date
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
	 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,	--clean the dur_date.

CASE WHEN sls_sales IS NULL OR sls_sales != sls_sales * ABS(sls_price)
	 THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
END AS sls_sales,	--clean the sls_sales_col.
sls_quantity,

CASE WHEN sls_price IS NULL OR sls_price <=0 
	 then sls_sales / NULLIF(sls_quantity,0)
	 ELSE sls_price
END AS sls_price	--clean the sales_detail col.
from brozen.crm_sales_details