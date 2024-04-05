--example of DML (Data manipulation language - insert/update/delete) trigger
use [Weterynarz]

go

create table temp(id int, imie varchar(50), liczba int)

go

create trigger prohibitMark
on temp after insert
as
select * from inserted
 if exists (select * from inserted i where i.imie = 'Mark')
  begin
   print 'Mark ma zakaz wstępu'
   rollback;
   end

--trigger test
insert into temp values(1,'Marek',26)

insert into temp values(2,'Mark',29)

select * from temp

insert into temp values(2,'Kamil',29),(3,'Mark',35)

select * from temp

--DDL trigger (DDL - Data Defintion Language - Create/Alter/Drop)

drop table temp

create table temp(id int, imie varchar(50), liczba int)

go

CREATE TRIGGER blockNewTables   
ON DATABASE   
FOR CREATE_TABLE   --event CREATE_TABLE
AS   
   PRINT 'Creating new tables is not allowed in that database'   
   ROLLBACK;--used to undo user transaction - table creation

  
drop table temp

--trigger test   

create table temp(id int, imie varchar(50), liczba int)

go

--instead of trigger

----Disable the previous defined trigger blockNewTables
DISABLE TRIGGER blockNewTables ON DATABASE

go

drop table temp 

go


SELECT * INTO temp FROM Firma

SELECT top 20 * FROM temp

ALTER TABLE temp ADD WAS_REMOVED bit default 0

SELECT top 20 * FROM temp

update temp set was_removed=0

SELECT top 20 * FROM temp

go

CREATE TRIGGER Remove_temp
ON temp
INSTEAD OF DELETE
AS BEGIN
select * from deleted
UPDATE t
SET t.was_removed = 1
FROM temp t JOIN Deleted d on t.id_firmy=d.id_firmy
end
;

go


drop trigger Remove_temp

--- triger test
select * from temp

delete from temp where temp.nip in (1000000001,50000,1231231)

select * from temp


