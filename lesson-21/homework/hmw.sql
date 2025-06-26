Homework 21
--Task 21 

drop table ProductSales 

CREATE TABLE ProductSales (
    SaleID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    SaleDate DATE NOT NULL,
    SaleAmount DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    CustomerID INT NOT NULL
);
INSERT INTO ProductSales (SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID)
VALUES 
(1, 'Product A', '2023-01-01', 148.00, 2, 101),
(2, 'Product B', '2023-01-02', 202.00, 3, 102),
(3, 'Product C', '2023-01-03', 248.00, 1, 103),
(4, 'Product A', '2023-01-04', 149.50, 4, 101),
(5, 'Product B', '2023-01-05', 203.00, 5, 104),
(6, 'Product C', '2023-01-06', 252.00, 2, 105),
(7, 'Product A', '2023-01-07', 151.00, 1, 101),
(8, 'Product B', '2023-01-08', 205.00, 8, 102),
(9, 'Product C', '2023-01-09', 253.00, 7, 106),
(10, 'Product A', '2023-01-10', 152.00, 2, 107),
(11, 'Product B', '2023-01-11', 207.00, 3, 108),
(12, 'Product C', '2023-01-12', 249.00, 1, 109),
(13, 'Product A', '2023-01-13', 153.00, 4, 110),
(14, 'Product B', '2023-01-14', 208.50, 5, 111),
(15, 'Product C', '2023-01-15', 251.00, 2, 112),
(16, 'Product A', '2023-01-16', 154.00, 1, 113),
(17, 'Product B', '2023-01-17', 210.00, 8, 114),
(18, 'Product C', '2023-01-18', 254.00, 7, 115),
(19, 'Product A', '2023-01-19', 155.00, 3, 116),
(20, 'Product B', '2023-01-20', 211.00, 4, 117),
(21, 'Product C', '2023-01-21', 256.00, 2, 118),
(22, 'Product A', '2023-01-22', 157.00, 5, 119),
(23, 'Product B', '2023-01-23', 213.00, 3, 120),
(24, 'Product C', '2023-01-24', 255.00, 1, 121),
(25, 'Product A', '2023-01-25', 158.00, 6, 122),
(26, 'Product B', '2023-01-26', 215.00, 7, 123),
(27, 'Product C', '2023-01-27', 257.00, 3, 124),
(28, 'Product A', '2023-01-28', 159.50, 4, 125),
(29, 'Product B', '2023-01-29', 218.00, 5, 126),
(30, 'Product C', '2023-01-30', 258.00, 2, 127);


select * from ProductSales;
--Task 1
--Write a query to assign a row number to each sale based on the SaleDate.

  GO
WITH cte AS (
    SELECT SaleID,
    SaleDate,
  ROW_NUMBER() OVER (ORDER BY SaleDate DESC) AS Rn
    FROM ProductSales)
SELECT * 
FROM cte
WHERE Rn = 1;

--Task 2
--Write a query to rank products based on the total quantity sold. 
--give the same rank for the same amounts without skipping numbers.

go
with cte as(
select SaleID,
quantity,
SaleAmount,
RANK()OVER(order by Quantity DESC) as rn
from ProductSales)
select * from cte 
where rn=1



---Task 3
--Write a query to identify the top sale for each customer based on the SaleAmount.

;WITH CTE AS(
 SELECT
 CustomerID,
 SaleID,
 SaleAmount,
RANK() OVER (partition by CustomerID order by SaleAmount DESC ) as rnk
from ProductSales)
SELECT * FROM CTE 
WHERE rnk = 1;

---Task 4 
--Write a query to display each sale's amount along with
--the next sale amount in the order of SaleDate.

  select * from ProductSales 


 go
 SELECT 
    SaleID,
    SaleDate,
    SaleAmount,
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales 


---Task 5
--Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.

SELECT 
CustomerID,
  SaleID,
  SaleDate,
  SaleAmount,
  LAG(SaleAmount)over(Partition by CustomerID order by SaleDate) AS SL
  FROM ProductSales 

 

