--Sub Query
--หาตำแหน่งของ Nancy ก่อน
Select Title From Employees
Where FirstName = 'Nancy'
--หาข้อมูลคนที่มีตำแหน่งเดียวกับข้อ 1
Select *
From Employees
Where Title = (Select Title
				From Employees
				Where FirstName = 'Nancy')
--ต้องการชื่อนามสกุลพนักงานที่มีอายุมากที่สุด
select FirstName,LastName
from Employees
where BirthDate = (select min (BirthDate)from Employees)
--ต้องการชื่อสินค้าที่มีราคามากกว่าสินค้าชื่อ Ikura
select ProductName
from Products
where UnitPrice > (select UnitPrice from Products
                    where ProductName = 'Ikura')
--ต้องการชื่อบริษัทลูกค้าที่อยู่เมืองเดียวกับบริษัทชื่อ Around the Horn
select CompanyName
from Customers
where City = (select city from Customers
               where CompanyName ='Around the Horn')
--ต้องการชื่อนามสกุลพนักงานที่เข้างานคนล่าสุด
select FirstName,LastName
from Employees
where HireDate = (select max(HireDate)from Employees)
--ข้อมูลใบสั่งซื้อที่ถูกส่งไปประเทศที่ไม่มีผู้ผลิตสินค้าตั้งอยู่
select * from Orders
where ShipCountry not in (select distinct country from Suppliers)

--การใส่ตัวเลขลำดับ
--ต้องการข้อมูลสินค้าที่มีราคาน้อยกว่า 50$
select ROW_NUMBER() over (order by unitprice desc) as rownum, ProductName,UnitPrice
from Products
where UnitPrice < 50

