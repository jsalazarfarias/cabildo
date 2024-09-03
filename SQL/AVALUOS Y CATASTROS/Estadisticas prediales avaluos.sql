select to_char(a.fecha_creacion,'rrrr'), count(a.clave) claves_creadas,
       (select count(b.clave)
        from v_urbanorustico b
        where to_date(fecha_modifica,'dd-mm-rrrr') >= to_date('01-01-2021','dd-mm-rrrr')
        and to_date(fecha_modifica,'dd-mm-rrrr') <= to_date('31-12-2021','dd-mm-rrrr')
        and to_char(fecha_modifica,'rrrr') = '2021') claves_modificadas,
       (select count(distinct(b.pur01pred))
        from pur_mordena a,pur_ordena b
        where purexiste = 'ELIMINA'
        and a.purord = b.purord
        and to_char(purfap,'rrrr') = '2021') claves_dada_de_baja,
       (select count(distinct(b.pur01pred))
        from pur_mordena a,pur_ordena b
        where purexiste = 'CAMBIO'
        and a.purord = b.purord
        and to_char(purfap,'rrrr') = '2021') actualizacion_clave_catastral,
       (select count(distinct(pur01pred)) 
        from pur06
        where to_char(pur06fing,'rrrr') = '2021'
        and to_char(pur06fter,'rrrr') = '2021'
        and pur01pred not in (select tra01clave 
                              from tra01
                              where to_char(tra01fmod,'rrrr') = '2021'
                              and tra01esta = 'F')) cambios_de_nombre,
       (select count(distinct(tra01clave)) 
        from tra01
        where to_char(tra01fmod,'rrrr') = '2021'
        and tra01esta = 'F') traspasos_dominio_efectuados,
       (select count(pur01audcercodi) 
        from pur01audcer
        where to_char(pur01audcerfcre,'rrrr') = '2021') certificados_manuales_emitidos,
       (select count(distinct(pur01repcodi)) from pur01rep
        where pur01repesta = 'CA'
        and to_char(pur01repfap,'rrrr') = '2021') certificados_generados_PC
from v_urbanorustico a
where to_date(fecha_creacion,'dd-mm-rrrr') >= to_date('01-01-2021','dd-mm-rrrr')
and to_date(fecha_creacion,'dd-mm-rrrr') <= to_date('31-12-2021','dd-mm-rrrr')
and to_char(fecha_creacion,'rrrr') = '2021'
group by to_char(fecha_creacion,'rrrr')


select count(distinct(pur01repcodi)) from pur01rep
where pur01repesta = 'CA'
and to_char(pur01repfap,'rrrr') = '2021'