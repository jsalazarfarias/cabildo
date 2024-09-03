DROP VIEW SISESMER.V_TOTDIASDISP;

/* Formatted on 2021/04/13 12:01 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW sisesmer.v_totdiasdisp (nom01codi,
                                                     fech_ingreso,
                                                     periodo,
                                                     dias,
                                                     horas,
                                                     minutos,
                                                     regimen
                                                    )
AS
   SELECT   c.nom01codi, c.nom01fingreso fech_ingreso, b.nomca02per periodo,
            totdiasdisp (a.nom01codi) dias, tothorasdisp (a.nom01codi) horas,
            totmindisp (a.nom01codi) minutos,
            NVL
               ((SELECT b.reg01bl
                   FROM reg01 b
                  WHERE b.reg01codi IN
                                    (pk_nomtitulos.f_regactivo (c.nom01codi))),
                'SIN REGIMEN ASIGNADO'
               )
       FROM nomca01 a, nomca02 b, nom01 c
      WHERE b.nomca02per = (SELECT MAX (d.nomca02per)
                              FROM v_detvacaciones d
                             WHERE a.nom01codi = d.nom01codi)
        -- AND A.NOM01CODI = 297--:NOMCA01.NOM01CODI
        AND nomca02esta = 'AP'
        AND a.nomca01codi = b.nomca01codi
        AND a.nom01codi = c.nom01codi
        AND c.nom01estado = '1'
        AND NVL
               ((SELECT b.reg01bl
                   FROM reg01 b
                  WHERE b.reg01codi IN
                                    (pk_nomtitulos.f_regactivo (c.nom01codi))),
                'SIN REGIMEN ASIGNADO'
               ) NOT LIKE ('%SIN REGIMEN ASIGNADO%')
   GROUP BY a.nom01codi, b.nomca02per, c.nom01codi, c.nom01fingreso;


DROP PUBLIC SYNONYM V_TOTDIASDISP;

CREATE PUBLIC SYNONYM V_TOTDIASDISP FOR SISESMER.V_TOTDIASDISP;

