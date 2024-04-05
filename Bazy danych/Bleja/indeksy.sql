--indeksy
use tempdb
--plusy - indeksy poprawiaja select (wyszykiwanie, sortowanie, zlaczenia)
--minusy - indeksy pogarszaja DML (insert, update,delete), 
--        zajmuja dodatkowe miejsce

--demo uzycia indeksu
drop table big1

create table big1(id int identity,
              nr int,
			   tekst char(400))

--uwaga: tabela nie ma klucza g³ównego ani ograniczenia unique a zatem
--nie ma ¿adnego indeksu

drop table tab1
create table tab1(id int identity primary key, email varchar(100) unique)
--tab1 ma z automatu 2 indeksy

--id int identity primary key == id int identity primary key clustered
-- email varchar(100) unique == email varchar(100) unique NONCLUSTERED 
drop table tab1

create table tab1(id int identity primary key nonclustered, email varchar(100) unique)
--dwa unikalne indeksy nieklastrowe


drop table tab1

create table tab1(id int identity primary key nonclustered, email varchar(100) unique clustered)
--na id niklastrowy uniklany
--ne email indeks klastrowy

--nalezy po generacji kodu SQL z Oracle developer data modeller rozwazyc utworzenie indeksow nieklastrowych na kluczach
--glownych (tzn. zamienic clustered na nonclustered)
--indeksy klastrowe sa dobre do zapytan zakresowych np. data_zamowiania > data1 and data_zamowienia< data2

select rand()

--wstawiamy 10000 rekordow do tabeli big1
insert into big1 values(cast(rand()*10 as int),'wmii')
go 10000

select count(*) from big1

select top 100 * from big1

--w³¹czamy I/O statystyki aby wyswietlic ilosc 8KB stron przetwarzanych przez SQL Server w celu wykonania zapytania
set statistics io on

select * from big1

--logical reads 633, physical reads 0 -- 633 strony zostaly orzetworzone w celeu realizacji tego zapytania

--wynik tego zapytania mieœci siê na 1 stronie
select * from big1
where id=100   --logical reads 633

set statistics io off
create nonclustered index idx1 on big1(id)    -- = create  index idx1 on big1(id)
set statistics io on

--wlaczyc execution plan (Ctrl+M)

select * from big1
where id=100     --logical reads 3 (zamiast 633 stront tylko 3 strony zostaly przetworzone - zysk jest znaczacy)

select * from big1

select id from big1 --wszystkie dane zwracana przez to zapytanie sa w indeksie, zatem nie ma koniecznosci odwolania sie
--do sterty/indeksu klastrowego. W naszym przypadku do sterty. Indeks nieklastrowy ma znacznie mniej stron niz sterta
--wiec optymalizator powinien uzyc indeksu
-- logical reads 25, (nie 633), execution plan pokazuje Index Scan (czyli przeczytanie wszystkich stron indeksu)

select * from big1
where id>100 and id < 600

set statistics io off

alter table big1 add nr2 int

declare @i int = 10000
while @i>=0
begin
update big1 set nr2=cast(rand()*1000 as int)
where id=@i
set @i=@i-1
end

select nr2,count(*)
from big1
group by nr2
order by 1

--tworze indeks klastrowy na kolumnie nr2
create clustered index idx2 on big1(nr2) 

set statistics io on

--wlaczyc plan wykonia (Ctrl+M)

select * from big1
--poprzednio w planie bylo full table scan (tabele byla heap - nie miala indeksu klastrowego)
--teraz oczekujemy clustered index scan (pelne sknaowanie naszego indeksu klastrowego)
-- logical reads 560

select * from big1 where id=100
--poprzenio bylo index seek na nieklastrowym oraz RID Lookup na stercie (lokalizacja tego wiersza na odpowiedniej stronie tabeli)
--logical reads 5,

--?? zagadka
select id from big1

select nr2 from big1

alter index idx1 on big1 rebuild

alter index idx2 on big1 rebuild

select nr2 from big1

drop index idx1 on  big1

select nr2 from big1

create nonclustered index idx1 on big1(id)

select nr2 from big1

--w tym indeksie nieklastrowym mamy id posortowane , obok kazdego id jest klucz indeksu klastrowego, 
--czyli wartosc z kolumny nr2







