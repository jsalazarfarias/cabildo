--------------------------punto 8-----------------------------
select 'EMISION PREDIAL URBANA DE TITULOS DE CREDITO QUE CONTIENEN EL COMPONENTE CEM',NULL CANTIDAD_TITULOS,NULL VALOR,'' ESTADO FROM DUAL
union
select '2019' anio, 0 titulos, 0 valor, 'NO HUBO EMISION CEM' from dual
union
select '2020' anio, 0 titulos, 0 valor, 'NO HUBO EMISION CEM' from dual
union
select '2021' anio, 0 titulos, 0 valor, 'NO HUBO EMISION CEM' from dual
union
select to_char(emi01fcre,'rrrr') anio, count(emi01codi) titulos, 
      (sum(nvl(emi01vtot,0))+
       sum(nvl(emi01inte,0))+
       sum(nvl(emi01reca,0))+
       sum(nvl(emi01coa,0)))-
       sum(nvl(emi01desc,0)) valor,
       case emi01esta
        when 'E' then 'PENDIENTES'
        when 'R' then 'RECAUDADOS'
        when 'A' then 'ABONO'
        when 'J' then 'RECAUDADOS POR ABONO'
        when 'B' then 'BAJA'
       end estado_titulo
from emi01
where to_date(emi01fcre,'dd-mm-rrrr') >= to_date('01-01-2019','dd-mm-rrrr')
and to_date(emi01fcre,'dd-mm-rrrr') <= to_date('30-09-2023','dd-mm-rrrr')
and emi01seri in 140
and emi01codi in (select emi01codi from emi02 where emi04codi = 510)
and upper(emi01titu) like ('%EXON%ANCIA%')
and emi01esta not in ('B')
group by to_char(emi01fcre,'rrrr'), emi01esta
union
select '2019' anio, 0 titulos, 0 valor, 'NO HUBO EMISION CEM' from dual
union
select '2020' anio, 0 titulos, 0 valor, 'NO HUBO EMISION CEM' from dual
union
select '2021' anio, 0 titulos, 0 valor, 'NO HUBO EMISION CEM' from dual
union
select to_char(emi01fcre,'rrrr') anio, count(emi01codi) titulos, 
      (sum(nvl(emi01vtot,0))+
       sum(nvl(emi01inte,0))+
       sum(nvl(emi01reca,0))+
       sum(nvl(emi01coa,0)))-
       sum(nvl(emi01desc,0)) valor,
       case emi01esta
        when 'E' then 'PENDIENTES'
        when 'R' then 'RECAUDADOS'
        when 'A' then 'ABONO'
        when 'J' then 'RECAUDADOS POR ABONO'
        when 'B' then 'BAJA'
       end estado_titulo
from emi01
where to_date(emi01fcre,'dd-mm-rrrr') >= to_date('01-01-2019','dd-mm-rrrr')
and to_date(emi01fcre,'dd-mm-rrrr') <= to_date('30-09-2023','dd-mm-rrrr')
and emi01seri in 140
and emi01codi in (select emi01codi from emi02 where emi04codi = 510)
and emi01esta in ('B')
and emi01motbaja = 'BAJA POR EXONERACION LEY ANCIANO'
group by to_char(emi01fcre,'rrrr'), emi01esta
order by 1,2 asc