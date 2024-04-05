--table valued functions (TVF)
--przyk³ady pochodz¹ z Books Online
--zaczynamy od Inline Table-Valued Function
use AdventureWorks2012
go

--inline table valued function - it can have only select statement inside
CREATE FUNCTION Sales.ufn_SalesByStore (@storeid int)
RETURNS TABLE
AS
RETURN 
(
    SELECT P.ProductID, P.Name, SUM(SD.LineTotal) AS 'Total'
    FROM Production.Product AS P 
    JOIN Sales.SalesOrderDetail AS SD ON SD.ProductID = P.ProductID
    JOIN Sales.SalesOrderHeader AS SH ON SH.SalesOrderID = SD.SalesOrderID
    JOIN Sales.Customer AS C ON SH.CustomerID = C.CustomerID
    WHERE C.StoreID = @storeid
    GROUP BY P.ProductID, P.Name
);
GO

select * from Sales.ufn_SalesByStore(1024)
where productid=714

go

create view Sales.ufn_SalesByStoreView as
SELECT P.ProductID, P.Name, SUM(SD.LineTotal) AS 'Total'
    FROM Production.Product AS P 
    JOIN Sales.SalesOrderDetail AS SD ON SD.ProductID = P.ProductID
    JOIN Sales.SalesOrderHeader AS SH ON SH.SalesOrderID = SD.SalesOrderID
    JOIN Sales.Customer AS C ON SH.CustomerID = C.CustomerID
    GROUP BY P.ProductID, P.Name
go

select * from Sales.ufn_SalesByStoreView
where ProductID=712 

select top 10 * FROM SALES.Customer

--naszym celem jest wywo³anie funkcji dla ka¿dego storeId
select count(StoreID) FROM SALES.Customer

select count(distinct StoreID) FROM SALES.Customer

--41022 --the following two queries are equivalent
select c.StoreID,s.Name,s.ProductID,s.Total
from sales.Customer as c cross apply sales.ufn_SalesByStore(c.storeId) s

select c.CustomerID,c.CustomerID,c.StoreID,s.Name,s.ProductID,s.Total
from sales.Customer as c outer apply sales.ufn_SalesByStore(c.storeId) s
where c.StoreID is not null


select c.CustomerID,c.StoreID,s.Name,s.ProductID,s.Total
from sales.Customer as c outer apply sales.ufn_SalesByStore(c.storeId) s


--chcemy uruchomiæ zapytanie dla unikalnych wartoœci storeId
select c.StoreID,s.Name,s.ProductID,s.Total
from (select distinct storeId from sales.Customer) as c
                cross apply sales.ufn_SalesByStore(c.storeId) s

--przyk³ad u¿cia cte (common table expression)
with cte_storeId as
(select distinct storeId as storeId from sales.Customer)
select c.StoreID,s.Name,s.ProductID,s.Total
from cte_storeId c cross apply sales.ufn_SalesByStore(c.storeId) s

--another CTE - source https://docs.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql?view=sql-server-2017
-- Define the CTE expression name and column list.  
WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)  
AS  
-- Define the CTE query.  
(  
    SELECT SalesPersonID, SalesOrderID, YEAR(OrderDate) AS SalesYear  
    FROM Sales.SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  
)  
-- Define the outer query referencing the CTE name.  
SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear  
FROM Sales_CTE  
GROUP BY SalesYear, SalesPersonID  
ORDER BY SalesPersonID, SalesYear;  
GO

WITH Sales_CTE (SalesPersonID, TotalSales, SalesYear)  
AS  
-- Define the first CTE query.  
(  
    SELECT SalesPersonID, SUM(TotalDue) AS TotalSales, YEAR(OrderDate) AS SalesYear  
    FROM Sales.SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  
       GROUP BY SalesPersonID, YEAR(OrderDate)  
  
)  
,   -- Use a comma to separate multiple CTE definitions.  
  
-- Define the second CTE query, which returns sales quota data by year for each sales person.  
Sales_Quota_CTE (BusinessEntityID, SalesQuota, SalesQuotaYear)  
AS  
(  
       SELECT BusinessEntityID, SUM(SalesQuota)AS SalesQuota, YEAR(QuotaDate) AS SalesQuotaYear  
       FROM Sales.SalesPersonQuotaHistory  
       GROUP BY BusinessEntityID, YEAR(QuotaDate)  
)  
  
-- Define the outer query by referencing columns from both CTEs.  
SELECT SalesPersonID  
  , SalesYear  
  , FORMAT(TotalSales,'C','en-us') AS TotalSales  
  , SalesQuotaYear  
  , FORMAT (SalesQuota,'C','en-us') AS SalesQuota  
  , FORMAT (TotalSales -SalesQuota, 'C','en-us') AS Amt_Above_or_Below_Quota  
FROM Sales_CTE  
JOIN Sales_Quota_CTE ON Sales_Quota_CTE.BusinessEntityID = Sales_CTE.SalesPersonID  
                    AND Sales_CTE.SalesYear = Sales_Quota_CTE.SalesQuotaYear  
ORDER BY SalesPersonID, SalesYear;  
GO



--Multistatement Table-valued functions
select top 10 * from sales.SalesOrderHeader

select year(OrderDate) as [year],sum(SubTotal) as [sales amount]
from sales.SalesOrderHeader
group by year(OrderDate)
order by year(OrderDate)

go

--multi-statement table valued function
create FUNCTION sales.ufn_MTVF_Demo(@year int)
RETURNS @salesAmount TABLE 
(
    [year] int NOT NULL,
    [sales amount] money
)
AS
BEGIN
if @year in (select year(orderdate) from sales.SalesOrderHeader)
    insert into @salesAmount
       select year(OrderDate) as [year],sum(SubTotal) as [sales amount]
       from sales.SalesOrderHeader
       where year(OrderDate)=@year
       group by year(OrderDate)
       order by year(OrderDate)
else
     insert into @salesAmount
	    select @year,0
return
END


select * from  sales.ufn_MTVF_Demo(2017) 

select * from  sales.ufn_MTVF_Demo(2011) 


--scalar function
--source https://docs.microsoft.com/en-us/sql/t-sql/statements/create-function-transact-sql?view=sql-server-2017
go

CREATE FUNCTION dbo.ISOweek (@DATE datetime)  
RETURNS int  
WITH EXECUTE AS CALLER  
AS  
BEGIN  
     DECLARE @ISOweek int;  
     SET @ISOweek= DATEPART(wk,@DATE)+1  
          -DATEPART(wk,CAST(DATEPART(yy,@DATE) as CHAR(4))+'0104');  
--Special cases: Jan 1-3 may belong to the previous year  
     IF (@ISOweek=0)   
          SET @ISOweek=dbo.ISOweek(CAST(DATEPART(yy,@DATE)-1   
               AS CHAR(4))+'12'+ CAST(24+DATEPART(DAY,@DATE) AS CHAR(2)))+1;  
--Special case: Dec 29-31 may belong to the next year  
     IF ((DATEPART(mm,@DATE)=12) AND   
          ((DATEPART(dd,@DATE)-DATEPART(dw,@DATE))>= 28))  
          SET @ISOweek=1;  
     RETURN(@ISOweek);  
END;  
GO  
SET DATEFIRST 1;  
SELECT dbo.ISOweek(CONVERT(DATETIME,'12/26/2004',101)) AS 'ISO Week';
