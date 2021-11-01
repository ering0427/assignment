-- 1.	What is View? What are the benefits of using views?
A view is a virtual table in which the content comes from the result set of a query.

2.	Can data be modified through views?
Yes. But the data must follow the same restrictions specified in the base table.

3.	What is stored procedure and what are the benefits of using it?
A stored procedure groups one or multiple SQL statements and stores as an object in the database. It allows users to reuse queires and provides fast performance.
Also, the use of stored procedures increase database security because it limites direct access.

4.	What is the difference between view and stored procedure?
A view is a virtual table and cannot take parameters. A stored procedure can take parameters to perform an action.

5.	What is the difference between stored procedure and functions?
A stored procedure can call functions, have input/output parameters, and return zero, single, or multiple values. A function must return a single value
and can only have input parameter.

6.	Can stored procedure return multiple result sets?
Yes.

7.	Can stored procedure be executed as part of SELECT Statement? Why?
No. We should use a function instead.

8.	What is Trigger? What types of Triggers are there?
A trigger is a special stored procedure that gets triggered when a specific event happens.
We have DML triggers, DDL triggers, and LOGON triggers.

9.	What is the difference between Trigger and Stored Procedure?
A stored procedure needs to be invoked by the user. A trigger is a special type of stored procedure that runs automatically when
special events happen.


1.	Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
CREATE VIEW view_product_order_gong
AS
SELECT p.ProductName, p.ProductID, SUM(od.Quantity) AS TotalOrderedQuantity
FROM Products p LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, P.ProductName

2.	Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
CREATE PROC sp_product_order_quantity_gong
@productid VARCHAR(10),
@totalquantity INT out
AS
BEGIN
SELECT @totalquantity = SUM(od.Quantity) 
FROM Products p LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE od.ProductID = @productid
GROUP BY p.ProductID
END

3.	Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
CREATE PROC sp_product_order_city_gong
@productname varchar(20)
AS
SELECT dt.ShipCity, dt.total_quantity
FROM
(SELECT o.ShipCity, SUM(od.Quantity) total_quantity, RANK() OVER(PARTITION BY o.ShipCity ORDER BY SUM(p.ProductID) DESC ) AS RNK
FROM Products p LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID LEFT JOIN Orders o ON od.OrderID = o.OrderID
WHERE p.ProductName = @productname
GROUP BY o.ShipCity, od.Quantity) dt
WHERE RNK <= 5

4.	Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE people_gong
(
ID int,
[Name] varchar(20),
City int
)

CREATE TABLE city_gong
(
ID int,
City varchar(20)
)

INSERT INTO people_gong VALUES(1, 'Aaron Rodgers', 2)
INSERT INTO people_gong VALUES(2, 'Russell Wilson', 1)
INSERT INTO people_gong VALUES(3, 'Jody Nelson', 2)

INSERT INTO city_gong VALUES(1, 'Seattle')
INSERT INTO city_gong VALUES(2, 'Green Bay')

DECLARE @cityid AS int
SELECT @cityid = ID
FROM city_gong
WHERE City = 'Seattle'
print(@cityid)
UPDATE people_gong
SET City = 3
WHERE ID = @cityid

DELETE FROM city_gong
WHERE City = 'Seattle'

INSERT INTO city_gong VALUES(3, 'Madison')

CREATE VIEW Packers_gong
AS
SELECT p.Name
FROM people_gong p JOIN city_gong c ON p.City = c.ID
WHERE c.City = 'Green Bay'

drop table city_gong
drop table people_gong

5.	 Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employees_gong
AS
BEGIN
SELECT EmployeeID,BirthDate INTO birthday_employees_gong
FROM Employees
WHERE MONTH(BirthDate) = 2
END

EXEC sp_birthday_employees_gong

drop table birthday_employees_gong

6.	How do you make sure two tables have the same data?
We can UNION the tables together. The row number should not change if the two tables have the same data.

7.
First Name	Last Name	Middle Name
John	Green	
Mike	White	M
Output should be
Full Name
John Green
Mike White M.
Note: There is a dot after M when you output.

SELECT [First Name] + ' ' + [Last Name] + IIF([Middle Name] != ' ', [Middle Name] + '.', ' ') AS [Full Name]
FROM TABLE

8.
Student	Marks	Sex
Ci	70	F
Bob	80	M
Li	90	F
Mi	95	M
Find the top marks of Female students.
If there are to students have the max score, only output one.

SELECT MAX(Marks)
FROM TABLE
WHERE Sex = 'F'

9.
Student	Marks	Sex
Li	90	F
Ci	70	F
Mi	95	M
Bob	80	M
How do you out put this?

SELECT *
FROM TABLE
ORDER BY Sex, Marks DESC