---Task 5
--Write a query to identify sales amounts that are greater than the previous sale's amount

GO
 WITH SalesLagged AS (
  SELECT 
    CustomerID,
    SaleDate,
    SaleAmount,
    LAG(SaleAmount) OVER (PARTITION BY CustomerID ORDER BY SaleDate) AS PrevSaleAmount
  FROM ProductSales
)
SELECT *
FROM SalesLagged
WHERE SaleAmount > PrevSaleAmount;

---tASK 6 
--Write a query to calculate the difference in sale amount from the previous sale for every product


  WITH CTE AS (
  SELECT 
    SaleID,
    ProductName,
    SaleAmount,
    LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSale
  FROM ProductSales
)
SELECT 
  SaleID,
  ProductName,
  SaleAmount,
  PreviousSale,
  SaleAmount - PreviousSale AS SaleDifference
FROM CTE;

select * from ProductSales
--Task 7
--Write a query to compare the current sale amount with the next sale amount in terms of percentage change.


 WITH cte AS (
  SELECT 
    SaleID,
    SaleAmount,
    SaleDate,
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
  FROM ProductSales
)
SELECT 
  SaleID,
  SaleAmount,
  SaleDate,
  NextSaleAmount,
  ((NextSaleAmount - SaleAmount) * 100.0 / SaleAmount) AS PercentageChange
FROM cte;




--Task 8

--Write a query to compare the current sale amount with the next sale amount in terms of percentage change.


;with cte as(
select SaleID,
   SaleAmount,
   LEAD(SaleAMount)Over (order by SaleAmount) as NextSalesAmounyt
   from ProductSales
)
select *, (NextSalesAmounyt-SaleAmount)*100 as difference from cte


--Task 9
--Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.


;WITH cte AS (
    SELECT 
        ProductName,
        SaleID,
        SaleAmount,
        SaleDate,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousAmount
    FROM ProductSales
)
SELECT 
    ProductName,
    SaleID,
    SaleAmount,
    SaleDate,
    PreviousAmount,
    CASE 
        WHEN PreviousAmount IS NOT NULL THEN 
            CAST(SaleAmount AS DECIMAL(10,2)) / PreviousAmount
        ELSE NULL
    END AS RatioToPrevious
FROM cte


--Task 10
--Write a query to calculate the difference in sale amount from the very first sale of that product.


select * from ProductSales 

;with cte as (select 
saleID,
ProductName,
SaleDate,
SaleAmount,
Lag(SaleAmount) over (partition by ProductName order by SaleDate) firstSale
from ProductSales )

select * from cte 

---Task 11
--Write a query to find sales that have been increasing continuously
--for a product (i.e., each sale amount is greater than the previous sale amount for that product).

;WITH cte AS (
    SELECT 
        ProductName,
        SaleID,
        SaleDate,
        SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousAmount
    FROM ProductSales
)
SELECT 
    ProductName,
    SaleID,
    SaleDate,
    SaleAmount,
    PreviousAmount
FROM cte
WHERE SaleAmount > PreviousAmount


--Task 12
--Write a query to calculate a "closing balance"(running total) for sales amounts which 
--adds the current sale amount to a running total of previous sales.

