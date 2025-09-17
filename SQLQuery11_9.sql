-- 1.   จงแสดงให้เห็นว่าพนักงานแต่ละคนขายสินค้าประเภท Beverage ได้เป็นจำนวนเท่าใด และเป็นจำนวนกี่ชิ้น เฉพาะครึ่งปีแรกของ 2540(ทศนิยม 4 ตำแหน่ง)
SELECT 
  E.EmployeeID,(E.FirstName + ' ' + E.LastName) AS EmployeeFullName,
  CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS TotalAmount,
  SUM(OD.Quantity) AS TotalQuantity
FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID
JOIN Categories C ON P.CategoryID = C.CategoryID
JOIN Employees E ON O.EmployeeID = E.EmployeeID
WHERE C.CategoryName = 'Beverages'
  AND O.OrderDate >= '1997-01-01' AND O.OrderDate < '1997-07-01'
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY E.EmployeeID
-- 2.   จงแสดงชื่อบริษัทตัวแทนจำหน่าย  เบอร์โทร เบอร์แฟกซ์ ชื่อผู้ติดต่อ จำนวนชนิดสินค้าประเภท Beverage ที่จำหน่าย โดยแสดงจำนวนสินค้า จากมากไปน้อย 3 อันดับแรก
SELECT TOP 3
  S.SupplierID,
  S.CompanyName,
  S.Phone,
  S.Fax,
  S.ContactName,
  COUNT(DISTINCT P.ProductID) AS BeverageProductTypesSold
FROM Suppliers S
JOIN Products P ON S.SupplierID = P.SupplierID
JOIN [Order Details] OD ON P.ProductID = OD.ProductID
JOIN Categories C ON P.CategoryID = C.CategoryID
WHERE C.CategoryName = 'Beverages'
GROUP BY S.SupplierID, S.CompanyName, S.Phone, S.Fax, S.ContactName
ORDER BY COUNT(DISTINCT P.ProductID) DESC
-- 3.   จงแสดงข้อมูลชื่อลูกค้า ชื่อผู้ติดต่อ เบอร์โทรศัพท์ ของลูกค้าที่ซื้อของในเดือน สิงหาคม 2539 ยอดรวมของการซื้อโดยแสดงเฉพาะ ลูกค้าที่ไม่มีเบอร์แฟกซ์
SELECT
  C.CustomerID,
  C.CompanyName,
  C.ContactName,
  C.Phone,
  CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS TotalPurchased
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1996 AND MONTH(O.OrderDate) = 8
  AND (C.Fax IS NULL OR LTRIM(RTRIM(C.Fax)) = '')
GROUP BY C.CustomerID, C.CompanyName, C.ContactName, C.Phone
ORDER BY TotalPurchased DESC;
-- 4.   แสดงรหัสสินค้า ชื่อสินค้า จำนวนที่ขายได้ทั้งหมดในปี 2541 ยอดเงินรวมที่ขายได้ทั้งหมดโดยเรียงลำดับตาม จำนวนที่ขายได้เรียงจากน้อยไปมาก พรอ้มทั้งใส่ลำดับที่ ให้กับรายการแต่ละรายการด้วย
WITH ProdSales AS (SELECT P.ProductID, P.ProductName,SUM(OD.Quantity) AS TotalQty,
    CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS TotalAmount
  FROM Products P
  JOIN [Order Details] OD ON P.ProductID = OD.ProductID
  JOIN Orders O ON OD.OrderID = O.OrderID
  WHERE YEAR(O.OrderDate) = 1998
  GROUP BY P.ProductID, P.ProductName)
SELECT
  ROW_NUMBER() OVER (ORDER BY TotalQty ASC) AS RowRank,
  ProductID,
  ProductName,
  TotalQty,
  TotalAmount
