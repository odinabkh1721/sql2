

--Task 17

--task 1
--You must provide a report of all distributors and their sales by region.
--If a distributor did not have any sales for a region, 
--rovide a zero-dollar value for that day. Assume there is at least one sale for each region

select * from #RegionSales 

DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

select distinct t2.Distributor,t1.region,isnull(A.Sales,0) as sales 
from #regionSales as t1
cross join(select distinct distributor from #regionSales) t2
left join #regionSales as A on A.region = t1.region and A.distributor = t2.distributor

---Task 2
--2. Find managers with at least five direct reports

drop table Employee 


CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

select * from Employee 

select emp.name
from Employee as emp
join Employee as m
on emp.id=m.managerid
group by emp.name
having count(m.managerid)>=5

--- task 3 
--Write a solution to get the names of products that have at least 100 units ordered 
--in February 2020 and their amount.


drop table Products 
drop table Orders 

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

select * from Products 
select * from Orders 


go
with cte as (
select product_name,unit
from Products as p
join orders as o on p.product_id = o.product_id
where year(o.order_date)=2020 and month(order_date)=2)
select product_name,SUM(unit) as unit from cte
group by product_name
having Sum(unit)>=100



---Task 4
---4. Write an SQL statement that returns the vendor from which each customer has placed the most orders


DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

select * from orders

SELECT 
    o.customerid,
   o.vendor
    COUNT(*) AS order_count
FROM 
    orders o
GROUP BY 
    o.customer_id, o.vendor_id



-- task 5
--You will be given a number as a variable called @Check_Prime check if this number is prime then return 
--'This number is prime' else eturn 'This number is not prime'

DECLARE @Check_Prime INT = 91;
-- Your WHILE-based SQL logic here

DECLARE @Check_Prime INT = 91;
SET @Check_Prime = 91  
DECLARE @i INT = 2
DECLARE @IsPrime BIT = 1
WHILE @i <= SQRT(@Check_Prime)
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @IsPrime = 0
        BREAK
    END
    SET @i = @i + 1
END
IF @Check_Prime <= 1
    PRINT 'This number is not prime'
ELSE IF @IsPrime = 1
    PRINT 'This number is prime'
ELSE
    PRINT 'This number is not prime'

	--task 6
	--Write an SQL query to return the number of locations,
	--in which location most signals sent, and total number of signal for each device from the given table.

	drop table Device 
	CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

select * from device 

select TOP 1 Locations,Count (*) as total_signals 
from device
group by locations 
order by total_signals DESC 


---tASK 7

DROP TABLE Employee

CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);


select * from EMployee 
Write a SQL to find all Employees who earn more than th
e average salary in their corresponding department. Return EmpID, EmpName,Salary in your output

select empID,EmpName,Salary
from employee e
where salary>(select avg(salary) as avgSalary from employee)

--- Task 8
--You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of each ticket’s chosen numbers.
--If a ticket has some but not all the winning numbers, you win $10.
--If a ticket has all the winning numbers, you win $100. Calculate the total winnings for today’s drawing.

go
WITH WinningCount AS (
    SELECT COUNT(*) AS TotalWinningNumbers
    FROM Numbers 
),
MatchedNumbers AS (
    SELECT T.TicketID, COUNT(*) AS MatchCount
    FROM Tickets T
    JOIN WinningNumbers W ON T.Number = W.Number
    GROUP BY T.TicketID
),
TicketWinnings AS (
    SELECT 
        M.TicketID,
        CASE 
            WHEN M.MatchCount = W.TotalWinningNumbers THEN 100
            ELSE 10
        END AS Prize
    FROM MatchedNumbers M, WinningCount W
)
SELECT SUM(Prize) AS TotalWinnings
FROM TicketWinnings;



---Task 9

select * from Spending 

drop table Spending 

CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);


	SELECT 
    Spend_date,
    Platform,
    SUM(Amount) AS Total_Amount,
    COUNT(DISTINCT User_id) AS Total_Users
FROM (
    SELECT 
        Spend_date,
        User_id,
        CASE 
            WHEN COUNT(DISTINCT Platform) = 2 THEN 'Both'
            ELSE MAX(Platform)
        END AS Platform,
        SUM(Amount) AS Amount
    FROM spending
    GROUP BY Spend_date, User_id
) AS sub
GROUP BY Spend_date, Platform
ORDER BY Spend_date, 
         CASE 
             WHEN Platform = 'Mobile' THEN 1
             WHEN Platform = 'Desktop' THEN 2
             WHEN Platform = 'Both' THEN 3
         END;


---Task 10

DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);


select * from Grouped 

go
WITH de_Grouped AS (
  SELECT Product, Quantity, 1 AS n
  FROM Grouped
  WHERE Quantity > 0
  UNION ALL
  SELECT Product, Quantity, n + 1
  FROM De_Grouped
  WHERE n + 1 <= Quantity
)
SELECT Product
FROM De_Grouped
ORDER BY Product;
