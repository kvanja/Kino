DROP TABLE KORISNICI CASCADE CONSTRAINTS;
DROP TABLE FILMOVI CASCADE CONSTRAINTS;
DROP TABLE RASPORED CASCADE CONSTRAINTS;
DROP TABLE REZERVACIJE CASCADE CONSTRAINTS;

--------------------------------------UNOSENJE TABLICA-----------------------------------
CREATE TABLE KORISNICI(
    ID   number(9)   NOT NULL,
    IME   varchar2(20)   NOT NULL,
    PREZIME   varchar2(20)   NOT NULL,
    EMAIL   varchar2(40)   NOT NULL,
    EMAIL_DOMENA   varchar2(40 CHAR) as (substr(EMAIL,
instr(EMAIL, '@', 1,1)+1)) virtual,
    PASSWORD varchar2(10)   NOT NULL,
    OVLASTI  number(1)   DEFAULT 0 NOT NULL,
    CREATED  TIMESTAMP(6) NOT NULL,
    UPDATED  TIMESTAMP(6) NOT NULL,
    ID_UPD   NUMBER(9) NOT NULL,
    ID_CRE   NUMBER(9)NOT NULL,
    CONSTRAINT check_ime
        CHECK (REGEXP_LIKE(IME, '^[a-zA-Z]+$')),
    CONSTRAINT check_prezime
        CHECK (REGEXP_LIKE(PREZIME, '^[a-zA-Z]+$')),
    CONSTRAINT email_check
        CHECK(email like '%_@__%.__%'),
    CONSTRAINT pk_KORISNICI 
        PRIMARY KEY (ID),
    CONSTRAINT uk_EMAIL
        UNIQUE (EMAIL),
    CONSTRAINT ck_OVLASTI
        CHECK (OVLASTI in(0,1,2)),
    CONSTRAINT fk_ID_UPD
        FOREIGN KEY (ID_UPD)
        REFERENCES KORISNICI(ID)
        ON DELETE CASCADE,
    CONSTRAINT fk_ID_CRE
        FOREIGN KEY (ID_CRE)
        REFERENCES KORISNICI(ID)
        ON DELETE CASCADE
);    
    
comment on table KORISNICI is
'U ovu tablicu unosimo korisnike koji se moraju prijaviti da bi rezervirali ulaznice za odredeni film';
comment on column KORISNICI.ID is
'ID korisnika je primary key u tablici KORISNICI, unosi se preko sequence';
comment on column KORISNICI.IME is
'Ovaj stupac sadrzi ime korisnika, napravljen je check constraint da se mogu unositi samo slova a-zA-Z';
comment on column KORISNICI.PREZIME is
'Ovaj stupac sadrzi prezime korisnika, napravljen je check constraint da se mogu unositi samo slova a-zA-Z';
comment on column KORISNICI.EMAIL is
'Ovaj stupac sadrzi E-mail adresu korisnika, ovaj stupac je unique index';
comment on column KORISNICI.EMAIL_DOMENA is
'Ovaj stupac sadrzi domenu email-a, domena je sam znak @ i sve sto se nalazi poslije njega';
comment on column KORISNICI.PASSWORD is
'Ovaj stupac sadrži password korisnika, password ne može biti duži od 10 slogova.';
comment on column KORISNICI.OVLASTI is
'Ovaj stupac sadrzi ovlasti obicnog korisnika -->0, ovlasti korisnika sa odredenim pravima --->1,te administratora --->2';
comment on column KORISNICI.CREATED is
'Ovaj stupac sadrzi tocan datum i sat kada su kreirani podaci iz tablice KORISNICI';
comment on column KORISNICI.UPDATED is
'Ovaj stupac sadrzi tocan datum i sat kada su podaci iz tablice KORISNICI mijenjani';
comment on column KORISNICI.ID_CRE is 
'Ovaj stupac sadrzi ID korisnika koji je kreirao racun';
comment on column KORISNICI.ID_UPD is
'Ovaj stupac sadrzi ID korisnika koji je napravio izmjene na racunu';

    
    
CREATE TABLE FILMOVI(
    ID   number(9)  NOT NULL,
    NAZIV   varchar2(20)   NOT NULL,
    ZANR   varchar2(20)   NOT NULL,
    TRAJANJE   number(3)   NOT NULL,
    POSTER_LINK  varchar2(500) NOT NULL,
    TRAILER_LINK  varchar2(500) NOT NULL,
    ULOGE       VARCHAR2(500) NOT NULL,
    OPIS        VARCHAR2(2000) NOT NULL, 
    CREATED   TIMESTAMP(8) NOT NULL,
    UPDATED   TIMESTAMP(8)NOT NULL,
    ID_CREATED   NUMBER(9) NOT NULL,
    ID_UPDATED   NUMBER(9)NOT NULL,
    CONSTRAINT pk_FILMOVI 
        PRIMARY KEY(ID),
    CONSTRAINT uk_NAZIV
        UNIQUE (NAZIV),
    CONSTRAINT check_naziv
        CHECK (REGEXP_LIKE(NAZIV, '^[a-zA-Z]+?[a-zA-Z]')),
    CONSTRAINT check_trajanje
        CHECK (TRAJANJE between 90 and 240),
    CONSTRAINT uk_POSTER_LINK
        UNIQUE (POSTER_LINK),
    CONSTRAINT uk_TRAILER_LINK
        UNIQUE (TRAILER_LINK),
    CONSTRAINT fk_ID_CREATED
        FOREIGN KEY (ID_CREATED)
        REFERENCES KORISNICI(ID)
        ON DELETE CASCADE,
    CONSTRAINT fk_ID_UPDATED
        FOREIGN KEY (ID_UPDATED)
        REFERENCES KORISNICI(ID)
        ON DELETE CASCADE
);
    
    
comment on table FILMOVI is
'U ovu tablicu se unose filmovi i svi bitni podaci o filmu';
comment on column FILMOVI.ID is
'Ovaj stupac je primary key, id filma se unosi preko sequence';
comment on column FILMOVI.NAZIV is
'U ovaj stupac se upisuje ime fima na engleskom jeziku, naziv filma je UNIQUE,  napravljen je check constraint da se mogu unositi samo slova a-zA-Z te da to može biti napravljeno više puta';
comment on column FILMOVI.ZANR is
'U ovaj stupac se upisuju svi zanrovi filma';
comment on column FILMOVI.TRAJANJE is
'U ovaj stupac se upisuje vrijeme trajanja filma u minutama, napravljen je check constraint da filmovi mogu trajati izmedu 90minuta(sat i pol) i 240 minuta(4 sata)';
comment on column FILMOVI.POSTER_LINK is
'U ovaj stupac se upisuje link sluzbenog postera filma, link je UNIQUE';
comment on column FILMOVI.TRAILER_LINK is
'U ovaj stupac upisuje se YouTube link sluzbenog trailera filma, link je UNIQUE';
comment on column FILMOVI.CREATED is
'U ovaj stupac upisuje se tocan datum i vrijeme kada su kreirani podaci za odredeni film';
comment on column FILMOVI.UPDATED is
'U ovaj stupac upisuje se tocan datum i vrijeme kada su izmjenjeni podaci za odredeni film';
comment on column FILMOVI.ID_CREATED is
'U ovaj stupac upisuje se id korisnika koji je kreirao podatke,stupac je foreign key na tablicu korisnici, stupac ID';
comment on column FILMOVI.ID_UPDATED is
'U ovaj stupac upisuje se id korisnika koji je mijenjao podatke,stupac je foreign key na tablicu korisnici, stupac ID';


CREATE TABLE RASPORED(
ID         NUMBER(9)   NOT NULL,
ID_FILMA   NUMBER(9)   NOT NULL,
DAT_PRIKAZ DATE NOT NULL,
VRI_PRIKAZ VARCHAR2(5) NOT NULL,
DIMENZIJA     NUMBER(1) DEFAULT 0 NOT NULL,
CIJENA     NUMBER(2) DEFAULT 30 NOT NULL,
CREATED    TIMESTAMP(8) NOT NULL,
UPDATED    TIMESTAMP(8) NOT NULL,
ID_CREA    NUMBER(9)   NOT NULL,
ID_UPDA    NUMBER(9)   NOT NULL,
CONSTRAINT pk_RASPORED
    PRIMARY KEY(ID),
CONSTRAINT fk_ID_FILMA
    FOREIGN KEY (ID_FILMA)
    REFERENCES FILMOVI(ID)
    ON DELETE CASCADE,
CONSTRAINT fk_ID_CREA
    FOREIGN KEY (ID_CREA)
    REFERENCES KORISNICI(ID)
    ON DELETE CASCADE,
CONSTRAINT fk_ID_UPDA
    FOREIGN KEY(ID_UPDA)
    REFERENCES KORISNICI(ID)
    ON DELETE CASCADE,
CONSTRAINT check_2D_3D 
    CHECK (DIMENZIJA in(0,1))
);

comment on table RASPORED is
'Tablica u kojoj se nalazi raspored prikazivanja filmova';
comment on column RASPORED.ID is
'U ovom stupcu ubacuje se ID rasporeda putem sequence, ovaj stupac je primary key';
comment on column RASPORED.ID_FILMA is
'U ovom stupcu upisan je ID filma, stupac je foreign key na tablicu FILMOVI na stupac ID';
comment on column RASPORED.DAT_PRIKAZ is
'U ovom stupcu zapisan je datum prikazivanja filma';
comment on column RASPORED.VRI_PRIKAZ is
'U ovom stupcu zapisano je vrijeme prikazivanja filma';
comment on column RASPORED.DIMENZIJA is
'U ovom stupcu 0 oznacuje 2D projekciju filma, a 1 oznacuje 3D projekciju filma za sto je napravljen check constraint,takoder defaultna vrijednost je 0 (2D prikaz)';
comment on column RASPORED.CIJENA is
'U ovom stupcu je upisana cijena filma, 30 je postavljena kao defaultna vrijednost sto je vrijednost 2D prikazivanja filma';
comment on column RASPORED.CREATED is
'U ovom stupcu upisani je tocan datum i vrijeme  kada su upisani podaci u retku';
comment on column RASPORED.UPDATED is
'U ovom stupcu upisani je tocan datum i vrijeme kada su upisani podaci u retku poslijednji put izmjenjeni';
comment on column RASPORED.ID_CREA is
'U ovom stupcu upisan je ID korisnika koji je upisivao podatke u redak, foreign key na tablicu KORISNICI na stupac ID';
comment on column RASPORED.ID_UPDA is
'U ovom stupcu upisan je ID zadnjeg korisnika koji je mijenjao podatke u retku, foreign key na tablicu KORISNICI na stupac ID';


CREATE TABLE REZERVACIJE
( 
  ID       NUMBER(9)  NOT NULL,
  ID_RASPO NUMBER(9)  NOT NULL,
  REDOVI   NUMBER(2)  NOT NULL,
  SJED_1   NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_2   NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_3   NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_4   NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_5   NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_6   NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_7   NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_8   NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_9   NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_10  NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_11  NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_12  NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_13  NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_14  NUMBER(9) DEFAULT 0 NOT NULL,
  SJED_15  NUMBER(9) DEFAULT 0 NOT NULL,
  CREATED  TIMESTAMP (6)NOT NULL, 
  UPDATED  TIMESTAMP (6)NOT NULL, 
  ID_CREAT NUMBER(4) NOT NULL, 
  ID_UPDAT NUMBER(4) NOT NULL, 
  CONSTRAINT pk_REZERVACIJE
     PRIMARY KEY(ID),
  CONSTRAINT fk_raspored_id
     FOREIGN KEY (ID_RASPO)
  REFERENCES RASPORED(ID)
     ON DELETE CASCADE,
  CONSTRAINT fk_ID_UPDAT
     FOREIGN KEY (ID_UPDAT)
     REFERENCES KORISNICI(ID)
     ON DELETE CASCADE,
  CONSTRAINT fk_id_CREAT
     FOREIGN KEY (ID_CREAT)
     REFERENCES KORISNICI(ID)
     ON DELETE CASCADE,
  CONSTRAINT CHECK_REDOVI
     CHECK (REDOVI in(1,2,3,4,5,6,7,8,9,10))
);
 
 
 comment on table REZERVACIJE is
 'U ovoj tablici spremamo koja mjesta i u kojem retku su korisnici rezervirali za projekcije filma';
 comment on column REZERVACIJE.ID is
 'U ovom stupcu upisan je ID rezervacije, ovaj stupac je primary key';
 comment on column REZERVACIJE.ID_RASPO is
 'U ovom stupcu upisan je ID rasporeda, foreign key na tablicu RASPORED stupac ID';
 comment on column REZERVACIJE.SJED_1 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_2 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_3 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_4 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_5 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_6 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_7 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_8 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_9 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_10 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_11 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_12 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_13 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_14 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.SJED_15 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column REZERVACIJE.CREATED is
