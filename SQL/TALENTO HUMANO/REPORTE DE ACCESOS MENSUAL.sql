select sesion01 login,
       case when pk_uti.SEG03_COM(sesion01) = 'CA-0010' 
           then pk_uti.nom01_com(PK_UTI.SEG03_NOM01CODI(c.sesion01))
           else pk_uti.SEG03_COM(sesion01)
       end funcionario, 
       to_char(c.fechaing,'mm-rrrr') mes_ingreso, 
       count(sesion01) cantidad_accesos, 
       opcion cod_opcion,
       (select seg01des from st_seg01 where seg01fun = c.opcion) opcion, 
       PK_UTI.SEG03_NOM01CODI(c.sesion01) codigo_funcionario,
       PK_NOMTITULOS.FD_DEPARTAMENTO(b.departamento) departamento,
       pk_nomtitulos.FD_CARGOS(b.cargo) cargo,
       pk_nomtitulos.FD_REGIMEN(b.REGIMEN) regimen
from sysmenus c, trol01 b
where opcion in (select seg01fun
                 from st_seg01
                 where seg01des like ('%RECAUD%')) 
and fechaing >= to_date('01-01-2013','dd-mm-rrrr')
and fechaing <= to_date('31-12-2016','dd-mm-rrrr')
and b.nom01codis = PK_UTI.SEG03_NOM01CODI(c.sesion01)
and to_char(c.fechaing,'mm-rrrr') = to_char(b.fecha_creacion,'mm-rrrr')
and sesion01 not in ('VLACHORN','SESTUPIN','AGRACIA')
group by to_char(c.fechaing,'mm-rrrr'), opcion, sesion01, b.departamento, b.REGIMEN, b.cargo 
order by 1,2,4


select pk_nomtitulos.FD_CARGOS('C.096') from dual