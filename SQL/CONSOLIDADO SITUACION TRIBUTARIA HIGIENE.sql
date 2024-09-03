select A.REN05CODZONA,  NVL(a.ZONA,'NO ZONIFICADO'), count(a.ren05codi) CANTIDAD, 'ADEUDAN' SITUACION                       
from v_catastro_higiene a
where a.REN05ESTA in ('IG','MD')
AND ren05codi not in (select b.ren05codi 
                      from ren31 b
                      where b.ren30nemi in (select c.emi01codi 
                                            from emi01 c
                                            where c.emi01codi = b.ren30nemi
                                            AND EMI01ANIO = 2019
                                            AND EMI01ESTA IN ('R','J')))
GROUP BY A.REN05CODZONA, a.ZONA
UNION
select A.REN05CODZONA, NVL(a.ZONA,'NO ZONIFICADO'), count(a.ren05codi) CANTIDAD,  'PAGADO' SITUACION                         
from v_catastro_higiene a
where a.REN05ESTA in ('IG','MD')
AND ren05codi in (select b.ren05codi 
                      from ren31 b
                      where b.ren30nemi in (select c.emi01codi 
                                            from emi01 c
                                            where c.emi01codi = b.ren30nemi
                                            AND EMI01ANIO = 2019
                                            AND EMI01ESTA IN ('R','J')))
GROUP BY A.REN05CODZONA, a.ZONA
ORDER BY 4,2