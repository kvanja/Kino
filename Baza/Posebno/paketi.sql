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
                                                               i_2D3D in RASPORED."2D3D"%type,
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
                                                            i_novi_2D3D in RASPORED."2D3D"%type,
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
END P_REZERVACIJE;


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
       o_error_m:='Došlo je do pogreške, molimo pokušajte ponovo';
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
      o_error_m :='Došlo je do neočekivane pogreške, molimo pokušajte ponovo.';
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
           o_error_m :='Email se već koristi, molimo unesite drugi email.';
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
      o_error_m := 'Dogodila se pogreška u obradi podataka. Molimo vas pokušajte ponovo.';
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

    INSERT INTO FILMOVI(NAZIV,ZANR,TRAJANJE,POSTER_LINK,TRAILER_LINK,ID_CREATED,ID_UPDATED)
                values(i_naziv,i_zanr,i_trajanje,i_poster_link,i_trailer_link,1,1);
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
    o_error_m := 'Dogodila se neocekivana pogreška,molimo pokušajte ponovo';
END P_UNOS_FILMOVA;
--------------------------------------------------------------------------------------------------
PROCEDURE P_UNOS_RASPOREDA(i_id_filma in RASPORED.ID_FILMA%type,
                                                               i_dat_prikaz in RASPORED.DAT_PRIKAZ%type,
                                                               i_vri_prikaz in RASPORED.VRI_PRIKAZ%type,
                                                               i_2D3D in RASPORED."2D3D"%type,
                                                               o_error_c out number,
                                                               o_error_m out varchar) AS
l_filmovi_id FILMOVI.ID%type;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';
   IF NVL(i_id_filma,0)= 0 THEN
      o_error_c :=13;
      o_error_m := 'Molimo unesite ID filma';
      RAISE e_iznimka;
   END IF;

   IF (i_2D3D not in(0,1))THEN 
      o_error_c:=14;
      o_error_m:='Molimo unesite vrijednost 0 za 2D ili 1 3D film';
      RAISE e_iznimka;
   END IF;

  IF NVL(i_dat_prikaz,'01.01.0001')='01.01.0001' THEN
     o_error_c :=15;
     o_error_m :='Molimo unesite datum prikaz';
     RAISE e_iznimka;
   END IF;

   IF NVL(i_vri_prikaz,' ')= ' ' THEN
      o_error_c :=16;
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

   IF (l_filmovi_id=0) THEN
      o_error_c :=17;
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
          INSERT INTO RASPORED(ID_FILMA,DAT_PRIKAZ,VRI_PRIKAZ,"2D3D",CIJENA)
                      VALUES(i_id_filma,i_dat_prikaz,i_vri_prikaz,i_2D3D,35);
   END IF;
END IF;

EXCEPTION
   WHEN e_iznimka THEN
   NULL;
   WHEN OTHERS THEN
      o_error_c :=102;
      o_error_m := 'Dogodila se greška koju nismo ocekivali, molimo pokušajte ponovo';
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
       o_error_c :=18;
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
      o_error_c :=19;
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
         o_error_c:=20;
         o_error_m:='Dvorana je već unesena';
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
EXCEPTION
   WHEN e_iznimka THEN
   NULL;
   WHEN OTHERS THEN
      o_error_c :=103;
      o_error_m :='Došlo je do neocekivane pogreške, molimo pokušajte ponovo';
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
      o_error_c :=21;
      o_error_m :='Molimo unesite svoje novo ime ili staro ukoliko ga niste mijenjali.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_prezime,' ')=' ' THEN
      o_error_c :=22;
      o_error_m :='Molimo unesite svoje novo prezime ili staro ukoliko ga niste mijenjali.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_passw,' ')=' ' THEN
      o_error_c :=23;
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
        o_error_c :=24;
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
   o_error_c:=25;
   o_error_m:='Access denied!';
