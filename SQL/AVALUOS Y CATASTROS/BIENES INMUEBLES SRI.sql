select a.tipo_identificacion, a.numero_identificacion,
       a.nombre_razon_social, 
       case 
       when nvl((select count(*)
                 from tra01 b
                 where b.tra01clave = a.clave_catastral
                 and to_date(b.tra01fingr,'dd-mm-rrrr') >= to_date('01-01-2022','dd-mm-rrrr')
                 and to_date(b.tra01fingr,'dd-mm-rrrr') <= to_date('31-12-2022','dd-mm-rrrr')
                 and b.tra01esta = 'F'),0) > 0 then '03'
       when nvl((select count(*)
                 from tra01 b
                 where b.tra01clave = a.clave_catastral
                 and to_date(b.tra01fingr,'dd-mm-rrrr') >= to_date('01-01-2022','dd-mm-rrrr')
                 and to_date(b.tra01fingr,'dd-mm-rrrr') <= to_date('31-12-2022','dd-mm-rrrr')
                 and b.tra01esta = 'F'),0) = 0 then '02' 
       when nvl((select count(*)
                 from tra01 b
                 where b.tra01clave = a.clave_catastral
                 and to_date(b.tra01fingr,'dd-mm-rrrr') >= to_date('01-01-2022','dd-mm-rrrr')
                 and to_date(b.tra01fingr,'dd-mm-rrrr') <= to_date('31-12-2022','dd-mm-rrrr')
                 and b.tra01esta = 'F'),0) = 0
       and  nvl((select count(*)
                 from pur01 b
                 where b.pur01pred = a.clave_catastral
                 and to_date(b.pur01fcre,'dd-mm-rrrr') >= to_date('01-01-2023','dd-mm-rrrr')
                 and to_date(b.pur01fcre,'dd-mm-rrrr') <= to_date(sysdate,'dd-mm-rrrr')),0) > 0 then '04'
       end tipo_transaccion_report,
       ' ' otro_tipo_trasn_rep,
       (select b.pur06por
        from pur06 b
        where b.pur01pred = a.clave_catastral
        and b.gen01codi = f_propietariopur_ciu(a.clave_catastral)) porcentaje_propiedad,
        case 
            nvl((select nvl(b.pur05cfca,1)
                 from pur05 b
                 where b.pur01pred = a.clave_catastral
                 and b.pur05codi = (select max(c.pur05codi)
                                    from pur05 c
                                    where c.pur01pred = a.clave_catastral) 
                 and pur05acons > 0),0) 
        when 1 then '01'
        when 2 then '03'
        when 0 then '04'
        else '07'
        end tipo_bien_inmueble, 
        case  
            case 
                nvl((select nvl(b.pur05cfca,1)
                     from pur05 b
                     where b.pur01pred = a.clave_catastral
                     and b.pur05codi = (select max(c.pur05codi)
                                        from pur05 c
                                        where c.pur01pred = a.clave_catastral) 
                     and pur05acons > 0),0) 
            when 1 then '01'
            when 2 then '03'
            when 0 then '04'
            else '07'
            end
        when '07' then (select b.ren21desc 
                        from ren21 b
                        where b.ren20codi = 55
                        and b.ren21subf = (select nvl(b.pur05cfca,1)
                                           from pur05 b
                                           where b.pur01pred = a.clave_catastral
                                           and b.pur05codi = (select max(c.pur05codi)
                                                              from pur05 c
                                                              where c.pur01pred = a.clave_catastral) 
                                           and pur05acons > 0))
        end otro_tip_bien_inm,
        numero_predio,
        clave_catastral,
        avaluo_terreno,
        avaluo_const,
        area_total_predio,
        avaluo_total_predio,
        '108' provincia,
        '10801' canton 
from v_catastro_urb_sri a


/*
    01 casa  1  
    02 edificio 
    03 departamneto
    04 terreno
    05 local comercial
    06 fabrica
    07 otros
*/

select * from ren21 where ren21subf in (select distinct(pur05cfca) from pur05)
and ren20codi = 55


select * from ren21 where ren20codi = 55

select * from ren21 where ren21codi = 320