FROM ProdSales
ORDER BY TotalQty ASC;
-- 5.   จงแสดงข้อมูลของสินค้าที่ขายในเดือนมกราคม 2540 เรียงตามลำดับจากมากไปน้อย 5 อันดับใส่ลำดับด้วย รวมถึงราคาเฉลี่ยที่ขายให้ลูกค้าทั้งหมดด้วย
WITH JanSales AS (
  SELECT
    P.ProductID,
    P.ProductName,
    SUM(OD.Quantity) AS TotalQty,
    CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS TotalAmount,
    CASE WHEN SUM(OD.Quantity) = 0 THEN 0
         ELSE CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) / SUM(OD.Quantity) AS DECIMAL(18,4))
    END AS AvgSoldPrice
  FROM Products P
  JOIN [Order Details] OD ON P.ProductID = OD.ProductID
  JOIN Orders O ON OD.OrderID = O.OrderID
  WHERE YEAR(O.OrderDate) = 1997 AND MONTH(O.OrderDate) = 1
  GROUP BY P.ProductID, P.ProductName)
SELECT TOP 5
  ROW_NUMBER() OVER (ORDER BY TotalQty DESC) AS RankNo,
  ProductID,
  ProductName,
  TotalQty,
  TotalAmount,
  AvgSoldPrice
FROM JanSales
ORDER BY TotalQty DESC;
-- 6.   จงแสดงชื่อพนักงาน จำนวนใบสั่งซื้อ ยอดเงินรวมทั้งหมด ที่พนักงานแต่ละคนขายได้ ในเดือน ธันวาคม 2539 โดยแสดงเพียง 5 อันดับที่มากที่สุด
SELECT TOP 5
  E.EmployeeID,
  (E.FirstName + ' ' + E.LastName) AS EmployeeFullName,
  COUNT(DISTINCT O.OrderID) AS OrderCount,
  CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS TotalSales
FROM Employees E
JOIN Orders O ON E.EmployeeID = O.EmployeeID
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1996 AND MONTH(O.OrderDate) = 12
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY TotalSales DESC;
-- 7.   จงแสดงรหัสสินค้า ชื่อสินค้า ชื่อประเภทสินค้า ที่มียอดขาย สูงสุด 10 อันดับแรก ในเดือน ธันวาคม 2539 โดยแสดงยอดขาย และจำนวนที่ขายด้วย
SELECT TOP 10
  P.ProductID,
  P.ProductName,
  C.CategoryName,
  SUM(OD.Quantity) AS TotalQty,
  CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS TotalAmount
FROM Products P
JOIN Categories C ON P.CategoryID = C.CategoryID
JOIN [Order Details] OD ON P.ProductID = OD.ProductID
JOIN Orders O ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 1996 AND MONTH(O.OrderDate) = 12
GROUP BY P.ProductID, P.ProductName, C.CategoryName
ORDER BY TotalAmount DESC;
-- 8.   จงแสดงหมายเลขใบสั่งซื้อ ชื่อบริษัทลูกค้า ที่อยู่ เมืองประเทศของลูกค้า ชื่อเต็มพนักงานผู้รับผิดชอบ ยอดรวมในแต่ละใบสั่งซื้อ จำนวนรายการสินค้าในใบสั่งซื้อ และเลือกแสดงเฉพาะที่จำนวนรายการในใบสั่งซื้อมากกว่า 2 รายการ
SELECT
  O.OrderID,
  C.CompanyName,
  C.Address,
  C.City,
  C.Country,
  (E.FirstName + ' ' + E.LastName) AS EmployeeFullName,
  CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS OrderTotal,
  COUNT(OD.ProductID) AS ItemsCount
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN Employees E ON O.EmployeeID = E.EmployeeID
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderID, C.CompanyName, C.Address, C.City, C.Country, E.FirstName, E.LastName
HAVING COUNT(OD.ProductID) > 2
ORDER BY O.OrderID;
-- 9.   จงแสดง ชื่อบริษัทลูกค้า ชื่อผู้ติดต่อ เบอร์โทร เบอร์แฟกซ์ ยอดที่สั่งซื้อทั้งหมดในเดือน ธันวาคม 2539 แสดงผลเฉพาะลูกค้าที่มีเบอร์แฟกซ์
SELECT
  C.CustomerID,
  C.CompanyName,
  C.ContactName,
  C.Phone,
  C.Fax,
  CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS TotalOrderedInDec1996
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1996 AND MONTH(O.OrderDate) = 12
  AND C.Fax IS NOT NULL AND LTRIM(RTRIM(C.Fax)) <> ''
