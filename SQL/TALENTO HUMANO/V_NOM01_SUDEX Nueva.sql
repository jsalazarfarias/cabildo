DROP VIEW SISESMER.V_NOM01_SUDEX;

/* Formatted on 2021/11/11 11:52 (Formatter Plus v4.8.8) */
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
                                                     per01codi,
                                                     anio,
                                                     mes_numero
                                                    )
AS
   SELECT   (SELECT TRUNC (TO_DATE (rol01fecha, 'dd-mm-rrrr'))
               FROM rol01
              WHERE rol01.rol01codi = a.rol01codi) fecha, a.trol02codi,
            a.reg01codi, pk_nomtitulos.fd_regimen (a.reg01codi) regimen,
            a.departamento, pk_flow.f_departamento (a.departamento),
            a.codigo_funcionario nom01codi,
            (SELECT nom01cedual
               FROM nom01
              WHERE nom01.nom01codi = a.codigo_funcionario) cedula,
            a.nombre_funcionario empleado, a.unificado, a.descripcion_ingreso,
            CASE a.descripcion_ingreso
               WHEN 'Horas Extras'
                  THEN NVL ((SELECT    SUM (NVL (g.hora_entra1, 0))
                                    || ':'
                                    || SUM (NVL (g.min_entra1, 0))
                               FROM asi02 g
                              WHERE g.per01codi = a.per01codi
                                AND g.nom01codi = a.codigo_funcionario),
                            0
                           )
               WHEN 'Horas Suplementarias'
                  THEN NVL ((SELECT    SUM (NVL (g.hora_sale1, 0))
                                    || ':'
                                    || SUM (NVL (g.min_sale1, 0))
                               FROM asi02 g
                              WHERE g.per01codi = a.per01codi
                                AND g.nom01codi = a.codigo_funcionario),
                            0
                           )
               WHEN 'Trabajo Nocturno 25%'
                  THEN NVL ((SELECT    SUM (NVL (g.hora_nocturna, 0))
                                    || ':'
                                    || SUM (NVL (g.min_nocturna, 0))
                               FROM asi02 g
                              WHERE g.per01codi = a.per01codi
                                AND g.nom01codi = a.codigo_funcionario),
                            0
                           )
               ELSE '0'
            END tiempo,
            nvl(CASE
               WHEN (SELECT nom01acum_d3ro
                       FROM nom01
                      WHERE nom01.nom01codi = a.codigo_funcionario) =
                                                                   1
                  THEN (SELECT SUM (ingreso)
                          FROM v_rol_individual b
                         WHERE b.rol01codi = a.rol01codi
                           AND b.con01codi = 46)
               ELSE 0
            END,0) dco_3ero,
            a.ingreso vl_total, a.per01codi, a.anio, a.mes_numero
       FROM v_rol_individual a
      WHERE a.descripcion_ingreso IN
               ('Horas Extras', 'Horas Suplementarias',
                'Trabajo Nocturno 25%', 'DECIMO TERCER SUELDO')
      ORDER BY 4, 2, 5, 8, 1;

DROP PUBLIC SYNONYM V_NOM01_SUDEX;

CREATE PUBLIC SYNONYM V_NOM01_SUDEX FOR SISESMER.V_NOM01_SUDEX;

