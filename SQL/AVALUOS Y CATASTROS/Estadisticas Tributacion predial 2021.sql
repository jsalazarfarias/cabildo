select '2021' anio, a.emi01seri, pk_uti.find_impuesto(a.emi01seri) concepto_tributario, count(a.emi01codi) titulos_emitidos,
       (select count(b.emi01codi)
        from emi01 b
        where b.emi01esta in('B')
        and to_char(b.emi01fcre,'rrrr') = '2021'
        and b.emi01seri = a.emi01seri) dados_de_baja
from emi01 a
where to_char(a.emi01fcre,'rrrr') = '2021'
and a.emi01seri not in (140,95,408,5,49,130,115)
and a.emi01seri not in (select emi03codi from emi03 where emi03nota like ('%ESPECI%'))
group by to_char(emi01fcre,'rrrr'), emi01seri
order by 4 desc



select * from emi03