DROP VIEW SISESMER.V_ROL_MENSUAL;

/* Formatted on 2020/01/10 10:30 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW sisesmer.v_rol_mensual (codigo_funcionario,
                                                     funcionario,
                                                     anio,
                                                     mes_numero,
                                                     descripcion_rol,
                                                     tipo_concepto,
                                                     cod_descripcion,
                                                     descripcion,
                                                     valor
                                                    )
AS
   SELECT   a.codigo_funcionario,
            pk_uti.nom01_com (a.codigo_funcionario) funcionario, a.anio,
            a.mes_numero, a.descripcion_rol,
            CASE NVL (descripcion_ingreso, '-')
               WHEN '-'
                  THEN 'EGRESO'
               ELSE 'INGRESO'
            END tipo_concepto,
            CASE NVL (descripcion_ingreso, '-')
               WHEN '-'
                  THEN a.con02codi
               ELSE a.con01codi
            END cod_descripcion,
            CASE NVL (descripcion_ingreso, '-')
               WHEN '-'
                  THEN descripcion_descuento
               ELSE descripcion_ingreso
            END descripcion,
            CASE NVL (descripcion_ingreso, '-')
               WHEN '-'
                  THEN SUM (a.descuento)
               ELSE SUM (a.ingreso)
            END valor
       FROM v_rol_individual a
   GROUP BY a.codigo_funcionario,
            a.anio,
            a.descripcion_ingreso,
            a.descripcion_descuento,
            a.mes_numero,
            a.descripcion_rol,
            a.con02codi,
            a.con01codi;


DROP PUBLIC SYNONYM V_ROL_MENSUAL;

CREATE PUBLIC SYNONYM V_ROL_MENSUAL FOR SISESMER.V_ROL_MENSUAL;

