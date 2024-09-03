select * from v_vacaciones_tom
--WHERE cod = 297
where (descripcion = 'VACACIONES')
and to_date(nomca01fini,'dd-mm-rrrr') >= to_date(:fecha1,'dd-mm-rrrr') 
     --and to_date(:fecha2,'dd-mm-rrrr') <= to_date(nomca01ffin,'dd-mm-rrrr'))



select * from v_vacaciones_tom
WHERE cod = 337
and (descripcion = 'VACACIONES')
and (nomca01fini between to_date(:fecha1,'dd-mm-rrrr') and to_date(:fecha2,'dd-mm-rrrr')) 
 (nomca01ffin between to_date(:fecha1,'dd-mm-rrrr') and to_date(:fecha2,'dd-mm-rrrr'))



select * from v_vacaciones_tom
where (descripcion = 'VACACIONES')
and (to_date(:fecha1,'dd-mm-rrrr') between nomca01fini and nomca01ffin
    and to_date(:fecha2,'dd-mm-rrrr') between nomca01fini and nomca01ffin)



select * from v_vacaciones_tom
where (descripcion = 'VACACIONES')
and ((nomca01fini between to_date(:fecha1,'dd-mm-rrrr') and to_date(:fecha2,'dd-mm-rrrr')
     or nomca01ffin between to_date(:fecha1,'dd-mm-rrrr') and to_date(:fecha2,'dd-mm-rrrr'))
     or (to_date(:fecha1,'dd-mm-rrrr') between nomca01fini and nomca01ffin
     and to_date(:fecha2,'dd-mm-rrrr') between nomca01fini and nomca01ffin))
     and cod = 337
     
     
select * from v_ausencia     
     
select * from nomca02
where nom01codi = 345
and nomca02per = 2021


select max(nomca02codi) from nomca02


select * from ren21 where ren21codi = 6824

select * from v_nomprv01_disp where codigo_funcionario = 345


select * from nom01 where nom01codi = 345


select * from st_seg04