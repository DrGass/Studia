create procedure HumanResources.deleteDepartment @departmentId int
as
begin
	
	  delete from HumanResources.Department
      where DepartmentID=@departmentId
end

go

select * from HumanResources.Department

exec HumanResources.deleteDepartment @departmentId=1

select * from HumanResources.EmployeeDepartmentHistory where DepartmentID=1

/*Msg 547, Level 16, State 0, Procedure deleteDepartment, Line 5 [Batch Start Line 10]
The DELETE statement conflicted with the REFERENCE constraint "FK_EmployeeDepartmentHistory_Department_DepartmentID". The conflict occurred in database "AdventureWorks2016", table "HumanResources.EmployeeDepartmentHistory", column 'DepartmentID'.
The statement has been terminated.*/
go

alter procedure HumanResources.deleteDepartment @departmentId int
as
begin

	begin try
	  delete from HumanResources.Department
	  where DepartmentID=@departmentId
    end try
	begin catch
		--print 'There are some employees working in this department'
		print 'we are in catch';
		SELECT  
        ERROR_NUMBER() AS ErrorNumber,  
        ERROR_SEVERITY() AS ErrorSeverity,  
        ERROR_STATE() AS ErrorState,  
        ERROR_PROCEDURE() AS ErrorProcedure,  
        ERROR_LINE() AS ErrorLine,  
        ERROR_MESSAGE() AS ErrorMessage;  
		throw
	end catch
	 
end

exec HumanResources.deleteDepartment @departmentId=15


--Homework
--1. Change the procedure
--2. Check whether there are rows in HumanResources.EmployeeDepartmentHistory
-- which are connected with the procedure parameter @departmentId
--3. If there are some then set departmentId to null
--4. Delete the row from the Department table

select * from HumanResources.EmployeeDepartmentHistory

go

alter procedure HumanResources.deleteDepartment @departmentId int
as
begin
	begin try
	 begin transaction
	  if exists (select * from HumanResources.EmployeeDepartmentHistory
	             where DepartmentID=@departmentId)
	  begin
	    delete from HumanResources.EmployeeDepartmentHistory
		where DepartmentID=@departmentId
	  end
	  delete from HumanResources.Department
	  where DepartmentID=@departmentId
     commit transaction
    end try
	begin catch
		rollback transaction;
		throw;
	end catch
end
go

select * from HumanResources.EmployeeDepartmentHistory where DepartmentID=15
select * from HumanResources.Department where DepartmentID=15



exec HumanResources.deleteDepartment @departmentId=15



--xact_abort -- from https://docs.microsoft.com/en-us/sql/t-sql/statements/set-xact-abort-transact-sql?view=sql-server-2017
USE AdventureWorks2014; 

GO  
IF OBJECT_ID(N't2', N'U') IS NOT NULL  
    DROP TABLE t2;  
GO  
IF OBJECT_ID(N't1', N'U') IS NOT NULL  
    DROP TABLE t1;  
GO  


CREATE TABLE t1  
    (a INT NOT NULL PRIMARY KEY);  

CREATE TABLE t2  
    (a INT NOT NULL REFERENCES t1(a));  
GO  

INSERT INTO t1 VALUES (1);  
INSERT INTO t1 VALUES (3);  
INSERT INTO t1 VALUES (4);  
INSERT INTO t1 VALUES (6);  
GO  
SET XACT_ABORT OFF;  
GO  
BEGIN TRANSACTION;  
INSERT INTO t2 VALUES (1);  
INSERT INTO t2 VALUES (2); -- Foreign key error.  
INSERT INTO t2 VALUES (3);  
COMMIT TRANSACTION;  
GO  

select * from t2 --sa dwa wiersze
delete from t2

go

alter  procedure p1 as 
SET XACT_ABORT ON;
begin
BEGIN TRANSACTION;  
INSERT INTO t2 VALUES (1);  
INSERT INTO t2 VALUES (2); -- Foreign key error.  
INSERT INTO t2 VALUES (3);  
COMMIT TRANSACTION;  
end

select * from t2

exec p1

select * from t2


SET XACT_ABORT ON;  
GO  
BEGIN TRANSACTION;  
INSERT INTO t2 VALUES (4);  
INSERT INTO t2 VALUES (5); -- Foreign key error.  
INSERT INTO t2 VALUES (6);  
COMMIT TRANSACTION;  
GO  

select * from t2

-- SELECT shows only keys 1 and 3 added.   
-- Key 2 insert failed and was rolled back, but  
-- XACT_ABORT was OFF and rest of transaction  
-- succeeded.  
-- Key 5 insert error with XACT_ABORT ON caused  
-- all of the second transaction to roll back.  
SELECT *  
    FROM t2;  
GO

--apply try-catch do deal with transactions
begin try
  BEGIN TRANSACTION;  
    INSERT INTO t2 VALUES (4);  
    INSERT INTO t2 VALUES (5); -- Foreign key error.  
    INSERT INTO t2 VALUES (6);  
   COMMIT TRANSACTION;  
end try
begin catch
  rollback;
  throw;--alows to display exception
end catch

select * from t2

--transactions

use tempdb

create table Person(personId int identity primary key,
                    lastName varchar(50))