END IF;
COMMIT;
EXCEPTION
   WHEN e_iznimka THEN
   null;
      WHEN OTHERS THEN
      o_error_c :=104;
      o_error_m :='Dogodila se greška koju nismo očekivali, molimo pokušajte ponovo';
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
      o_error_c :=26;
      o_error_m :='Molimo unesite novi naziv filma ili stari ukoliko ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;

   IF (NVL(i_zanr, ' ')= ' ') THEN
      o_error_c :=27;
      o_error_m :='Molimo unesite novi žanr filma ili stari ukoliko ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;

   IF (NVL(i_trajanje,0)=0) THEN
      o_error_c :=28;
      o_error_m :='Molimo unesite novo trajanje filma u minutama ili staro ukoliko ne želite promijeniti.';
      RAISE e_iznimka; 
   END IF;
    IF (i_trajanje<90) AND
       (i_trajanje>240)THEN
       o_error_c :=29;
       o_error_m := 'Unesite vrijeme trajanja filma izmedu 90 i 240 minuta';
   END IF;  
   IF (NVL(i_poster_link,' ')=' ') THEN
      o_error_c :=30;
      o_error_m := 'Molimo unesite novi link postera filma ili stari ukoliko ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;

   IF (NVL(i_trailer_link,' ')=' ') THEN
      o_error_c :=31;
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
        o_error_c :=32;
        o_error_m :='Ne postoji uneseni email.';
        RAISE e_iznimka;
END IF;



    IF (l_old_naziv=' ') THEN
       o_error_c :=33;
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
         o_error_c:=34;
         o_error_m:='Access denied!';
END IF;
EXCEPTION
   WHEN e_iznimka THEN
   null;
   WHEN OTHERS THEN
      o_error_c :=105;
      o_error_m := 'Dogodila se neočekivana pogreška,molimo pokušajte ponovo.';
END P_UPDATE_FILMOVA; 

------------------------------------UPDATE RASPOREDA-----------------------------------------------------
PROCEDURE P_UPDATE_RASPOREDA(i_email in KORISNICI.EMAIL%type,
                                                            i_id_raspo RASPORED.ID%type,
                                                            i_novi_id_filma in RASPORED.ID_FILMA%type,
                                                            i_novi_dat_prikaz in RASPORED.DAT_PRIKAZ%type,
                                                            i_novo_vri_prikaz in RASPORED.VRI_PRIKAZ%type,
                                                            i_novi_2D3D in RASPORED."2D3D"%type,
                                                            o_error_c out number,
                                                            o_error_m out varchar2)AS
l_id_raspo RASPORED.ID%type;
l_id_filma FILMOVI.ID%type;
l_email KORISNICI.EMAIL%type;
BEGIN
   o_error_c :=0;
   o_error_m :=' ';

   IF NVL(i_id_raspo,0)=0 THEN
      o_error_c :=35;
      o_error_m :='Molimo unesite ID rasporeda.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_novi_id_filma,0)=0 THEN
      o_error_c :=36;
      o_error_m :='Molimo unesite novi ID filma, ili stari ukoliko ga ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_novi_dat_prikaz,'01.01.0001')='01.01.0001' THEN
      o_error_c :=37;
      o_error_m :='Molimo unesite novi datum prikazivanja, ili stari ukoliko ga ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_novo_vri_prikaz,' ')=' ' THEN
      o_error_c :=38;
      o_error_m :='Molimo unesite novo vrijeme prikazivanja, ili staro ukoliko ga ne želite promijeniti.';
      RAISE e_iznimka;
   END IF;

   IF (i_novi_2D3D not in(0,1)) THEN
      o_error_c :=39;
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
      o_error_c :=40;
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
        o_error_c :=41;
        o_error_m :='Ne postoji uneseni email.';
        RAISE e_iznimka;
END IF;

   IF(l_id_raspo=0) THEN
      o_error_c :=42;
      o_error_m :='Molimo unesite ID koji postoji';
      RAISE e_iznimka;
   END IF;

   IF(l_id_raspo=l_id_raspo) AND
     (F_CHECK_ADMIN(i_email,o_error_c,o_error_m)) THEN
      UPDATE RASPORED SET ID_FILMA=i_novi_id_filma,
                          DAT_PRIKAZ=i_novi_dat_prikaz,
                          VRI_PRIKAZ=i_novo_vri_prikaz,
                          "2D3D"=i_novi_2D3D
      WHERE ID=i_id_raspo;
  ELSE
    o_error_c:=43;
    o_error_m:='Access denied!';
  END IF;
