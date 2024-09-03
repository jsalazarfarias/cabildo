
select count(*), upper('Titulos con vlaor cem en 0') detalle
from emi01 where emi01codi in (
select emi01codi from emi02 
where emi01codi in (select emi01codi from emi01
                    where to_date(emi01fcre,'dd-mm-rrrr') >= to_date('01-01-2019','dd-mm-rrrr')
                    and to_date(emi01fcre,'dd-mm-rrrr') <= to_date('30-09-2023','dd-mm-rrrr')
                    and emi01seri in 140)
and emi04codi = 510)
and emi01vtot = 0
union
select count(*), upper('Titulos dados de baja con vlaor cem en 0') detalle
from emi01 where emi01codi in (
select emi01codi from emi02 
where emi01codi in (select emi01codi from emi01
                    where to_date(emi01fcre,'dd-mm-rrrr') >= to_date('01-01-2019','dd-mm-rrrr')
                    and to_date(emi01fcre,'dd-mm-rrrr') <= to_date('30-09-2023','dd-mm-rrrr')
                    and emi01seri in 140)
and emi04codi = 510)
and emi01vtot = 0
and emi01esta = 'B'