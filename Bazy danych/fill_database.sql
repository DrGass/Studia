USE [Weterynarz]

GO


DELETE FROM Zamówienie_produkt
DELETE FROM Sklep_Produkt
DELETE FROM Zamówienie
DELETE FROM dbo.Osoba
DELETE FROM dbo.Firma
DELETE FROM dbo.Adres
DELETE FROM dbo.Klient
DELETE FROM dbo.Pracownik
DELETE FROM dbo.Produkt
DELETE FROM dbo.Sklep

go

SELECT * FROM Pracownik


Declare @Id int

Set @Id = 1

While @Id <= 20000
Begin 

		Print @Id

   INSERT INTO dbo.Osoba(id_osoby,imie,nazwisko,numer_telefonu,email) VALUES(@Id,'imie' + CAST((@Id % 500) as varchar),'nazwisko' + CAST((@Id % 1500) as varchar),  400000000 + @Id, 'email' + CAST(@Id as varchar))

	Set @Id = @Id + 1
End

go

Declare @Id int

Set @Id = 1

While @Id <= 10000
Begin 

		Print @Id

   INSERT INTO dbo.Adres(id_adresu,ulica,miasto,kod_ZIP,numer_domu) VALUES (@Id,'ulica' + CAST((@Id % 100) as varchar),'miasto' + CAST((@Id % 4) as varchar),(@Id % 4),'nr' + CAST((@Id % 200) as varchar))
   INSERT INTO dbo.Produkt(id_produktu,nazwa,cena) VALUES(@Id,'produkt' + CAST(@Id as varchar), (@Id % 250) + ((@Id % 100)/100))
   
   INSERT INTO dbo.Firma(id_firmy,NIP,nr_telefonu,Adres_id_adresu) VALUES (@Id, @Id + 1000000000, 300000000 + @Id, @Id)
   INSERT INTO dbo.Sklep(id_sklepu,nazwa,stan_produktu,Adres_id_adresu,Firma_id_firmy) VALUES(@Id,'nazwa' + CAST(@Id as varchar),((@Id % 100) + 100 + (@Id % 2)),@Id,@Id)
   INSERT INTO dbo.Klient(id_klienta,zwierzak,Osoba_id_osoby) VALUES (@Id, 'zwierzak' + CAST(@Id as varchar),@Id)
   INSERT INTO dbo.Pracownik(id_pracownika,pozycja,Sklep_id_sklepu,Osoba_id_osoby) VALUES(@Id,'pozycja' + CAST((@Id % 20 )as varchar),@Id,@Id + 10000)
   INSERT INTO dbo.Sklep_Produkt(Sklep_id_sklepu,Produkt_id_produktu) values (@Id,@Id)
   INSERT INTO dbo.Zamówienie(id_zamowienia,Klient_id_klienta) values (@Id,@Id)
   INSERT INTO dbo.Zamówienie_produkt(Produkt_id_produktu,Zamówienie_id_zamowienia) values (@Id,@Id)

	Set @Id = @Id + 1
End

go
