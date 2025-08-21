--1 แสดงชื่อประเภทสินค้า ชื่อสินค้า และ ราคาสินค้า
--CARTESIAN PRODUCT เชื่อมโยงที่ค าสั่ง WHERE
Select CategoryName, ProductName, UnitPrice
From Products as P, Categories as C
where P.CategoryID=C.CategoryID
and categoryName = 'seafood'

--JOIN OPERATOR เชื่อมโยงที่คำสั่ง FROM...ON...
Select CategoryName, ProductName,UnitPrice
From Products as P Join Categories as C
On P.CategoryID=C.CategoryID
where categoryName = 'seafood'

--จงแสดงข้อมูลหมายเลขใบสั่งซื้อ และชื่อบริษัท ขนส่งสินค้า
Select CompanyName, OrderID
FROM Orders, Shippers
WHERE Shippers.ShipperID = Orders.Shipvia

Select CompanyName, OrderID
FROM Orders join Shippers
ON Shippers.ShipperID = Orders.Shipvia

--จงแสดงข้อมูลหมายเลขใบสั่งซื้อและชื่อบริษัทขนส่งสินค้าของใบสั่งซื้อหมายเลข 10275
--Cartesian Product
SELECT CompanyName, OrderID
FROM Orders, Shippers
WHERE Shippers.ShipperID = Orders.Shipvia
AND OrderID = 10275

--Join Operator
SELECT CompanyName, OrderID
FROM Orders JOIN Shippers
ON Shippers.ShipperID=Orders.Shipvia
WHERE OrderID=10275

select p.ProductID,p.ProductName,s.CompanyName,s.Country
from Products p join Suppliers s on p.SupplierID = p.SupplierID
where Country in ('usa','uk')

select e.EmployeeID,FirstName,
from Employees e join Orders o on e.EmployeeID=e.EmployeeID
order by EmployeeID

SELECT O.OrderID เลขใบสั่งซื้อ, C.CompanyName ลูกค้า,
E.FirstName พนักงาน, O.ShipAddress ส่งไปที่
FROM Orders O
join Customers C on O.CustomerID=C.CustomerID
join Employees E on O.EmployeeID=E.EmployeeID
