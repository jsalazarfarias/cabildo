select distinct(pur01pred) clave,
       sysaudpur01cmod cambio, 
       case sysaudpur01vant
         when 'IG' then 'INGRESADO'
         when 'MD' then 'MODIFICADO'
         when 'PE' then 'PREDIO ELIMINADO'
         when 'PH' then 'PROPIEDAD HORIZONTAL'
         when 'TT' then 'TRASPASO DE DOMINIO'
         when 'CO' then 'PREDIO COACTIVADO'
         when 'ERROR' then 'SIN VALOR ASIGNADO'
       else sysaudpur01vant      
       end valor_anterior, 
       case sysaudpur01vnue
         when 'IG' then 'INGRESADO'
         when 'MD' then 'MODIFICADO'
         when 'PE' then 'PREDIO ELIMINADO'
         when 'PH' then 'PROPIEDAD HORIZONTAL'
         when 'TT' then 'TRASPASO DE DOMINIO'
         when 'CO' then 'PREDIO COACTIVADO'
         when 'ERROR' then 'SIN VALOR ASIGNADO'
       else sysaudpur01vnue
       end valor_nuevo,
       sysaudpur01lcre login, 
       pk_uti.nom01_com((select seg03codnomi 
                         from st_seg03 
                         where seg03codi = sysaudpur01.sysaudpur01lcre)) funcionario,
       (select account_status 
        from dba_users 
        where username = sysaudpur01.sysaudpur01lcre) estado_cuenta,
       (select decode(nom01estado,'1','ACTIVO','2','INACTIVO') 
        from nom01 where nom01codi in (select seg03codnomi 
                                       from st_seg03 
                                       where seg03codi = sysaudpur01.sysaudpur01lcre)) estado_empleado,
      (select departamento from v_empleados
       where estado_empleado = 1
       and codigo_empleado in (select seg03codnomi 
                               from st_seg03 
                               where seg03codi = sysaudpur01.sysaudpur01lcre)) departamento,
      (select cargo from v_empleados
       where estado_empleado = 1
       and codigo_empleado in (select seg03codnomi 
                               from st_seg03 
                               where seg03codi = sysaudpur01.sysaudpur01lcre)) cargo
from sysaudpur01
where sysaudpur01fcam >= to_date('01-01-2023','dd-mm-rrrr')
and sysaudpur01fcam <= to_date(sysdate,'dd-mm-rrrr')
group by pur01pred, sysaudpur01lcre, sysaudpur01cmod,sysaudpur01vant, sysaudpur01vnue
order by 1
 

select distinct(account_status) from dba_users


select * from v_urbanorustico where clave = '1701357001'


case sysaudpur01vant
     when 'IG' then 'INGRESADO'
     when 'MD' then 'MODIFICADO'
     when 'PE' then 'PREDIO ELIMINADO'
     when 'PH' then 'PROPIEDAD HORIZONTAL'
     when 'TT' then 'TRASPASO DE DOMINIO'
     when 'CO' then 'PREDIO COACTIVADO'
else sysaudpur01vant
end sysaudpur01vant


select distinct(pur01esta) from pur01




select count(departamento 
from v_empleados


select departamento from v_empleados
where estado_empleado = 1
and codigo_empelado in (
