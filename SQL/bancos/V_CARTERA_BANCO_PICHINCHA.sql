DROP VIEW SISESMER.V_CARTERA_BANCO_PICHINCHA;

/* Formatted on 2024/08/13 15:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW sisesmer.v_cartera_banco_pichincha (numero_emision,
                                                                 fecha_emision,
                                                                 emi01seri,
                                                                 tributo,
                                                                 ciu,
                                                                 identificacion,
                                                                 tipo_identificacion,
                                                                 anio_titulo,
                                                                 valor_emision,
                                                                 interes,
                                                                 recargo,
                                                                 descuento,
                                                                 coactiva,
                                                                 fecha_actual,
                                                                 total,
                                                                 estado_titulo
                                                                )
AS
   SELECT emi01codi numero_emision, emi01femi fecha_emision, emi01seri,
          pk_uti.find_impuesto (emi01seri) tributo, ciu,
          cedula identificacion,
          CASE (SELECT gen01tid
                  FROM gen01
                 WHERE gen01codi = ciu)
             WHEN '1'
                THEN 'RUC'
             WHEN '2'
                THEN 'CEDULA'
             WHEN '3'
                THEN 'PASAPORTE'
          END tipo_identificacion,
          anio anio_titulo, vtot valor_emision, inte interes, rec recargo,
          descu descuento, coact coactiva, SYSDATE fecha_actual,
          vtot + inte + rec + descu + coact total, emi01esta estado_titulo
     FROM v_estcue
    WHERE emi01esta IN ('E', 'A');

