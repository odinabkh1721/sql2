
CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');


select * from #Sales 
--Task 1

Find customers who purchased at least one item in March 2024 using EXISTS

drop table #Sales 
	CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);

--Task 2
--Find the product with the highest total sales revenue using a subquery

SELECT Product, SUM(Quantity * Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(TotalRev)
    FROM (
        SELECT SUM(Quantity * Price) AS TotalRev
        FROM #Sales
        GROUP BY Product
    ) AS RevenueByProduct
);



--Task 3
--3. Find the second highest sale amount using a subquery


select Product,SUM(quantity * price) as saleamount
from #Sales
Group by Product
Having SUM(MAX(saleamount* price) =(
 SELECT MAX(saleamount * price ) as Sale
from #Sales
Group by Product
) as revenuesaleamount );


--TASK 4

--Find the total quantity of products sold per month using a subquery

select * from #Sales


SELECT 
  YEAR(SaleDate) AS SaleYear,
  MONTH(SaleDate) AS SaleMonth,
  SUM(Quantity) AS TotalQuantity
FROM #Sales
GROUP BY YEAR(SaleDate), MONTH(SaleDate)

---Task 5
--Find customers who bought same products as another customer using EXISTS

select DISTINCT SaleID,
CustomerName,
Product
from #Sales as S1
where EXISTS(
select 1
from #sales as  s2
where s1.CustomerName = s2.CustomerName 
and S1.SaleID=s2.SaleID)

---Task 6

--Return how many fruits does each person have in individual fruit level

create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')

							select * from Fruits


							Select  name ,
 sum( case when Fruit='Apple' then 1 else 0 end) as Apple,
     sum( case when Fruit='Orange' then 1 else 0 end) as Orange,
	 sum( case when Fruit='Banana' then 1 else 0 end) as Banana
	 from Fruits
group by  name 

---Task 7

create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)

select * from Family 



;with RecursiveFamily as (
select ParentId as pid,ChildID as chid from  Family

union all

Select rf.PID, f.ChildID from  RecursiveFamily as rf
join Family as f 
on rf.chid=f.ParentId)

Select pid,chid from RecursiveFamily
ORDER BY PID, CHID;


---Task 8

CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);


INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);


select * from Orders 


 
Select * from  #Orders
where DeliveryState = 'TX' and CustomerID in (Select CustomerID from #Orders where DeliveryState = 'ca' )



----Task 9

create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')


select * from #residents


UPDATE r
SET fullname = 
    SUBSTRING(address, 
              CHARINDEX('name=', address) + 5, 
              CHARINDEX(' ', address + ' ', CHARINDEX('name=', address)) - (CHARINDEX('name=', address) + 5))
FROM #residents r
WHERE address LIKE '%name=%'
  AND (fullname IS NULL OR fullname NOT IN ( 
       SUBSTRING(address, 
                 CHARINDEX('name=', address) + 5, 
                 CHARINDEX(' ', address + ' ', CHARINDEX('name=', address)) - (CHARINDEX('name=', address) + 5)) 
  ));
;


----Task 10

CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

select * from #Routes 



;with bekat1 as(
select * from #Routes 
where DepartureCity = 'Tashkent'),
destination as(
select concat(bekat1.DepartureCity,'-',bekat1.ArrivalCity,'-',bekat2.ArrivalCity,'-',bekat3.ArrivalCity,'-',bekat4.ArrivalCity) as route,
    bekat1.cost + bekat2.Cost + isnull(bekat3.Cost,0) + isnull(bekat4.Cost,0) as cost from bekat1
  
join #Routes as bekat2 on bekat1.ArrivalCity = bekat2.DepartureCity
left join #Routes as bekat3 on bekat2.ArrivalCity = bekat3.DepartureCity
left join #Routes as bekat4 on bekat3.ArrivalCity = bekat4.DepartureCity )

select * from destination
where cost in (select min(cost) from destination) or cost in (select max(cost) from destination)

---Task 11

CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')




Select id, 
      vals,
     SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END) OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) as SumVals from #RankingPuzzle


	 ---Task 12
	 CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);


select * from #EmployeeSales


;with Avgcte  as (Select EmployeeName, Department,SalesAmount,avg(SalesAmount) over (partition by Department ) as AvgSales
from #EmployeeSales)

Select EmployeeName,Department,SalesAmount,AvgSales from  Avgcte
where AvgSales<SalesAmount
order by Department


---Task 13


SELECT EmployeeID, EmployeeName, Department, SalesAmount, SalesMonth
FROM #EmployeeSales AS E1
WHERE NOT EXISTS (
    SELECT 1 
    FROM #EmployeeSales AS E2
    WHERE E2.SalesMonth = E1.SalesMonth
      AND E2.SalesAmount > E1.SalesAmount
);

---Task 14

CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);




WITH AllMonths AS (
  SELECT DISTINCT SalesMonth
  FROM #EmployeeSales
)


SELECT DISTINCT E.EmployeeName
FROM #EmployeeSales E
WHERE NOT EXISTS (
    SELECT 1
    FROM AllMonths M
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales ES
        WHERE ES.EmployeeName = E.EmployeeName
          AND ES.SalesMonth = M.SalesMonth
    )
)



 ---Tas 14

 CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);


select * from Products 



WITH AllMonths AS (
  SELECT DISTINCT SalesMonth
  FROM #EmployeeSales
)


SELECT DISTINCT E.EmployeeName
FROM #EmployeeSales E
WHERE NOT EXISTS (
    SELECT 1
    FROM AllMonths M
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales ES
        WHERE ES.EmployeeName = E.EmployeeName
          AND ES.SalesMonth = M.SalesMonth
    )
)


---Task 15


;with AvgPrice as (Select ProductID,
       Name,
	   Category, 
	   Price,
	   Avg(Price) over (partition by Category) as AvgPrice from Products)

Select * from AvgPrice
where AvgPrice<Price


---tsk 16




SELECT Name,Stock
FROM products
WHERE Stock < (
    SELECT MAX(Stock)
    FROM products
);



---Task 17

Select * from products 
where Category=(Select Category from products 
where Product='Laptop' ) and name<>'Laptop'


select * from Products 

--Task 18


 SELECT name, price,Category
FROM products
WHERE price > (
    SELECT MIN(price)
    FROM products
    WHERE Category = 'Electronics'
);


--TAsk 19


;with Avgcte as (Select ProductID,name,Category,Price,avg(Price) over (partition by category) as AvgPrice from products)

Select * from Avgcte
where Price>AvgPrice

Select p1.name,p1.Category,p1.Price from products as p1
where p1.Price>(Select avg(p2.Price) from products as p2
where p1.Category=p2.Category )



--Task 20


Select OrderID, ProductID,Quantity from Orders
where Quantity>=1

--Task 21

;with Avgcte as (Select OrderID, ProductID,Quantity,avg(Quantity) over () AvgQuantity from Orders)

Select distinct A.ProductID from Avgcte as A
join Orders as O
on a.ProductID=o.ProductID
where o.Quantity>A.AvgQuantity


--Task 22

SELECT o.OrderID,o.ProductID
FROM Orders o
LEFT JOIN Orders o1 ON o.ProductID = o1.ProductID
WHERE o.ProductID IS NULL;

--Task 23 
Select top 1 ProductID,sum(Quantity) as SumQuantity from Orders
group by ProductID
order by sum(Quantity) desc