SELECT 
    ProductName,
    SaleID,
    SaleDate,
    SaleAmount,
    SUM(SaleAmount) OVER (
        PARTITION BY ProductName 
        ORDER BY SaleDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS ClosingBalance
FROM ProductSales


--Task 13 
--Write a query to calculate the moving average of sales amounts over the last 3 sales.


SELECT 
    ProductName,
    SaleID,
    SaleDate,
    SaleAmount,
    AVG(CAST(SaleAmount AS DECIMAL(10,2))) OVER (
        PARTITION BY ProductName 
        ORDER BY SaleDate
        R(SALEOWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAverageLast3
FROM ProductSales


--Task 14
--Write a query to show the difference between each sale amount and the average sale amount.

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    AVG(CAST(SaleAmount AS DECIMAL(10,2))) OVER (PARTITION BY ProductName) AS AvgPerProduct,
    CAST(SaleAmount AS DECIMAL(10,2)) - 
        AVG(CAST(SaleAmount AS DECIMAL(10,2))) OVER (PARTITION BY ProductName) AS DifferenceFromAverage
FROM ProductSales

drop table Employees1 


CREATE TABLE Employees1 (
    EmployeeID   INT PRIMARY KEY,
    Name         VARCHAR(50),
    Department   VARCHAR(50),
    Salary       DECIMAL(10,2),
    HireDate     DATE
);

INSERT INTO Employees1 (EmployeeID, Name, Department, Salary, HireDate) VALUES
(1, 'John Smith', 'IT', 60000.00, '2020-03-15'),
(2, 'Emma Johnson', 'HR', 50000.00, '2019-07-22'),
(3, 'Michael Brown', 'Finance', 75000.00, '2018-11-10'),
(4, 'Olivia Davis', 'Marketing', 55000.00, '2021-01-05'),
(5, 'William Wilson', 'IT', 62000.00, '2022-06-12'),
(6, 'Sophia Martinez', 'Finance', 77000.00, '2017-09-30'),
(7, 'James Anderson', 'HR', 52000.00, '2020-04-18'),
(8, 'Isabella Thomas', 'Marketing', 58000.00, '2019-08-25'),
(9, 'Benjamin Taylor', 'IT', 64000.00, '2021-11-17'),
(10, 'Charlotte Lee', 'Finance', 80000.00, '2016-05-09'),
(11, 'Ethan Harris', 'IT', 63000.00, '2023-02-14'),
(12, 'Mia Clark', 'HR', 53000.00, '2022-09-05'),
(13, 'Alexander Lewis', 'Finance', 78000.00, '2015-12-20'),
(14, 'Amelia Walker', 'Marketing', 57000.00, '2020-07-28'),
(15, 'Daniel Hall', 'IT', 61000.00, '2018-10-13'),
(16, 'Harper Allen', 'Finance', 79000.00, '2017-03-22'),
(17, 'Matthew Young', 'HR', 54000.00, '2021-06-30'),
(18, 'Ava King', 'Marketing', 56000.00, '2019-04-16'),
(19, 'Lucas Wright', 'IT', 65000.00, '2022-12-01'),
(20, 'Evelyn Scott', 'Finance', 81000.00, '2016-08-07');

select * from Employees1 

--Task 15
--Find Employees Who Have the Same Salary Rank

;WITH cte AS (
    SELECT 
        EmployeeID,
        Name,
        Salary,
        RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM Employees1
)
SELECT *
FROM cte
WHERE SalaryRank IN (
    SELECT SalaryRank
    FROM cte
    GROUP BY SalaryRank
    HAVING COUNT(*) > 1
)

---Task 16
--Identify the Top 2 Highest Salaries in Each Department



;WITH cte AS (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        RANK() OVER (
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM Employees1
)
SELECT *
FROM cte
WHERE SalaryRank <= 2


---Task 17
--Find the Lowest-Paid Employee in Each Department


WITH cte AS (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        ROW_NUMBER() OVER (
            PARTITION BY Department 
            ORDER BY Salary ASC
        ) AS SalaryRank
    FROM Employees1
)
SELECT *
FROM cte
WHERE SalaryRank = 1


--Task 18
--Calculate the Running Total of Salaries in Each Department

SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    SUM(Salary) OVER (
        PARTITION BY Department 
        ORDER BY Salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM Employees1


--Task 19
--Find the Total Salary of Each Department Without GROUP BY

SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    SUM(Salary) OVER (PARTITION BY Department) AS TotalDepartmentSalary
FROM Employees1

---Task 20
--Calculate the Average Salary in Each Department Without GROUP BY


SELECT     
    Department,
    Salary,
    AVG(Salary) OVER (PARTITION BY Department) AS AvgDepartmentSalary
FROM Employees1

