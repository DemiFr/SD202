CREATE OR REPLACE PROCEDURE VSTAT (x NUMBER) AS
cursor A_CUR is select LIEU, EXTRACT(year FROM ACHATS.DATES) AS ANNEE, SUM(QTE) AS consommation
                from ACHATS
                where NV = x
                group by LIEU, EXTRACT(year FROM ACHATS.DATES)
                order by LIEU, EXTRACT(year FROM ACHATS.DATES);

cursor SUM_CUR is select LIEU, SUM(QTE) AS SUM
                  from ACHATS
                  where NV = x
                  group by LIEU
                  order by SUM(QTE) DESC;

BEGIN
  dbms_output.new_line;
  dbms_output.put_line('Vente du vin numero ' || x);
  for V_Ligne in SUM_CUR
  loop
    dbms_output.new_line;
    dbms_output.put_line(V_Ligne.LIEU ||'('|| V_Ligne.SUM || ' bouteilles)');

    for S_Ligne in A_CUR
    loop
      IF S_Ligne.LIEU = V_Ligne.LIEU THEN
        dbms_output.new_line;
        dbms_output.put_line(S_Ligne.ANNEE || ' : ' ||S_Ligne.consommation);
      END IF;
    end loop;

  end loop;
END;
/

--order by SUM(QTE) DESC;
/*
--COUNT must be used together with GROUP BY !!!!!

*/

SET SERVEROUTPUT ON
EXECUTE dbms_output.enable(1000000);
BEGIN
  VSTAT(1);
END;
/
