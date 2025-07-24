-- แบบฝึกหัดคำสั่ง SQL ใช้ฐานข้อมูล Northwind
--1. ต้องการรหัสพนักงาน คำนำหน้า ชื่อ นามสกุล ของพนักงานที่อยู่ในประเทศ USA
Select EmployeeID, TitleOfCourtesy, FirstName, LastName 
from Employees
where Country = 'usa'
--2. ต้องการข้อมูลสินค้าที่มีรหัสประเภท 1,2,4,8 และมีราคา ช่วง 100$-200$
Select *
from Products
where CategoryID in (1,2,4,8) and UnitPrice between 100 and 200
--3. ต้องการประเทศ เมือง ชื่อบริษัทลูกค้า ชื่อผู้ติดต่อ เบอร์โทร ของลูกค้าทั้งหมด ที่อยู่ในภาค WA และ WY
select Country, City, CompanyName, Phone
from Customers
where Region = 'WA' or Region = 'WY' --WA และ WY
--4. ข้อมูลของสินค้ารหัสประเภทที่ 1 ราคาไม่เกิน 20 หรือสินค้ารหัสประเภทที่ 8 ราคาตั้งแต่ 150 ขึ้นไป
Select  ProductName,ProductID,UnitPrice
from Products
where (CategoryID = 1 and UnitPrice<=20)
	or (CategoryID = 8 and UnitPrice >= 50);
--5. ชื่อบริษัทลูกค้า ที่อยู่ใน ประเทศ USA ที่ไม่มีหมายเลข FAX  เรียงตามลำดับชื่อบริษัท
select CompanyName
from Customers
where Fax is null
order by CompanyName
--6. ต้องการข้อมูลลูกค้าที่ชื่อบริษัททมีคำว่า Com
select *
from Customers
where CompanyName like '%com%'