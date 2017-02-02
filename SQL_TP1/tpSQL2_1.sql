#1
select type
from buveurs
group by type
/
#2
select * from vins
order by cru, mill desc
/
#3
SELECT REGION
FROM PRODUCTEURS P, RECOLTES R, VINS V
WHERE P.NP = R.NP
AND R.NV = V.NV
AND (V.CRU = 'Pommard' OR V.CRU = 'Brouilly')
/
#4
SELECT REGION
FROM PRODUCTEURS P,RECOLTES R,VINS V
WHERE P.NP = R.NP
AND R.NV = V.NV
AND V.CRU = 'Pommard'
AND EXISTS(SELECT *
		FROM P,R,V
		WHERE P.NP = R.NP
		AND R.NV = V.NV
		AND V.CRU = 'Brouilly')
/
#5
SELECT SUM(QTE),CRU,MILL
FROM ACHATS A,VINS V
WHERE A.NV = V.NV
GROUP BY CRU,MILL
/
#6
SELECT NV
FROM RECOLTES
GROUP BY NV
HAVING COUNT(NP)>3
/
#7