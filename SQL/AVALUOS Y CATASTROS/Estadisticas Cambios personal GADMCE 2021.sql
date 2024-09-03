select 2021 anio, count(nom01codi) usuarios_creados,
      (select count(distinct(to_number(replace(substr(a.campo, instr(a.campo,'(')+1, instr(a.campo,')')),')'))))
       from sysaudcab a
       where tabla = 'NOM01'
       and to_char(a.fecha,'rrrr') = '2021' 
       and sentencia_DML = 'UPDATE') usuarios_modificados,
      (select count(distinct(trol02codi)) 
       from trol02
       where trol02desc like ('%2021%')
       and trol02est = 'G') roles_de_pago_gestionados,
      300 actualizaciones_cargo
from nom01
where to_char(nom01fcre,'rrrr') = '2021'
group by to_char(nom01fcre,'rrrr')



select * from con01


select * from car03










