SELECT DISTINCT NB
FROM ACHATS A, VINS V
WHERE A.NV = V.NV
AND V.MILL = '1980'

/