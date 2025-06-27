
CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')


	select * from sales_data 
	
  --Task 1
  --Compute Running Total Sales per Customer


  select Customer_id,
  Customer_name,
  total_amount,
  order_date,
  SUM(total_amount) over(partition by Customer_id order by order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
 AS c1
 from sales_data;


 ---tASK 2
 --Count the Number of Orders per Product Category


SELECT 
  Customer_id,
  Customer_Name,
  Product_category,
  COUNT(*) AS total_orders
FROM 
  sales_data
GROUP BY 
  Customer_id, Customer_Name, Product_category;


  --Task 3
  --Find the Maximum Total Amount per Product Category

  select * from Sales_data 

  select customer_id,
  product_category,
  total_amount,
  Max(total_amount) as totalAmount
  from sales_data 
  group by customer_id,
  product_category,
  total_amount


--Task 4 
--Find the Minimum Price of Products per Product Category

select Customer_id,
product_category,
unit_price,
MIn(unit_price) as minPrice 
from sales_data
group by Customer_id,
product_category,
unit_price


--Task 5
--Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)

SELECT 
  Sale_ID,
  product_category,
  order_date,
  total_amount,
  AVG(total_amount) OVER (
    PARTITION BY product_category
    ORDER BY order_date
    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS totalsales
FROM 

--Task 6
---Find the Total Sales per Region

 select 
region,
Sum(total_amount) as maxsalary
from sales_data
group by
 region

 --Task 7
 --Compute the Rank of Customers Based on Their Total Purchase Amount

  SELECT 
  customer_id,
  customer_name,
  SUM(total_amount) AS total_purchase,
  RANK() OVER (ORDER BY SUM(total_amount) DESC) AS purchase_rank
FROM 
  sales_data
GROUP BY 
  customer_id,
  customer_name



---Task 8
---Calculate the Difference Between Current and Previous Sale Amount per Customer

select sale_id,
 customer_name,
 total_amount,
 order_date,
 LAG(total_amount)over(partition by customer_id order by order_date) as previous_sale,
 total_amount-
 LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS amount_difference
FROM
  sales_data;
     

	 select * from sales_data 

---Task 9
--Find the Top 3 Most Expensive Products in Each Category


select * from (select sale_id,
product_category,
product_name, 
RANK()over(partition by product_category order by total_amount desc) as price_rank
from sales_data
) ranked where price_rank< = 3;


---Task 10 
--Compute the Cumulative Sum of Sales Per Region by Order Date


select 
region,
order_date,
total_amount,
SUM(total_amount) over(partition by region order by order_date  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_sales
from sales_data 


---Task 11 
--Compute Cumulative Revenue per Product Category

select 
product_category,
region,
total_amount,
SUM(total_amount) over(partition by product_category order by region) perproduct
from sales_data 


---Task 12
--Here you need to find out the sum of previous values.
-- Please go through the sample input and expected output.

select sale_id,
SUM(total_amount) over (order by sale_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as SumPreValues
from sales_data


--TASK 13
--Sum of Previous Values to Current Value


CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);

SELECT * FROM OneColumn


select*,
SUM(value)over(order by value ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as SumofPrevious
from oneColumn


---Task 14
--Find customers who have purchased items from more than one product_category

SELECT *
FROM (
  SELECT 
    customer_id,
    product_category,
  COUNT(quantity_sold) OVER (PARTITION BY customer_id order by product_category) AS category_count
  FROM sales_data
) t
WHERE category_count > 1;


---Task 15
--Find Customers with Above-Average Spending in Their Region

select sale_id,
 customer_name,
 total_amount,
 region,
 avg(total_amount) over (partition by sale_id order by customer_name desc) as avg
 from sales_data 


 ---Task 16 
 --Rank customers based on their total spending (total_amount) 
--within each region. If multiple customers have the same spending, they should receive the same rank.

More actions
SELECT 
    Customer_ID,
    Region,
    SUM(total_Amount) AS TotalSpending
FROM 
   sales_data 
JOIN 
    Sales s ON Customer_ID = Customer_ID
GROUP BY 
    c.Customer_ID, c.Region
HAVING 
    SUM(s.total_Amount) > (
        SELECT AVG(region_spending)
        FROM (
            SELECT 
                Region,
                SUM(s2.total_sAmount) AS region_spending
            FROM 
                Customers c2
            JOIN 
                Sales s2 ON c2.Customer_ID = s2.Customer_ID
            GROUP BY 
                c2.Customer_ID, c2.Region
        ) AS regional_totals
        WHERE regional_totals.Region = c.Region
    );
Add comment


--Task 17
--Calculate the running total (cumulative_sales) 
--of total_amount for each customer_id, ordered by order_date.

SELECT 
    Customer_ID,
    Region,
    SUM(Total_Amount) AS TotalSpending,
    RANK() OVER (
        PARTITION BY Region
        ORDER BY SUM(Total_Amount) DESC
    ) AS SpendingRank
FROM sales_data 
GROUP BY 
    Customer_ID, Region;


--Task 18

	SELECT 
    Customer_ID,
    Order_Date,
    Total_Amount,
    SUM(Total_Amount) OVER (
        PARTITION BY Customer_ID
        ORDER BY Order_Date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Cumulative_Sales
FROM 
    Sales_data 

	--Task 19
--Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)


SELECT 
  customer_id,
  order_date,
  total_amount,
  LAG(total_amount) OVER (
    PARTITION BY customer_id 
    ORDER BY order_date
  ) AS previous_amount
FROM sales_data


--Task 20
--Identify Products that prices are above the average product price

SELECT 
  product_category,
  product_name,
  unit_price,
  AVG(unit_price) OVER () AS avg_price
FROM 
  sales_data
WHERE 
  unit_price > AVG(unit_price) OVER ();


  select * from sales_data