'U ovom stupcu upisani je tocan datum i vrijeme  kada su upisani podaci u retku';
comment on column REZERVACIJE.UPDATED is
'U ovom stupcu upisani je tocan datum i vrijeme kada su upisani podaci u retku poslijednji put izmjenjeni';
comment on column REZERVACIJE.ID_CREAT is
'U ovom stupcu upisan je ID korisnika koji je upisivao podatke u redak, foreign key na tablicu KORISNICI na stupac ID';
comment on column REZERVACIJE.ID_UPDAT is
'U ovom stupcu upisan je ID zadnjeg korisnika koji je mijenjao podatke u retku, foreign key na tablicu KORISNICI na stupac ID';

-------------------------------------SEQ--------------------------------------------

DROP SEQUENCE SEQ_FILMOVI_ID;
DROP SEQUENCE SEQ_KORISNICI_ID;
DROP SEQUENCE SEQ_RASPORED_ID;
DROP SEQUENCE SEQ_REZERVACIJE_ID;

CREATE SEQUENCE SEQ_FILMOVI_ID
MINVALUE 1
MAXVALUE  999999999
START WITH 1
INCREMENT BY 1
CACHE 20;

CREATE SEQUENCE SEQ_KORISNICI_ID
MINVALUE 1
MAXVALUE  999999999
START WITH 1
INCREMENT BY 1
CACHE 20;

CREATE SEQUENCE SEQ_RASPORED_ID
MINVALUE 1
MAXVALUE 999999999
START WITH 1
INCREMENT BY 1
CACHE 20;

CREATE SEQUENCE SEQ_REZERVACIJE_ID
MINVALUE 1
MAXVALUE 999999999
START WITH 1
INCREMENT BY 1
CACHE 20;


----------------------------------------TRIGG----------------------------------------

CREATE OR REPLACE TRIGGER TRIG_REZERVACIJE_BI 
BEFORE INSERT ON REZERVACIJE
    FOR EACH ROW
    WHEN(new.ID IS NULL)
BEGIN
  SELECT
    SEQ_REZERVACIJE_ID.nextval
  INTO
    :new.ID
  FROM dual;
  
  SELECT
    SYSTIMESTAMP
  INTO
    :new.CREATED
  FROM dual;
  
  SELECT
    SYSTIMESTAMP
  INTO
    :new.UPDATED
  FROM dual;
  
    SELECT 
     NVL(:NEW.ID_CREAT, 1)
  INTO
     :NEW.ID_CREAT
  FROM DUAL;
  
  SELECT 
     NVL(:NEW.ID_UPDAT, 1)
  INTO
     :NEW.ID_UPDAT
  FROM DUAL;
END TRIG_REZERVACIJE_BI;
/


CREATE OR REPLACE TRIGGER TRIG_REZERVACIJE_BU 
BEFORE UPDATE ON REZERVACIJE 
REFERENCING NEW AS NEWER OLD AS OLDER
FOR EACH ROW
BEGIN
    :NEWER.UPDATED:=SYSTIMESTAMP;
END TRIG_REZERVACIJE_BU ;
/



CREATE OR REPLACE TRIGGER TRIG_FILMOVI_BI 
BEFORE INSERT ON FILMOVI
    FOR EACH ROW
    WHEN(new.ID IS NULL)
BEGIN
  SELECT 
  SEQ_FILMOVI_ID.nextval
  INTO
  :new.ID
  FROM dual;
  
  SELECT
    SYSTIMESTAMP
  INTO
    :new.CREATED
  FROM dual;
  
  SELECT
    SYSTIMESTAMP
  INTO
    :new.UPDATED
  FROM dual;
  
      SELECT 
     NVL(:NEW.ID_CREATED, 1)
  INTO
     :NEW.ID_CREATED
  FROM DUAL;
  
  SELECT 
     NVL(:NEW.ID_UPDATED, 1)
  INTO
     :NEW.ID_UPDATED
  FROM DUAL;
END TRIG_FILMOVI_BI;
/



CREATE OR REPLACE TRIGGER TRIG_FILMOVI_BU 
BEFORE UPDATE ON FILMOVI
REFERENCING NEW AS NEWER OLD AS OLDER
FOR EACH ROW
BEGIN
    :NEWER.UPDATED:=SYSTIMESTAMP;
END TRIG_FILMOVI_BU;
/

CREATE OR REPLACE TRIGGER TRIG_RASPORED_BI 
BEFORE INSERT ON RASPORED
FOR EACH ROW
WHEN(new.ID IS NULL)
BEGIN
    SELECT
        SEQ_RASPORED_ID.nextval
    INTO
        :new.ID
    FROM dual;
    
    SELECT
        SYSTIMESTAMP
    INTO
        :new.CREATED
    FROM dual;
    
    SELECT 
        SYSTIMESTAMP
    INTO
        :new.UPDATED
    FROM dual;
    
        SELECT 
     NVL(:NEW.ID_CREA, 1)
  INTO
     :NEW.ID_CREA
  FROM DUAL;
  
  SELECT 
     NVL(:NEW.ID_UPDA, 1)
  INTO
     :NEW.ID_UPDA
  FROM DUAL;
END TRIG_RASPORED_BI;
/
create or replace TRIGGER TRIG_RASPORED_BU 
BEFORE UPDATE ON RASPORED 
REFERENCING NEW AS NEWER OLD AS OLDER
FOR EACH ROW
BEGIN
    :NEWER.UPDATED:=SYSTIMESTAMP;
END;
/


CREATE OR REPLACE TRIGGER TRIG_KORISNICI_BI 
BEFORE INSERT ON KORISNICI 
FOR EACH ROW
WHEN(new.ID IS NULL)
BEGIN
    SELECT
        SEQ_KORISNICI_ID.nextval
    INTO
        :new.ID
    FROM dual;
    
    SELECT
        SYSTIMESTAMP
    INTO
        :new.CREATED
    FROM dual;
    
    SELECT
        SYSTIMESTAMP
    INTO
        :new.UPDATED
    FROM dual;
    
        SELECT 
     NVL(:NEW.ID_CRE, 1)
  INTO
     :NEW.ID_CRE
  FROM DUAL;
  
  SELECT 
     NVL(:NEW.ID_UPD, 1)
  INTO
     :NEW.ID_UPD
  FROM DUAL;
END TRIG_KORISNICI_BI;
/
CREATE OR REPLACE TRIGGER TRIG_KORISNICI_BU 
BEFORE UPDATE ON KORISNICI
REFERENCING NEW AS NEWER OLD AS OLDER
FOR EACH ROW
BEGIN
    :NEWER.UPDATED:=SYSTIMESTAMP;
END TRIG_KORISNICI_BU;
/

create or replace TRIGGER TRIG_REZERVACIJE_BI 
BEFORE INSERT ON REZERVACIJE
    FOR EACH ROW
    WHEN(new.ID IS NULL)
BEGIN
  SELECT
    SEQ_REZERVACIJE_ID.nextval
  INTO
    :new.ID
  FROM dual;

  SELECT
    SYSTIMESTAMP
  INTO
    :new.CREATED
  FROM dual;

  SELECT
    SYSTIMESTAMP
  INTO
    :new.UPDATED
  FROM dual;
  
      SELECT 
     NVL(:NEW.ID_CREAT, 1)
  INTO
     :NEW.ID_CREAT
  FROM DUAL;
  
  SELECT 
     NVL(:NEW.ID_UPDAT, 1)
  INTO
     :NEW.ID_UPDAT
  FROM DUAL;
END TRIG_REZERVACIJE_BI;
/

create or replace TRIGGER TRIG_REZERVACIJE_BU 
BEFORE UPDATE ON REZERVACIJE 
REFERENCING NEW AS NEWER OLD AS OLDER
FOR EACH ROW
BEGIN
    :NEWER.UPDATED:=SYSTIMESTAMP;
END TRIG_REZERVACIJE_BU ;
/

------------------------------------------INSERT---------------------------------------

SELECT * FROM KORISNICI;

insert into KORISNICI (IME,PREZIME,EMAIL,PASSWORD,OVLASTI) values ('DEV','USER','dev.user@vub.hr',1122,2);    
insert into KORISNICI (IME,PREZIME,EMAIL,PASSWORD) values ('Robert','Kovacevic','robi.kova@gmail.com',2341);
insert into KORISNICI (IME,PREZIME,EMAIL,PASSWORD) values ('Josipa','RajkoviC','josipa.rajkovic@gmail.com',2852);
insert into KORISNICI (IME,PREZIME,EMAIL,PASSWORD) values ('Iva','Maric','iva.maric@gmail.com',9041);
insert into KORISNICI (IME,PREZIME,EMAIL,PASSWORD) values ('Iva','Maric','iva.maricad@gmail.com',9041);

SELECT * FROM FILMOVI;
INSERT INTO FILMOVI(NAZIV,ZANR,TRAJANJE,POSTER_LINK,TRAILER_LINK,ULOGE,OPIS) VALUES ('Aquaman','Sci-Fi',100,'https://contentserver.com.au/assets/652795_aquaman_v8.jpg','"https://www.youtube.com/embed/WDkg3h8PCVU"',' Uloge: Jason Momoa,Amber Heard, Patrick Wilson, Nicole Kidman,Dolph Lundgreen, Willem Dafoe','Prièa o mladom Arthur Curry koji doznaje da je nasljednik trona podvodnog kraljevstva Atlantide u koje se mora vratiti i spasiti svoj narod. Uz Jasona Momou u ulozi kralja mora, u filmu se pojavljuje još veliki broj fantastiènih glumaca – Ocean Mastera glumi Patrick Wilson, Amber Heard glumi kraljicu mora Meru, a Willem Dafoe je Aquamanov saveznik, Vulko.');
INSERT INTO FILMOVI(NAZIV,ZANR,TRAJANJE,POSTER_LINK,TRAILER_LINK,ULOGE,OPIS) VALUES ('Iron Man','Sci-Fi',200,'http://www.movienewsletters.net/photos/277216R1.jpg','"https://www.youtube.com/embed/8hYlB38asDY"','blabla','blabla');
INSERT INTO FILMOVI(NAZIV,ZANR,TRAJANJE,POSTER_LINK,TRAILER_LINK,ULOGE,OPIS) VALUES ('Captain Marvel','Sci-Fi',150,'http://t1.gstatic.com/images?q=tbn:ANd9GcQ1bDkDLq-_bteASakhnC1XYwlkErFuqcof7KMhFpRwVhCTh1Vo','"https://www.youtube.com/embed/Z1BCujX3pw8"','blabla','blabla');
INSERT INTO FILMOVI(NAZIV,ZANR,TRAJANJE,POSTER_LINK,TRAILER_LINK,ULOGE,OPIS) VALUES ('Avengers Endgame','Sci-Fi',210,'http://t3.gstatic.com/images?q=tbn:ANd9GcT7lbt-11YvVHCYw55oDCcOxXeKF6VaPOrf9rRFINXaq3WWsbo6','"https://www.youtube.com/embed/-iFq6IcAxBc"','blabla','blabla');


