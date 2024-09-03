select count(a.emi01codi) titulos_exonerados, nvl(round(avg(d.traexoporce),2),0) promedio_exoneracion, 
       sum(a.emi01vtot) valor_titulos, nvl(round(sum((a.emi01vtot*traexoporce)/100),2),0) valor_exonerado, nvl(round(sum(a.emi01vtot - (a.emi01vtot*traexoporce)/100),2),sum(a.emi01vtot)) diferencia, '2019' año
from emi01 a, traexo03 b, traexo02 c, traexo01 d
where a.emi01codi = b.emi01codi
and c.traexo02codi = b.traexo02codi
and c.traexocodi = d.traexocodi
and d.traexofcre >= to_date('01-01-2019','dd-mm-rrrr')
and d.traexofcre <= to_date('31-12-2019','dd-mm-rrrr')
and d.traexoesta = 'E'
group by d.traexoporce
union
select count(a.emi01codi) titulos_exonerados, nvl(round(avg(d.traexoporce),2),0) promedio_exoneracion, 
       sum(a.emi01vtot) valor_titulos, nvl(round(sum((a.emi01vtot*traexoporce)/100),2),0) valor_exonerado, nvl(round(sum(a.emi01vtot - (a.emi01vtot*traexoporce)/100),2),sum(a.emi01vtot)) diferencia, '2020' año
from emi01 a, traexo03 b, traexo02 c, traexo01 d
where a.emi01codi = b.emi01codi
and c.traexo02codi = b.traexo02codi
and c.traexocodi = d.traexocodi
and d.traexofcre >= to_date('01-01-2020','dd-mm-rrrr')
and d.traexofcre <= to_date('31-12-2020','dd-mm-rrrr')
and d.traexoesta = 'E'
group by d.traexoporce
union
select count(a.emi01codi) titulos_exonerados, nvl(round(avg(d.traexoporce),2),0) promedio_exoneracion, 
       sum(a.emi01vtot) valor_titulos, nvl(round(sum((a.emi01vtot*traexoporce)/100),2),0) valor_exonerado, nvl(round(sum(a.emi01vtot - (a.emi01vtot*traexoporce)/100),2),sum(a.emi01vtot)) diferencia, '2021' año
from emi01 a, traexo03 b, traexo02 c, traexo01 d
where a.emi01codi = b.emi01codi
and c.traexo02codi = b.traexo02codi
and c.traexocodi = d.traexocodi
and d.traexofcre >= to_date('01-01-2021','dd-mm-rrrr')
and d.traexofcre <= to_date('31-12-2021','dd-mm-rrrr')
and d.traexoesta = 'E'
group by d.traexoporce
order by 6



