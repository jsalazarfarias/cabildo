select 2021 anio,count(emi01codi) titulos_recaudados,
       (select count(fpm01codi) from fpm01
        where to_char(fpm01fauto,'rrrr') = '2021') abonos_autorizados,
       (select COUNT(ID) from ncr01
        where to_char(f_aprobacion,'rrrr') = '2021') notas_credito_autorizadas 
from emi01
where to_char(emi01fpag,'rrrr') = '2021'
and emi01esta = 'R'
group by to_char(emi01fpag,'rrrr')


select COUNT(ID) from ncr01
where to_char(f_aprobacion,'rrrr') = '2021'




