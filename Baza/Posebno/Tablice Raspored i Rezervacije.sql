DROP TABLE RASPORED CASCADE CONSTRAINTS;
DROP TABLE REZERVACIJE CASCADE CONSTRAINTS;

CREATE TABLE RASPORED(
ID         NUMBER(9)   NOT NULL,
ID_FILMA   NUMBER(9)   NOT NULL,
DAT_PRIKAZ DATE NOT NULL,
VRI_PRIKAZ VARCHAR2(5) NOT NULL,
"2D3D"     NUMBER(1) DEFAULT 0 NOT NULL,
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
    CHECK ("2D3D" in(0,1))
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
comment on column RASPORED."2D3D" is
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
  SJED_1   NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_2   NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_3   NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_4   NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_5   NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_6   NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_7   NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_8   NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_9   NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_10  NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_11  NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_12  NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_13  NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_14  NUMBER(1) DEFAULT 0 NOT NULL,
  SJED_15  NUMBER(1) DEFAULT 0 NOT NULL,
  UKUPNO   NUMBER(3) AS (SJED_1+SJED_2+SJED_3+SJED_4+SJED_5+SJED_6+SJED_7+SJED_8+SJED_9+SJED_10+SJED_11+SJED_12+SJED_13+SJED_14+SJED_15)VIRTUAL,
  CREATED  TIMESTAMP (6)NOT NULL, 
  UPDATED  TIMESTAMP (6)NOT NULL, 
  ID_CREAT NUMBER(4) NOT NULL, 
  ID_UPDAT NUMBER(4) NOT NULL, 
  CONSTRAINT pk_rezervacije
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
 
 
 comment on table rezervacije is
 'U ovoj tablici spremamo koja mjesta i u kojem retku su korisnici rezervirali za projekcije filma';
 comment on column rezervacije.ID is
 'U ovom stupcu upisan je ID rezervacije, ovaj stupac je primary key';
 comment on column rezervacije.ID_RASPO is
 'U ovom stupcu upisan je ID rasporeda, foreign key na tablicu RASPORED stupac ID';
 comment on column rezervacije.SJED_1 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_2 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_3 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_4 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_5 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_6 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_7 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_8 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_9 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_10 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_11 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_12 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_13 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_14 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.SJED_15 is
 'U ovom stupcu upisane su vrijednosti 0 za nije rezervirano i 1 za rezervirano je';
 comment on column rezervacije.UKUPNO is
 'U ovom stupcu zbrojena su zauzeta sjedala';
 comment on column rezervacije.CREATED is
'U ovom stupcu upisani je tocan datum i vrijeme  kada su upisani podaci u retku';
comment on column rezervacije.UPDATED is
'U ovom stupcu upisani je tocan datum i vrijeme kada su upisani podaci u retku poslijednji put izmjenjeni';
comment on column rezervacije.ID_CREAT is
'U ovom stupcu upisan je ID korisnika koji je upisivao podatke u redak, foreign key na tablicu KORISNICI na stupac ID';
comment on column rezervacije.ID_UPDAT is
'U ovom stupcu upisan je ID zadnjeg korisnika koji je mijenjao podatke u retku, foreign key na tablicu KORISNICI na stupac ID';

 
SELECT * FROM RASPORED;

/*          UNOS 2D FILMA       */
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ) 
VALUES(3,to_date('11.01.2018', 'DD.MM.YYYY'),'18:30');
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ) 
VALUES(2,to_date('11.01.2018', 'DD.MM.YYYY'),'18:00');
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ) 
VALUES(2,to_date('12.01.2018', 'DD.MM.YYYY'),'18:00');
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ) 
VALUES(2,to_date('12.01.2018', 'DD.MM.YYYY'),'20:00');
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ) 
VALUES(4,to_date('13.01.2018', 'DD.MM.YYYY'),'18:00');
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ) 
VALUES(4,to_date('13.01.2018', 'DD.MM.YYYY'),'20:00');


/*          UNOS 3D FILMA       */


INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ,"2D3D",CIJENA) 
VALUES(3,to_date('11.01.2018', 'DD.MM.YYYY'),'20:00',1,35);
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ,"2D3D",CIJENA) 
VALUES(3,to_date('14.01.2018', 'DD.MM.YYYY'),'20:00',1,35);
INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ,"2D3D",CIJENA) 
VALUES(4,to_date('11.01.2018', 'DD.MM.YYYY'),'18:00',1,35);

SELECT * FROM rezervacije;

insert into rezervacije
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,10,1,0,1,0,1,1,1,0,1,0,1,0,0,0,1);
insert into rezervacije
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,10,0,1,0,1,0,0,0,1,0,1,0,1,1,1,0);
insert into rezervacije
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,9,1,0,1,0,1,1,1,0,1,0,1,0,0,0,1);
insert into rezervacije
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,8,1,0,1,0,1,1,1,0,1,0,1,0,0,0,1);
insert into rezervacije
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,7,0,0,0,1,0,1,0,0,1,1,1,0,1,0,1);
insert into rezervacije
(ID_RASPO,REDOVI,SJED_1,SJED_2,SJED_3,SJED_4,SJED_5,SJED_6,SJED_7,SJED_8,SJED_9,SJED_10,SJED_11,SJED_12,SJED_13,SJED_14,SJED_15)
values
(1,6,1,0,1,0,1,1,1,0,1,0,1,0,0,0,1);



CREATE INDEX ix_rezervacije on rezervacije
    (ID_UPDAT,ID_CREAT,ID_RASPO,REDOVI,SJED_7,SJED_8,SJED_5,SJED_6,SJED_9,SJED_10,SJED_4,SJED_3,SJED_11,SJED_12,SJED_2,SJED_1,SJED_13,SJED_14,SJED_15);

/*      PRETRAZIVANJE PUTEM INDEXA ix_rezervacije       */

SELECT * FROM 
    rezervacije
WHERE
ID_RASPO=1 and
REDOVI= 10;
