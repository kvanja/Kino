SET SERVEROUTPUT ON;

DECLARE
L_REZERVACIJA REZERVACIJA%ROWTYPE;
BEGIN
  SELECT *
  INTO
    L_REZERVACIJA
  FROM
    REZERVACIJA
  WHERE
  ID IS NOT NULL;

DBMS_OUTPUT.PUT_LINE('U rezervaciji sa ID-em ' ||L_REZERVACIJA.ID || ' ,ID-em rasporeda ' || L_REZERVACIJA.ID_RASPO || ' u redu broj ' || L_REZERVACIJA.REDOVI);
  IF (L_REZERVACIJA.SJED_1=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 1 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_2=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 2 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_3=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 3 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_4=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 4 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_5=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 5 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_6=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 6 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_7=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 7 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_8=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 8 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_9=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 9 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_10=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 10 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_11=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 11 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_12=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 12 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_13=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 13 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_14=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 14 je rezervirano');
  END IF;
  IF  (L_REZERVACIJA.SJED_15=1)THEN
         DBMS_OUTPUT.PUT_LINE('Sjedalo 15 je rezervirano');
  END IF;
END;

DECLARE
CURSOR cur_get_reservation IS
SELECT
  id,
  id_raspo,
  redovi,
  sjed_1,
  sjed_2,
  sjed_3,
  sjed_4,
  sjed_5,
  sjed_6,
  sjed_7,
  sjed_8,
  sjed_9,
  sjed_10,
  sjed_11,
  sjed_12,
  sjed_13,
  sjed_14,
  sjed_15
FROM
    REZERVACIJA
WHERE ID_RASPO=1;
l_rezervacija cur_get_reservation%rowtype;
BEGIN
  OPEN cur_get_reservation;
  LOOP
    FETCH cur_get_reservation INTO l_rezervacija;
    EXIT WHEN cur_get_reservation%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('U rezervaciji sa ID-em ' || l_rezervacija.ID || ', ID-em rasporeda ' || l_rezervacija.ID_RASPO || ' u redu broj ' || l_rezervacija.REDOVI);
        IF (L_REZERVACIJA.SJED_1=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 1 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 1 je slobodno');
        END IF;
        IF  (L_REZERVACIJA.SJED_2=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 2 je rezervirano');
            ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 2 je slobodno');
        END IF;
        IF  (L_REZERVACIJA.SJED_3=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 3 je rezervirano');
            ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 3 je slobodno');
        END IF;
        IF (L_REZERVACIJA.SJED_4=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 4 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 4 je slobodno');
        END IF;
        IF (L_REZERVACIJA.SJED_5=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 5 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 5 je slobodno');
        END IF;
        IF (L_REZERVACIJA.SJED_6=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 6 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 6 je slobodno');
        END IF;
        IF (L_REZERVACIJA.SJED_7=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 7 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 7 je slobodno');
        END IF;
        IF (L_REZERVACIJA.SJED_8=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 8 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 8 je slobodno');
        END IF;
        IF (L_REZERVACIJA.SJED_9=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 9 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 9 je slobodno');
        END IF;
        IF (L_REZERVACIJA.SJED_10=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 10 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 10 je slobodno');
        END IF;
        IF (L_REZERVACIJA.SJED_11=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 11 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 11 je slobodno');
        END IF;
        IF (L_REZERVACIJA.SJED_12=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 12 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 12 je slobodno');
        END IF;
        IF (L_REZERVACIJA.SJED_13=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 13 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 13 je slobodno');
        END IF;
        IF (L_REZERVACIJA.SJED_14=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 14 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 14 je slobodno');
        END IF;
        IF (L_REZERVACIJA.SJED_15=1)THEN
            DBMS_OUTPUT.PUT_LINE('Sjedalo 15 je rezervirano');
             ELSE
               DBMS_OUTPUT.PUT_LINE('Sjedalo 15 je slobodno');
        END IF;
    dbms_output.new_line;
END LOOP;
CLOSE cur_get_reservation;    
END;