SELECT * FROM RASPORED;

/*          UNOS 2D FILMA       */
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ) 
VALUES(3,to_date('25.02.2019', 'DD.MM.YYYY'),'18:30');
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ) 
VALUES(2,to_date('26.02.2019', 'DD.MM.YYYY'),'18:00');
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ) 
VALUES(2,to_date('27.02.2019', 'DD.MM.YYYY'),'18:00');
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ) 
VALUES(2,to_date('28.02.2019', 'DD.MM.YYYY'),'20:00');


/*          UNOS 3D FILMA       */


INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ,DIMENZIJA,CIJENA) 
VALUES(3,to_date('01.03.2019', 'DD.MM.YYYY'),'20:00',1,35);
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ,DIMENZIJA,CIJENA) 
VALUES(3,to_date('02.03.2019', 'DD.MM.YYYY'),'20:00',1,35);
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ,DIMENZIJA,CIJENA) 
VALUES(4,to_date('03.03.2019', 'DD.MM.YYYY'),'18:00',1,35);

SELECT * FROM REZERVACIJE;

insert into REZERVACIJE
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,1,1,0,1,0,1,1,1,0,1,0,1,0,0,0,1);
insert into REZERVACIJE
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,2,0,1,0,1,0,0,0,1,0,1,0,1,1,1,0);
insert into REZERVACIJE
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,3,1,0,1,0,1,1,1,0,1,0,1,0,0,0,1);
insert into REZERVACIJE
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,4,1,0,1,0,1,1,1,0,1,0,1,0,0,0,1);
insert into REZERVACIJE
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,5,0,0,0,1,0,1,0,0,1,1,1,0,1,0,1);
insert into REZERVACIJE
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,6,1,0,1,0,1,1,1,0,1,0,1,0,0,0,1);
insert into REZERVACIJE
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,7,1,0,1,0,1,1,1,0,1,0,1,0,0,0,1);
insert into REZERVACIJE
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,8,1,0,1,0,1,1,1,0,1,0,1,0,0,0,1);
insert into REZERVACIJE
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,9,1,0,1,0,1,1,1,0,1,0,1,0,0,0,1);
insert into REZERVACIJE
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);



CREATE INDEX ix_REZERVACIJE on REZERVACIJE
    (ID_UPDAT,ID_CREAT,ID_RASPO,REDOVI,SJED_7,SJED_8,SJED_5,SJED_6,SJED_9,SJED_10,SJED_4,SJED_3,SJED_11,SJED_12,SJED_2,SJED_1,SJED_13,SJED_14,SJED_15);

/*      PRETRAZIVANJE PUTEM INDEXA ix_REZERVACIJE       */

SELECT * FROM 
    REZERVACIJE
WHERE
ID_RASPO=1 and
REDOVI= 10;

-----------------------------------PAKETI---------------------------------------------------------------------

create or replace PACKAGE P_REZERVACIJE AS 
 e_iznimka exception;
  pragma exception_init(e_iznimka, -8888);

FUNCTION F_CHECK_EMAIL(i_email in varchar2,
                                          o_error_c out number,
                                          o_error_m out varchar2
   )RETURN BOOLEAN;

FUNCTION F_CHECK_ADMIN(i_email in varchar2,
                                          o_error_c out number,
                                          o_error_m out varchar2
)RETURN BOOLEAN;


PROCEDURE P_UNOS_KOR(i_ime in korisnici.ime%type,
                                                i_prezime in korisnici.prezime%type,
                                                i_email in korisnici.email%type,
                                                i_passw in korisnici.password%type,
                                                o_id_koris out korisnici.id%type,
                                                o_error_c out number,
                                                o_error_m out varchar2);                                                        

PROCEDURE P_UNOS_FILMOVA(i_naziv in FILMOVI.NAZIV%type,
                                                      i_zanr in FILMOVI.ZANR%type,
                                                      i_trajanje in FILMOVI.TRAJANJE%type,
                                                      i_poster_link in FILMOVI.POSTER_LINK%type,
                                                      i_trailer_link in FILMOVI.TRAILER_LINK%type,
                                                      o_id_filma out number,
                                                      o_error_c out number,
                                                      o_error_m out varchar2);


PROCEDURE P_UNOS_RASPOREDA(i_id_filma in RASPORED.ID_FILMA%type,
                                                               i_dat_prikaz in RASPORED.DAT_PRIKAZ%type,
                                                               i_vri_prikaz in RASPORED.VRI_PRIKAZ%type,
                                                               i_2D3D in RASPORED.DIMENZIJA%type,
                                                               o_error_c out number,
                                                               o_error_m out varchar);

PROCEDURE P_UNOS_DVORANE(i_id_raspo in REZERVACIJE.ID_RASPO%type,
                                                                o_error_c out number,
                                                                o_error_m out varchar2);
PROCEDURE P_UPDATE_KOR(i_email in KORISNICI.EMAIL%type,
                                                      i_old_email in KORISNICI.EMAIL%type,
                                                      i_ime in korisnici.ime%type,
                                                      i_prezime in korisnici.prezime%type,
                                                      i_novi_email in korisnici.email%type,
                                                      i_passw in korisnici.password%type,
                                                      o_error_c out number,
                                                      o_error_m out varchar2);

PROCEDURE P_UPDATE_FILMOVA(i_email in KORISNICI.EMAIL%type,
                                                          i_old_naziv_filma in FILMOVI.NAZIV%type,
                                                          i_naziv_filma in FILMOVI.NAZIV%type,
                                                          i_zanr in FILMOVI.ZANR%type,
                                                          i_trajanje in FILMOVI.TRAJANJE%type,
                                                          i_poster_link in FILMOVI.POSTER_LINK%type,
                                                          i_trailer_link in FILMOVI.TRAILER_LINK%type,
                                                          o_error_c out number,
                                                          o_error_m out varchar2);

PROCEDURE P_UPDATE_RASPOREDA(i_email in KORISNICI.EMAIL%type,
                                                            i_id_raspo RASPORED.ID%type,
                                                            i_novi_id_filma in RASPORED.ID_FILMA%type,
                                                            i_novi_dat_prikaz in RASPORED.DAT_PRIKAZ%type,
                                                            i_novo_vri_prikaz in RASPORED.VRI_PRIKAZ%type,
                                                            i_novi_2D3D in RASPORED.DIMENZIJA%type,
                                                            o_error_c out number,
                                                            o_error_m out varchar2);

PROCEDURE P_UPDATE_REZERVACIJE(i_email in KORISNICI.EMAIL%type,
                                                            i_red in REZERVACIJE.REDOVI%type,
                                                            i_sjed in number,
                                                            i_id_raspo in REZERVACIJE.ID_RASPO%type,
                                                            o_error_c out number,
                                                            o_error_m out varchar2);

PROCEDURE P_BRISANJE_KOR(i_ovlasteni_email in KORISNICI.EMAIL%type,
                                                                  i_email in KORISNICI.EMAIL%type,
                                                                  o_error_c out number,
                                                                  o_error_m out varchar2,
                                                                  o_rezultat out varchar2);

PROCEDURE P_BRISANJE_FILMOVA(i_ovlasteni_email in KORISNICI.EMAIL%type,
                                                                     i_naziv_filma in FILMOVI.NAZIV%type,
                                                                     o_error_c out number,
                                                                     o_error_m out varchar2,
                                                                     o_rezultat out varchar2);

PROCEDURE P_BRISANJE_RASPOREDA(i_ovlasteni_email in KORISNICI.EMAIL%type,
                                                                        i_id in RASPORED.ID%type,
                                                                        o_error_c out number,
                                                                        o_error_m out varchar2,
                                                                        o_rezultat out varchar2);

PROCEDURE P_BRISANJE_DVORANE(i_ovlasteni_email in KORISNICI.EMAIL%type,
                                                                      i_id_raspo in REZERVACIJE.ID_RASPO%type,
                                                                      o_error_c out number,
                                                                      o_error_m out varchar2,
                                                                      o_rezultat out varchar2);

PROCEDURE P_DOHVATI_KOR(o_rezultat out SYS_REFCURSOR,
                                                    o_error_c out number,
                                                    o_error_m out varchar2);
                                                    
PROCEDURE P_DOHVATI_FILMOVE(o_rezultat out SYS_REFCURSOR,
                                                    o_error_c out number,
                                                    o_error_m out varchar2);
                                                    
PROCEDURE P_DOHVATI_RASPORED(o_rezultat out SYS_REFCURSOR,
                                                    o_error_c out number,
                                                    o_error_m out varchar2);
                                                    
PROCEDURE P_DOHVATI_REZERVACIJE(o_rezultat out SYS_REFCURSOR,
                                                    o_error_c out number,
                                                    o_error_m out varchar2);
PROCEDURE P_DOHVATI_REZERVACIJU(i_id_raspo in REZERVACIJE.ID_RASPO%type,
                                                    o_rezultat out SYS_REFCURSOR,
                                                    o_error_c out number,
                                                    o_error_m out varchar2);
                                                    
PROCEDURE P_UPDATE_REZERVACIJE2(i_email in KORISNICI.EMAIL%type,
                                                            i_passw in KORISNICI.PASSWORD%type,
                                                            i_red in REZERVACIJE.REDOVI%type,
                                                            i_sjed in number,
                                                            i_id_raspo in REZERVACIJE.ID_RASPO%type,
                                                            o_error_c out number,
                                                            o_error_m out varchar2);

PROCEDURE P_DOHVATI_TJEDNI_RASPORED(o_rezultat out SYS_REFCURSOR,
                                                                o_error_c out number,
                                                                o_error_m out varchar2);
END P_REZERVACIJE;
/
create or replace PACKAGE BODY P_REZERVACIJE AS
--------------------------------------------------------------------------------------------------------
FUNCTION F_CHECK_EMAIL(i_email in varchar2,
                                          o_error_c out number,
                                          o_error_m out varchar2
)RETURN BOOLEAN AS
  BEGIN
     o_error_c:=0;
     o_error_m:=' ';
    if regexp_like(i_email, '^[[:alnum:]]+@[[:alnum:]]+(\.[[:alnum:]]+)+$') then
         return true;
      else
         return false;
      end if;
EXCEPTION
   WHEN OTHERS THEN
       o_error_c:=510;
       o_error_m:=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
       RETURN FALSE;
  END F_CHECK_EMAIL;
----------------------------------------CHECK_ADMIN_FUNKCIJA-------------------------------------------
FUNCTION F_CHECK_ADMIN(i_email in varchar2,
                                          o_error_c out number,
                                          o_error_m out varchar2
)RETURN BOOLEAN AS
l_email KORISNICI.EMAIL%type;
l_ovlasti KORISNICI.OVLASTI%type;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';
BEGIN
SELECT
   EMAIL,
   OVLASTI
INTO 
   l_email,
   l_ovlasti
FROM
   KORISNICI
WHERE
   EMAIL=i_email;
EXCEPTION
   WHEN OTHERS THEN
      l_email :=' ';
END;

   IF(l_email=l_email) and
     (l_ovlasti=2) OR
     (l_ovlasti=1) THEN
      RETURN TRUE;
         ELSE
         RETURN FALSE;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      o_error_c :=511;
      o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
      RETURN FALSE;
END F_CHECK_ADMIN;

--------------------------------------------------------------------------------------------
 PROCEDURE P_UNOS_KOR(i_ime in korisnici.ime%type,
                                                 i_prezime in korisnici.prezime%type,
                                                 i_email in korisnici.email%type,
                                                 i_passw in korisnici.password%type,
                                                 o_id_koris out korisnici.id%type,
                                                 o_error_c out number,
                                                 o_error_m out varchar2) AS
