CREATE VIEW vw_Supplier_Pareto_Analysis AS
WITH SupplierBase AS (
    SELECT 
        Supplier_Name,
        COUNT(DISTINCT Item_Code) AS Active_SKU_Count,
        SUM(Retail_Sales_Qty) AS Total_Retail_Sales,
        SUM(Retail_Transfers_Qty) AS Total_Retail_Transfers,
        SUM(Warehouse_Sales_Qty) AS Total_Warehouse_Sales,
        SUM(Retail_Sales_Qty + Warehouse_Sales_Qty) AS Gross_Outbound_Volume
    FROM 
        vw_Cleaned_Distribution_Data
    GROUP BY 
        Supplier_Name
),
SupplierRanking AS (
    SELECT 
        Supplier_Name,
        Active_SKU_Count,
        Total_Retail_Sales,
        Total_Retail_Transfers,
        Total_Warehouse_Sales,
        Gross_Outbound_Volume,
        SUM(Gross_Outbound_Volume) OVER () AS Global_Total_Volume,
        SUM(Gross_Outbound_Volume) OVER (ORDER BY Gross_Outbound_Volume DESC, Supplier_Name ASC) AS Cumulative_Volume
    FROM 
        SupplierBase
    WHERE 
        Gross_Outbound_Volume > 0
)
SELECT 
    Supplier_Name,
    Active_SKU_Count,
    Total_Retail_Sales,
    Total_Retail_Transfers,
    Total_Warehouse_Sales,
    Gross_Outbound_Volume,
    ROUND((Cumulative_Volume / Global_Total_Volume) * 100, 2) AS Cumulative_Volume_Pct,
    -- Apply the 80/20 Vendor Rationalization Logic
    CASE 
        WHEN (Cumulative_Volume / Global_Total_Volume) <= 0.80 THEN 'Tier 1 - Strategic (Top 80%)'
        WHEN (Cumulative_Volume / Global_Total_Volume) <= 0.95 THEN 'Tier 2 - Mid Core (80-95%)'
        ELSE 'Tier 3 - Long Tail (Bottom 5%)'
    END AS Vendor_Tier
FROM 
    SupplierRanking;