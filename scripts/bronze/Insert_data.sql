--make procedure for it.
CREATE OR ALTER PROCEDURE brozen.load_brozen AS 
BEGIN


	--Now we ll insert the data from csv file in bulk form.

	--load the data for crm_cust_info
	TRUNCATE TABLE brozen.crm_cust_info
	BULK INSERT  brozen.crm_cust_info
	FROM 'D:\python_serise\data_science IMB course\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SELECT COUNT(*)
	FROM brozen.crm_cust_info 


	--load the data for crm_prd_info
	TRUNCATE TABLE brozen.crm_prd_info
	BULK INSERT brozen.crm_prd_info
	FROM 'D:\python_serise\data_science IMB course\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SELECT top 10 *
	FROM brozen.crm_prd_info

	--load the data for crm_sales_details
	TRUNCATE TABLE brozen.crm_sales_details
	BULK INSERT brozen.crm_sales_details
	FROM 'D:\python_serise\data_science IMB course\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	)

	SELECT COUNT(*)
	FROM brozen.crm_sales_details


	---------------NOW FOR erp table load the data from csv.

	--for the cust)cust_az12 file
	TRUNCATE TABLE brozen.erp_CUST_AZ12
	BULK INSERT brozen.erp_CUST_AZ12
	FROM 'D:\python_serise\data_science IMB course\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	)

	SELECT COUNT(*)
	FROM brozen.erp_CUST_AZ12

	--for the cust loc_a101 file

	TRUNCATE TABLE brozen.erp_loc_a101
	BULK INSERT brozen.erp_loc_a101
	FROM 'D:\python_serise\data_science IMB course\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	)
	select count(*)
	from brozen.erp_loc_a101




	--for PX_CAT_G1V2
	TRUNCATE TABLE brozen.erp_PX_CAT_G1V2
	BULK INSERT brozen.erp_PX_CAT_G1V2
	FROM 'D:\python_serise\data_science IMB course\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	)

END



EXECUTE brozen.load_brozen