l_email KORISNICI.EMAIL%type;
  BEGIN
     o_error_c:=0;
     o_error_m:=' ';
	IF NVL(I_IME, ' ') = ' ' THEN
	   o_error_c := 1;
	   o_error_m := 'Molimo unesite ime korisnika.';
	   RAISE e_iznimka; 
	END IF;

    IF NVL(I_PREZIME, ' ') = ' ' THEN
	   o_error_c := 2;
	   o_error_m := 'Molimo unesite prezime korisnika.';
	   RAISE e_iznimka; 
	END IF;

    IF NVL(I_EMAIL, ' ') = ' ' THEN
       o_error_c := 3;
	   o_error_m := 'Molimo unesite E-mail korisnika.';
	   RAISE e_iznimka;
    END IF;
       IF (F_CHECK_EMAIL(i_email,o_error_c,o_error_m)=FALSE) THEN
          o_error_c :=4;
          o_error_m := 'Krivi format Email adrese.';
          RAISE e_iznimka;
    END IF;

      IF NVL(I_PASSW, ' ') = ' ' THEN
	   o_error_c := 5;
	   o_error_m:= 'Molimo unesite password korisnika.';
	   RAISE e_iznimka; 
	END IF;
BEGIN
   SELECT
      EMAIL
   INTO 
      l_email
   FROM 
      KORISNICI
   WHERE
      EMAIL=i_email;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_email :=' ';
END;

    IF (l_email=' ') THEN    
       INSERT INTO KORISNICI(IME,PREZIME,EMAIL,PASSWORD) 
                      VALUES(i_ime,i_prezime,i_email,i_passw);
    ELSE
       IF (l_email!=' ') THEN
           o_error_c :=6;
           o_error_m :='Email se ve? koristi, molimo unesite drugi email.';
           RAISE e_iznimka;
       END IF;
   END IF;

    SELECT
       ID
    INTO
       o_id_koris
    FROM
       KORISNICI
    WHERE
       EMAIL=i_email;
EXCEPTION
   WHEN e_iznimka THEN 
      NULL;
   WHEN OTHERS THEN
      o_error_c :=100;
      o_error_m := ('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
  END P_UNOS_KOR;
---------------------------------------------------------------------------------------------------  
PROCEDURE P_UNOS_FILMOVA(i_naziv in FILMOVI.NAZIV%type,
                                                      i_zanr in FILMOVI.ZANR%type,
                                                      i_trajanje in FILMOVI.TRAJANJE%type,
                                                      i_poster_link in FILMOVI.POSTER_LINK%type,
                                                      i_trailer_link in FILMOVI.TRAILER_LINK%type,
                                                      o_id_filma out number,
                                                      o_error_c out number,
                                                      o_error_m out varchar2)AS
l_naziv_filma FILMOVI.NAZIV%type;
l_trailer_link FILMOVI.TRAILER_LINK%type;
l_poster_link FILMOVI.POSTER_LINK%type;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';

   IF (NVL(i_naziv,' ')=' ') THEN
      o_error_c :=7;
      o_error_m :='Molimo unesite naziv filma';
      RAISE e_iznimka;
   END IF;

   IF (NVL(i_zanr, ' ')= ' ') THEN
      o_error_c :=8;
      o_error_m :='Molimo unesite žanr filma';
      RAISE e_iznimka;
   END IF;

   IF (NVL(i_trajanje,0)=0) THEN
      o_error_c :=9;
      o_error_m :='Molimo unesite trajanje filma u minutama';
      RAISE e_iznimka; 
   ELSE
    IF (i_trajanje<90) AND
       (i_trajanje>240)THEN
       o_error_c :=10;
       o_error_m := 'Unesite vrijeme trajanja filma izmedu 90 i 240 minuta';
       RAISE e_iznimka;
       END IF;
    END IF;   
   IF (NVL(i_poster_link,' ')=' ') THEN
      o_error_c :=11;
      o_error_m := 'Molimo unesite link postera filma';
      RAISE e_iznimka;
   END IF;

   IF (NVL(i_trailer_link,' ')=' ') THEN
      o_error_c :=12;
      o_error_m := 'Molimo unesite link službenog trailera filma';
      RAISE e_iznimka;
   END IF;
BEGIN
   SELECT
      NAZIV,
      POSTER_LINK,
      TRAILER_LINK
   INTO
      l_naziv_filma,
      l_poster_link,
      l_trailer_link
   FROM
      FILMOVI
   WHERE
      NAZIV=i_naziv OR
      POSTER_LINK=i_poster_link OR
      TRAILER_LINK=i_trailer_link;
   EXCEPTION
      WHEN OTHERS THEN
         l_naziv_filma :=0;
         l_poster_link :=' ';
         l_trailer_link :=' ';
END;
   IF(l_naziv_filma=i_naziv) THEN
      o_error_c :=13;
      o_error_m := 'Molimo unesite naziv filma koji ne postoji.';
      RAISE e_iznimka;
   END IF;
   
   IF(l_poster_link=i_poster_link) THEN
      o_error_c :=14;
      o_error_m :='Molimo unesite link postera koji se ne koristi.';
      RAISE e_iznimka;
   END IF;
   
   IF(l_trailer_link=i_trailer_link) THEN
      o_error_c :=15;
      o_error_m :='Molimo unesite link trailera koji se ne koristi.';
      RAISE e_iznimka;
   END IF;
      IF(l_naziv_filma=0) AND
        (l_trailer_link=' ') AND
        (l_poster_link=' ')THEN
    INSERT INTO FILMOVI(NAZIV,ZANR,TRAJANJE,POSTER_LINK,TRAILER_LINK,ID_CREATED,ID_UPDATED)
                values(i_naziv,i_zanr,i_trajanje,i_poster_link,i_trailer_link,1,1);
   END IF;
    SELECT
       ID
    INTO
       o_id_filma
    FROM
       FILMOVI
    WHERE 
       POSTER_LINK=i_poster_link;
    EXCEPTION
       WHEN e_iznimka THEN
       NULL;
    WHEN OTHERS THEN
    o_error_c :=101;
    o_error_m := ('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_UNOS_FILMOVA;
--------------------------------------------------------------------------------------------------
PROCEDURE P_UNOS_RASPOREDA(i_id_filma in RASPORED.ID_FILMA%type,
                                                               i_dat_prikaz in RASPORED.DAT_PRIKAZ%type,
                                                               i_vri_prikaz in RASPORED.VRI_PRIKAZ%type,
                                                               i_2D3D in RASPORED.DIMENZIJA%type,
                                                               o_error_c out number,
                                                               o_error_m out varchar) AS
l_filmovi_id FILMOVI.ID%type;
l_dat_prikaz RASPORED.DAT_PRIKAZ%type;
l_vri_prikaz RASPORED.VRI_PRIKAZ%type;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';
   IF NVL(i_id_filma,0)= 0 THEN
      o_error_c :=16;
      o_error_m := 'Molimo unesite ID filma';
      RAISE e_iznimka;
   END IF;

   IF (i_2D3D not in(0,1))THEN 
      o_error_c:=17;
      o_error_m:='Molimo unesite vrijednost 0 za 2D ili 1 3D film';
      RAISE e_iznimka;
   END IF;

  IF NVL(i_dat_prikaz,'01.01.0001')='01.01.0001' THEN
     o_error_c :=18;
     o_error_m :='Molimo unesite datum prikaz';
     RAISE e_iznimka;
   END IF;

   IF NVL(i_vri_prikaz,' ')= ' ' THEN
      o_error_c :=19;
      o_error_m := 'Molimo unesite vrijeme prikazivanja';
      RAISE e_iznimka;
   END IF;
BEGIN
   SELECT
      ID
   INTO
      l_filmovi_id
   FROM
      FILMOVI
   WHERE
      ID=i_id_filma;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_filmovi_id :=0;
END;
BEGIN
   SELECT
      DAT_PRIKAZ,
      VRI_PRIKAZ
   INTO
      l_dat_prikaz,
      l_vri_prikaz
   FROM
      RASPORED
   WHERE
      DAT_PRIKAZ=i_dat_prikaz;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_dat_prikaz :='01.01.0001';
         l_vri_prikaz :=' ';
END;
 
   IF (l_dat_prikaz=i_dat_prikaz) AND
      (l_vri_prikaz=i_vri_prikaz) THEN
       o_error_c:=20;
       o_error_m :='Datum i vrijeme pokazivanja ve? postoje, molimo unesite drugi datum ili vrijeme projekcije 2 sata kasnije od unešene.';
       RAISE e_iznimka;
   END IF;
   
   IF (l_filmovi_id=0) THEN
      o_error_c :=21;
      o_error_m := 'Molimo unesite ispravan ID filma';
     RAISE e_iznimka;
  END IF;  

   IF (i_2D3D=0) AND
      (l_filmovi_id=i_id_filma)THEN
      INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ)
                  VALUES(i_id_filma,i_dat_prikaz,i_vri_prikaz);
    ELSE  
      IF (i_2D3D=1) AND
         (l_filmovi_id=i_id_filma)THEN
          INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ,DIMENZIJA,CIJENA)
                      VALUES(i_id_filma,i_dat_prikaz,i_vri_prikaz,i_2D3D,35);
   END IF;
END IF;

