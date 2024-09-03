------------------------PUNTO 3----------------------------
select ciu, 
       pk_uti.gen01_com(ciu) contribuyente,
       anio anio,
       pk_uti.find_impuesto(emi01seri) TRIBUTO, 
       emi01codi NRO_TITULO, 
       emi01titu DESCRIPCION_TITULO,
       emi01femi FECHA_EMISION, 
       case emi01esta
       when 'E' then 'EMITIDO'
       when 'A' then 'ABONO'
       when 'R' then 'RECAUDADO'
       when 'J' then 'RECAUDADO POR ABONO'
       when 'B' then 'BAJA'
       end ESTADO_TITULO,
       nvl(vtot,0) valor_emision,
       nvl(inte,0) interes,
       nvl(rec,0) recargo,
       nvl(coact,0) coactiva,
       nvl(descu,0) descuento
from V_ESTCUE 
where emi01femi >= to_date('01-01-2014','dd-mm-rrrr')
and emi01femi <= to_date('31-08-2019','dd-mm-rrrr') 

/*------------------------------------------------------------------
------------------------PUNTO 4-----------------------------------*/

select ciu, 
       pk_uti.gen01_com(ciu) contribuyente,
       anio anio,
       pk_uti.find_impuesto(emi01seri) TRIBUTO, 
       emi01codi NRO_TITULO, 
       emi01femi FECHA_EMISION, 
       case emi01esta
       when 'E' then 'EMITIDO'
       when 'A' then 'ABONO'
       when 'R' then 'RECAUDADO'
       when 'J' then 'RECAUDADO POR ABONO'
       when 'B' then 'BAJA'
       end ESTADO_TITULO,
       emi01titu DESCRIPCION_TITULO,
       nvl(vtot,0) valor_emision,
       nvl(inte,0) interes,
       nvl(rec,0) recargo,
       nvl(coact,0) coactiva,
       nvl(descu,0) descuento
from V_ESTCUE 
where emi01femi >= to_date('01-01-2014','dd-mm-rrrr')
and emi01femi <= to_date('31-08-2019','dd-mm-rrrr')
and emi01esta = 'R'
 
/*----------------------------------------------------------------------------
------------------------------PUNTO 5---------------------------------------*/

select ciu, 
       pk_uti.gen01_com(ciu) contribuyente,
       anio anio,
       pk_uti.find_impuesto(emi01seri) TRIBUTO, 
       emi01codi NRO_TITULO, 
       emi01femi FECHA_EMISION, 
       case emi01esta
       when 'E' then 'EMITIDO'
       when 'A' then 'ABONO'
       when 'R' then 'RECAUDADO'
       when 'J' then 'RECAUDADO POR ABONO'
       when 'B' then 'BAJA'
       end ESTADO_TITULO,
       emi01titu DESCRIPCION_TITULO,
       nvl(vtot,0) valor_emision,
       nvl(inte,0) interes,
       nvl(rec,0) recargo,
       nvl(coact,0) coactiva,
       nvl(descu,0) descuento
from v_estcue 
where emi01femi >= to_date('01-01-2014','dd-mm-rrrr')
and emi01femi <= to_date('31-08-2019','dd-mm-rrrr')
and emi01titu like ('%EXON%')
order by ciu, anio, emi01seri

/*---------------------------------------------------------------------------------------
-------------------------------------------punto 6-------------------------------------*/

select PUR11LCRE, PUR11VANT, 
       CASE PUR11VANT
        when 'E' then 'EMISION'
        when 'R' then 'RECAUDACION'
        when 'J' then 'RECAUDACION'
        when 'B' then 'BAJA'
       END FUNCION, MIN(PUR11FCRE), MAX(PUR11FCRE)
from sysaudemi01 
where pur11vant in ('R','J','B','E')
GROUP BY PUR11LCRE, PUR11VANT
ORDER BY 1

-------------------------------------------------------------------------------------
---------------------------------PUINTO 10------------------------------------------


select emi01lcre loggin, 
       pk_uti.nom01_com(c.nom01codi) funcionario,
       c.NOM01RRDIRE direccion,
       c.NOM01RTELE telefono1,
       min(emi01fcre), 
       max(emi01fcre)
from emi01 a, st_seg03 b, nom01 c
where emi01femi >= to_date('01-01-2014','dd-mm-rrrr')
and emi01femi <= to_date('31-08-2019','dd-mm-rrrr')
and emi01titu like ('%EXON%')
and a.emi01lcre = b.seg03codi
and b.SEG03CODNOMI = c.nom01codi
group by emi01lcre, c.nom01codi, c.NOM01RRDIRE, c.NOM01RTELE

----------------------------------------------------------------------------------
--------------------------punto 2 ------------------------------------------------

select gen01codi, 
       pk_uti.gen01_com(gen01codi) contribuyente,
       emi01anio anio,
       pk_uti.find_impuesto(emi01seri) TRIBUTO,
       emi01titu descripcion,  
       emi01codi NRO_TITULO, 
       emi01femi FECHA_EMISION, 
       case emi01esta
       when 'E' then 'EMITIDO'
       when 'A' then 'ABONO'
       when 'R' then 'RECAUDADO'
       when 'J' then 'RECAUDADO POR ABONO'
       when 'B' then 'BAJA'
       end ESTADO_TITULO
from emi01 
where emi01femi >= to_date('01-01-2018','dd-mm-rrrr')
and emi01femi <= to_date('31-08-2019','dd-mm-rrrr') 
and emi01seri = 130

----------------------------------------------------------------------------------
--------------------------punto 3 ------------------------------------------------

select gen01codi, 
       pk_uti.gen01_com(gen01codi) contribuyente,
       emi01anio anio,
       pk_uti.find_impuesto(emi01seri) TRIBUTO,
       emi01titu descripcion,  
       emi01codi NRO_TITULO, 
       emi01femi FECHA_EMISION, 
       case emi01esta
       when 'E' then 'EMITIDO'
       when 'A' then 'ABONO'
       when 'R' then 'RECAUDADO'
       when 'J' then 'RECAUDADO POR ABONO'
       when 'B' then 'BAJA'
       end ESTADO_TITULO
from emi01 
where emi01femi >= to_date('01-01-2018','dd-mm-rrrr')
and emi01femi <= to_date('31-08-2019','dd-mm-rrrr') 
and emi01seri = 5

----------------------------------------------------------------------------------
--------------------------punto 4 ------------------------------------------------

select a.ren05codi codigo_catastro,
       b.REN05NCOM nombre_comercial,
       b.gen01codi ciu,
       pk_uti.gen01_com(b.gen01codi) contribuyente,
       pk_uti.find_impuesto(a.REN31SERI) tributo,
       a.REN30ANIO
from ren31 a, ren05 b
where ren31seri in (5,130)
and ren05fcre >= to_date('01-01-2018','dd-mm-rrrr')
and ren05fcre <= to_date('31-08-2019','dd-mm-rrrr') 
and a.ren05codi = b.ren05codi
group by a.ren05codi, b.REN05NCOM, b.gen01codi, a.REN31SERI, a.REN30ANIO
order by gen01codi 
