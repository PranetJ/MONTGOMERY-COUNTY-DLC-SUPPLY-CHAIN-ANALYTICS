CREATE VIEW vw_Monthly_Trends AS
SELECT 
    Reporting_Date,
    Sales_Year,
    Sales_Month,
    Item_Type,
    SUM(Retail_Sales_Qty) AS Monthly_Retail_Sales,
    SUM(Retail_Transfers_Qty) AS Monthly_Retail_Transfers,
    SUM(Warehouse_Sales_Qty) AS Monthly_Warehouse_Sales,
    SUM(Retail_Sales_Qty + Warehouse_Sales_Qty) AS Monthly_Gross_Volume
FROM 
    vw_Cleaned_Distribution_Data
GROUP BY 
    Reporting_Date,
    Sales_Year,
    Sales_Month,
    Item_Type;