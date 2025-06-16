
--- task 1 
--Create a numbers table using a recursive query from 1 to 1000.

with cte as(
select 1 as num
union all 
select NUM + 1 from cte
where NUm < 1000)
select * from cte 
option (MAXRECURSION 0)



--- TASK 2
--Write a query to find the total sales per employee using a derived table.(Sales, Employees)

SELECT * FROM Sales
select * from Employees 

select e.employeeID, e.FirstName,e.LastName,e.salary
from Employees e 
JOIN(
 select EmployeeID, SUM(salary) as totalsalary
 from Employees 
 Group by EmployeeID)
 s on e.employeeID = s.employeeID 

 --- TASK 3 
 --Create a CTE to find the average salary of employees.(Employees)

 drop table Employees 
select * from Employees 

;with cte as(
 select AVG(salary) as avgsalary
 from Employees
)
select * from cte 

--- Task 4
--Write a query using a derived table to find the highest sales for each product.(Sales, Products)

select * from sales
select * from Products

select s.productid,s.salesAmount 
from Sales s
join(
select productid,Max(salesAmount) as Maxsale
from Sales 
group by Productid)
as dt ON s.ProductID = dt.Productid 
and s.salesAmount = dt.maxsale

--- Task 5
--Beginning at 1, write a statement to double the number for each record,
--the max value you get should be less than 1000000.

  WITH cte AS (
SELECT 1 AS Num 
UNION ALL
SELECT Num*2 FROM cte
WHERE Num  < 1000000)

SELECT * FROM cte option(maxrecursion 1000)

---Task 6
--Use a CTE to get the names of employees who have made more than 5 sales.
--(Sales, Employees)
select * from Sales
select * from Employees 

go
WITH SalesCount AS (
    SELECT employeeid, COUNT(*) AS total_sales
    FROM Sales
    GROUP BY employeeid
    HAVING COUNT(*) > 5
)
SELECT e.Firstname
FROM SalesCount sc
JOIN Employees e ON sc.employeeid = e.employeeid;


--- Task 7
--Write a query using a CTE to find all products 
--with sales greater than $500.(Sales, Products)

select * from Sales
select * from Products 

with SalesCount as(
select product_id,COUNT(*) as max_sales
from Products 
group by product_id
having product_ID > 500)
select p.product_name
from products  sc
join products p on sc.product_id = p.product_id 

--- Task 8
--Create a CTE to find employees with salaries above the average salary.(Employees)

select *  from Employees 

WITH avg_salary_cte AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
),
above_avg_employees AS (
    SELECT *
    FROM employees
    WHERE salary > (SELECT avg_salary FROM avg_salary_cte)
)
SELECT * FROM above_avg_employees;


--- Task Medium 1
--Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)

select * from sales
select * from employees 

go
SELECT TOP 5 e.employeeID, e.firstName, e.lastName, COUNT(s.salesID) AS total_orders
FROM Employees e
JOIN Sales s ON e.employeeID = s.employeeID
GROUP BY e.employeeID, e.firstName, e.lastName
ORDER BY total_orders DESC;


--TASK 2
---Write a query using a derived table to find the sales per product category.
--(Sales, Products)

SELECT * FROM sALES
SELECT * FROM Products

select s.salesID,s.ProductID,s.salesAmount
from Sales s
join (select productid,SUM(salesAmount) as total_quantity_sold
from sales 
group by ProductID )
p ON s.productID = s.productID 

 ---TASK 3
 --Write a script to return the factorial of each value next to it.(Numbers1)
 CREATE TABLE Numbers1(Number INT)

INSERT INTO Numbers1 VALUES (5),(9),(8),(6),(7)

select * from Numbers1


with numbers as (
select 1 as n,
 1 as f
union all
select n+1,(n+1)*f from numbers
where n+1<10 
)
select * from numbers
where n in (select number from Numbers1)


---TAsk 4
--This script uses recursion to split a string into rows of substrings for each character in the string.(Example)


select * from Example 

WITH RecursiveSplit AS (
SELECT
        Id,
        1 AS Position,
        SUBSTRING(String, 1, 1) AS Character,
        String
    FROM Example
    WHERE LEN(String) > 0

    UNION ALL
	SELECT
        Id,
        Position + 1,
        SUBSTRING(String, Position + 1, 1),
        String
    FROM RecursiveSplit
    WHERE Position + 1 <= LEN(String)
)
SELECT
    Id,
    Position,
    Character
FROM RecursiveSplit
ORDER BY Id, Position;


---Task 5
--Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)

select * from Sales 

WITH MonthlySales AS (
    SELECT 
        FORMAT(SaleDate, 'yyyy-MM') AS SaleMonth,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY FORMAT(SaleDate, 'yyyy-MM')
),
SalesWithDifference AS (
    SELECT 
        SaleMonth,
        TotalSales,
        LAG(TotalSales) OVER (ORDER BY SaleMonth) AS PreviousMonthSales
    FROM MonthlySales
)
SELECT 
    SaleMonth,
    TotalSales,
    PreviousMonthSales,
    TotalSales - ISNULL(PreviousMonthSales, 0) AS SalesDifference
FROM SalesWithDifference
ORDER BY SaleMonth;

--Task 6
--Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)

select * from Sales
select * from Employees 


SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName
FROM Employees e
JOIN (
    SELECT 
        EmployeeID,
        DATEPART(QUARTER, SaleDate) AS Quarter,
        DATEPART(YEAR, SaleDate) AS SaleYear,
        SUM(SalesAmount) AS QuarterlySales
    FROM Sales
    GROUP BY EmployeeID, DATEPART(YEAR, SaleDate), DATEPART(QUARTER, SaleDate)
    HAVING SUM(SalesAmount) > 45000
) AS QuarterlySales
ON e.EmployeeID = QuarterlySales.EmployeeID
GROUP BY 
    e.EmployeeID, e.FirstName, e.LastName
HAVING COUNT(DISTINCT QuarterlySales.Quarter) = 4;


---Difficult task 1
This script uses recursion to calculate Fibonacci numbers

;with cte as (

select 0 as son, 1 as inc
union all
select son+inc as son, son as inc from cte
where son<100
)
select * from cte

--task 2
--Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)

CREATE TABLE FindSameCharacters
(
     Id INT
    ,Vals VARCHAR(10)
)
 
INSERT INTO FindSameCharacters VALUES
(1,'aa'),
(2,'cccc'),
(3,'abc'),
(4,'aabc'),
(5,NULL),
(6,'a'),
(7,'zzz'),
(8,'abc')

select * from FindSameCharacters 

WITH SameCharsCTE AS (
    SELECT input_str
    FROM FindSameCharacters
    WHERE LENGTH(input_str) > 1
)
SELECT input_str
FROM SameCharsCTE
WHERE input_str ~ '^(.)(\1)*$';


--task 3
select * from Employees
select * from sales 

SELECT e.employeeId, e.firstname, e.lastname, dt.total_sales
FROM Employees e
JOIN (
    SELECT employeeid, COUNT(*) AS total_sales
    FROM Sales
    WHERE saledate >= CURRENT_DATE - INTERVAL '6 MONTH'
    GROUP BY EmployeeID
) AS dt ON s.employeeid = dt.employeeid
WHERE dt.total_sales = (
    SELECT MAX(sub.total_sales)
    FROM (
        SELEct employeeid, COUNT(*) AS total_sales
        FROM Sales
        WHERE saledate >= CURRENT_DATE - INTERVAL '6 MONTH'
        GROUP BY employeeid
    ) AS sub
);
