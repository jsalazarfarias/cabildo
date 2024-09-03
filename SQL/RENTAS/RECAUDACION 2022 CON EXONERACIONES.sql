select gen01codi ciu,
       pk_uti.gen01_ruc(gen01codi) identificacion,
       pk_uti.gen01_com(gen01codi) contribuyente,
       emi01clave clave,
       decode(emi01seri,140,'URBANO',95,'RURAL') TIPO_PREDIO, 
       nvl((select pur01atter
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01supe
            from pru01
            where pru01cla = emi01.emi01clave),0)) area_terreno,
       nvl((select pur01atco
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01acon
            from pru01
            where pru01cla = emi01.emi01clave),0))  area_construccion,
       nvl((select sum(b.pur02areal)
            from pur02 b
            where b.pur01pred = emi01.emi01clave),
       nvl((select sum(b.pru20avaluo)
            from pru20 b
            where b.pru01cla = emi01.emi01clave),0)) avaluo_terreno,
       nvl((select sum(b.pur05areal)
            from pur05 b
            where b.pur01pred = emi01.emi01clave),
       nvl((select sum(b.pur05areal)
            from pru05 b
            where b.pru01cla = emi01.emi01clave),0)) avaluo_construccion,
       nvl((select pur01tavre
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01aval
            from pru01
            where pru01cla = emi01.emi01clave),0)) avaluo_predio,
       (nvl(emi01vtot,0) + 
        nvl(emi01inte,0) +
        nvl(emi01reca,0) +
        nvl(emi01coa,0)) -
        nvl(emi01desc,0) valor_recaudado,
       'BENEFICENCIA O ASISTENCIA SOCIAL' tipo_exoneracion
from emi01
where emi01anio = 2022
and emi01esta in ('R','J')
and upper(emi01titu) like ('%BENEFICENCIA O ASISTENCIA SOCIAL%')
and emi01seri in (140,95)
UNION
select gen01codi ciu,
       pk_uti.gen01_ruc(gen01codi) identificacion,
       pk_uti.gen01_com(gen01codi) contribuyente,
       emi01clave clave,
       decode(emi01seri,140,'URBANO',95,'RURAL') TIPO_PREDIO, 
       nvl((select pur01atter
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01supe
            from pru01
            where pru01cla = emi01.emi01clave),0)) area_terreno,
       nvl((select pur01atco
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01acon
            from pru01
            where pru01cla = emi01.emi01clave),0))  area_construccion,
       nvl((select sum(b.pur02areal)
            from pur02 b
            where b.pur01pred = emi01.emi01clave),
       nvl((select sum(b.pru20avaluo)
            from pru20 b
            where b.pru01cla = emi01.emi01clave),0)) avaluo_terreno,
       nvl((select sum(b.pur05areal)
            from pur05 b
            where b.pur01pred = emi01.emi01clave),
       nvl((select sum(b.pur05areal)
            from pru05 b
            where b.pru01cla = emi01.emi01clave),0)) avaluo_construccion,
       nvl((select pur01tavre
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01aval
            from pru01
            where pru01cla = emi01.emi01clave),0)) avaluo_predio,
       (nvl(emi01vtot,0) + 
        nvl(emi01inte,0) +
        nvl(emi01reca,0) +
        nvl(emi01coa,0)) -
        nvl(emi01desc,0) valor_recaudado,
       'COOTAD ART.509 POR AVALUO' tipo_exoneracion
from emi01
where emi01anio = 2022
and emi01esta in ('R','J')
and upper(emi01titu) like ('%ART.509%')
and emi01seri in (140,95)
union
select gen01codi ciu,
       pk_uti.gen01_ruc(gen01codi) identificacion,
       pk_uti.gen01_com(gen01codi) contribuyente,
       emi01clave clave,
       decode(emi01seri,140,'URBANO',95,'RURAL') TIPO_PREDIO, 
       nvl((select pur01atter
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01supe
            from pru01
            where pru01cla = emi01.emi01clave),0)) area_terreno,
       nvl((select pur01atco
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01acon
            from pru01
            where pru01cla = emi01.emi01clave),0))  area_construccion,
       nvl((select sum(b.pur02areal)
            from pur02 b
            where b.pur01pred = emi01.emi01clave),
       nvl((select sum(b.pru20avaluo)
            from pru20 b
            where b.pru01cla = emi01.emi01clave),0)) avaluo_terreno,
       nvl((select sum(b.pur05areal)
            from pur05 b
            where b.pur01pred = emi01.emi01clave),
       nvl((select sum(b.pur05areal)
            from pru05 b
            where b.pru01cla = emi01.emi01clave),0)) avaluo_construccion,
       nvl((select pur01tavre
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01aval
            from pru01
            where pru01cla = emi01.emi01clave),0)) avaluo_predio,
       (nvl(emi01vtot,0) + 
        nvl(emi01inte,0) +
        nvl(emi01reca,0) +
        nvl(emi01coa,0)) -
        nvl(emi01desc,0) valor_recaudado,
       'DISCAPACITADOS' tipo_exoneracion
