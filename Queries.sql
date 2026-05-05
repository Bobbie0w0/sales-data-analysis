USE sales_db;

-- Country Sales per Year
SELECT YEAR_ID, COUNTRY, SUM(SALES) as Sales
FROM sales_data
GROUP BY COUNTRY, YEAR_ID
ORDER BY YEAR_ID, Sales DESC

-- Daily Cumulative Sales Per Month
SELECT DATE(STR_TO_DATE(ORDERDATE, '%m/%d/%Y %H:%i')) AS Sales_Date, Sales AS Sale,
	   SUM(SALES) OVER (PARTITION BY MONTH_ID
						ORDER BY STR_TO_DATE(ORDERDATE, '%m/%d/%Y %H:%i')
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Monthly_Cumulative_Sales
FROM sales_data
WHERE YEAR_ID = 2004 AND MONTH_ID = 1

-- Top 3 Monthly Sales per Year
WITH TopMonthlySales AS (
	SELECT YEAR_ID as Year, 
		   MONTH_ID as Month, 
           SUM(Sales) as TotalSales, 
		   ROW_NUMBER() OVER (PARTITION BY YEAR_ID ORDER BY SUM(Sales) DESC) AS n
    FROM sales_data
    GROUP By MONTH_ID, YEAR_ID
    ORDER BY YEAR_ID, MONTH_ID
)
SELECT Year, Month, TotalSales
FROM TopMonthlySales
WHERE n <= 3

--
