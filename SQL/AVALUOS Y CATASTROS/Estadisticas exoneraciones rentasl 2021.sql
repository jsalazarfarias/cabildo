select '2021' anio, count(traexocodi) exoneraciones_aprobadas 
from traexo01
where to_char(traexofecha,'rrrr') = '2021'
and traexoesta = 'E'


select * from dplan01 where dplan01nrotram = 'RMC18710'