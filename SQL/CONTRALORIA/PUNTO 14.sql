select gen01codi, pk_uti.gen01_com(gen01codi), cem03anio 
from cem02 a, cem03 b
where a.cem02codi = b.cem02codi
group by a.gen01codi, cem03anio
order by 3,1



select * from cem03