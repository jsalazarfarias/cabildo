select a.gen01codi,
       pk_uti.gen01_com(a.gen01codi) comtribuyente,
       pk_uti.gen01_ruc(a.gen01codi) ruc,
       b.ren05codi,
       nvl((select c.ren05ncom 
            from ren05 c 
            where c.ren05codi = b.ren05codi),'SIN NOMBRE ASIGNADO') nombre_comercial, 
       a.emi01anio, 
       a.emi01seri, 
       pk_uti.find_impuesto(a.emi01seri) impuesto,
       a.emi01codi, 
       CASE a.emi01esta
             WHEN 'R'
                THEN a.emi01vtot
             WHEN 'E'
                THEN a.emi01vtot
             WHEN 'B'
                THEN a.emi01vtot
             WHEN 'J'
                THEN a.emi01vtot
             WHEN 'A'
                THEN a.emi01vtot
          END vtot,
          CASE a.emi01esta
             WHEN 'R'
                THEN a.emi01inte
             WHEN 'E'
                THEN web_interes (a.emi01codi)
             WHEN 'B'
                THEN NULL
             WHEN 'J'
                THEN (SELECT SUM (NVL (fpd01interes, 0))
                        FROM fpd01 b
                       WHERE b.emi01codi = a.emi01codi
                         AND b.fpd01estado = 'RE')
             else 0
          END inte,
          CASE a.emi01esta
             WHEN 'R'
                THEN a.emi01reca
             WHEN 'E'
                THEN web_recargo (a.emi01codi)
             WHEN 'B'
                THEN NULL
             WHEN 'J'
                THEN (SELECT SUM (NVL (fpd01recar, 0))
                        FROM fpd01 b
                       WHERE b.emi01codi = a.emi01codi
                         AND b.fpd01estado = 'RE')
             else 0
          END rec,
          CASE a.emi01esta
             WHEN 'R'
                THEN a.emi01desc
             WHEN 'E'
                THEN web_descuento (a.emi01codi)
             WHEN 'B'
                THEN NULL
             WHEN 'J'
                THEN (SELECT SUM (NVL (fpd01descue, 0))
                        FROM fpd01 b
                       WHERE b.emi01codi = a.emi01codi
                         AND b.fpd01estado = 'RE')
             else 0
          END descu,
          CASE a.emi01esta
             WHEN 'R'
                THEN a.emi01coa
             WHEN 'E'
                THEN web_coactiva (a.emi01codi)
             WHEN 'B'
                THEN NULL
             WHEN 'J'
                THEN (SELECT SUM (NVL (fpd01coa, 0))
                        FROM fpd01 b
                       WHERE b.emi01codi = a.emi01codi
                         AND b.fpd01estado = 'RE')
             else 0
          END coact,
       a.emi01esta,
       case a.emi01esta
        when 'R' then 'RECAUDADO'
        when 'E' then 'PENDIENTE DE PAGO'
        when 'J' then 'RECAUDADO POR ABONO'
        when 'A' then 'TITULO EN ABONO'
       end estado
from emi01 a, ren31 b
where a.emi01codi = b.ren30nemi
and a.emi01esta not in 'B'
and b.ren05codi in (select d.ren05codi 
                    from ren05 d 
                    where ren05esta in ('IG','MD') 
                    and d.ren05codi = b.ren05codi)
order by a.emi01anio, a.gen01codi


SELECT * FROM EMI01 WHERE EMI01ESTA = 'J'
AND EMI01ANIO = 2017



v_estcue