insert into a values(45, 12, sysdate, 'Paris', 20);
insert into a values(45, 12, sysdate, 'Paris', 33);
insert into a values(45, 12, to_date('13/02/2003', 'dd/mm/yyyy'), 'Paris', 10);
insert into a values(45, 12, to_date('13/02/2003', 'dd/mm/yyyy'), 'Paris', 11);
insert into a values(45, 12, sysdate, 'Lille', 33);
insert into a values(45, 12, sysdate, 'Lille', 13);
insert into a values(45, 12, to_date('13/02/2001', 'dd/mm/yyyy'), 'Lille', 15);
insert into a values(45, 12, to_date('13/02/2001', 'dd/mm/yyyy'), 'Lille', 16);
/


CREATE TABLE TEMP_1(nv NUMBER(5), region VARCHAR2(30), np NUMBER);
--X REGIONS SELECTIONS
CREATE TABLE TEMP_CLASSEMENT(nv NUMBER(5), annee NUMBER(4), lieu VARCHAR2(30), consommation NUMBER(5));



CREATE OR REPLACE PROCEDURE VSTAT (x NUMBER) AS
cursor A_CUR is select LIEU, EXTRACT(year FROM ACHATS.DATES) AS ANNEE, SUM(QTE) AS consommation
                from ACHATS
                where NV = x
                group by LIEU, EXTRACT(year FROM ACHATS.DATES)
                order by LIEU, ANNEE;

cursor SUM_CUR is select LIEU, SUM(QTE) AS SUM
                  from ACHATS
                  where NV = x
                  group by LIEU
                  order by SUM(QTE) DESC;

BEGIN
  dbms_output.new_line;
  dbms_output.put_line('Vente du vin numero ' || x);
  for V_Linge in SUM_CUR
  loop
    dbms_output.new_line;
    dbms_output.put_line(V_Ligne.LIEU ||'('|| V_Ligne.SUM || ' bouteilles)');

    for S_Linge in A_CUR
    loop
      IF S_Ligne.LIEU = V_Ligne.LIEU THEN
        dbms_output.new_line;
        dbms_output.put_line(S_Ligne.ANNEE || ' : ' ||S_Ligne.consommation);
      END IF;
    end loop;

  end loop;
END;
/
