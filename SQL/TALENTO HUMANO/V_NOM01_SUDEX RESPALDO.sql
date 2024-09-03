DROP VIEW SISESMER.V_NOM01_SUDEX;

/* Formatted on 2021/11/11 11:47 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW sisesmer.v_nom01_sudex (fecha,
                                                     trol02codi,
                                                     reg01codi,
                                                     regimen,
                                                     cod_departamento,
                                                     departamento,
                                                     nom01codi,
                                                     cedula,
                                                     empleado,
                                                     unificado,
                                                     concepto,
                                                     tiempo,
                                                     dco_3ero,
                                                     vl_total,
                                                     per01codi
                                                    )
AS
   SELECT   TRUNC (c.rol01fecha) fecha, a.trol02codi, a.reg01codi,
            pk_nomtitulos.fd_regimen (a.reg01codi) regimen,
            b.departamento cod_departamento,
            pk_flow.f_departamento (b.departamento) departamento, d.nom01codi,
            d.nom01cedual cedula, pk_uti.nom01_com (d.nom01codi) empleado,
            b.unificado, REPLACE (e.con01desc, ' ', '_') concepto,
            CASE e.con01desc
               WHEN 'Horas Extras'
                  THEN NVL ((SELECT    SUM (NVL (g.hora_entra1, 0))
                                    || ':'
                                    || SUM (NVL (g.min_entra1, 0))
                               FROM asi02 g
                              WHERE g.per01codi = a.per01codi
                                AND g.nom01codi = d.nom01codi),
                            0
                           )
               WHEN 'Horas Suplementarias'
                  THEN NVL ((SELECT    SUM (NVL (g.hora_sale1, 0))
                                    || ':'
                                    || SUM (NVL (g.min_sale1, 0))
                               FROM asi02 g
                              WHERE g.per01codi = a.per01codi
                                AND g.nom01codi = d.nom01codi),
                            0
                           )
               WHEN 'Trabajo Nocturno 25%'
                  THEN NVL ((SELECT    SUM (NVL (g.hora_nocturna, 0))
                                    || ':'
                                    || SUM (NVL (g.min_nocturna, 0))
                               FROM asi02 g
                              WHERE g.per01codi = a.per01codi
                                AND g.nom01codi = d.nom01codi),
                            0
                           )
               ELSE '0'
            END tiempo,
            CASE d.nom01acum_d3ro
               WHEN '1'
                  THEN NVL
                         ((SELECT SUM (NVL (ROUND (g.rol01valori, 2), 0))
                             FROM rol01 g
                            WHERE g.rol01codi = c.rol01codi
                              AND g.car03codi = f.car03codi
                              AND f.con01codi IN (46)),
                          0
                         )
               WHEN '0'
                  THEN 0
               ELSE 0                              --ROUND(B.UNIFICADO /12, 2)
            END dco_3ero,
            (NVL (c.rol01valori, 0)) vl_total, a.per01codi
       FROM trol02 a, trol01 b, rol01 c, nom01 d, con01 e, car03 f
      WHERE a.trol02codi = b.trol02codi
        AND b.trol01codi = c.trol01codi
        AND b.nom01codis = d.nom01codi
        AND e.con01codi = f.con01codi
        AND f.car03codi = c.car03codi
        AND c.car03codi IS NOT NULL
        AND e.con01desc IN
               ('Horas Extras', 'Horas Suplementarias',
                'Trabajo Nocturno 25%', 'DECIMO TERCER SUELDO')
        AND b.trol01esta = 'G'
        AND d.nom01estado = '1'
   --AND D.NOM01CODI = '4747'
   --AND D.NOM01ESTADO = '1'
   --AND C.ROL01FECHA >= TO_DATE(P_FECH1,'DD-MM-RRRR') AND C.ROL01FECHA <= TO_DATE(P_FECH2,'DD-MM-RRRR')
   ORDER BY 4, 2, 5, 8, 1;


DROP PUBLIC SYNONYM V_NOM01_SUDEX;

CREATE PUBLIC SYNONYM V_NOM01_SUDEX FOR SISESMER.V_NOM01_SUDEX;