EXCEPTION
   WHEN e_iznimka THEN
   NULL;
   WHEN OTHERS THEN
      o_error_c :=102;
      o_error_m := ('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_UNOS_RASPOREDA;
-------------------------------------------------------------------------------------------------------
PROCEDURE P_UNOS_DVORANE(i_id_raspo in REZERVACIJE.ID_RASPO%type,
                                                                o_error_c out number,
                                                                o_error_m out varchar2)AS

l_counter number;
l_red number;
l_raspored_id RASPORED.ID%type;
l_id_raspo REZERVACIJE.ID_RASPO%type;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';

   IF NVL(i_id_raspo,0)=0 THEN
       o_error_c :=22;
       o_error_m :='Raspored sa ID-em 0 ne postoji, molimo unesite ispravan ID rasporeda';
       RAISE e_iznimka;
   END IF;
----------------------POSTOJI LI ID RASPOREDA U TABLICI RASPORED-------------------------------
BEGIN
SELECT
   ID
INTO
   l_raspored_id
FROM
   RASPORED
WHERE
   ID=i_id_raspo;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
   l_raspored_id :=0;
END;

   IF (l_raspored_id=0) THEN
      o_error_c :=23;
      o_error_m :='Raspored ne postoji';
      RAISE e_iznimka;
   END IF;
---------------------POSTOJI LI RASPORED_ID U TABLICI REZERVACIJE, AKO NE MOZE SE UNJETI DVORANA, AKO DA NE MOŽE-------------------
BEGIN
   SELECT
      ID_RASPO
   INTO
      l_id_raspo
   FROM
      REZERVACIJE
   WHERE
      ID_RASPO=i_id_raspo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
      l_id_raspo :=0;
      WHEN OTHERS THEN
         o_error_c:=24;
         o_error_m:='Dvorana je ve? unesena';
         RAISE e_iznimka;
END;

    IF(l_id_raspo=0) THEN
       l_counter :=0;
       l_red :=0;
          WHILE l_counter < 10 LOOP
          l_red:=l_red+1;
          INSERT INTO REZERVACIJE(ID_RASPO,REDOVI)
                      VALUES(i_id_raspo,l_red);
          l_counter :=l_counter+1;
    END LOOP;
    END IF;
COMMIT;
EXCEPTION
   WHEN e_iznimka THEN
   NULL;
   WHEN OTHERS THEN
      o_error_c :=103;
      o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_UNOS_DVORANE;
-------------------------------UPDATE KORISNIKA--------------------------------
PROCEDURE P_UPDATE_KOR(i_email in KORISNICI.EMAIL%type,                                 
                                                      i_old_email in KORISNICI.EMAIL%type,
                                                      i_ime in korisnici.ime%type,
                                                      i_prezime in korisnici.prezime%type,
                                                      i_novi_email in korisnici.email%type,
                                                      i_passw in korisnici.password%type,
                                                      o_error_c out number,
                                                      o_error_m out varchar2)AS
l_old_email KORISNICI.EMAIL%type;
BEGIN
   IF NVL(i_ime,' ')=' ' THEN
      o_error_c :=25;
      o_error_m :='Molimo unesite svoje novo ime ili staro ukoliko ga niste mijenjali.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_prezime,' ')=' ' THEN
      o_error_c :=26;
      o_error_m :='Molimo unesite svoje novo prezime ili staro ukoliko ga niste mijenjali.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_passw,' ')=' ' THEN
      o_error_c :=27;
      o_error_m :='Molimo unesite neki drugi password, ili password koji ste do sada koristili ukoliko ga ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;
BEGIN
   SELECT
      EMAIL
   INTO
      l_old_email
   FROM 
      KORISNICI
   WHERE
      EMAIL=i_old_email;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_old_email :=' ';
END;
     IF (l_old_email=' ') THEN
        o_error_c :=28;
        o_error_m :='Ne postoji uneseni email.';
        RAISE e_iznimka;
END IF;
IF(l_old_email!=' ') and 
  (F_CHECK_ADMIN(i_email,o_error_c,o_error_m))THEN 
     UPDATE KORISNICI
     SET IME=i_ime,
         PREZIME=i_prezime,
         EMAIL=i_novi_email,
         PASSWORD=i_passw
     WHERE EMAIL=l_old_email;
ELSE
   o_error_c:=29;
   o_error_m:='Access denied!';
   RAISE e_iznimka;
END IF;
COMMIT;
EXCEPTION
   WHEN e_iznimka THEN
   null;
      WHEN OTHERS THEN
      o_error_c :=104;
      o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_UPDATE_KOR;

PROCEDURE P_UPDATE_FILMOVA(i_email in KORISNICI.EMAIL%type,
                                                            i_old_naziv_filma in FILMOVI.NAZIV%type,
                                                            i_naziv_filma in FILMOVI.NAZIV%type,
                                                            i_zanr in FILMOVI.ZANR%type,
                                                            i_trajanje in FILMOVI.TRAJANJE%type,
                                                            i_poster_link in FILMOVI.POSTER_LINK%type,
                                                            i_trailer_link in FILMOVI.TRAILER_LINK%type,
                                                            o_error_c out number,
                                                            o_error_m out varchar2)AS
l_old_naziv varchar2(20);
l_email KORISNICI.EMAIL%type;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';

   IF (NVL(i_naziv_filma,' ')=' ') THEN
      o_error_c :=30;
      o_error_m :='Molimo unesite novi naziv filma ili stari ukoliko ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;

   IF (NVL(i_zanr, ' ')= ' ') THEN
      o_error_c :=31;
      o_error_m :='Molimo unesite novi žanr filma ili stari ukoliko ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;

   IF (NVL(i_trajanje,0)=0) THEN
      o_error_c :=32;
      o_error_m :='Molimo unesite novo trajanje filma u minutama ili staro ukoliko ne želite promijeniti.';
      RAISE e_iznimka; 
   END IF;
    IF (i_trajanje<90) AND
       (i_trajanje>240)THEN
       o_error_c :=33;
       o_error_m := 'Unesite vrijeme trajanja filma izmedu 90 i 240 minuta';
       RAISE e_iznimka;
   END IF;  
   IF (NVL(i_poster_link,' ')=' ') THEN
      o_error_c :=34;
      o_error_m := 'Molimo unesite novi link postera filma ili stari ukoliko ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;

   IF (NVL(i_trailer_link,' ')=' ') THEN
      o_error_c :=35;
      o_error_m := 'Molimo unesite novi link službenog trailera filma ili stari ukoliko ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;
BEGIN   
SELECT
   NAZIV
INTO
   l_old_naziv
FROM
   FILMOVI
WHERE
   NAZIV=i_old_naziv_filma;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_old_naziv :=' ';
END;
BEGIN
   SELECT
      EMAIL
   INTO
      l_email
   FROM 
      KORISNICI
   WHERE
      EMAIL=i_email;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_email :=' ';
END;
     IF (l_email=' ') THEN
        o_error_c :=36;
        o_error_m :='Ne postoji uneseni email.';
        RAISE e_iznimka;
END IF;



    IF (l_old_naziv=' ') THEN
       o_error_c :=37;
       o_error_m :='Molimo unesite film koji postoji';
       RAISE e_iznimka;
    END IF;
       IF(l_old_naziv !=' ') AND
     (F_CHECK_ADMIN(i_email,o_error_c,o_error_m))THEN
          UPDATE FILMOVI SET NAZIV=i_naziv_filma,
                             ZANR=i_zanr,
                             TRAJANJE=i_trajanje,
                             POSTER_LINK=i_poster_link,
                             TRAILER_LINK=i_trailer_link
          WHERE NAZIV=l_old_naziv;
      ELSE
         o_error_c:=38;
         o_error_m:='Access denied!';
         RAISE  e_iznimka;
END IF;
COMMIT;
EXCEPTION
   WHEN e_iznimka THEN
   null;
   WHEN OTHERS THEN
      o_error_c :=105;
      o_error_m := ('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_UPDATE_FILMOVA; 

------------------------------------UPDATE RASPOREDA-----------------------------------------------------
PROCEDURE P_UPDATE_RASPOREDA(i_email in KORISNICI.EMAIL%type,
                                                            i_id_raspo RASPORED.ID%type,
                                                            i_novi_id_filma in RASPORED.ID_FILMA%type,
                                                            i_novi_dat_prikaz in RASPORED.DAT_PRIKAZ%type,
                                                            i_novo_vri_prikaz in RASPORED.VRI_PRIKAZ%type,
                                                            i_novi_2D3D in RASPORED.DIMENZIJA%type,
                                                            o_error_c out number,
                                                            o_error_m out varchar2)AS
l_id_raspo RASPORED.ID%type;
l_id_filma FILMOVI.ID%type;
l_email KORISNICI.EMAIL%type;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';

   IF NVL(i_id_raspo,0)=0 THEN
      o_error_c :=39;
      o_error_m :='Molimo unesite ID rasporeda.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_novi_id_filma,0)=0 THEN
      o_error_c :=40;
      o_error_m :='Molimo unesite novi ID filma, ili stari ukoliko ga ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_novi_dat_prikaz,'01.01.0001')='01.01.0001' THEN
      o_error_c :=41;
      o_error_m :='Molimo unesite novi datum prikazivanja, ili stari ukoliko ga ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_novo_vri_prikaz,' ')=' ' THEN
      o_error_c :=42;
      o_error_m :='Molimo unesite novo vrijeme prikazivanja, ili staro ukoliko ga ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;

   IF (i_novi_2D3D not in(0,1)) THEN
      o_error_c :=43;
      o_error_m :='Molimo unesite 0 za 2D prikazivanje filma, te 1 za 3D prikazivanje filma.';
      RAISE e_iznimka;
   END IF;
BEGIN
   SELECT
      ID
   INTO
      l_id_filma
   FROM
      FILMOVI
   WHERE
      ID=i_novi_id_filma;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_id_filma :=0;
END;
   IF(l_id_filma=0) THEN
      o_error_c :=44;
      o_error_m :='Molimo unesite ID filma koji postoji.';
      RAISE e_iznimka;
   END IF;

BEGIN
   SELECT
      ID
   INTO
      l_id_raspo
   FROM
      RASPORED
   WHERE
      ID=i_id_raspo;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      l_id_raspo :=0;
END;
BEGIN
   SELECT
      EMAIL
   INTO
      l_email
   FROM 
      KORISNICI
   WHERE
      EMAIL=i_email;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_email :=' ';
END;
     IF (l_email=' ') THEN
        o_error_c :=45;
        o_error_m :='Ne postoji uneseni email.';
        RAISE e_iznimka;
END IF;

   IF(l_id_raspo=0) THEN
      o_error_c :=46;
      o_error_m :='Molimo unesite ID koji postoji';
      RAISE e_iznimka;
   END IF;

   IF(l_id_raspo=l_id_raspo) AND
     (F_CHECK_ADMIN(i_email,o_error_c,o_error_m)) THEN
      UPDATE RASPORED SET ID_FILMA=i_novi_id_filma,
                          DAT_PRIKAZ=i_novi_dat_prikaz,
                          VRI_PRIKAZ=i_novo_vri_prikaz,
                          DIMENZIJA=i_novi_2D3D
      WHERE ID=i_id_raspo;
  ELSE
    o_error_c:=47;
    o_error_m:='Access denied!';
    RAISE e_iznimka;
  END IF;
COMMIT;
EXCEPTION
   WHEN e_iznimka THEN
   NULL;
   WHEN OTHERS THEN
      o_error_c :=106;
      o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_UPDATE_RASPOREDA;

PROCEDURE P_UPDATE_REZERVACIJE(i_email in KORISNICI.EMAIL%type,
                                                            i_red in REZERVACIJE.REDOVI%type,
                                                            i_sjed in number,
                                                            i_id_raspo in REZERVACIJE.ID_RASPO%type,
                                                            o_error_c out number,
                                                            o_error_m out varchar2)AS

l_naredba varchar2(400);
l_counter number(3);
l_id_kor number(9);
l_if varchar2(400);
BEGIN
   o_error_c :=0;
   o_error_m :=' ';

   IF NVL(i_red,0)=0 THEN
      o_error_c :=48;
      o_error_m :='Molimo unesite red u kojem želite rezervirati mjesto.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_sjed,0)=0 THEN
      o_error_c :=49;
      o_error_m :='Molimo unesite sjedalo koje želite rezervirati.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_id_raspo,0)=0 THEN
      o_error_c :=50;
      o_error_m :='Molimo unesite ID rasporeda za film koji želite rezervirati.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_email,' ')=' ' THEN
      o_error_c :=51;
      o_error_m :='Molimo unesite email.';
      RAISE e_iznimka;
   END IF;
BEGIN
   SELECT
      ID
   INTO
      l_id_kor
   FROM
      KORISNICI
   WHERE
      EMAIL=i_email;
   EXCEPTION
   WHEN OTHERS THEN
      l_id_kor:=0;
END;
   IF (l_id_kor=0) THEN
      o_error_c :=52;
      o_error_m :='Molimo unesite postoje?u email adresu.';
      RAISE e_iznimka;
   END IF;

BEGIN
 l_naredba := '    select 
        count(1) 
     from 
        RASPORED ra, 
        REZERVACIJE re 
     where
        ra.ID = re.ID_raspo and 
        re.redovi =' || i_red || ' and 
        sjed_' || i_sjed || '=0 and 
        ra.ID = ' || i_id_raspo;
        o_error_m := '1.' || l_naredba;
 EXECUTE IMMEDIATE l_naredba into l_counter ;
END;

IF l_counter>0 THEN
    l_naredba := 'UPDATE REZERVACIJE SET SJED_' || i_sjed || '=' || l_id_kor ||
    ' WHERE ID_RASPO=' || i_id_raspo ||' AND REDOVI='|| i_red;
    EXECUTE IMMEDIATE l_naredba;
    o_error_c  :=0;
    o_error_m := 'Uspješno ste rezervirali sjedalo ' || i_sjed || ' u ' || i_red || '. redu.'; 
ELSE
   o_error_c :=53;
   o_error_m :='Molimo odaberite sjedalo koje nije rezervirano!';
   RAISE e_iznimka;
    commit;
END IF;

EXCEPTION
   WHEN e_iznimka THEN
   NULL;
   WHEN OTHERS THEN
      o_error_c :=107;
      o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_UPDATE_REZERVACIJE;
---------------------------------PROCEDURA ZA BRISANJE KORISNIKA(BODY)------------------------------------

PROCEDURE P_BRISANJE_KOR(i_ovlasteni_email in KORISNICI.EMAIL%type,
                                                                  i_email in KORISNICI.EMAIL%type,
                                                                  o_error_c out number,
                                                                  o_error_m out varchar2,
                                                                  o_rezultat out varchar2)AS
l_email KORISNICI.EMAIL%type;
l_ovlasteni_korisnik KORISNICI.EMAIL%type;
l_ovlasti KORISNICI.OVLASTI%type;
   BEGIN
      o_error_c :=0;
      o_error_m :=' ';

    IF NVL(i_email,' ')=' ' THEN
       o_error_c :=54;
       o_error_m :='Molimo unesite email.';
       RAISE e_iznimka;
    END IF;

    IF NVL(i_ovlasteni_email,' ')=' ' THEN
       o_error_c :=55;
       o_error_m := 'Molimo unesite email korisnika ovlaštenog za brisanje';
       RAISE e_iznimka;
    END IF;
BEGIN
   SELECT
      EMAIL,
      OVLASTI
   INTO
      l_ovlasteni_korisnik,
      l_ovlasti
   FROM
      KORISNICI
   WHERE
      EMAIL=i_ovlasteni_email;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
           l_ovlasteni_korisnik :=' ';
           l_ovlasti := 0;
END;

BEGIN
    SELECT
       EMAIL
    INTO
       l_email
    FROM
       KORISNICI
    WHERE EMAIL=i_email;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
       l_email :=' ';
END;    
       IF(l_email!=i_email) THEN
          o_error_c :=56;
          o_error_m :='Unesite email koji se koristi.';
          RAISE e_iznimka;
          END IF;

          IF(l_email=l_ovlasteni_korisnik) AND
            (l_ovlasti>=1) OR
            (l_ovlasti=0) OR
            (l_ovlasti=1)THEN
             o_error_c :=57;
             o_error_m :='Nemate ovlasti za brisanje korisnika!';
             RAISE e_iznimka;
          ELSE          
          IF(l_email=l_email) AND
            (F_CHECK_ADMIN(i_ovlasteni_email,o_error_c,o_error_m)=TRUE) THEN
             DELETE FROM KORISNICI WHERE EMAIL=i_email;
             o_rezultat :='Uspješno obrisan korisnik!';
          END IF;
    END IF;
  EXCEPTION
     WHEN e_iznimka THEN
     NULL;
     WHEN OTHERS THEN
        o_error_c :=108;
        o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_BRISANJE_KOR;

PROCEDURE P_BRISANJE_FILMOVA(i_ovlasteni_email in KORISNICI.EMAIL%type,
                                                                     i_naziv_filma in FILMOVI.NAZIV%type,
                                                                     o_error_c out number,
                                                                     o_error_m out varchar2,
                                                                     o_rezultat out varchar2)AS
l_film FILMOVI.NAZIV%type;
   BEGIN
      o_error_c :=0;
      o_error_m :=' ';

    IF NVL(i_ovlasteni_email,' ')=' ' THEN
       o_error_c :=58;
       o_error_m := 'Molimo unesite email korisnika ovlaštenog za brisanje';
       RAISE e_iznimka;
    END IF;

    IF NVL(i_naziv_filma,' ')=' ' THEN
       o_error_c :=59;
       o_error_m :='Molimo unesite naziv filma';
       RAISE e_iznimka;
    END IF;
BEGIN      
   SELECT 
     NAZIV
   INTO
      l_film
   FROM
     FILMOVI
   WHERE
      NAZIV=i_naziv_filma;
   EXCEPTION
   WHEN OTHERS THEN
      l_film :=' ';
END;

IF(l_film=' ') THEN
   o_error_c :=60;
   o_error_m :='Molimo unesite film koji postoji';
   RAISE e_iznimka;
   ELSE
      IF(F_CHECK_ADMIN(i_ovlasteni_email,o_error_c,o_error_m)=TRUE) THEN
         DELETE FROM FILMOVI WHERE NAZIV=i_naziv_filma;
         o_rezultat :='Uspješno obrisan film!';
   ELSE
      o_error_c :=61;
      o_error_m :='Niste ovlašteni za brisanje filmova.';
      RAISE e_iznimka;
      END IF;
END IF;

EXCEPTION
  WHEN e_iznimka THEN
  NULL;
  WHEN OTHERS THEN
     o_error_c :=109;
     o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_BRISANJE_FILMOVA;
 
PROCEDURE P_BRISANJE_RASPOREDA(i_ovlasteni_email in KORISNICI.EMAIL%type,
                                                                        i_id in RASPORED.ID%type,
                                                                        o_error_c out number,
                                                                        o_error_m out varchar2,
                                                                        o_rezultat out varchar2)AS
l_id RASPORED.ID%type;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';

   IF NVL(i_ovlasteni_email,' ')=' ' THEN
      o_error_c :=62;
      o_error_m :='Molimo unesite email ovlaštene osobe.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_id,0)=0 THEN
      o_error_c :=63;
      o_error_m :='Molimo unesite ID koji postoji.';
      RAISE e_iznimka;
   END IF;

BEGIN
   SELECT
      ID
   INTO 
      l_id
   FROM
      RASPORED
   WHERE
      ID=i_id;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      l_id :=0;
END;
     IF(l_id=0) THEN
       o_error_c:=64;
       o_error_m :='Molimo unesite ID rasporeda koji postoji!';
       RAISE e_iznimka;
     ELSE
        IF(F_CHECK_ADMIN(i_ovlasteni_email,o_error_c,o_error_m)) THEN
        DELETE FROM RASPORED WHERE ID=i_id;
        o_rezultat :='Raspored uspješno obrisan!';
    ELSE
       o_error_c:=65;
       o_error_m:='Niste ovlašteni za brisanje rasporeda';
       RAISE e_iznimka;
    END IF;
END IF;
EXCEPTION
  WHEN e_iznimka THEN
  NULL;
  WHEN OTHERS THEN
     o_error_c :=110;
     o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_BRISANJE_RASPOREDA;

PROCEDURE P_BRISANJE_DVORANE(i_ovlasteni_email in KORISNICI.EMAIL%type,
                                                                      i_id_raspo in REZERVACIJE.ID_RASPO%type,
                                                                      o_error_c out number,
                                                                      o_error_m out varchar2,
                                                                      o_rezultat out varchar2)AS
l_id_raspo REZERVACIJE.ID_RASPO%type;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';

   IF NVL(i_ovlasteni_email,' ')=' ' THEN
      o_error_c :=66;
      o_error_m :='Molimo unesite email.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_id_raspo,0)=0 THEN
      o_error_c :=67;
      o_error_m :='Molimo unesite ID rasporeda';
      RAISE e_iznimka;
   END IF;
   
BEGIN
   SELECT
      ID_RASPO
   INTO
      l_id_raspo
   FROM
      REZERVACIJE
   WHERE
      ID_RASPO=i_id_raspo  and
      REDOVI=1;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      l_id_raspo :=0;
END;

   IF(l_id_raspo!=i_id_raspo) THEN
      o_error_c :=68;
      o_error_m :='Molimo unesite ID rasporeda koji se koristi!';
      RAISE e_iznimka;
   END IF;
   
      IF(F_CHECK_ADMIN(i_ovlasteni_email,o_error_c,o_error_m)=TRUE) THEN
         DELETE FROM REZERVACIJE WHERE ID_RASPO=l_id_raspo;
         o_rezultat :='Uspješno obrisana dvorana.';
      ELSE
         IF(F_CHECK_ADMIN(i_ovlasteni_email,o_error_c,o_error_m)=FALSE) THEN
         o_error_c :=69;
         o_error_m :='Niste ovlašteni za brisanje dvorane.';
         RAISE e_iznimka;
      END IF;
END IF;
EXCEPTION
   WHEN e_iznimka THEN
   NULL;
   WHEN OTHERS THEN
      o_error_c := 111;
      o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_BRISANJE_DVORANE;

PROCEDURE P_DOHVATI_KOR(o_rezultat out SYS_REFCURSOR,
                                                    o_error_c out number,
                                                    o_error_m out VARCHAR2) as
l_cursor SYS_REFCURSOR;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';
   OPEN l_cursor FOR
      SELECT
         *
      FROM
         KORISNICI
      WHERE
         ID IS NOT NULL;
      o_rezultat :=l_cursor;
EXCEPTION
   WHEN OTHERS THEN
   o_error_c :=111;
   o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_DOHVATI_KOR;

PROCEDURE P_DOHVATI_FILMOVE(o_rezultat out SYS_REFCURSOR,
                                                    o_error_c out number,
                                                    o_error_m out varchar2)AS                                                    
l_cursor SYS_REFCURSOR;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';
   OPEN l_cursor FOR
      SELECT
         *
      FROM
         FILMOVI
      WHERE
         ID IS NOT NULL;
      o_rezultat :=l_cursor;
EXCEPTION
   WHEN OTHERS THEN
   o_error_c :=112;
   o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_DOHVATI_FILMOVE;

PROCEDURE P_DOHVATI_RASPORED(o_rezultat out SYS_REFCURSOR,
                                                    o_error_c out number,
                                                    o_error_m out varchar2)AS                                                    
l_cursor SYS_REFCURSOR;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';
   OPEN l_cursor FOR
      SELECT
         *
      FROM
         RASPORED
      WHERE
         ID IS NOT NULL;
      o_rezultat :=l_cursor;
EXCEPTION
   WHEN OTHERS THEN
   o_error_c :=113;
   o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_DOHVATI_RASPORED;

PROCEDURE P_DOHVATI_REZERVACIJE(o_rezultat out SYS_REFCURSOR,
                                                    o_error_c out number,
                                                    o_error_m out varchar2)AS
l_cursor SYS_REFCURSOR;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';
   OPEN l_cursor FOR
      SELECT
         *
      FROM
         REZERVACIJE
      WHERE
         ID IS NOT NULL;
      o_rezultat :=l_cursor;
EXCEPTION
   WHEN OTHERS THEN
   o_error_c :=114;
   o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_DOHVATI_REZERVACIJE;
PROCEDURE P_DOHVATI_REZERVACIJU(i_id_raspo in REZERVACIJE.ID_RASPO%type,
                                                    o_rezultat out SYS_REFCURSOR,
                                                    o_error_c out number,
                                                    o_error_m out varchar2)AS
l_cursor SYS_REFCURSOR;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';
   OPEN l_cursor FOR
      SELECT
         *
      FROM
         REZERVACIJE
      WHERE
         ID_RASPO=i_id_raspo;
      o_rezultat :=l_cursor;
EXCEPTION
   WHEN OTHERS THEN
   o_error_c :=114;
   o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_DOHVATI_REZERVACIJU;

PROCEDURE P_UPDATE_REZERVACIJE2(i_email in KORISNICI.EMAIL%type,
                                                            i_passw in KORISNICI.PASSWORD%type,
                                                            i_red in REZERVACIJE.REDOVI%type,
                                                            i_sjed in number,
                                                            i_id_raspo in REZERVACIJE.ID_RASPO%type,
                                                            o_error_c out number,
                                                            o_error_m out varchar2)AS

l_naredba varchar2(400);
l_counter number(3);
l_id_kor number(9);
l_pass_kor KORISNICI.PASSWORD%type;
l_if varchar2(400);
l_sjed number;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';
   l_sjed := i_sjed;

   IF NVL(i_red,0)=0 THEN
      o_error_c :=48;
      o_error_m :='Molimo unesite red u kojem želite rezervirati mjesto.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_sjed,0)=0 THEN
      o_error_c :=49;
      o_error_m :='Molimo unesite sjedalo koje želite rezervirati.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_id_raspo,0)=0 THEN
      o_error_c :=50;
      o_error_m :='Molimo unesite ID rasporeda za film koji želite rezervirati.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_email,' ')=' ' THEN
      o_error_c :=51;
      o_error_m :='Molimo unesite email.';
      RAISE e_iznimka;
   END IF;
BEGIN
   SELECT
      ID,
      PASSWORD
   INTO
      l_id_kor,
      l_pass_kor
   FROM
      KORISNICI
   WHERE
      EMAIL=i_email;
   EXCEPTION
   WHEN OTHERS THEN
      l_id_kor:=0;
      l_pass_kor:=' ';
END;
   IF (l_id_kor=0) THEN
      o_error_c :=52;
      o_error_m :='Molimo unesite postojecu email adresu.';
      RAISE e_iznimka;
   END IF;

   IF (l_pass_kor!=i_passw)THEN
      o_error_c:=70;
      o_error_m:='Molimo unesite ispravan password.';
      RAISE e_iznimka;
    END IF;

    IF (i_red = 10) THEN
        IF (i_sjed between 2 and 7) THEN
            l_sjed := l_sjed + 1;
        ELSIF (i_sjed > 7) THEN
            l_sjed := l_sjed + 2;
        END IF;
    END IF;
BEGIN
 l_naredba := '    select 
        count(1) 
     from 
        RASPORED ra, 
        REZERVACIJE re 
     where
        ra.ID = re.ID_raspo and 
        re.redovi =' || i_red || ' and 
        sjed_' || l_sjed || '=0 and 
        ra.ID = ' || i_id_raspo;
        o_error_m := '1.' || l_naredba;
 EXECUTE IMMEDIATE l_naredba into l_counter ;
END;

IF l_counter>0 THEN
    IF (i_red = 10 and l_sjed IN (1, 8, 14)) THEN
        l_naredba := 'UPDATE REZERVACIJE SET SJED_' || l_sjed || '=' || l_id_kor || ', SJED_' || (l_sjed + 1) || '=' || l_id_kor || ' WHERE ID_RASPO=' || i_id_raspo ||' AND REDOVI='|| i_red;
    ELSE
        l_naredba := 'UPDATE REZERVACIJE SET SJED_' || l_sjed || '=' || l_id_kor || ' WHERE ID_RASPO=' || i_id_raspo ||' AND REDOVI='|| i_red;
    END IF;

    EXECUTE IMMEDIATE l_naredba;
    o_error_c  :=0;
    o_error_m := 'Uspješno ste rezervirali sjedalo ' || l_sjed || ' u ' || i_red || '. redu.';
    commit;
ELSE
    o_error_c :=53;
    o_error_m :='Molimo odaberite sjedalo koje nije rezervirano!';
    RAISE e_iznimka;
END IF;

EXCEPTION
   WHEN e_iznimka THEN
   NULL;
   WHEN OTHERS THEN
      o_error_c :=107;
      o_error_m :=('Dogodila se neocekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
      rollback;
END P_UPDATE_REZERVACIJE2;

PROCEDURE P_DOHVATI_TJEDNI_RASPORED(o_rezultat out SYS_REFCURSOR,
                                                                o_error_c out number,
                                                                o_error_m out varchar2)AS
l_cursor SYS_REFCURSOR;
BEGIN
    o_error_c:=0;
    o_error_m:=' ';
OPEN l_cursor FOR
    SELECT
        trim(initcap(TO_CHAR(RA.DAT_PRIKAZ, 'DAY'))) AS DAN,
        to_char(RA.DAT_PRIKAZ, 'DD.MM.YYYY.') || ' ' || RA.VRI_PRIKAZ || 'h' AS DAT_VRI_PRIKAZ,
        FI.NAZIV || ' ' || 
        (CASE RA.DIMENZIJA
            WHEN 1 THEN '3D'
            ELSE '2D'
        END)
        AS NAZIV,
        RA.ID,
        FI.ULOGE,
        FI.OPIS,
        FI.POSTER_LINK,
        RA.CIJENA || ' kn' AS CIJENA 
    FROM
        RASPORED RA
    JOIN
        FILMOVI FI ON RA.ID_FILMA = FI.ID
    WHERE
        RA.DAT_PRIKAZ BETWEEN(select TRUNC(sysdate, 'iw') from dual) and 
        (SELECT TRUNC(sysdate, 'iw') + 7 - 1/86400 from dual) ORDER BY RA.DAT_PRIKAZ;
        o_rezultat :=l_cursor;
        
EXCEPTION
   WHEN OTHERS THEN
   o_error_c :=116;
   o_error_m :=('Dogodila se neo?ekivana pogreška, molimo pokušajte ponovo.'||chr(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE|| SQLERRM);
END P_DOHVATI_TJEDNI_RASPORED;            
END P_REZERVACIJE;

/*
----------------------------------ANONIMNI BLOKOVI ZA POZIV FUNKCIJA/PROCEDURA--------------------------
SET SERVEROUTPUT ON;
DECLARE
   l_ime KORISNICI.IME%type :='Tomislav';
   l_prezime KORISNICI.PREZIME%type :='Adamov?';
   l_email KORISNICI.EMAIL%type :='Tadamovic@vub.hr';
   l_passw KORISNICI.PASSWORD%type :='koliko99';
   l_o_id_koris korisnici.id%type;
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
BEGIN
   P_REZERVACIJE.P_UNOS_KOR(l_ime,l_prezime,l_email,l_passw,l_o_id_koris,l_error_c,l_error_m);
   IF L_ERROR_C > 0 THEN
      DBMS_OUTPUT.PUT_LINE(L_ERROR_M || ' Error code= ' || L_ERROR_C);
   ELSE
      DBMS_OUTPUT.PUT_LINE('VAŠ ID JE ' || l_o_id_koris);
   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('TEST' || l_error_c || SQLERRM);
END;
SELECT * FROM KORISNICI;
----------------------------------UNOS FILMA---------------------------------------
DECLARE
   l_naziv_filma FILMOVI.NAZIV%type :='Lord of the asssad';
   l_zanr FILMOVI.ZANR%type :='Sci-fi,Adventure';
   l_trajanje FILMOVI.TRAJANJE%type :=200;
   l_poster_link FILMOVI.POSTER_LINK%type :='C:\Users\Kiki\Desktaops\stag';
   l_trailer_link FILMOVI.TRAILER_link%type :='C:\Users\Kiki\Deskatop\stdagod';
   l_o_id_filma FILMOVI.ID%type;
   l_o_error_c number:=0;
   l_o_error_m varchar2(300):=' ';
BEGIN
   P_REZERVACIJE.P_UNOS_FILMOVA(l_naziv_filma,l_zanr,l_trajanje,l_poster_link,l_trailer_link,l_o_id_filma,l_o_error_c,l_o_error_m);
   IF (l_o_error_c>0) THEN
      dbms_output.put_line( l_o_error_c || ' ' || l_o_error_m);
   ELSE
      dbms_output.put_line('Film je unesen,ID filma je ' || l_o_id_filma || '.');
   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line('Došlo je do neo?ekivane pogreške, molimo pokušajte ponovo');
END;

SELECT * FROM FILMOVI;

------------------------------UNOS RASPOREDA ZA PRIKAZIVANJE FILMA---------------------------
DECLARE
   l_id_filma RASPORED.ID_FILMA%type :=1;
   l_dat_prikaz RASPORED.DAT_PRIKAZ%type :='19.01.2018';
   l_vri_prikaz RASPORED.VRI_PRIKAZ%type :='18:25';
   l_2D number :=0;
   l_3D number :=1;
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
BEGIN
   P_REZERVACIJE.P_UNOS_RASPOREDA(l_id_filma,l_dat_prikaz,l_vri_prikaz,l_2D,l_error_c,l_error_m);
   IF(l_error_c>0) THEN
      dbms_output.put_line(l_error_m || '. Error code=' ||  l_error_c);
   ELSE
      dbms_output.put_line('Raspored unesen');
END IF;
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('TEST' || l_error_c || SQLERRM);
END;

-----------------UNOS PRAZNE KINO DVORANE---------------------------------
DECLARE
   l_id_raspo REZERVACIJE.ID_RASPO%type :=7;
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
BEGIN
 P_REZERVACIJE.P_UNOS_DVORANE(l_id_raspo,l_error_c , l_error_m );
   IF (l_error_c>0) THEN
      dbms_output.put_line( l_error_m  || '. Error code=' || l_error_c);
   ELSE
      dbms_output.put_line('Dvorana unesena');
END IF;
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line('TEST' || l_error_c || SQLERRM);
END;
-----------------------------UPDATE KORISNIKA---------------------------------------
DECLARE
   l_ovlasteni_email KORISNICI.EMAIL%type :='dev.user@vub.hr';
   l_stari_email KORISNICI.EMAIL%type :='josipa.rajkovic@gmail.com';
   l_novo_staro_ime KORISNICI.IME%type :='Tomislav';
   l_novo_staro_prezime KORISNICI.PREZIME%type :='Adamovi?';
   l_novi_stari_email KORISNICI.EMAIL%type :='josipa.rajkovic@gmail.com ';
   l_novi_stari_pass KORISNICI.PASSWORD%type :='1245arra';
   l_id_koris korisnici.id%type;
   l_error_c number := 0;
   l_error_m varchar2(300):=' ';
BEGIN

   P_REZERVACIJE.P_UPDATE_KOR(l_ovlasteni_email,l_stari_email,l_novo_staro_ime,l_novo_staro_prezime,l_novi_stari_email,l_novi_stari_pass,l_error_c,l_error_m);
   IF L_ERROR_C > 0 THEN
      DBMS_OUTPUT.PUT_LINE(L_ERROR_M || ' Error code=' || L_ERROR_C);
   ELSE
      DBMS_OUTPUT.PUT_LINE('Uspješan update!');
   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('TEST' || l_error_c || SQLERRM);
END;

SELECT * FROM KORISNICI;
-----------------------------UPDATE FILMOVA------------------------------------------
DECLARE
   l_ovlasteni_email KORISNICI.EMAIL%type :='dev.user@vub.hr';
   l_naziv_filma FILMOVI.NAZIV%type :='Aquaman';
   l_novi_naziv_filma FILMOVI.NAZIV%type :='Aquamana';
   l_novi_zanr FILMOVI.ZANR%type :='sci-fi,avantura';
   l_trajanje_filma FILMOVI.TRAJANJE%type :=230;
   l_novi_poster_link FILMOVI.POSTER_LINK%type :='whateverman';
   l_novi_trailer_link FILMOVI.TRAILER_LINK%type :='whatevermaan its a trick';
   l_error_c number :=0;
   l_error_m varchar2(300) :=' ';
BEGIN
   P_REZERVACIJE.P_UPDATE_FILMOVA(l_ovlasteni_email,l_naziv_filma,l_novi_naziv_filma,l_novi_zanr,l_trajanje_filma,l_novi_poster_link,l_novi_trailer_link,l_error_c,l_error_m);
      IF (l_error_c>0) THEN
         dbms_output.put_line( l_error_m || ' Error code=' || l_error_c);
      ELSE
         dbms_output.put_line('Prošao update!');
      END IF;
      EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Test' || SQLERRM);
END;

SELECT * FROM FILMOVI;
----------------------------UPDATE RASPOREDA------------------------------------------
DECLARE
   l_ovlasteni_email KORISNICI.EMAIL%type :='dev.user@vub.hr';
   l_id_raspo RASPORED.ID%type :=1;
   l_novi_id_filma RASPORED.ID_FILMA%type :=4;
   l_novi_dat_prikaz RASPORED.DAT_PRIKAZ%type :='08.02.2018';
   l_novo_vri_prikaz RASPORED.VRI_PRIKAZ%type :='18:22';
   l_2D number:=0;
   l_3D number:=1;
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
BEGIN
P_REZERVACIJE.P_UPDATE_RASPOREDA(l_ovlasteni_email,l_id_raspo,l_novi_id_filma,l_novi_dat_prikaz,l_novo_vri_prikaz,l_2D,l_error_c,l_error_m);
   IF (l_error_c>0) THEN
      dbms_output.put_line(l_error_m || ' Error code=' || l_error_c);
   ELSE
      dbms_output.put_line('Uspješan update');
END IF;
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line('Test' || SQLERRM);
END;

---------------------------BRISANJE KORISNIKA-------------------------------------------
DECLARE
   l_error_c number :=0;
   l_error_m varchar2(300) :=' ';
   l_rezultat varchar2(30) :=' ';
   l_ovlasteni_email varchar2(40) :='dev.user@vub.hr';
   l_email varchar2(40) :='robi.kova@gmail.com';
BEGIN
   P_REZERVACIJE.P_BRISANJE_KOR(l_ovlasteni_email,l_email,l_error_c,l_error_m,l_rezultat);
      IF(l_error_c>0) THEN
         dbms_output.put_line(l_error_m || ' Error code=' || l_error_c);
      ELSE
         dbms_output.put_line(l_rezultat);
      END IF;
    EXCEPTION
       WHEN OTHERS THEN
          dbms_output.put_line('Test'|| SQLERRM);
END;

--------------------------BRISANJE FILMA-------------------------------------------------
DECLARE
   l_error_c number :=0;
   l_error_m varchar2(300) :=' ';
   l_rezultat varchar2(30) :=' ';
   l_ovlasteni_email varchar2(40) :='dev.user@vub.hr';
   l_film varchar2(40) :='Aquaman';
BEGIN
   P_REZERVACIJE.P_BRISANJE_FILMOVA(l_ovlasteni_email,l_film,l_error_c,l_error_m,l_rezultat);
      IF(l_error_c>0) THEN
         dbms_output.put_line(l_error_m || ' Error code=' || l_error_c);
      ELSE
         dbms_output.put_line(l_rezultat);
      END IF;
    EXCEPTION
       WHEN OTHERS THEN
          dbms_output.put_line('Test'|| SQLERRM);
END;

----------------------------BRISANJE RASPOREDA-------------------------------------------
DECLARE
   l_error_c number :=0;
   l_error_m varchar2(300) :=' ';
   l_rezultat varchar2(30) :=' ';
   l_ovlasteni_email varchar2(40) :='dev.user@vub.hr';
   l_id varchar2(40) :=5;
BEGIN
   P_REZERVACIJE.P_BRISANJE_RASPOREDA(l_ovlasteni_email,l_id,l_error_c,l_error_m,l_rezultat);
      IF(l_error_c>0) THEN
         dbms_output.put_line(l_error_m || ' Error code=' || l_error_c);
      ELSE
         dbms_output.put_line(l_rezultat);
      END IF;
    EXCEPTION
       WHEN OTHERS THEN
          dbms_output.put_line('Test'|| SQLERRM);
END;

--------------------------BRISANJE DVORANE------------------------------------------
DECLARE
   l_error_c number :=0;
   l_error_m varchar2(300) :=' ';
   l_rezultat varchar2(30) :=' ';
   l_ovlasteni_email varchar2(40) :='dev.user@vub.hr';
   l_id_raspo varchar2(40) :=2;
BEGIN
   P_REZERVACIJE.P_BRISANJE_DVORANE(l_ovlasteni_email,l_id_raspo,l_error_c,l_error_m,l_rezultat);
      IF(l_error_c>0) THEN
         dbms_output.put_line(l_error_m || ' Error code=' || l_error_c);
      ELSE
         dbms_output.put_line(l_rezultat);
      END IF;
    EXCEPTION
       WHEN OTHERS THEN
          dbms_output.put_line('Test'|| SQLERRM);
END;

-------------------------UPDATE REZERVACIJE--------------------------------------------

declare
  l_sjed number(2) := 7;
  l_red number(2) := 10;
  l_id_raspo number(9) := 1;
  l_email varchar2(40) :='robi.kova@gmail.com';
  l_error_c number :=0;
  l_error_m varchar2(300) :=' ';
BEGIN
   P_REZERVACIJE.P_UPDATE_REZERVACIJE(l_email,l_red,l_sjed,l_id_raspo,l_error_c,l_error_m);
   IF (l_error_c>0) THEN
       dbms_output.put_line(l_error_m || ' Error code=' || l_error_c);
   ELSE
      dbms_output.put_line(l_error_m);
   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line('Test' || SQLERRM);
END;

--------------------------------DOHVATI KORISNIKE-------------------------------------------
DECLARE
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
   l_o_rezultat sys_refcursor;
   l_korisnici korisnici%rowtype;
BEGIN
   P_REZERVACIJE.P_DOHVATI_KOR(l_o_rezultat,l_error_c,l_error_m);
      IF(l_error_c>0) THEN
         dbms_output.put_line(l_error_m || ' Error code=' || l_error_c);
      ELSE
       loop
          fetch l_o_rezultat into l_korisnici;
          dbms_output.put_line('ID=' ||l_korisnici.ID|| chr(10) || 'ime='|| l_korisnici.IME || chr(10) || 'prezime=' || l_korisnici.PREZIME || chr(10) ||  'Email=' || l_korisnici.EMAIL || chr(10)||  'password=' || l_korisnici.PASSWORD ||chr(10)|| 'ovlasti=' || l_korisnici.OVLASTI ||chr(10));     
    exit when l_o_rezultat%notfound;
    
       end loop;
      END IF;
      EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Test'|| SQLERRM);
END;

--------------------------------------DOHVATI FILMOVE----------------------------------------
DECLARE
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
   l_o_rezultat sys_refcursor;
   l_filmovi filmovi%rowtype;
BEGIN
   P_REZERVACIJE.P_DOHVATI_FILMOVE(l_o_rezultat,l_error_c,l_error_m);
      IF(l_error_c>0) THEN
         dbms_output.put_line(l_error_m || ' Error code=' || l_error_c);
      ELSE
       loop
          fetch l_o_rezultat into l_filmovi;
          dbms_output.put_line('ID=' ||l_filmovi.ID || chr(10) || 'naziv='|| l_filmovi.NAZIV|| chr(10) || 'žanr=' || l_filmovi.ZANR|| chr(10) ||  'trajanje=' || l_filmovi.TRAJANJE|| chr(10)||  'link službenog postera filma=' || l_filmovi.POSTER_LINK||chr(10)|| 'link službenog trailera filma=' || l_filmovi.TRAILER_LINK||chr(10));    
    exit when l_o_rezultat%notfound;
    
       end loop;
      END IF;
      EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Test'|| SQLERRM);
END;

----------------------------------DOHVATI RASPORED-----------------------------------------
DECLARE
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
   l_o_rezultat sys_refcursor;
   l_raspored RASPORED%rowtype;
BEGIN
   P_REZERVACIJE.P_DOHVATI_RASPORED(l_o_rezultat,l_error_c,l_error_m);
      IF(l_error_c>0) THEN
         dbms_output.put_line(l_error_m || ' Error code=' || l_error_c);
      ELSE
       loop
          fetch l_o_rezultat into l_raspored;
          dbms_output.put_line('ID=' ||l_raspored.ID || chr(10) || 'ID filma='|| l_raspored.ID_FILMA|| chr(10) || 'datum prikazvanja=' || l_raspored.DAT_PRIKAZ|| chr(10) ||  'Vrijeme prikazivanja=' || l_raspored.VRI_PRIKAZ || chr(10)||  '2D ili 3D prikazivanje=' || l_raspored.DIMENZIJA||chr(10)|| 'cijena=' || l_raspored.CIJENA||chr(10));    
    exit when l_o_rezultat%notfound;
    
       end loop;
      END IF;
      EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Test'|| SQLERRM);
END;

---------------------------------DOHVATI REZERVACIJE--------------------------------------------
DECLARE
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
   l_o_rezultat sys_refcursor;
   l_rezervacije REZERVACIJE%rowtype;
BEGIN
   P_REZERVACIJE.P_DOHVATI_REZERVACIJE(l_o_rezultat,l_error_c,l_error_m);
      IF(l_error_c>0) THEN
         dbms_output.put_line(l_error_m || ' Error code=' || l_error_c);
      ELSE
       loop
          fetch l_o_rezultat into l_rezervacije;
          dbms_output.put_line('---------------');
          dbms_output.put_line('ID=' ||l_rezervacije.ID || chr(10) || 'ID rasporeda='|| l_rezervacije.ID_RASPO|| chr(10) || 'red=' || l_rezervacije.REDOVI|| chr(10) ||  'Sjedalo 1=' || l_rezervacije.SJED_1 ||chr(10) || 'Sjedalo 2=' || l_rezervacije.SJED_2 ||chr(10) ||'Sjedalo 3=' || l_rezervacije.SJED_3 ||chr(10) ||'Sjedalo 4=' || l_rezervacije.SJED_4 ||chr(10) ||'Sjedalo 5=' || l_rezervacije.SJED_5 ||chr(10) ||'Sjedalo 6=' || l_rezervacije.SJED_6 ||chr(10) ||'Sjedalo 7=' || l_rezervacije.SJED_7 ||chr(10) ||'Sjedalo 8=' || l_rezervacije.SJED_8 ||chr(10) ||'Sjedalo 9=' || l_rezervacije.SJED_9 ||chr(10) ||'Sjedalo 10=' || l_rezervacije.SJED_10 ||chr(10) ||'Sjedalo 11=' || l_rezervacije.SJED_11 ||chr(10) ||'Sjedalo 12=' || l_rezervacije.SJED_12 ||chr(10) ||'Sjedalo 13=' || l_rezervacije.SJED_13 ||chr(10) ||'Sjedalo 14=' || l_rezervacije.SJED_14 ||chr(10) ||'Sjedalo 15=' || l_rezervacije.SJED_15);
          dbms_output.put_line('--------------' || chr(10));
    exit when l_o_rezultat%notfound;
    
       end loop;
      END IF;
      EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Test'|| SQLERRM);
END;
------------------------------DOHVATI JEDNU REZERVACIJU---------------------------------------
DECLARE
   l_ID_RASPO REZERVACIJE.ID_RASPO%type:=1;
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
   l_o_rezultat sys_refcursor;
   l_rezervacije REZERVACIJE%rowtype;
BEGIN
   P_REZERVACIJE.P_DOHVATI_REZERVACIJU(l_ID_RASPO,l_o_rezultat,l_error_c,l_error_m);
      IF(l_error_c>0) THEN
         dbms_output.put_line(l_error_m || ' Error code=' || l_error_c);
      ELSE
       loop
          fetch l_o_rezultat into l_rezervacije;
          dbms_output.put_line('---------------');
          dbms_output.put_line('ID=' ||l_rezervacije.ID || chr(10) || 'ID rasporeda='|| l_rezervacije.ID_RASPO|| chr(10) || 'red=' || l_rezervacije.REDOVI|| chr(10) ||  'Sjedalo 1=' || l_rezervacije.SJED_1 ||chr(10) || 'Sjedalo 2=' || l_rezervacije.SJED_2 ||chr(10) ||'Sjedalo 3=' || l_rezervacije.SJED_3 ||chr(10) ||'Sjedalo 4=' || l_rezervacije.SJED_4 ||chr(10) ||'Sjedalo 5=' || l_rezervacije.SJED_5 ||chr(10) ||'Sjedalo 6=' || l_rezervacije.SJED_6 ||chr(10) ||'Sjedalo 7=' || l_rezervacije.SJED_7 ||chr(10) ||'Sjedalo 8=' || l_rezervacije.SJED_8 ||chr(10) ||'Sjedalo 9=' || l_rezervacije.SJED_9 ||chr(10) ||'Sjedalo 10=' || l_rezervacije.SJED_10 ||chr(10) ||'Sjedalo 11=' || l_rezervacije.SJED_11 ||chr(10) ||'Sjedalo 12=' || l_rezervacije.SJED_12 ||chr(10) ||'Sjedalo 13=' || l_rezervacije.SJED_13 ||chr(10) ||'Sjedalo 14=' || l_rezervacije.SJED_14 ||chr(10) ||'Sjedalo 15=' || l_rezervacije.SJED_15);
          dbms_output.put_line('--------------' || chr(10));
    exit when l_o_rezultat%notfound;
    
       end loop;
      END IF;
      EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Test'|| SQLERRM);
END;
SELECT * FROM REZERVACIJE;*/
