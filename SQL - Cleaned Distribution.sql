CREATE VIEW vw_Cleaned_Distribution_Data AS
SELECT
    CAST(`YEAR` AS UNSIGNED) AS Sales_Year,
    CAST(`MONTH` AS UNSIGNED) AS Sales_Month,

    STR_TO_DATE(CONCAT(`YEAR`, '-', `MONTH`, '-01'), '%Y-%m-%d') AS Reporting_Date,
    COALESCE(SUPPLIER, 'UNKNOWN SUPPLIER') AS Supplier_Name,
    `ITEM CODE` AS Item_Code,
    `ITEM DESCRIPTION` AS Item_Description,
    COALESCE(`ITEM TYPE`, 'UNCATEGORIZED') AS Item_Type,

    -- The data was originally as text, converted it into float/decimal and if the value was NULL, 0 was assigned to it
    COALESCE(CAST(`RETAIL SALES` AS DECIMAL(10,2)), 0) AS Retail_Sales_Qty,
    COALESCE(CAST(`RETAIL TRANSFERS` AS DECIMAL(10,2)), 0) AS Retail_Transfers_Qty,
    COALESCE(CAST(`WAREHOUSE SALES` AS DECIMAL(10,2)), 0) AS Warehouse_Sales_Qty
FROM
    export_data;