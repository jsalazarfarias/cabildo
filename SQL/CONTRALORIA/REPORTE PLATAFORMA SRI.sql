select d.nom01codi, PK_NOMTITULOS.FD_CEDULA(D.NOM01CODI),
       PK_UTI.NOM01_COM(D.NOM01CODI), (SELECT SUM(ROL01VALORI) 
                                       FROM ROL01 WHERE TROL01CODI IN (SELECT TROL01CODI 
                                                                       FROM TROL01 
                                                                       WHERE NOM01CODIS = D.NOM01CODI)
                                       AND CAR03CODI IN (67410, 82415)) SALARIO_ANUAL,
                                       (SELECT SUM(ROL01VALORI) 
                                       FROM ROL01 WHERE TROL01CODI IN (SELECT TROL01CODI 
                                                                       FROM TROL01 
                                                                       WHERE NOM01CODIS = D.NOM01CODI)
                                       AND CAR03CODI IN (67439)) SUBSIDIO_ANTIG_ANUAL,
                                       (SELECT SUM(ROL01VALORI) 
                                       FROM ROL01 WHERE TROL01CODI IN (SELECT TROL01CODI 
                                                                       FROM TROL01 
                                                                       WHERE NOM01CODIS = D.NOM01CODI)
                                       AND CAR03CODI IN (4408)) HORAS_EXTRAS_ANUAL,
                                       (SELECT SUM(ROL01VALORI) 
                                       FROM ROL01 WHERE TROL01CODI IN (SELECT TROL01CODI 
                                                                       FROM TROL01 
                                                                       WHERE NOM01CODIS = D.NOM01CODI)
                                       AND CAR03CODI IN (386)) HORAS_SUPL_ANUAL,
                                       (SELECT SUM(ROL01VALORI) 
                                       FROM ROL01 WHERE TROL01CODI IN (SELECT TROL01CODI 
                                                                       FROM TROL01 
                                                                       WHERE NOM01CODIS = D.NOM01CODI)
                                       AND CAR03CODI IN (41162, 49938)) FONDO_RESER_ANUAL,
                                       CASE NVL((SELECT SUM(ROL01VALORI) 
                                       FROM ROL01 WHERE TROL01CODI IN (SELECT TROL01CODI 
                                                                       FROM TROL01 
                                                                       WHERE NOM01CODIS = D.NOM01CODI)
                                       AND CAR03CODI IN (82467, 82935)),0) 
                                       WHEN 0 THEN B.UNIFICADO
                                       ELSE NVL((SELECT SUM(ROL01VALORI) 
                                       FROM ROL01 WHERE TROL01CODI IN (SELECT TROL01CODI 
                                                                       FROM TROL01 
                                                                       WHERE NOM01CODIS = D.NOM01CODI)
                                       AND CAR03CODI IN (82467, 82935)),0) 
                                       END DECIMO_TERCER_ANUAL,
                                       CASE NVL((SELECT SUM(ROL01VALORI) 
                                       FROM ROL01 WHERE TROL01CODI IN (SELECT TROL01CODI 
                                                                       FROM TROL01 
                                                                       WHERE NOM01CODIS = D.NOM01CODI)
                                       AND CAR03CODI IN (82480)),0) 
                                       WHEN 0 THEN V_SALARIOMINIMO(2019)
                                       ELSE NVL((SELECT SUM(ROL01VALORI) 
                                       FROM ROL01 WHERE TROL01CODI IN (SELECT TROL01CODI 
                                                                       FROM TROL01 
                                                                       WHERE NOM01CODIS = D.NOM01CODI)
                                       AND CAR03CODI IN (82480)),0) 
                                       END DECIMO_CUARTO_ANUAL
from rol01 a, trol01 b, trol02 c, nom01 d, per01 g
where a.trol01codi = b.trol01codi
and b.trol02codi = c.trol02codi
and b.nom01codis = d.nom01codi
and d.nom01estado = 1
AND c.per01codi = g.per01codi
and per01fini >= to_date('01-01-2019','dd-mm-rrrr')
and per01fini <= to_date('31-12-2019','dd-mm-rrrr')
--and b.nom01codis in (345, 663, 297)
group by d.nom01codi, B.UNIFICADO