GROUP BY C.CustomerID, C.CompanyName, C.ContactName, C.Phone, C.Fax
ORDER BY TotalOrderedInDec1996 DESC;
-- 10.  จงแสดงชื่อเต็มพนักงาน จำนวนใบสั่งซื้อที่รับผิดชอบ ยอดขายรวมทั้งหมด เฉพาะในไตรมาสสุดท้ายของปี 2539 เรียงตามลำดับ มากไปน้อยและแสดงผลตัวเลขเป็นทศนิยม 4 ตำแหน่ง
SELECT
  E.EmployeeID,
  (E.FirstName + ' ' + E.LastName) AS EmployeeFullName,
  COUNT(DISTINCT O.OrderID) AS OrderCount,
  CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS TotalSalesQ4_1996
FROM Employees E
JOIN Orders O ON E.EmployeeID = O.EmployeeID
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE O.OrderDate >= '1996-10-01' AND O.OrderDate < '1997-01-01'
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY TotalSalesQ4_1996 DESC;
-- 11.  จงแสดงชื่อพนักงาน และแสดงยอดขายรวมทั้งหมด ของสินค้าที่เป็นประเภท Beverage ที่ส่งไปยังประเทศ ญี่ปุ่น
SELECT
  E.EmployeeID,
  (E.FirstName + ' ' + E.LastName) AS EmployeeFullName,
  CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS BeverageSalesToJapan
FROM Employees E
JOIN Orders O ON E.EmployeeID = O.EmployeeID
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID
JOIN Categories C ON P.CategoryID = C.CategoryID
WHERE C.CategoryName = 'Beverages'
  AND O.ShipCountry = 'Japan'
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY BeverageSalesToJapan DESC;
-- 12.  แสดงรหัสบริษัทตัวแทนจำหน่าย ชื่อบริษัทตัวแทนจำหน่าย ชื่อผู้ติดต่อ เบอร์โทร ชื่อสินค้าที่ขาย เฉพาะประเภท Seafood ยอดรวมที่ขายได้แต่ละชนิด แสดงผลเป็นทศนิยม 4 ตำแหน่ง เรียงจาก มากไปน้อย 10 อันดับแรก
SELECT TOP 10
  S.SupplierID,
  S.CompanyName AS SupplierCompany,
  S.ContactName,
  S.Phone,
  P.ProductID,
  P.ProductName,
  CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS TotalAmount
FROM Suppliers S
JOIN Products P ON S.SupplierID = P.SupplierID
JOIN [Order Details] OD ON P.ProductID = OD.ProductID
JOIN Orders O ON OD.OrderID = O.OrderID
JOIN Categories C ON P.CategoryID = C.CategoryID
WHERE C.CategoryName = 'Seafood'
GROUP BY S.SupplierID, S.CompanyName, S.ContactName, S.Phone, P.ProductID, P.ProductName
ORDER BY TotalAmount DESC;
-- 13.  จงแสดงชื่อเต็มพนักงานทุกคน วันเกิด อายุเป็นปีและเดือน พร้อมด้วยชื่อหัวหน้า
SELECT
  E.EmployeeID,
  (E.FirstName + ' ' + E.LastName) AS EmployeeFullName,
  CONVERT(VARCHAR(10), E.BirthDate, 105) AS BirthDate_105,
  -- อายุเป็นปี
  DATEDIFF(YEAR, E.BirthDate, GETDATE())
    - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.BirthDate, GETDATE()), E.BirthDate) > GETDATE() THEN 1 ELSE 0 END
    AS AgeYears,
  -- อายุส่วนเดือน (เหลือ)
  (DATEDIFF(MONTH, E.BirthDate, GETDATE())
    - (DATEDIFF(YEAR, E.BirthDate, GETDATE())
       - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.BirthDate, GETDATE()), E.BirthDate) > GETDATE() THEN 1 ELSE 0 END) * 12) AS AgeMonths,
  (M.FirstName + ' ' + M.LastName) AS ManagerFullName
