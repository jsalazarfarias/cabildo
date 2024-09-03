select clave, terreno, construccion, cedula, nombre, b.pur04escr ciudad_escritura, 
       b.PUR04NOTA notario
from v_urbanorustico a, pur04 b
where substr(a.CLAVE,1,4) in ('0802')
and a.clave = b.pur01pred
and a.manzana in ('024','025','026','027','028','030','031','032')
union 
select clave, terreno, construccion, cedula, nombre, 'SIN ESCRITURA' ciudad_escritura, 
       'SIN NOTARIA' notario
from v_urbanorustico a
where substr(a.CLAVE,1,4) in ('0802')
and a.manzana in ('024','025','026','027','028','030','031','032')
ORDER BY CLAVE

