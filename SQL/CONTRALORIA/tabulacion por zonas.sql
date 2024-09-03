select clave, terreno, construccion, cedula, nombre, b.pur04escr ciudad_escritura, 
       b.PUR04NOTA notario
from v_urbanorustico a, pur04 b
where substr(a.CLAVE,1,4) in ('0805')
and a.clave = b.pur01pred
and a.manzana in ('001','002','003','004','005','006','007','008','009','010','011','012','013','014','015', '025','026', '027','028','029','030')
union 
select clave, terreno, construccion, cedula, nombre, 'SIN ESCRITURA' ciudad_escritura, 
       'SIN NOTARIA' notario
from v_urbanorustico a
where substr(a.CLAVE,1,4) in ('0805')
and a.manzana in ('001','002','003','004','005','006','007','008','009','010','011','012','013','014','015', '025','026', '027','028','029','030')
ORDER BY CLAVE

