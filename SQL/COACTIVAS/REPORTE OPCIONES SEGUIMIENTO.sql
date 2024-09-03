select SEG01SISTEMA, 
       (select seg01des from st_seg01 where st_seg01.s01codi = st_seg02.s01codi) opcion,
       (select nom01cedual from nom01 where nom01codi in (select seg03codnomi from st_seg03 where st_seg03.seg03codi = st_seg02.seg03codi)) cedula,
       (select nom01codi from nom01 where nom01codi in (select seg03codnomi from st_seg03 where st_seg03.seg03codi = st_seg02.seg03codi)) codigo_func,
       pk_uti.nom01_com((select nom01codi from nom01 where nom01codi in (select seg03codnomi from st_seg03 where st_seg03.seg03codi = st_seg02.seg03codi))) funcionario
from st_seg02
where s01codi in (
select S01CODI from st_seg01
where seg01sistema = 'COACTIVAS'
and seg01des = 'SEGUIMIENTO')
and seg03codi in (select seg03codi from st_seg03
                  where seg03codnomi in (select nom01codi from nom01 where nom01estado = 1))
and seg03codi not in ('SESTUPIN', 'AGRACIA', 'DRODRIG')