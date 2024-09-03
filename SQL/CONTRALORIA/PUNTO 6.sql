-----------------------------------punto 6------------------------------------- 
select gen01codi ciu, pk_uti.gen01_com(gen01codi) contribuyente,
       emi01anio anio_titulo, emi01fcre fecha_emision, 
       case when UPPER(emi01titu) like ('%EXON%ANCIA%') or upper(emi01motbaja) like ('%ANCIA%') then
        'SI'
       ELSE 
        'NO'
       END LEY_ANCIANO, 
       emi01codi nro_emision, (select emi02vdet from emi02 where emi01codi = emi01.emi01codi
                               and emi04codi = 510) valor_cem,
                              (select emi02vdet from emi02 where emi01codi = emi01.emi01codi
                               and emi04codi = 176) valor_bomberos, 
                              (select emi02vdet from emi02 where emi01codi = emi01.emi01codi
                               and emi04codi = 185) valor_servicios,
                              case emi01esta
                                when 'E' then 'Pendiente de pago'
                                when 'R' then 'Recaudado'
                                when 'A' then 'Abono'
                                when 'B' then 'Baja'
                              end estado_titulo, 
                              case emi01esta
                                when 'B' then emi01motbaja
                              end emi01motbaja
from emi01
where to_date(emi01fcre,'dd-mm-rrrr') >= to_date('01-01-2019','dd-mm-rrrr')
and to_date(emi01fcre,'dd-mm-rrrr') <= to_date('31-12-2021','dd-mm-rrrr')
and emi01anio in (2019,2020,2021,2022,2023)
union
select gen01codi ciu, pk_uti.gen01_com(gen01codi) contribuyente,
       emi01anio anio_titulo, emi01fcre fecha_emision, 
       case when UPPER(emi01titu) like ('%EXON%ANCIA%') or upper(emi01motbaja) like ('%ANCIA%') then
        'SI'
       ELSE 
        'NO'
       END LEY_ANCIANO, 
       emi01codi nro_emision, (select emi02vdet from emi02 where emi01codi = emi01.emi01codi
                               and emi04codi = 510) valor_cem,
                              (select emi02vdet from emi02 where emi01codi = emi01.emi01codi
                               and emi04codi = 176) valor_bomberos, 
                              (select emi02vdet from emi02 where emi01codi = emi01.emi01codi
                               and emi04codi = 185) valor_servicios,
                              case emi01esta
                                when 'E' then 'Pendiente de pago'
                                when 'R' then 'Recaudado'
                                when 'A' then 'Abono'
                                when 'B' then 'Baja'
                              end estado_titulo,
                              case emi01esta
                                when 'B' then emi01motbaja
                              end emi01motbaja
from emi01 where emi01codi in (
select emi01codi from emi02 
where emi01codi in (select emi01codi from emi01
                    where to_date(emi01fcre,'dd-mm-rrrr') >= to_date('01-01-2019','dd-mm-rrrr')
                    and to_date(emi01fcre,'dd-mm-rrrr') <= to_date('30-09-2023','dd-mm-rrrr')
                    and emi01seri in 140)
and emi04codi = 510)
and emi01anio in (2019,2020,2021,2022,2023)
order by 3