FROM Employees E
LEFT JOIN Employees M ON E.ReportsTo = M.EmployeeID
ORDER BY EmployeeFullName;
-- 14.  จงแสดงชื่อบริษัทลูกค้าที่อยู่ในประเทศ USA และแสดงยอดเงินการซื้อสินค้าแต่ละประเภทสินค้า
SELECT
  C.CustomerID,
  C.CompanyName,
  Cat.CategoryName,
  CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS TotalByCategory
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID
JOIN Categories Cat ON P.CategoryID = Cat.CategoryID
WHERE C.Country = 'USA'
GROUP BY C.CustomerID, C.CompanyName, Cat.CategoryName
ORDER BY C.CompanyName, TotalByCategory DESC;
-- 15.  แสดงข้อมูลบริษัทผู้จำหน่าย ชื่อบริษัท ชื่อสินค้าที่บริษัทนั้นจำหน่าย จำนวนสินค้าทั้งหมดที่ขายได้และราคาเฉลี่ยของสินค้าที่ขายไปแต่ละรายการ แสดงผลตัวเลขเป็นทศนิยม 4 ตำแหน่ง
SELECT
  S.SupplierID,
  S.CompanyName AS SupplierCompany,
  P.ProductID,
  P.ProductName,
  SUM(OD.Quantity) AS TotalQuantitySold,
  CASE WHEN SUM(OD.Quantity) = 0 THEN CAST(0 AS DECIMAL(18,4))
       ELSE CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) / SUM(OD.Quantity) AS DECIMAL(18,4))
  END AS AvgSoldPrice
FROM Suppliers S
JOIN Products P ON S.SupplierID = P.SupplierID
LEFT JOIN [Order Details] OD ON P.ProductID = OD.ProductID
LEFT JOIN Orders O ON OD.OrderID = O.OrderID
GROUP BY S.SupplierID, S.CompanyName, P.ProductID, P.ProductName
ORDER BY S.CompanyName, TotalQuantitySold DESC;
-- 16.  ต้องการชื่อบริษัทผู้ผลิต ชื่อผู้ต่อต่อ เบอร์โทร เบอร์แฟกซ์ เฉพาะผู้ผลิตที่อยู่ประเทศ ญี่ปุ่น พร้อมทั้งชื่อสินค้า และจำนวนที่ขายได้ทั้งหมด หลังจาก 1 มกราคม 2541
SELECT
  S.SupplierID,
  S.CompanyName,
  S.ContactName,
  S.Phone,
  S.Fax,
  P.ProductID,
  P.ProductName,
  SUM(OD.Quantity) AS TotalQtySoldAfter1998_01_01
FROM Suppliers S
JOIN Products P ON S.SupplierID = P.SupplierID
JOIN [Order Details] OD ON P.ProductID = OD.ProductID
JOIN Orders O ON OD.OrderID = O.OrderID
WHERE S.Country = 'Japan'
  AND O.OrderDate >= '1998-01-02'  -- หลังจาก 1 มกราคม 2541 (ถ้ารวมวันที่ 2 เป็นต้นไป) 
  -- ถ้าต้องการรวมวันที่ 1/1/1998 ด้วย ให้ใช้ >= '1998-01-01'
GROUP BY S.SupplierID, S.CompanyName, S.ContactName, S.Phone, S.Fax, P.ProductID, P.ProductName
ORDER BY TotalQtySoldAfter1998_01_01 DESC;
-- 17.  แสดงชื่อบริษัทขนส่งสินค้า เบอร์โทรศัพท์ จำนวนรายการสั่งซื้อที่ส่งของไปเฉพาะรายการที่ส่งไปให้ลูกค้า ประเทศ USA และ Canada แสดงค่าขนส่งโดยรวมด้วย
SELECT
  Sh.ShipperID,
  Sh.CompanyName AS ShipperName,
  Sh.Phone,
  COUNT(DISTINCT O.OrderID) AS OrdersCountToUS_AC,
  CAST(SUM(O.Freight) AS DECIMAL(18,4)) AS TotalFreight
