select  'TITULOS DADOS DE BAJA' detalle, count(*) cantidad, '2023' anio
from emi01 
where to_date(emi01feli,'dd-mm-rrrr') >= to_date('01-08-2023','dd-mm-rrrr') 
and to_date(emi01feli,'dd-mm-rrrr') <= to_date('31-10-2023','dd-mm-rrrr')
union
select 'TITULOS EMITIDOS', count(*), '2023'
from emi01 
where to_date(emi01fcre,'dd-mm-rrrr') >= to_date('01-08-2023','dd-mm-rrrr')
and to_date(emi01fcre,'dd-mm-rrrr') <= to_date('31-10-2023','dd-mm-rrrr')
union
select 'EXONERACIONES REALIZADAS LEY ANCIANO', count(*), '2023'
from traexo01
where to_date(traexofcre,'dd-mm-rrrr') >= to_date('01-08-2023','dd-mm-rrrr')
and to_date(traexofcre,'dd-mm-rrrr') <= to_date('31-10-2023','dd-mm-rrrr')
and traexoesta = 'E'
union
select 'EXONERACIONES REALIZADAS OTROS CONCEPTOS', count(*), '2023'  
from oex03
where to_date(f_creacion,'dd-mm-rrrr') >= to_date('01-08-2023','dd-mm-rrrr')
and to_date(f_creacion,'dd-mm-rrrr') <= to_date('31-10-2023','dd-mm-rrrr')
and estado = 'F'
union
select 'TITULOS DADOS DE BAJA', count(*), '2022'
from emi01 
where to_date(emi01feli,'dd-mm-rrrr') >= to_date('01-08-2022','dd-mm-rrrr') 
and to_date(emi01feli,'dd-mm-rrrr') <= to_date('31-10-2022','dd-mm-rrrr')
union
select 'TITULOS EMITIDOS', count(*), '2022'
from emi01 
where to_date(emi01fcre,'dd-mm-rrrr') >= to_date('01-08-2022','dd-mm-rrrr')
and to_date(emi01fcre,'dd-mm-rrrr') <= to_date('31-10-2022','dd-mm-rrrr')
union
select 'EXONERACIONES REALIZADAS LEY ANCIANO', count(*), '2022'
from traexo01
where to_date(traexofcre,'dd-mm-rrrr') >= to_date('01-08-2022','dd-mm-rrrr')
and to_date(traexofcre,'dd-mm-rrrr') <= to_date('31-10-2022','dd-mm-rrrr')
and traexoesta = 'E'
union
select 'EXONERACIONES REALIZADAS OTROS CONCEPTOS', count(*), '2022'  
from oex03
where to_date(f_creacion,'dd-mm-rrrr') >= to_date('01-08-2022','dd-mm-rrrr')
and to_date(f_creacion,'dd-mm-rrrr') <= to_date('31-10-2022','dd-mm-rrrr')
and estado = 'F'
order by 1,3