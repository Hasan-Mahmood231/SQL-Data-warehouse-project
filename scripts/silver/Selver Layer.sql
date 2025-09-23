--create the empty table in silver and then insert clean data form brozen layer one by one.

IF OBJECT_ID('silver.crm_cust_info','U') IS NOT NULL
	DROP TABLE silver.crm_cust_info
CREATE TABLE silver.crm_cust_info(
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(40),
cst_lastname NVARCHAR(40),
cst_martial_status NVARCHAR(50),
cst_gndr NVARCHAR (50),
cst_create_date DATE
)

IF OBJECT_ID('silver.crm_prd_info','U') IS NOT NULL
	DROP TABLE silver.crm_prd_info
CREATE TABLE silver.crm_prd_info(
prd_id INT,
cat_id NVARCHAR(50),
prd_key NVARCHAR(40),
prd_nm NVARCHAR(40),
prd_cost INT,
prd_line NVARCHAR(40),
prd_start_dt DATE,
prd_end_dt DATE
)

IF OBJECT_ID('silver.crm_sales_details','U') IS NOT NULL
	DROP TABLE silver.crm_sales_details
CREATE TABLE silver.crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(45),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT
)


IF OBJECT_ID('silver.erp_CUST_AZ12','U') IS NOT NULL
	DROP TABLE silver.erp_CUST_AZ12
CREATE TABLE silver.erp_CUST_AZ12(
CID NVARCHAR(40),
BDATE DATE,
GEN NVARCHAR(50)
)


--erp_LOC_A101
IF OBJECT_ID('silver.erp_LOC_A101','U') IS NOT NULL
	DROP TABLE silver.erp_LOC_A101
CREATE TABLE silver.erp_LOC_A101(
CID NVARCHAR(40),
CNTRY NVARCHAR(40)
)


--erp_LOC_
IF OBJECT_ID('silver.erp_PX_CAT_G1V2','U') IS NOT NULL
	DROP TABLE silver.erp_PX_CAT_G1V2
CREATE TABLE silver.erp_PX_CAT_G1V2(
ID NVARCHAR(40),
CAT NVARCHAR(40),
SUBCATE NVARCHAR(34),
MAINTENANCE NVARCHAR(34)
)
