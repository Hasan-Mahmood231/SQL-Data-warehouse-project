--clean the data of crm_prd_info and then insert into silver layer.

-- Insert clean data into Silver
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
