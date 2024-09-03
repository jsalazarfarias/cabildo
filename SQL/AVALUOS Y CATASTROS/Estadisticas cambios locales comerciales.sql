select '2021' anio, count(distinct(a.ren05codi)) fichas_creadas, 
        (select count(distinct(ren05codi))
         from ren05 b
         where to_char(b.ren05fmod,'rrrr') = '2021') fichas_modificadas
from ren05 a
where to_char(a.ren05fcre,'rrrr') = '2021'
group by to_char(a.ren05fcre,'rrrr')