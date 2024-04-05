
--source Microsoft

https://learn.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql?view=sql-server-ver16



select *
from Production.Product


select ProductID,Name,ListPrice,
       row_number() over (order by ListPrice desc) 'row_number',
	   rank() over (order by ListPrice desc) 'rank',
	   dense_rank() over (order by ListPrice desc) 'dense_rank',
	   ntile(5) over (order by ListPrice desc) 'ntile'
from Production.Product


select ProductID,Name,ListPrice,ProductSubcategoryID,
   row_number() over (partition by ProductSubcategoryID order by ListPrice desc) row_number,
   rank() over (partition by ProductSubcategoryID order by ListPrice desc) 'rank',
   dense_rank() over (partition by ProductSubcategoryID order by ListPrice desc) 'dense_rank',
   ntile(5) over (partition by ProductSubcategoryID order by ListPrice desc) 'ntile'
from Production.Product
where  ProductSubcategoryID is not null
order by ProductSubcategoryID

--wypisac najdrozsze produkty w danej podkategorii

select pid,productName,productPrice,subId,subName
from (select p.ProductID pid,p.Name productName,p.ListPrice productPrice,
             p.ProductSubcategoryID subId,ps.Name subName,
            dense_rank() over 
			   (partition by p.ProductSubcategoryID order by ListPrice desc) ranking
      from Production.Product p join Production.ProductSubcategory ps
	       on p.ProductSubcategoryID=ps.ProductSubcategoryID
      where  p.ProductSubcategoryID is not null) tab
where ranking=1


select 
	  object_id
	, [min]	= min(object_id) over()
	, [max]	= max(object_id) over()
from sys.objects


select 
	  object_id, type
	, [min]	= min(object_id) over(partition by type) 
	, [max]	= max(object_id) over(partition by type)
from sys.objects


/*if order by is specified (specifies the logical order in which the window function calculation is performed)
and
a ROWS/RANGE is not specified
then default RANGE UNBOUNDED PRECEDING AND CURRENT ROW is used as default 
*/
select 
	  object_id, type
	, [min]	= min(object_id) over(partition by type order by object_id)
	, [max]	= max(object_id) over(partition by type order by object_id)
from sys.objects


select 
	  object_id, type
	, [min]	= min(object_id) over(partition by type order by object_id rows between UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING )
	, [max]	= max(object_id) over(partition by type order by object_id rows between UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING)
	, [min2]	= min(object_id) over(partition by type order by object_id rows between 2 PRECEDING and 2 FOLLOWING )
	, [max2]	= max(object_id) over(partition by type order by object_id rows between 2 PRECEDING and 2 FOLLOWING)
from sys.objects


