/*
DECLARE
    x  NUMBER := 1;
BEGIN
    WHILE x < 100 LOOP
          DELETE FROM ACHATS WHERE nv=x;
	  x := x + 2;
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..100 LOOP
      IF MOD(i,2) = 0 THEN     -- i est pair
	       UPDATE ACHATS SET QTE=QTE*2 WHERE nv=i;
	    ELSE
	       UPDATE ACHATS SET QTE=QTE/2 WHERE nv=i;
	    END IF;
    END LOOP;
END;
/

CREATE TABLE TEMP (Vin NUMBER(3), description VARCHAR2(30),commentaire VARCHAR2(30));


DECLARE
   cursor V_CUR is select * from vins
              where nv in (select nv from recoltes, producteurs
                           where region='Alsace' and producteurs.np=recoltes.np)
              order by nv;
-- declare record variable that represents a row fetched from the employees table
   V_LIGNE VINS%ROWTYPE;
BEGIN
-- open the explicit cursor and use it to fetch data into employee_rec
   open V_CUR;
   loop
       fetch V_CUR into V_Ligne;
       exit when V_CUR%NOTFOUND;
       IF V_Ligne.mill in (1976, 1978, 1983) THEN
	        INSERT INTO TEMP
		      VALUES (V_Ligne.nv, V_Ligne.cru || '(' || to_char(V_Ligne.mill) || ')', 'Récolte exeptionelle !');
       ELSE
          INSERT INTO TEMP
		      VALUES (V_Ligne.nv, V_Ligne.cru || '(' || to_char(V_Ligne.mill) || ')', 'RAS !');
       END IF;
   end loop;
   close V_CUR;
END;
/

DECLARE
   cursor V_CUR is select * from vins
              where nv in (select nv from recoltes, producteurs
                           where region='Alsace' and producteurs.np=recoltes.np)
              order by nv;
BEGIN
   for V_Ligne in V_CUR
   loop
       IF V_Ligne.mill in (1976, 1978, 1983) THEN
	        INSERT INTO TEMP
		      VALUES (V_Ligne.nv, V_Ligne.cru || '(' || to_char(V_Ligne.mill) || ')', 'Récolte exeptionelle !');
       ELSE
          INSERT INTO TEMP
		      VALUES (V_Ligne.nv, V_Ligne.cru || '(' || to_char(V_Ligne.mill) || ')', 'RAS !');
       END IF;
   end loop;
END;
/


CREATE OR REPLACE PROCEDURE choix_experts AS
--DECLARE
   cursor V_CUR is select * from vins
              where nv in (select nv from recoltes, producteurs
                           where region='Alsace' and producteurs.np=recoltes.np)
              order by nv;
BEGIN
   for V_Ligne in V_CUR loop
       IF V_Ligne.mill in (1976, 1978, 1983) THEN
          INSERT INTO TEMP
		      VALUES (V_Ligne.nv, V_Ligne.cru || '(' || to_char(V_Ligne.mill) || ')', 'Récolte exeptionelle !');
       ELSE
          INSERT INTO TEMP
		      VALUES (V_Ligne.nv, V_Ligne.cru || '(' || to_char(V_Ligne.mill) || ')', 'RAS !');
       END IF;
   end loop;
END;
/


EXECUTE choix_experts;
/
/*
OU

BEGIN
  choix_experts;
END;
/
*/
CREATE OR REPLACE FUNCTION recherche_vins (r PRODUCTEURS.REGION%TYPE, annee VINS.MILL%TYPE) RETURN number AS
--DECLARE
--   r PRODUCTEURS.REGION%TYPE;
--   annee VINS.MILL%TYPE;
   cursor V_CUR is select * from vins
              where nv in (select nv from recoltes, producteurs
                           where region=r and producteurs.np=recoltes.np)
              order by nv;
   cpt number:=0;

BEGIN
   for V_Ligne in V_CUR
   loop
       IF V_Ligne.mill = annee THEN
	        INSERT INTO TEMP
		      VALUES (V_Ligne.nv, V_Ligne.cru || '(' || to_char(V_Ligne.mill) || ')', 'Recolte exeptionelle !');
          cpt:=cpt+1;
       END IF;
   end loop;
   RETURN cpt;
END;
/


SET SERVEROUTPUT ON
EXECUTE dbms_output.enable(1000000);

DECLARE
  x number;
BEGIN
  x:=recherche_vins('Alsace',1983);
  dbms_output.new_line;
  dbms_output.put_line(x || ' vins selectionnes ');
END;
/