FROM Shippers Sh
JOIN Orders O ON Sh.ShipperID = O.ShipVia
WHERE O.ShipCountry IN ('USA','Canada')
GROUP BY Sh.ShipperID, Sh.CompanyName, Sh.Phone
ORDER BY OrdersCountToUS_AC DESC;
-- 18.  ต้องการข้อมูลรายชื่อบริษัทลูกค้า ชื่อผู้ติดต่อ เบอร์โทรศัพท์ เบอร์แฟกซ์ ของลูกค้าที่ซื้อสินค้าประเภท Seafood แสดงเฉพาะลูกค้าที่มีเบอร์แฟกซ์เท่านั้น
SELECT DISTINCT
  C.CustomerID,
  C.CompanyName,
  C.ContactName,
  C.Phone,
  C.Fax
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID
JOIN Categories Cat ON P.CategoryID = Cat.CategoryID
WHERE Cat.CategoryName = 'Seafood'
  AND C.Fax IS NOT NULL AND LTRIM(RTRIM(C.Fax)) <> ''
ORDER BY C.CompanyName;
-- 19.  จงแสดงชื่อเต็มของพนักงาน  วันเริ่มงาน (รูปแบบ 105) อายุงานเป็นปี เป็นเดือน ยอดขายรวม เฉพาะสินค้าประเภท Condiment ในปี 2540
SELECT
  E.EmployeeID,
  (E.FirstName + ' ' + E.LastName) AS EmployeeFullName,
  CONVERT(VARCHAR(10), E.HireDate, 105) AS HireDate_105,
  -- อายุงานเป็นปี (นับถึง 1997-12-31)
  DATEDIFF(YEAR, E.HireDate, '1997-12-31')
    - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.HireDate, '1997-12-31'), E.HireDate) > '1997-12-31' THEN 1 ELSE 0 END
    AS TenureYears,
  -- อายุงานส่วนเดือนที่เหลือ
  (DATEDIFF(MONTH, E.HireDate, '1997-12-31') 
    - (DATEDIFF(YEAR, E.HireDate, '1997-12-31')
       - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.HireDate, '1997-12-31'), E.HireDate) > '1997-12-31' THEN 1 ELSE 0 END) * 12
  ) AS TenureMonths,
  CAST(ISNULL(SUM(
    CASE WHEN Cat.CategoryName = 'Condiments' AND YEAR(O.OrderDate) = 1997
         THEN OD.Quantity * OD.UnitPrice * (1-OD.Discount) ELSE 0 END
  ),0) AS DECIMAL(18,4)) AS CondimentSales_1997
FROM Employees E
LEFT JOIN Orders O ON E.EmployeeID = O.EmployeeID
LEFT JOIN [Order Details] OD ON O.OrderID = OD.OrderID
LEFT JOIN Products P ON OD.ProductID = P.ProductID
LEFT JOIN Categories Cat ON P.CategoryID = Cat.CategoryID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, E.HireDate
ORDER BY EmployeeFullName;
-- 20.  จงแสดงหมายเลขใบสั่งซื้อ  วันที่สั่งซื้อ(รูปแบบ 105) ยอดขายรวมทั้งหมด ในแต่ละใบสั่งซื้อ โดยแสดงเฉพาะ ใบสั่งซื้อที่มียอดจำหน่ายสูงสุด 10 อันดับแรก
SELECT TOP 10
  O.OrderID,
  CONVERT(VARCHAR(10), O.OrderDate, 105) AS OrderDate_105,
  CAST(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS DECIMAL(18,4)) AS OrderTotal
FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderID, O.OrderDate
ORDER BY OrderTotal DESC;