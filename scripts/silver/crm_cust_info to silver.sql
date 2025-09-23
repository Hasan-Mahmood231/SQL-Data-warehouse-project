--the CRM_CUST_INFO table clean and then insert into silver layer.

--insert into silver layer the clean data.
INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_martial_status,
    cst_gndr,
    cst_create_date
)
--transform the row to uniqe wehre dublicate data find.
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS frist_name,
TRIM(cst_lastname) AS last_name,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	 WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	 ELSE 'N/A'  END AS cst_gndr,--give the full name

CASE WHEN cst_martial_status = 'M' THEN 'Merrage'
	 WHEN cst_martial_status = 'S' THEN 'None Merrage'
	 ELSE 'NA'
END AS cst_martial_status,	--give the full name
cst_create_date

FROM (
	SELECT*,
	ROW_NUMBER() OVER(PARTITION BY CST_ID ORDER BY CST_CREATE_DATE) AS NUL_COL
	FROM brozen.crm_cust_info
	)t
WHERE NUL_COL = 1 
--now the data is almost clear we need to insert it into silver layer.