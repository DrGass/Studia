CREATE TABLE Adres
  (
    id_adresu               INTEGER NOT NULL ,
    ulica                   VARCHAR (30) NOT NULL ,
    miasto                  VARCHAR(30) NOT NULL ,
    kod_ZIP                 INTEGER NOT NULL ,
    "numer_domu" VARCHAR (30)
  ) ;
ALTER TABLE Adres ADD CONSTRAINT Adres_PK PRIMARY KEY ( id_adresu ) ;


CREATE TABLE Firma
  (
    id_firmy        INTEGER NOT NULL ,
    NIP             INTEGER NOT NULL ,
    nr_telefonu     INTEGER ,
    Adres_id_adresu INTEGER 
  ) ;
ALTER TABLE Firma ADD CONSTRAINT Firma_PK PRIMARY KEY ( id_firmy ) ;


CREATE TABLE Klient
  (
    id_klienta     INTEGER NOT NULL ,
    zwierzak       VARCHAR (30) ,
    Osoba_id_osoby INTEGER 
  ) ;
ALTER TABLE Klient ADD CONSTRAINT Klient_PK PRIMARY KEY ( id_klienta ) ;


CREATE TABLE Osoba
  (
    id_osoby INTEGER NOT NULL ,
    imie     VARCHAR (30) NOT NULL ,
    nazwisko VARCHAR (30)  NOT NULL ,
    numer_telefonu VARCHAR(30) NOT NULL ,
    email          VARCHAR(30)
  ) ;
ALTER TABLE Osoba ADD CONSTRAINT Osoba_PK PRIMARY KEY ( id_osoby ) ;


CREATE TABLE Pracownik
  (
    id_pracownika   INTEGER NOT NULL ,
    pozycja         VARCHAR(30) NOT NULL ,
    Sklep_id_sklepu INTEGER ,
    Osoba_id_osoby  INTEGER 
  ) ;
ALTER TABLE Pracownik ADD CONSTRAINT Pracownik_PK PRIMARY KEY ( id_pracownika ) ;


CREATE TABLE Produkt
  (
    id_produktu INTEGER NOT NULL ,
    nazwa       VARCHAR(30) NOT NULL ,
    cena FLOAT(2) NOT NULL
  ) ;
ALTER TABLE Produkt ADD CONSTRAINT Produkt_PK PRIMARY KEY ( id_produktu ) ;


CREATE TABLE Sklep
  (
    id_sklepu     INTEGER NOT NULL ,
    nazwa         VARCHAR(30) NOT NULL ,
    stan_produktu VARCHAR(30)
    --  ERROR: VARCHAR2 size not specified
    NOT NULL ,
    Adres_id_adresu INTEGER ,
    Firma_id_firmy  INTEGER 
  ) ;
ALTER TABLE Sklep ADD CONSTRAINT Sklep_PK PRIMARY KEY ( id_sklepu ) ;


CREATE TABLE Sklep_Produkt
  (
    Sklep_id_sklepu     INTEGER NOT NULL ,
    Produkt_id_produktu INTEGER NOT NULL
  ) ;
ALTER TABLE Sklep_Produkt ADD CONSTRAINT Relation_2_PK PRIMARY KEY ( Sklep_id_sklepu, Produkt_id_produktu ) ;


CREATE TABLE Zam�wienie
  (
    id_zamowienia     INTEGER NOT NULL ,
    Klient_id_klienta INTEGER 
  ) ;
ALTER TABLE Zam�wienie ADD CONSTRAINT Zam�wienie_PK PRIMARY KEY ( id_zamowienia ) ;


CREATE TABLE Zam�wienie_produkt
  (
    Zam�wienie_id_zamowienia INTEGER NOT NULL ,
    Produkt_id_produktu      INTEGER NOT NULL
  ) ;
ALTER TABLE Zam�wienie_produkt ADD CONSTRAINT Relation_1_PK PRIMARY KEY ( Zam�wienie_id_zamowienia, Produkt_id_produktu ) ;

ALTER TABLE Zam�wienie_produkt ADD CONSTRAINT FK_ASS_1 FOREIGN KEY ( Zam�wienie_id_zamowienia ) REFERENCES Zam�wienie ( id_zamowienia ) ;

ALTER TABLE Zam�wienie_produkt ADD CONSTRAINT FK_ASS_2 FOREIGN KEY ( Produkt_id_produktu ) REFERENCES Produkt ( id_produktu ) ;

ALTER TABLE Sklep_Produkt ADD CONSTRAINT FK_ASS_5 FOREIGN KEY ( Sklep_id_sklepu ) REFERENCES Sklep ( id_sklepu ) ;

ALTER TABLE Sklep_Produkt ADD CONSTRAINT FK_ASS_6 FOREIGN KEY ( Produkt_id_produktu ) REFERENCES Produkt ( id_produktu ) ;

ALTER TABLE Firma ADD CONSTRAINT Firma_Adres_FK FOREIGN KEY ( Adres_id_adresu ) REFERENCES Adres ( id_adresu ) ;

ALTER TABLE Klient ADD CONSTRAINT Klient_Osoba_FK FOREIGN KEY ( Osoba_id_osoby ) REFERENCES Osoba ( id_osoby ) ;

ALTER TABLE Pracownik ADD CONSTRAINT Pracownik_Osoba_FK FOREIGN KEY ( Osoba_id_osoby ) REFERENCES Osoba ( id_osoby ) ;

ALTER TABLE Pracownik ADD CONSTRAINT Pracownik_Sklep_FK FOREIGN KEY ( Sklep_id_sklepu ) REFERENCES Sklep ( id_sklepu ) ;

ALTER TABLE Sklep ADD CONSTRAINT Sklep_Adres_FK FOREIGN KEY ( Adres_id_adresu ) REFERENCES Adres ( id_adresu ) ;

ALTER TABLE Sklep ADD CONSTRAINT Sklep_Firma_FK FOREIGN KEY ( Firma_id_firmy ) REFERENCES Firma ( id_firmy ) ;

ALTER TABLE Zam�wienie ADD CONSTRAINT Zam�wienie_Klient_FK FOREIGN KEY ( Klient_id_klienta ) REFERENCES Klient ( id_klienta ) ;