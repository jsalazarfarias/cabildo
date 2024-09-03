select * from v_predios_sri
where fecha_creacion <= to_date('31-12-2021','dd-mm-rrrr')

select * from emi03 where emi03codi = 130


select * from emi01
where emi01seri = 130
and emi01fpag >= to_date('01-01-2020','dd-mm-rrrr')
and emi01fpag <= to_date('31-12-2020','dd-mm-rrrr')



select pk_uti.gen01_ruc(gen01codi) numero_id_propietario
        
from ren05
where ren05fcre <= to_date('31-12-2020','dd-mm-rrrr')



select * from v_catastro_higiene

select pk_uti.gen01_ruc(gen01codi) num_id_prop,
       (select b.actividad 
        from v_catastro_higiene b 
        where b.ren05codi = a.ren05codi) actividad_economica_principal, 
       (select substr(ren21valo,1,3)
        from ren21 
        where ren21codi = a.ren21codb) provincia, 
       (select substr(ren21valo,1,5)
        from ren21 
        where ren21codi = a.ren21codb) canton,
       (select substr(ren21valo,1)
        from ren21 
        where ren21codi = a.ren21codb) parroquia,
       a.ren05dire direccion,
       a.ren05fini fecha_inicio_actividad,
       (select distinct(to_date(emi01fpag,'dd-mm-rrrr')) 
        from emi01 b
        where emi01codi in (select ren30nemi
                            from ren31 c
                            where c.ren05codi = a.ren05codi
                            and ren30anio in to_char(a.ren05fcre,'rrrr')
                            and ren31seri = 130)
        and b.emi01anio in to_char(a.ren05fcre,'rrrr')
        and b.emi01esta in ('R','J')
        and b.emi01seri = 130) fecha_pago_patente,
       (select (nvl(emi01vtot,0) + nvl(emi01inte,0) + nvl(emi01reca,0) + nvl(emi01coa,0)) - nvl(emi01coa,0)  
        from emi01 b
        where emi01codi in (select ren30nemi
                            from ren31 c
                            where c.ren05codi = a.ren05codi
                            and ren30anio in to_char(a.ren05fcre,'rrrr')
                            and ren31seri = 130)
        and b.emi01anio in to_char(a.ren05fcre,'rrrr')
        and b.emi01esta in ('R','J')
        and b.emi01seri = 130) monto_pagado,
        a.ren05fcre
from ren05 a
where ren05fcre <= to_date('31-12-2020','dd-mm-rrrr')




select pk_uti.gen01_ruc(a.gen01codi) num_id_prop,
       CASE pk_uti.titulo_catalogos (6, a.ren21coda)
            WHEN 'RE-00600' THEN 'NO ASIGNADO'
            ELSE pk_uti.titulo_catalogos (6, a.ren21coda)
       END actividad,
      (select substr(ren21valo,1,3)
        from ren21 
        where ren21codi = a.ren21codb) provincia, 
      (select substr(ren21valo,1,5)
       from ren21 
       where ren21codi = a.ren21codb) canton,
      (select substr(ren21valo,1)
       from ren21 
       where ren21codi = a.ren21codb) parroquia,
      a.ren05dire direccion,
      a.ren05fini fecha_inicio_actividad,
      c.emi01fpag fecha_pago_patente,
      case when not c.emi01fpag is null 
        then (nvl(c.emi01vtot,0) + nvl(c.emi01inte,0) + nvl(c.emi01reca,0) + nvl(c.emi01coa,0)) - nvl(c.emi01coa,0) 
      else 0
      end valor_recaudado,
      c.emi01anio,
      a.ren05fcre 
from ren05 a, ren31 b, emi01 c
where a.ren05codi = b.ren05codi 
and b.ren30nemi = c.emi01codi
and c.emi01esta IN ('R','J','E','A')


select * from emi01 where emi01anio = 2016
and emi01esta = 'E'


select * from reg01


select * from gen01 where gen01codi = 






select * from v_nomprv01_disp_1
where codigo_funcionario = 345



select * from ren31

select ruc numero_id_propietario,
       actividad, 
       
from v_catastro_higiene


select ren21valo from ren21 where ren21codi = 247

select * from ren20 where ren20codi = 7


select * from cat04

v_predios_sri


SELECT * FROM CAM001
WHERE PUR01PRED IN (SELECT PUR01PRED FROM PUR01)


SELECT CAM01CODI, PUR01PRED, '="'||PUR01PRED||'";'||
       'Se ha realizado una actualizacion al campo: '||NVL(cam01campo,'VACIO ')||', de un valor: '||NVL(cam01valant,'VACIO ')||', por un valor de: '||nvl(cam01valnue, 'VACIO ') 
       ||';'||nvl(cam01lcre,'NN')
       ||';'||NVL(TO_DATE(CAM01FCRE, 'DD-MM-RRRR'),TO_DATE('01-01-1900', 'DD-MM-RRRR'))
       ||';'||'NN'
       ||';'||'NN' LINEA
FROM CAM001

V_PUR03



SELECT * FROM EMI01 WHERE EMI01ANIO = 2000