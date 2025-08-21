select CategoryName,ProductName,UnitPrice
from Products,Categories
where products.CategoryID=Categories.CategoryID