select
	  object_id
	, [preceding]	= count(*) over(order by object_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
	, [central]	= count(*) over(order by object_id ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING )
	, [following]	= count(*) over(order by object_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
from sys.objects
order by object_id asc

select top 10 * FROM Sales.SalesPersonQuotaHistory

/*LAG (scalar_expression [,offset] [,default])  
    OVER ( [ partition_by_clause ] order_by_clause )  */


--LAG i LEAD
SELECT BusinessEntityID, YEAR(QuotaDate) AS SalesYear, SalesQuota AS CurrentQuota, 
       LAG(SalesQuota, 1,0) OVER (ORDER BY YEAR(QuotaDate)) AS PreviousQuota, QuotaDate
FROM Sales.SalesPersonQuotaHistory
WHERE BusinessEntityID = 275 and YEAR(QuotaDate) IN ('2011','2012');


SELECT BusinessEntityID, YEAR(QuotaDate) AS SalesYear, SalesQuota AS CurrentQuota, 
       LEAD(SalesQuota, 1, 0) OVER (ORDER BY YEAR(QuotaDate)) AS NextQuota,QuotaDate
FROM Sales.SalesPersonQuotaHistory
WHERE BusinessEntityID = 275 and YEAR(QuotaDate) IN ('2011','2012');

SELECT TerritoryName, BusinessEntityID, SalesYTD, 
       LAG (SalesYTD, 1, 0)
	      OVER (PARTITION BY TerritoryName ORDER BY SalesYTD DESC) AS PrevRepSales
FROM Sales.vSalesPerson
WHERE TerritoryName IN (N'Northwest', N'Canada') 
ORDER BY TerritoryName;

select * from Sales.vSalesPerson


/*FIRST_VALUE ( [scalar_expression ] )  [ IGNORE NULLS | RESPECT NULLS ]
    OVER ( [ partition_by_clause ] order_by_clause [ rows_range_clause ] )*/

	--FIRST_VALUE Returns the first value in an ordered set of values.
SELECT Name, ListPrice, 
       FIRST_VALUE(Name) OVER (ORDER BY ListPrice ASC) AS LeastExpensive 
FROM Production.Product
WHERE ProductSubcategoryID = 37;

SELECT JobTitle, LastName, VacationHours,
       FIRST_VALUE(LastName) OVER (PARTITION BY JobTitle
                                   ORDER BY VacationHours ASC
                                   ROWS UNBOUNDED PRECEDING
                                  ) AS FewestVacationHours
FROM HumanResources.Employee AS e
INNER JOIN Person.Person AS p
    ON e.BusinessEntityID = p.BusinessEntityID
ORDER BY JobTitle;

/*
The ROWS clause limits the rows within a partition by specifying a fixed number of rows preceding or following the current row. 
Alternatively, the RANGE clause logically limits the rows within a partition by specifying a range of values with respect to the value in the current row.
*/


--LAST_VALUE Returns the last value in an ordered set of values.
SELECT Name, ListPrice, 
        LAST_VALUE(Name) OVER (ORDER BY ListPrice asc) AS MostExpensive ,
		 LAST_VALUE(Name) OVER (ORDER BY ListPrice asc range between UNBOUNDED PRECEDING AND CURRENT ROW) AS MostExpensive1 ,
	   LAST_VALUE(Name) OVER (ORDER BY ListPrice asc rows between UNBOUNDED PRECEDING AND CURRENT ROW) AS MostExpensive2 ,
	    LAST_VALUE(Name) OVER (ORDER BY ListPrice asc rows between unbounded preceding and unbounded following) AS MostExpensive3--,
	   -- FIRST_VALUE(Name) OVER (ORDER BY ListPrice desc) AS MostExpensive3
FROM Production.Product
WHERE ProductSubcategoryID = 37;

/*AVG ( [ ALL | DISTINCT ] expression )  
   [ OVER ( [ partition_by_clause ] order_by_clause ) ]*/

SELECT BusinessEntityID, TerritoryID   
   ,DATEPART(yy,ModifiedDate) AS SalesYear  ,ModifiedDate
   ,CONVERT(VARCHAR(20),SalesYTD,1) AS  SalesYTD  
   ,CONVERT(VARCHAR(20),AVG(SalesYTD) OVER (PARTITION BY TerritoryID   
                                            ORDER BY DATEPART(yy,ModifiedDate)   
                                           ),1) AS MovingAvg  
   ,CONVERT(VARCHAR(20),SUM(SalesYTD) OVER (PARTITION BY TerritoryID   
                                            ORDER BY DATEPART(yy,ModifiedDate)   
                                            ),1) AS CumulativeTotal  
   ,CONVERT(VARCHAR(20),SUM(SalesYTD) OVER (PARTITION BY TerritoryID   
                                             ORDER BY DATEPART(yy,ModifiedDate)   
                                             ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ),1) AS CumulativeTotal2
FROM Sales.SalesPerson  
WHERE TerritoryID IS NULL OR TerritoryID < 5  
ORDER BY TerritoryID,SalesYear;

select 559697.56+519905.93, (559697.56+519905.93)/2.0

YTD            avg         sum          sum
559697.56	559697.56	559697.56	1079,603.50
519905.93	539801.75	1079603.50	692430.38
172524.45	417375.98	1252127.95	172524.45

select (559697.56+519905.93+172524.45)/3, 559697.56+519905.93+172524.45



SELECT BusinessEntityID, TerritoryID   
    ,CONVERT(VARCHAR(20),SalesYTD,1) AS SalesYTD  
    ,DATEPART(yy,ModifiedDate) AS SalesYear  
    ,CONVERT(VARCHAR(20),SUM(SalesYTD) OVER (PARTITION BY TerritoryID   
                                             ORDER BY DATEPART(yy,ModifiedDate)   
                                             ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ),1) AS CumulativeTotal  
FROM Sales.SalesPerson  
WHERE TerritoryID IS NULL OR TerritoryID < 5;  


/*
OVER (   
       [ <PARTITION BY clause> ]  
       [ <ORDER BY clause> ]   
       [ <ROW or RANGE clause> ]  
      )  


PARTITION BY that divides the query result set into partitions.
ORDER BY that defines the logical order of the rows within each partition of the result set.
ROWS/RANGE that limits the rows within the partition by specifying start and end points within the partition. It requires ORDER BY argument and the default value is from the start of partition to the current element if the ORDER BY argument is specified.
*/


select * from HumanResources.Employee
