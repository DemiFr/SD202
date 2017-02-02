
CREATE OR REPLACE PROCEDURE VSTAT (x NUMBER) AS
--DECLARE a cursor of PRODUCTEURS
cursor P_CUR is select REGION, COUNT(NP) AS Nombre_NP from PRODUCTEURS
                where NP in (select NP from RECOLTES, VINS
                             where RECOLTES.NV = VINS.NV
                             and VINS.NV = x)
                group by REGION
                order by COUNT(NP) DESC;

--DECLARE a cursor of ACHATS
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
  dbms_output.put_line('Regions de production du vin numero' || x);
  for V_Ligne in P_CUR
  loop
    dbms_output.new_line;
    dbms_output.put_line(V_Ligne.REGION || '(' || V_Ligne.Nombre_NP || ' producteurs)');
  end loop;
  dbms_output.new_line;
  dbms_output.put_line(chr(0)||chr(9));

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
        dbms_output.put_line(chr(9)||S_Ligne.ANNEE || ' : ' ||S_Ligne.consommation);
      END IF;
    end loop;

  end loop;
END;
/