from emi01
where emi01anio = 2022
and emi01esta in ('R','J')
and upper(emi01titu) like ('%DISCAPACITADOS%')
and emi01seri in (140,95)
union
select gen01codi ciu,
       pk_uti.gen01_ruc(gen01codi) identificacion,
       pk_uti.gen01_com(gen01codi) contribuyente,
       emi01clave clave,
       decode(emi01seri,140,'URBANO',95,'RURAL') TIPO_PREDIO, 
       nvl((select pur01atter
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01supe
            from pru01
            where pru01cla = emi01.emi01clave),0)) area_terreno,
       nvl((select pur01atco
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01acon
            from pru01
            where pru01cla = emi01.emi01clave),0))  area_construccion,
       nvl((select sum(b.pur02areal)
            from pur02 b
            where b.pur01pred = emi01.emi01clave),
       nvl((select sum(b.pru20avaluo)
            from pru20 b
            where b.pru01cla = emi01.emi01clave),0)) avaluo_terreno,
       nvl((select sum(b.pur05areal)
            from pur05 b
            where b.pur01pred = emi01.emi01clave),
       nvl((select sum(b.pur05areal)
            from pru05 b
            where b.pru01cla = emi01.emi01clave),0)) avaluo_construccion,
       nvl((select pur01tavre
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01aval
            from pru01
            where pru01cla = emi01.emi01clave),0)) avaluo_predio,
       (nvl(emi01vtot,0) + 
        nvl(emi01inte,0) +
        nvl(emi01reca,0) +
        nvl(emi01coa,0)) -
        nvl(emi01desc,0) valor_recaudado,
       ' PROPIEDADES DEL ESTADO' tipo_exoneracion
from emi01
where emi01anio = 2022
and emi01esta in ('R','J')
and upper(emi01titu) like ('%PROPIEDADES DEL ESTADO%')
and emi01seri in (140,95)
union
select gen01codi ciu,
       pk_uti.gen01_ruc(gen01codi) identificacion,
       pk_uti.gen01_com(gen01codi) contribuyente,
       emi01clave clave,
       decode(emi01seri,140,'URBANO',95,'RURAL') TIPO_PREDIO, 
       nvl((select pur01atter
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01supe
            from pru01
            where pru01cla = emi01.emi01clave),0)) area_terreno,
       nvl((select pur01atco
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01acon
            from pru01
            where pru01cla = emi01.emi01clave),0))  area_construccion,
       nvl((select sum(b.pur02areal)
            from pur02 b
            where b.pur01pred = emi01.emi01clave),
       nvl((select sum(b.pru20avaluo)
            from pru20 b
            where b.pru01cla = emi01.emi01clave),0)) avaluo_terreno,
       nvl((select sum(b.pur05areal)
            from pur05 b
            where b.pur01pred = emi01.emi01clave),
       nvl((select sum(b.pur05areal)
            from pru05 b
            where b.pru01cla = emi01.emi01clave),0)) avaluo_construccion,
       nvl((select pur01tavre
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01aval
            from pru01
            where pru01cla = emi01.emi01clave),0)) avaluo_predio,
       (nvl(emi01vtot,0) + 
        nvl(emi01inte,0) +
        nvl(emi01reca,0) +
        nvl(emi01coa,0)) -
        nvl(emi01desc,0) valor_recaudado,
       'LEY DEL ANCIANO' tipo_exoneracion
from emi01
where emi01anio = 2022
and emi01esta in ('R','J')
and upper(emi01titu) like ('%ANCIANO%')
and emi01seri in (140,95)
union
select gen01codi ciu,
       pk_uti.gen01_ruc(gen01codi) identificacion,
       pk_uti.gen01_com(gen01codi) contribuyente,
       emi01clave clave,
       decode(emi01seri,140,'URBANO',95,'RURAL') TIPO_PREDIO, 
       nvl((select pur01atter
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01supe
            from pru01
            where pru01cla = emi01.emi01clave),0)) area_terreno,
       nvl((select pur01atco
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01acon
            from pru01
            where pru01cla = emi01.emi01clave),0))  area_construccion,
       nvl((select sum(b.pur02areal)
            from pur02 b
            where b.pur01pred = emi01.emi01clave),
       nvl((select sum(b.pru20avaluo)
            from pru20 b
            where b.pru01cla = emi01.emi01clave),0)) avaluo_terreno,
       nvl((select sum(b.pur05areal)
            from pur05 b
            where b.pur01pred = emi01.emi01clave),
       nvl((select sum(b.pur05areal)
            from pru05 b
            where b.pru01cla = emi01.emi01clave),0)) avaluo_construccion,
       nvl((select pur01tavre
            from pur01
            where pur01pred = emi01.emi01clave),
       nvl((select pru01aval
            from pru01
            where pru01cla = emi01.emi01clave),0)) avaluo_predio,
       (nvl(emi01vtot,0) + 
        nvl(emi01inte,0) +
        nvl(emi01reca,0) +
        nvl(emi01coa,0)) -
        nvl(emi01desc,0) valor_recaudado,
       'NORMAL' tipo_exoneracion
from emi01
where emi01anio = 2022
and emi01esta in ('R','J')
and upper(emi01titu) NOT LIKE ('%EXONER%')
and emi01seri in (140,95)
order by 12
