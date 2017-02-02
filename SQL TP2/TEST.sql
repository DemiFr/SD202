--DROP TABLE TEMP_1;

--DROP TABLE TEMP_CLASSEMENT;

--DROP PROCEDURE VSTAT;

CREATE OR REPLACE PROCEDURE VSTAT (x NUMBER) AS

cursor A_CUR is select EXTRACT(year FROM DATES) AS ANNEE, LIEU, SUM(QTE) AS consommation
                from ACHATS
                where NV = x
                group by EXTRACT(year FROM DATES), LIEU
                order by ANNEE;

BEGIN
dbms_output.new_line;
dbms_output.put_line('Vente du vin numero ' || x);
for V_Ligne in A_CUR
loop
  INSERT INTO TEMP_CLASSEMENT
  VALUES (x, V_Ligne.ANNEE, V_Ligne.LIEU, V_Ligne.consommation);
  dbms_output.new_line;
  dbms_output.put_line(x || ' ' || V_Ligne.ANNEE || ' ' || V_Ligne.LIEU || ' ' || V_Ligne.consommation);
end loop;
END;
/



SET SERVEROUTPUT ON
EXECUTE dbms_output.enable(1000000);
BEGIN
  VSTAT(9);
END;
/
create or replace procedure vstat(v v.nv%type) as
        cursor v_cur2 is select lieu, extract(year from a.dates) as year, sum(qte)as sum from a
                where nv=v
                group by extract(year from a.dates), lieu
                order by lieu, extract(year from a.dates), sum(qte) desc;
        cursor v_cur3 is select lieu, sum(qte) as sum from a
                where nv=v
                group by lieu
                order by lieu;
begin

        dbms_output.new_line;
         dbms_output.put_line('Vente du vin numero '|| v);
         for v_ligne1 in v_cur3 loop
                 dbms_output.new_line;
                 dbms_output.put_line(chr(9)||v_ligne1.lieu||'('||v_ligne1.sum||'b'||')');
                for v_ligne in v_cur2 loop
                        if v_ligne1.lieu=v_ligne.lieu then
                                dbms_output.new_line;
                                 dbms_output.put_line(chr(9)||chr(9)||v_ligne.year||':'||v_ligne.sum);
                         end if;
                end loop;
        end loop;
end;
/
