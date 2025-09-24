
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    BEGIN TRY

        --clean the bronz layer and then insert into silver layer.
        --==============================================================CRM layer clean and insert into silver layer.
        --the sales_detail table clean and then insert into silver layer.
        TRUNCATE TABLE silver.crm_sales_details
        print 'Inserting data into the crm sales table.';
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


        --the CRM_CUST_INFO table clean and then insert into silver layer.

        --insert into silver layer the clean data.
        TRUNCATE TABLE silver.crm_cust_info
        print 'Inserting data into the silver.crm_cust_info table.'
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




        --clean the data of crm_prd_info and then insert into silver layer.

        -- Insert clean data into Silver
        TRUNCATE TABLE silver.crm_prd_info
        print 'Inserting data into the silver.crm_prd_info table.'
        INSERT INTO silver.crm_prd_info(
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT 
            prd_id,
            REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,   -- clean category id
            SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,        -- clean product key
            TRIM(prd_nm) AS prd_nm,                              -- remove extra spaces
            ISNULL(prd_cost,0) AS prd_cost,                      -- replace NULL with 0
            CASE 
                WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                ELSE 'N/A'
            END AS prd_line,
            TRY_CAST(prd_start_dt AS DATE) AS prd_start_dt,      -- safe date conversion
            TRY_CAST(prd_end_dt AS DATE) AS prd_end_dt
        FROM brozen.crm_prd_info;


        --=========================================================ERP TABLE CLEANING AND INSERTING INTO SILVER.
        --clean the erp_loc table and then insert into silver layer.
        TRUNCATE TABLE silver.erp_LOC_A101
        print 'Inserting data into the silver.erp_LOC_A101 table.'
        INSERT INTO silver.erp_LOC_A101(
        CID,
        CNTRY)

        SELECT
        REPLACE(cid,'-','') AS cid,
        CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	         WHEN TRIM(cntry) IN ('US','USA') THEN 'United State'
	         WHEN TRIM(cntry) = '' OR CNTRY IS NULL THEN 'N/A'
	         ELSE TRIM(CNTRY)
        END AS CNTRY
        FROM brozen.erp_LOC_A101



        --clean the erp_px_cat_g1v2 table and then insert into silver layer.
        TRUNCATE TABLE silver.erp_PX_CAT_G1V2
        print 'Inserting data into the silver.erp_PX_CAT_G1V2 table.'
        INSERT INTO silver.erp_PX_CAT_G1V2(
        ID,
        CAT,
        SUBCATE,
        MAINTENANCE
        )


        SELECT
        ID,
        CAT,
        SUBCATE,
        MAINTENANCE
        FROM brozen.erp_PX_CAT_G1V2




        --clean the erp_cust_az12 table and insert into silver layer.
        TRUNCATE TABLE silver.erp_CUST_AZ12
        print 'Inserting data into the silver.erp_CUST_AZ12 table.'
        INSERT INTO silver.erp_CUST_AZ12(
        CID,
        BDATE,
        GEN)

        SELECT
        CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4,LEN(CID))
	        ELSE CID
        END AS CID,
        CASE WHEN BDATE  >GETDATE() THEN NULL
	        ELSE BDATE
        END AS BDATE,
        CASE WHEN UPPER(TRIM(GEN)) IN ('F','FEMALE') THEN 'FEMALE'
	         WHEN UPPER(TRIM(GEN)) IN ('M','MALE') THEN 'MALE'
	         ELSE 'N/A'
        END AS GEN
        FROM brozen.erp_CUST_AZ12

    END TRY
    BEGIN CATCH 
        PRINT '==================ERROR OCCURE================';
        PRINT 'Error messagage is ' + ERROR_MESSAGE();
        PRINT 'Error number is ' + ERROR_NUMBER();
    END CATCH
END






