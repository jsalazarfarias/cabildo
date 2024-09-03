select a.REN05CODI,
       b.NOM01CODI,
       pk_uti.nom01_com(b.nom01codi) inspector_notificador,
       a.REN58FECCIT as fecha,
       'NOTIFICACION' AS OBSERVACIONES
from ren58 a, ren581 b 
where a.REN58CODI = b.REN58CODI
union
select a.codtabla as ren05codi, 
       a.nom01codi, 
       pk_uti.nom01_com(a.nom01codi) inspector_notificador,
       a.FECHA,
       a.OBSERVACIONES
from histinsp01 a
where tabla = 'REN05'
order by 5,4


select contribuyente, 
       ciu, 
       cod, 
       impuesto, 
       clave, 
       anio,  
       emi01codi,
       emi01titu,
       estado,
       vtot,
       inte,
       rec,
       coact,
       descu,
       emi01fcre,
       emi01femi,
       emi01fobl,
       emi01fpag,
       emi01npag,
       nroplan
       from v_estcue
where emi01esta not in ('B','A')
and emi01femi >= to_date('01-01-2014','dd-mm-rrrr')
and emi01femi <= to_date('31-08-2019','dd-mm-rrrr')


select PK_UTI.GEN01_COM(a.GEN01CODI) CONTRIBUYENTE, 
       a.GEN01CODI ciu, 
       a.EMI01SERI cod, 
       PK_UTI.FIND_IMPUESTO(a.EMI01SERI) impuesto, 
       a.EMI01CLAVE clave, 
       a.EMI01ANIO anio,  
       a.emi01titu,
       a.emi01codi,
       CASE a.EMI01ESTA
       WHEN 'A' THEN 'ABONO'
       END estado,
       a.EMI01VTOT vtot,
       b.fpm01codi CODIGO_ABONO,
       b.FPD01NROABONOS NRO,
       b.fpd01codi CODIGO,
       b.FPD01CAPITAL VALOR_ABONO,
       b.FPD01COA COACTIVA,
       b.FPD01INTERES INTERES,
       b.FPD01RECAR RECARGO,
       b.FPD01VALORTOTALABONO VALOR_TOTAL,
       b.FPD01FPAGO FECHA_PAGO,
       CASE b.FPD01ESTADO
       WHEN 'RE' THEN 'RECAUDADO'
       WHEN 'IG' THEN 'PENDIENTE DE PAGO'
       END estado,
       a.emi01fcre,
       a.emi01femi,
       a.emi01fobl
from emi01 a, fpd01 b
where b.EMI01CODI = a.EMI01CODI
and emi01esta = 'A'
and emi01femi >= to_date('01-01-2014','dd-mm-rrrr')
and emi01femi <= to_date('31-08-2019','dd-mm-rrrr')
order by a.emi01anio, a.gen01codi, a.emi01codi 



select GEN01CODI, EMI01CODI, EMI01FPAG from emi01 where emi01estA = 'J'
order by 3 desc

b.fpm