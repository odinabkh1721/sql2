

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');

select * from Products
select * from Sales 

--create a temporary table named MonthlySales to store the total quantity sold and total
--revenue for each product in the current month.
--Return: ProductID, TotalQuantity, TotalRevenue

-- Create the temporary table to store current month's sales data

CREATE temporary TABLE MonthlySales (
    ProductName INT,
    TotalQuantity INT,
    TotalRevenue DECIMAL(18, 2)
);

---2. Create a view named vw_ProductSalesSummary that returns 
--product info along with total sales quantity across all time.


CREATE VIEW vw_ProductSalesSummary AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    SUM(p.price) AS Totalprice
FROM Products p
JOIN Sales  s ON p.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category;


---3 Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)

CREATE FUNCTION fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalRevenue INT;

    SELECT @TotalRevenue = SUM(Quantity * Price)
    FROM Sales
    WHERE ProductID = @ProductID;

    RETURN ISNULL(@TotalRevenue, 0); 
END;


---4 Create an function fn_GetSalesByCategory(@Category VARCHAR(50))
Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.

  go
  CREATE FUNCTION fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS table
AS
RETURN
( SELECT 
        P.ProductName,
        SUM(p.price) AS TotalQuantity,
        SUM(p.price * p.price) AS TotalRevenue
    FROM 
        Products P
    INNER JOIN 
      Category ON P.ProductID = p.ProductID
    INNER JOIN 
       p.Category C ON P.CategoryID = p.CategoryID
	   WHERE 
        p.Category = @Category
    GROUP BY 
        P.ProductName
);


---5You have to create a function that get one argument as input from user and the function should return 'Yes' 
--if the input number is a prime number and 'No' otherwise. You can start it like this:


go
Create function dbo.fn_IsPrime (@Number INT)
Returns
as
begin
return
    DECLARE @i INT = 2;
    IF @Number < 2
        RETURN 'No';
    WHILE @i * @i <= @Number
    BEGIN
        IF @Number % @i = 0
            RETURN 'No';
        SET @i = @i + 1;
    END
    RETURN 'Yes';
END



---8Write a SQL query to find the person who has the most friends.


;with F1 as (select count (*) as NumFriends from (
select requester_id from 
friendship 
union all 
select accepter_id from Friendship
) as A
group by A.requester_id),
F2 as (select * from F1
where NumFriends in (select
max(Numfriends) from F1))
select * from F2

--9)Create a View for Customer Order Summary.


select * from Customers
select * from Orders 

go
CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    C.customer_id,
    C.Name,
    COUNT(DISTINCT O.orderid) AS TotalOrders,
    SUM(c.count) AS TotalQuantity,
    SUM(count * c.count) AS TotalRevenue
FROM 
    Customers C
INNER JOIN 
    Orders O ON C.Customer_ID = c.Customer_ID
INNER JOIN 
 c.orders ON O.OrderID = O.OrderID
GROUP BY 
    C.Customer_ID, C.Name;


	
10) Write an SQL statement to fill in the missing gaps. You have to write only select statement, no need to modify the table.


go
select *from gaps 

select count(testcase) as case_lar
from gaps where count(testcase)
from Gaps
with cte_gaps as (
select count(rownumber),count(testcase from gaps 
where testcase is null and 
group by rownumber) 
 
