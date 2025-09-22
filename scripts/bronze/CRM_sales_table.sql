--just define the table form vary basic.

USE DataWerehouse

IF OBJECT_ID('brozen.crm_cust_info','U') IS NOT NULL
	DROP TABLE brozen.crm_cust_info
CREATE TABLE brozen.crm_cust_info(
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(40),
cst_lastname NVARCHAR(40),
cst_martial_status NVARCHAR(50),
cst_gndr NVARCHAR (50),
cst_create_date DATE
)

IF OBJECT_ID('brozen.crm_prd_info','U') IS NOT NULL
	DROP TABLE brozen.crm_prd_info
CREATE TABLE brozen.crm_prd_info(
prd_id INT,
prd_key NVARCHAR(40),
prd_nm NVARCHAR(40),
prd_cost INT,
prd_line NVARCHAR(40),
prd_start_dt DATETIME,
prd_end_dt DATETIME

)

IF OBJECT_ID('brozen.crm_sales_details','U') IS NOT NULL
	DROP TABLE brozen.crm_sales_details
CREATE TABLE brozen.crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(45),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
)

