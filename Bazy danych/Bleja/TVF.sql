--inline table valued functions (TVF)
use [Weterynarz]

go


CREATE FUNCTION dbo.Znajdz_osobe (@imie varchar(30))
RETURNS TABLE
AS
RETURN 
(
	SELECT O.nazwisko,O.imie,O.numer_telefonu
	from dbo.Osoba O
	WHERE O.imie = CAST(@imie as varchar)
	Group by O.nazwisko,O.imie,O.numer_telefonu

);
GO

CREATE FUNCTION dbo.Znajdz_osobe_id (@id INT)
RETURNS TABLE
AS
RETURN 
(
	SELECT O.imie,O.nazwisko
	FROM Osoba O 
	WHERE O.id_osoby = @id
	GROUP BY O.imie,O.nazwisko
);
GO

select * from dbo.Znajdz_osobe('imie15')

go

select * from dbo.Znajdz_osobe_id(5)

go

--Multistatement Table-valued functions
CREATE FUNCTION dbo.Znajdz_pracownika()
	RETURNS @Pracownik TABLE
	(

		id_pracownika int,
		pozycja varchar(30)

	) 

AS 
BEGIN
	INSERT INTO @Pracownik
	SELECT
		id_pracownika,
		pozycja
	FROM
		dbo.Pracownik
		
RETURN
END

go


SELECT * from dbo.Znajdz_pracownika();

go

DROP FUNCTION dbo.Znajdz_pracownika
SELECT * FROM dbo.Adres

SELECT * FROM Pracownik

-- 

Declare @Id int
Set @Id = 1

While @Id <= 10000
Begin 

		Print @Id

   INSERT INTO dbo.Firma(Adres_id_adresu) values (@Id)


	Set @Id = @Id + 1
End

SELECT * FROM Firma

-- sequence 

CREATE SEQUENCE dbo.seq1
start with 1
increment by 1
go

drop sequence dbo.seq1

drop table temp

go

create table temp(id int, liczba int)

go

select * from temp



Insert into temp(id,liczba) values(NEXT VALUE FOR dbo.seq1,NEXT VALUE FOR dbo.seq1 % 5)
go
--- try catch


create procedure dbo.deleteTemp @tempId int
as
begin
	
	  delete from dbo.temp
      where temp.id = @tempId
end

go

drop procedure dbo.deleteTemp

go



alter procedure dbo.deleteTemp @tempId int
as
begin

	begin try
	   delete from dbo.temp
      where temp.id = @tempId
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

select * from temp

exec Weterynarz.dbo.deleteTemp @tempid = 25

select * from temp

GRANT EXECUTE ON OBJECT:: dbo.deleteTemp