CREATE VIEW vw_Item_Inventory_Flow AS
SELECT 
    Item_Code,
    Item_Description,
    Item_Type,
    Supplier_Name,
    SUM(Retail_Sales_Qty) AS Total_Retail_Sales,
    SUM(Retail_Transfers_Qty) AS Total_Retail_Transfers,
    SUM(Warehouse_Sales_Qty) AS Total_Warehouse_Sales,
    SUM(Retail_Transfers_Qty) - SUM(Retail_Sales_Qty) AS Inventory_Delta,
    
    CASE 
        WHEN SUM(Retail_Transfers_Qty) = 0 AND SUM(Retail_Sales_Qty) > 0 THEN 100.00 
        WHEN SUM(Retail_Transfers_Qty) = 0 THEN 0.00
        ELSE ROUND((SUM(Retail_Sales_Qty) / SUM(Retail_Transfers_Qty)) * 100, 2)
    END AS Sell_Through_Pct,

    -- SKU Rationalization
    CASE 
        WHEN SUM(Retail_Sales_Qty) = 0 AND SUM(Warehouse_Sales_Qty) = 0 AND SUM(Retail_Transfers_Qty) > 0 THEN 'Dead Stock (Stuck in Retail)'
        WHEN SUM(Retail_Sales_Qty) = 0 AND SUM(Warehouse_Sales_Qty) = 0 THEN 'Non-Moving'
        WHEN SUM(Retail_Sales_Qty) > 0 AND SUM(Retail_Transfers_Qty) = 0 THEN 'Depleting Backstock'
        ELSE 'Active Moving'
    END AS Inventory_Health_Status
FROM 
    vw_Cleaned_Distribution_Data
GROUP BY 
    Item_Code,
    Item_Description,
    Item_Type,
    Supplier_Name;