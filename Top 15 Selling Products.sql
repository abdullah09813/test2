WITH MonthlySales AS (
    SELECT 
        p.product_id,
        p.product_name,
        SUM(s.quantity_sold) AS total_quantity_sold
    FROM 
        sales s
    JOIN 
        products p ON s.product_id = p.product_id
    WHERE 
        s.sale_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
        AND s.sale_date < DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY 
        p.product_id, p.product_name
),
RankedSales AS (
    SELECT 
        product_id,
        product_name,
        total_quantity_sold,
        ROW_NUMBER() OVER (ORDER BY total_quantity_sold DESC) AS sales_rank
    FROM 
        MonthlySales
)
SELECT 
    product_id,
    product_name,
    total_quantity_sold
FROM 
    RankedSales
WHERE 
    sales_rank <= 15;