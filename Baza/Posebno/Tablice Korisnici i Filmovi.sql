DROP TABLE KORISNICI CASCADE CONSTRAINTS;
DROP TABLE FILMOVI CASCADE CONSTRAINTS;

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
    POSTER_LINK  varchar2(50) NOT NULL,
    TRAILER_LINK  varchar2(400) NOT NULL,
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


SELECT * FROM KORISNICI;

insert into KORISNICI (IME,PREZIME,EMAIL,PASSWORD,OVLASTI) values ('DEV','USER','dev.user@vub.hr',1122,2);    
insert into KORISNICI (IME,PREZIME,EMAIL,PASSWORD) values ('Robert','Kovacevic','robi.kova@gmail.com',2341);
insert into KORISNICI (IME,PREZIME,EMAIL,PASSWORD) values ('Josipa','RajkoviC','josipa.rajkovic@gmail.com',2852);
insert into KORISNICI (IME,PREZIME,EMAIL,PASSWORD) values ('Iva','Maric','iva.maric@gmail.com',9041);
insert into KORISNICI (IME,PREZIME,EMAIL,PASSWORD) values ('Iva','Maric','iva.maricad@gmail.com',9041);


SELECT * FROM FILMOVI;

INSERT INTO FILMOVI(NAZIV,ZANR,TRAJANJE,POSTER_LINK,TRAILER_LINK) VALUES ('Aquaman','Sci-Fi',100,'C:\Users\Kiki\Desktopa','<iframe width="1280" height="720" src="https://www.youtube.com/embed/WDkg3h8PCVU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>');
INSERT INTO FILMOVI(NAZIV,ZANR,TRAJANJE,POSTER_LINK,TRAILER_LINK) VALUES ('Iron Man','Sci-Fi',200,'C:\Users\Kiki\Desktopb','<iframe width="1280" height="720" src="https://www.youtube.com/embed/WDkg3h8PCVU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>a');
INSERT INTO FILMOVI(NAZIV,ZANR,TRAJANJE,POSTER_LINK,TRAILER_LINK) VALUES ('Captain Marvel','Sci-Fi',150,'C:\Users\Kiki\Desktopc','<iframe width="1280" height="720" src="https://www.youtube.com/embed/WDkg3h8PCVU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>b');
INSERT INTO FILMOVI(NAZIV,ZANR,TRAJANJE,POSTER_LINK,TRAILER_LINK) VALUES ('Avengers Endgame','Sci-Fi',210,'C:\Users\Kiki\Desktopd','<iframe width="1280" height="720" src="https://www.youtube.com/embed/WDkg3h8PCVU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>c');
