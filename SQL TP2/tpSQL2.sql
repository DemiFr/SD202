/*
//tpSQL2_1_2
UPDATE BUVEURS
SET TYPE = 'gros'
WHERE TYPE IN (SELECT TYPE
		    FROM BUVEURS B, ACHATS A
		    WHERE A.QTE>=100 AND A.NB = B.NB)

/

//tpSQL2_1_3
INSERT INTO BONS_BUVEURS
VALUES(102, 'Li', 'Yanting', 'moyen')
/
Oui, ce buveur est visible à travers la vue.

//tpSQL2_1_4
INSERT INTO BONS_BUVEURS
VALUES(103, 'z', 'Nicholas', 'petit')
/
C'est pas possible d'insérer dans la vue BONS_BUVEURS parce que il n'y a que 'moyen' et 'gros' dans cette vue

//tpSQL2_1_5
create view bons_buveurs as
select * from buveurs
where type ='gros' or type = 'moyen'
with check option;

//tpSQL2_1_6
create view buveurs_Achats as
select * from buveurs
where  nb in (select nb from Achats)
with check option;  --max(NB) = 100

create view buveurs_Achats2 as
select * from buveurs
where nb not in (select nb from buveurs_asec)
with check option;  --max(NB) = 100
*/

insert into buveurs_Achats
values(103, 'A','Nicholas','petit');