EXCEPTION
   WHEN e_iznimka THEN
   NULL;
   WHEN OTHERS THEN
      o_error_c :=106;
      o_error_m :='Dogodila se neočekivana pogreška, molimo pokušajte ponovo.';
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
      o_error_c :=60;
      o_error_m :='Molimo unesite red u kojem želite rezervirati mjesto.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_sjed,0)=0 THEN
      o_error_c :=61;
      o_error_m :='Molimo unesite sjedalo koje želite rezervirati.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_id_raspo,0)=0 THEN
      o_error_c :=62;
      o_error_m :='Molimo unesite ID rasporeda za film koji želite rezervirati.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_email,' ')=' ' THEN
      o_error_c :=63;
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
      o_error_c :=64;
      o_error_m :='Molimo unesite postojeću email adresu.';
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
   o_error_c :=65;
   o_error_m :='Molimo odaberite sjedalo koje nije rezervirano!';
   RAISE e_iznimka;
    commit;
END IF;

EXCEPTION
   WHEN e_iznimka THEN
   NULL;
   WHEN OTHERS THEN
      o_error_c :=111;
      o_error_m :='Dogodila se neočekivana pogreška, molimo pokušajte ponovo.';
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
       o_error_c :=44;
       o_error_m :='Molimo unesite email.';
       RAISE e_iznimka;
    END IF;

    IF NVL(i_ovlasteni_email,' ')=' ' THEN
       o_error_c :=45;
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
          o_error_c :=46;
          o_error_m :='Unesite email koji se koristi.';
          RAISE e_iznimka;
          END IF;

          IF(l_email=l_ovlasteni_korisnik) AND
            (l_ovlasti>=1) OR
            (l_ovlasti=0) OR
            (l_ovlasti=1)THEN
             o_error_c :=47;
             o_error_m :='Nemate ovlasti za brisanje korisnika!';
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
        o_error_c :=107;
        o_error_m :='Dogodila se neocekivana pogreška, molimo pokušajte ponovo';
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
       o_error_c :=48;
       o_error_m := 'Molimo unesite email korisnika ovlaštenog za brisanje';
       RAISE e_iznimka;
    END IF;

    IF NVL(i_naziv_filma,' ')=' ' THEN
       o_error_c :=49;
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
   o_error_c :=50;
   o_error_m :='Molimo unesite film koji postoji';
   RAISE e_iznimka;
   ELSE
      IF(F_CHECK_ADMIN(i_ovlasteni_email,o_error_c,o_error_m)=TRUE) THEN
         DELETE FROM FILMOVI WHERE NAZIV=i_naziv_filma;
         o_rezultat :='Uspješno obrisan film!';
   ELSE
      o_error_c :=51;
      o_error_m :='Niste ovlašteni za brisanje filmova.';
      RAISE e_iznimka;
      END IF;
END IF;

EXCEPTION
  WHEN e_iznimka THEN
  NULL;
  WHEN OTHERS THEN
     o_error_c :=108;
     o_error_m :='Dogodila se neočekivana pogreška, molimo pokušajte ponovo.';
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
      o_error_c :=52;
      o_error_m :='Molimo unesite email ovlaštene osobe.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_id,0)=0 THEN
      o_error_c :=53;
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
       o_error_c:=54;
       o_error_m :='Molimo unesite ID rasporeda koji postoji!';
       RAISE e_iznimka;
     ELSE
        IF(F_CHECK_ADMIN(i_ovlasteni_email,o_error_c,o_error_m)) THEN
        DELETE FROM RASPORED WHERE ID=i_id;
        o_rezultat :='Raspored uspješno obrisan!';
    ELSE
       o_error_c:=55;
       o_error_m:='Niste ovlašteni za brisanje rasporeda';
    END IF;
END IF;
EXCEPTION
  WHEN e_iznimka THEN
  NULL;
  WHEN OTHERS THEN
     o_error_c :=109;
     o_error_m :='Došlo je do neočekivane pogreške, molimo pokušajte ponovo';
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
      o_error_c :=56;
      o_error_m :='Molimo unesite email.';
      RAISE e_iznimka;
   END IF;

   IF NVL(i_id_raspo,0)=0 THEN
      o_error_c :=57;
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
      ID_RASPO=i_id_raspo;
   EXCEPTION
   WHEN OTHERS THEN
      l_id_raspo :=0;
END;

   IF(l_id_raspo=0) THEN
      o_error_c :=58;
      o_error_m :='Molimo unesite ID rasporeda koji se koristi!';
      RAISE e_iznimka;
   ELSE 
      IF(F_CHECK_ADMIN(i_ovlasteni_email,o_error_c,o_error_m)=TRUE) THEN
         DELETE FROM REZERVACIJE WHERE ID_RASPO=i_id_raspo;
         o_rezultat :='Uspješno obrisana dvorana.';
      ELSE
         o_error_c :=59;
         o_error_m :='Niste ovlašteni za brisanje dvorane.';
         RAISE e_iznimka;
      END IF;
   END IF;
