--- task 1

SELECT CONCAT('EMPLOYEE_ID',' ','FIRST_NAME',' ','LAST_NAME') AS EMPLOYEES 
FROM Employees 
 WHERE EMPLOYEE_ID = 100 

 ---TASK2

Update Employees
SET PHONE_NUMBER = replace(PHONE_NUMBER,'124','999')
WHERE PHONE_NUMBER LIKE '%124%'
 


--- TASK 3 

select
 FIRST_NAME as ism,
len (FIRST_NAME) as uzunlik
from employees
where FIRST_NAME like '%A%'
or FIRST_NAME like '%J%'
or FIRST_NAME like '%M%'
order by FIRST_NAME

--- TASK 4 

SELECT MANAGER_ID,
SUM(SALARY) AS TOTALSALARY
FROM Employees
GROUP BY MANAGER_ID 


--- TASK 5
select * from TestMax


SELECT
 year
GREATEST(Max1, Max2, Max3) AS Highest_value
from TestMax 


--- TASK 6

SELECT *
FROM cinema 
where id % 2 = 1
 AND description ! = 'boring'


 --- task 7

 SELECT * 
 FROM SingleOrder
 ORDER BY(id = 0), id,


 --- task 8

select 
 COALASCE(ssn,passportid,itin,id) as FIRST_NonNULL_CONCAT
 from person 


 --MEDIUM TASK 
 --- task 1

select 
   FULLNAME
   PARSENAME(REPLACE(FULLNAME,' ','.'),3)AS FIRSTNAME,
   PARSENAME(REPLACE(FULLNAME,' ','.'),2) AS Middlename,
   PARSENAME(REPLACE(FULL_NAME,' ','.'),1) AS LastName
   from Students 


--- task 2


select * from Orders 
where DeliveryState ='Texas'
AND Customerid in(
SELECT DISTINCT CustomerID
From orders
where DeliveryState = 'California'
and deliveryState = 'Texas')


--- task 3


select * from DMLTable

select CONCAT (sequenceNumber,String) as result
from DMLTable 


--- task 4


select * from employees 

 select 
EMPLOYEE_ID,   
concat(first_name,last_name) as full_name
FROM EMPLOYEES
WHERE LEN(REPLACE(CONCAT(FIRST_NAME,LAST_NAME), 'a', ''))<=LEN(CONCAT(FIRST_NAME,LAST_NAME)) - 3


--- task 5


select
 DEPARTMENT_ID,
 COUNT(*) as total_employees,
 ROUND(
 (SUM(CASE when DATEDIFF(YEAR,hire_date, GETDATE()) > 3 THEN 1 ELSE 0 END) / COUNT(*)) *100,
 2
 ) AS percentage_more_than_3_years
 FROM 
 Employees
 GROUP BY 
 DEPARTMENT_ID;



 --- TASK 6

 
SELECT * FROM PERSONAL 

SELECT 
SpacemanID,
DATEDIFF(YEAR,hire_date,GETDATE()) AS years_of_experience
FROM PERSONAL
WHERE Jobdescription = 'Spaceman'
order by 
years_of_experince DESC
limit 1 


---- DIFFICULT TASK
--TASK 1

SELECT
  REGEXP_REPLACE('tf56sd#%OqH', '[^A-Z]', '') AS uppercase_letters,
  REGEXP_REPLACE('tf56sd#%OqH', '[^a-z]', '') AS lowercase_letters,
  REGEXP_REPLACE('tf56sd#%OqH', '[^0-9]', '') AS numbers,
  REGEXP_REPLACE('tf56sd#%OqH', '[A-Za-z0-9]', '') AS other_characters;



  --- TASK 2

  SELECT * FROM STUDENTS 

  SELECT 
  student_id,
  name
  SUM(score)over (order by student_id) as cumulativ_sum
  from students 


  --- task 3


select * from Equations 

SELECT SUM(eval_expression(Equations)) AS total
FROM Equations;