create table Car
(carId int identity primary key,
mark varchar(50),
model varchar(50),
personId int,
constraint fk_personId foreign key(personId) references Person(personId)
)

delete from Person

--here we have two independnet tranactions (each insert statement
--is a standalone transaction
insert into Person values('Smith')
declare @perId int
set @perId = SCOPE_IDENTITY()
insert into Car values('BMW','X5',@perId)

select * from Person
select * from Car

go
--the second insert will fail (too many characters)
insert into Person values('Norris')
declare @perId int
set @perId = SCOPE_IDENTITY()
insert into Car values(
  'BMW',
  'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
   @perId)

select * from Person
select * from Car



delete from Person where personId=2

go

--our goal is to create a transaction to ensure that both statements
--will succeed or none of them

--the following code does not cancel the first insert if the second
--insert fails

set xact_abort off

begin transaction
  insert into Person values('Norris')
  declare @perId int
  set @perId = SCOPE_IDENTITY()
  insert into Car values(
    'BMW',
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
     aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
   @perId)
commit transaction

select * from Person
delete from Person where personId=3

--complete atomic transaction
begin try
  begin transaction
    insert into Person values('Norris')
    insert into Car values(
      'BMW',
      'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
       aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    scope_identity())
  commit transaction
end try
begin catch
 rollback transaction;
 throw
end catch

select * from Person
select * from Car

--it is also a good practise to check whether there are open transactions
--before you type rollback

begin try
  begin transaction
    insert into Person values('Norris')
    insert into Car values(
      'BMW',
      'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
       aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    scope_identity())
  commit transaction
end try
begin catch
 if XACT_STATE()=1  --is there open transaction
  begin
   rollback transaction
  end;
  throw
end catch

select * from Person
go
--create a procedure to insert a new person (the procedure shuold
--take one paramater - person last name


--create a procedure to create a new car (the procedure should take 3 
--parameters: personId, mark and model
--If personId is not valid you should print some message to the user (e.g.
--there is no person with such identifier)

--solution
create procedure addNewPerson @lastName varchar(60)
as
begin
  insert into Person(lastName) values(@lastName)
end

execute addNewPerson @lastName='Kowalski'
select * from Person

go

create procedure addNewCar @personID int, @mark varchar(50),
                          @model varchar(50)
as
begin
if exists (select * from Person where personId=@personID)
  insert into Car(mark,model,personId)
     values(@mark,@model,@personID)
else
  select 'There is no person with such identifier: '+
      cast(@personId as varchar(50)) as result
end

exec addNewCar @personId=20,@mark='BMW',@model='X5'

exec addNewCar @personId=11,@mark='BMW',@model='X5'

go

select * from Car
select * from Person

go

create procedure addNewPersonAndCar @lastName varchar(60),
       @mark varchar(50),@model varchar(50)
as
begin
declare @personId int
begin try
   begin transaction
	insert into Person(lastName) values(@lastName)
    set @personId = SCOPE_IDENTITY() --retrieve the last personId
	insert into Car(mark,model,personId)
     values(@mark,@model,@personID)
   commit transaction 
end try
begin catch
  rollback; --if some errors occur then cancel the transaction 
  throw
 end catch
end


exec addNewPersonAndCar @lastName='Nowak',@mark='Citroen',@model='C5'

select * from Person
select * from Car

--the same procedure with sequence insted of identity/scope_identity
go
CREATE SEQUENCE person_seq  
    START WITH 50  
    INCREMENT BY 1 ;  
GO  

CREATE SEQUENCE car_seq  
    START WITH 30  
    INCREMENT BY 1 ;  
GO  


drop table Car
drop table Person
go

--Person and car now have no identity column
create table Person(personId int primary key,
                    lastName varchar(50))

create table Car
(carId int primary key,
mark varchar(50),
model varchar(50),
personId int,
constraint fk_personId foreign key(personId) references Person(personId)
)


go
alter procedure addNewPersonAndCar @lastName varchar(60),
       @mark varchar(50),@model varchar(50)
as
begin
declare @personId int
begin try
   begin transaction
	set @personId = NEXT VALUE FOR person_seq
	insert into Person values(@personId,@lastName)
    insert into Car values(NEXT VALUE FOR car_seq, @mark,@model,@personID)
   commit transaction 
end try
begin catch
  rollback; --if some errors occur then cancel the transaction 
  throw
end catch
end

exec addNewPersonAndCar @lastName='Terry',@mark='Toyota',@model='RAV 4'

select * from Car
select * from Person


go

----SEQUENCES
--FROM https://docs.microsoft.com/en-us/sql/t-sql/functions/next-value-for-transact-sql?view=sql-server-2017
USE AdventureWorks2014 ;  
GO  
  
CREATE SCHEMA Test;  
GO  
  
CREATE SEQUENCE Test.CountBy1  
    START WITH 1  
    INCREMENT BY 1 ;  
GO  

CREATE TABLE Test.TestTable  
     (CounterColumn int PRIMARY KEY,  
    Name nvarchar(25) NOT NULL) ;   
GO  
  
INSERT Test.TestTable (CounterColumn,Name)  
    VALUES (NEXT VALUE FOR Test.CountBy1, 'Syed') ;  
GO  
  
SELECT * FROM Test.TestTable;   
GO  
  
 select NEXT VALUE FOR Test.CountBy1










