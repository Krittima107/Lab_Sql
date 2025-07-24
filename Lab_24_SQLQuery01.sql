--ต้องการ ภาค ประเทศ เมือง ชื่อบริษัทลูกค้า เบอร์
select Region,Country,City, CompanyName,Phone
from Customers
order by 1 asc,2asc,3asc
--มูลค่าสินค้าคงเหลือต่อรายการ
select ProductID, ProductName, UnitPrice, UnitsInStock, 
UnitPrice * UnitsInStock as StockValue
from Products
--ต้องสั่งสินค้าเพิ่มหรือยัง?
select ProductID as รหัส, ProductName as ชื่อสินค้า, 
 จำนวนคงเหลือทั้งหมด = UnitsInStock + UnitsOnOrder,
 จุดสั่งซื้อ = ReorderLevel
from Products
where (UnitsInStock+UnitsOnOrder) < ReorderLevel
--ภาษีมูลค่าเพื่ม 7%
select ProductID, ProductName,
UnitPrice,ROUND(UnitPrice*0.07,2) AS	vat
from Products
--ชื่อ นามสกุล พนักงาน
select EmployeeID,
TitleOfCourtesy+FirstName+SPACE(1) +LastName as [employee Name]
from Employees
--ต้องการทราบราคาในแต่ละรายการสินค้า[order details]
select OrderID, ProductID, UnitPrice, Quantity, Discount,
	(UnitPrice*Quantity)as totalPrice,
	(UnitPrice*Quantity)-(UnitPrice*Quantity*Discount)as netPrice
from [Order Details]

select OrderID, ProductID, UnitPrice, Quantity, Discount,
	(UnitPrice*Quantity)as totalPrice,
	UnitPrice*Quantity*(1-Discount) as netPrice
from [Order Details]
--ราคาจริง = ราคาเต็ม - ส่วนลด
--ราคาเต็ม = ราคา * จำนวน
--ส่วนลด = ราคาเต็ม * ลด
--ราคาจริง = (ราคา * จำนวน)-(ราคา*จำนวน*ลด)
--ราคาจริง = ราคา * จำนวน * (1-ลด)
select (42.40*35)-(42.40*35*0.15)
--ต้องการทราบอายุ และอายุงานของพนักงานทุกคน จนถึงปัจจุบัน
select EmployeeID, FirstName, BirthDate,datediff(YEAR,BirthDate,'2025-07-24')age,
HireDate, datediff(YEAR,HireDate,GETDATE()) YearInoffice
from Employees

select GETDATE()
--แสดงข้อมูลจ านวนสินค้าที่มีเก็บไว้ต่ำกว่า 15 ชิ้น
SELECT COUNT(*) as จำนวนสินค้า, COUNT(ProductID),COUNT(ProductName),COUNT(UnitPrice)
FROM Products
WHERE UnitsInStock < 15
--จำนวนลูกค้าที่อยู่ประเทศ USA
select COUNT(*) 
from Customers
where Country = 'USA'
--จำนวนลูกค้าที่อยู่ใน london
select COUNT(*)
from Employees
where City = 'london'
--จำนวนใบสั่งซื้อที่ออกในปี 1997
select COUNT(*) from Orders where YEAR(OrderDate)=1997
--จำนวนครั้งที่ขายสินค้ารหัส 1
select count(*) from [Order Details] where ProductID = 1
--function Sum
--จำนวนสินค้าที่ขายได้ทั้งหมด
select sum(Quantity)
from [Order Details]
where ProductID =2
--มูลค่าสินค้าในคลังทั้งหมด
select sum(UnitPrice * UnitsInStock)
from Products
--จำนวนสินค้ารหัสประเภท 8 ที่สั่งซื้อแล้ว
select sum(UnitsOnOrder)
from Products
where CategoryID =8
--function Max, Min
--ราคาสินค้ารหัส 1 ที่ขายได้ราคาสูงสุด และต่ำสุด
select max(UnitPrice), min(UnitPrice)
from [Order Details]
where ProductID =71
--function AVG
--ราคาสินค้าเฉลี่ยทั้งหมดที่เคยขายได้ เฉพาะสินค้ารหัส 5
select avg(UnitPrice),min(UnitPrice),max(UnitPrice)
from [Order Details]
where ProductID = 5
--แสดงชื่อประเทศ และจำนวนลูกค้า
SELECT Country , COUNT(*) as [Num of Country]
FROM Customers
GROUP BY Country
--รหัสประเภทสินค้า ราคาเฉลี่ยสินค้าประเภทเดียวกัน
select CategoryID, avg(UnitPrice),min(UnitPrice),max(UnitPrice)
from Products
group by CategoryID
--รายการสินค้าในใบสั่งซื้อ[order Details]
--เฉพาะในใบสั่งซื้อที่มีสินค้ามากกว่า 3 ชนิด
select orderID, count(*)
from [Order Details]
group by OrderID 
having count(*)>3
--ประเทศปลายทาง และจำนวนใบสั่งซื้อที่ส่งสินค้าไปถึงปลายทาง
--ต้องการเฉพาะที่มีจำนวนใบสั่งซื้อ ตั้งแต่ 100 ขึ้นไป
select ShipCountry, count(*) numOfOrders
from Orders
group by ShipCountry
HAVING count(*)>=100
--ข้อมูลรหัสใบสั่งซื้อ ยอดเงินรวมในใบสั่งซื้อนั้น แสดงเฉพาะใบสั่งซื้อที่มียอดเงินน้อยกว่า 100 [order details]
select OrderID,sum( UnitPrice*Quantity*(1-Discount))
from [Order Details]
group by OrderID
having sum( UnitPrice*Quantity*(1-Discount)) < 100
--ประเทศใดที่มีจำนวนใบสั่งซื้อที่ส่งสินค้าไปปลายทางต่ำกว่า 20 รายการ ในปี 1997
select ShipCountry,count(*) as numOfOrders
from Orders
where YEAR(OrderDate)=1997
group by ShipCountry
having count(*)<20
order by count(*) DESC
--ใบสั่งซื้อใดมียอดสั่งซื้อสูงที่สุด แสดงรหัสใบสั่งซื้อ และยอดขาย
select OrderID, sum(UnitPrice*Quantity*(1-Discount)) as total
from [Order Details]
group by OrderID
order by total desc
--ใบสั่งซื้อใดมียอดขายต่ำที่สุด 5 อันดับ แสดงรหัสใบสั่งซื้อและยอดขาย
select top 5 OrderID, sum(UnitPrice*Quantity*(1-Discount)) as total
from [Order Details]
group by OrderID
order by total asc
