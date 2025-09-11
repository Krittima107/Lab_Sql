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

--คำสั่ง DML(Insert Update Delete)
select* from Shippers
----------คำสั่ง Insert เพิ่มข้อมูล
--ตาราง มี PK เป็น AutoInsement (AutoNumber)
insert into Shippers
values('บริษัทขนเยอะจำกัด','081-12345678')

insert into Shippers(CompanyName)
values('บริษัทขนมหาศาลจำกัด')

select*from Customers
--ตารางที่มี PK เป็น char nchar
insert into Customers(CustomerID,CompanyName)
values ('A0001','บริษัทชื่อเยอะจำกัด')
--จงเพิ่มข้อมูลพนักงาน 1 คน (ใส่ข้อมูลเท่าที่มี)
insert into Employees (FirstName,LastName)
values ('วุ้นเส้น','เขมรสกุล')

select * from Employees
--จงเพิ่มสินค้า ปลาแดกบอง ราคา 1.5$ จำนวน 12
insert into Products(ProductName,UnitPrice,UnitsInStock)
values ('ปลาแดกบอง',1.5,12)

select * from Products
--คำสั่ง Update ปรับปรุงข้อมูล
--ปรับปรุงเบอร์โทรศัพท์ ของบริษัทขนส่ง รหัส 6
update Shippers
set Phone = '085-99998989'
where ShipperID = 5

select * from Shippers
--ปรับปรุงจำนวนสินค้าคงเหลือสิค้ารหัส 1 เพิ่มจำนวนเข้าไป 100 ชิ้น
update Products
set UnitsInStock = UnitsInStock + 100
where ProductID = 1

select * from Products
--ปรับปรุง เมือง และประเทศลูกค้า รหัส A0001 ให้เป็นอุดรธานีม Thailand
update Customers
set City = 'อุดรธานี', Country = 'Thailand'
where CustomerID = 'A0001'

select * from Customers
--ลบข้อมูลสินค้าที่มีรหัสหมายเลข 78
DELETE FROM Products
WHERE ProductID = 78;

select * from Products

----------คำสั่ง Delete ลบข้อมูล
--ลบบริษัทขนส่งสินค้า รหัส 6
delete from Shippers
where ShipperID = 6

select * from Orders
--ต้องการข้อมูล รหัสและชื่อพนักงาน และรหัสและชื่อหัวหน้าพนักงาน
select emp.EmployeeID,emp.FirstName ชื่อพนักงาน,
		boss.EmployeeID,boss.FirstName ชื่อหัวหน้า
from Employees emp join Employees boss
on emp.ReportsTo = boss.EmployeeID