EXCEPTION
   WHEN e_iznimka THEN
   NULL;
   WHEN OTHERS THEN
      o_error_c := 110;
      o_error_m :='Došlo je do neočekivane pogreške, molimo pokušajte ponovo.';
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
         ID,
         IME,
         PREZIME,
         EMAIL,
         PASSWORD,
         OVLASTI
      FROM
         KORISNICI
      WHERE
         ID IS NOT NULL;
      o_rezultat :=l_cursor;
EXCEPTION
   WHEN OTHERS THEN
   o_error_c :=112;
   o_error_m :='Dogodila se pogreška u obradi podataka, molimo pokušajte ponovo.';
END P_DOHVATI_KOR;          
END P_REZERVACIJE;


----------------------------------ANONIMNI BLOKOVI ZA POZIV FUNKCIJA/PROCEDURA--------------------------
/*
SET SERVEROUTPUT ON;
DECLARE
  l_id_koris korisnici.id%type;
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
BEGIN
   P_REZERVACIJE.P_UNOS_KOR('Tomislav','Adamović','Tadamdovic@vub.hr','123',l_id_koris,l_error_c,l_error_m);
   IF L_ERROR_C > 0 THEN
      DBMS_OUTPUT.PUT_LINE(L_ERROR_M || ' Error code= ' || L_ERROR_C);
   ELSE
      DBMS_OUTPUT.PUT_LINE('VAŠ ID JE ' || l_id_koris);
   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('TEST' || l_error_c || SQLERRM);
END;
SELECT * FROM KORISNICI;
----------------------------------UNOS FILMA---------------------------------------
DECLARE
   l_o_id_filma FILMOVI.ID%type;
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
BEGIN
   P_REZERVACIJE.P_UNOS_FILMOVA('Lord of the Rings','Sci-fi,Adventure',200,'eee','štagaaod1',l_o_id_filma,l_o_error_c,l_o_error_m);
   IF (l_o_error_c>0) THEN
      dbms_output.put_line( l_o_error_c || ' ' || l_o_error_m);
   ELSE
      dbms_output.put_line('Film je unesen,ID filma je ' || l_o_id_filma || '.');
   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line('Došlo je do neočekivane pogreške, molimo pokušajte ponovo');
END;

SELECT * FROM FILMOVI;

------------------------------UNOS RASPOREDA ZA PRIKAZIVANJE FILMA---------------------------
DECLARE
   l_2D number :=0;
   l_3D number :=1;
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
BEGIN
   P_REZERVACIJE.P_UNOS_RASPOREDA(1,'19.01.2019','15:30',l_2D,l_error_c,l_error_m);
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
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
BEGIN
 P_REZERVACIJE.P_UNOS_DVORANE(2,l_error_c , l_error_m );
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
  l_id_koris korisnici.id%type;
  l_error_c number := 0;
  l_error_m varchar2(300):=' ';
BEGIN

   P_REZERVACIJE.P_UPDATE_KOR('robo.kova@gmail.com','1414rad@gmail.com','Tomislav','Adamović','1414rad@gmail.com','12ar3',l_error_c,l_error_m);
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
   l_error_c number :=0;
   l_error_m varchar2(300) :=' ';
BEGIN
   P_REZERVACIJE.P_UPDATE_FILMOVA('tadamović@vub.hr','Aquamana','Aquaman','Wi-fi',80,'cccaaa','bbbbddddcc',l_error_c,l_error_m);
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
   l_error_c number:=0;
   l_error_m varchar2(300):=' ';
   l_2D number:=0;
   l_3D number:=1;
BEGIN
P_REZERVACIJE.P_UPDATE_RASPOREDA('1414rad@gmail.com',32,2,'10.12.2018','18:00',l_2D,l_error_c,l_error_m);
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
   l_ovlasteni_email varchar2(40) :='iva.maric@gmail.com';
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
   l_ovlasteni_email varchar2(40) :='dev.auser@vub.hr';
   l_id_raspo varchar2(40) :=1;
BEGIN
   P_REZERVACIJE.P_BRISANJE_RASPOREDA(l_ovlasteni_email,l_id_raspo,l_error_c,l_error_m,l_rezultat);
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
  l_sjed number(2) := 11;
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


SELECT * FROM REZERVACIJE;*/