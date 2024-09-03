select anio, 
       a.codigo_funcionario,
       pk_uti.nom01_com(a.codigo_funcionario) funcionario, 
       pk_nomtitulos.FD_CEDULA(a.codigo_funcionario) cedula,
       (select sum(b.VALOR) 
            from v_rol_mensual b
            where b.CODIGO_FUNCIONARIO = a.CODIGO_FUNCIONARIO
            and b.DESCRIPCION LIKE '%APORTE%'
            and b.anio = a.anio) APORTE_IESS_TRA,
       (select sum(b.VALOR) 
            from v_rol_mensual b
            where b.CODIGO_FUNCIONARIO = a.CODIGO_FUNCIONARIO
            and b.DESCRIPCION = 'APORTE IESS EMP'
            and b.anio = a.anio) APORTE_IESS_EMP,
       (select sum(b.VALOR) 
            from v_rol_mensual b
            where b.CODIGO_FUNCIONARIO = a.CODIGO_FUNCIONARIO
            and b.DESCRIPCION = 'FONDO DE RESERVA'
            and b.anio = a.anio) FONDO_DE_RESERVA,
       (select sum(b.VALOR) 
            from v_rol_mensual b
            where b.CODIGO_FUNCIONARIO = a.CODIGO_FUNCIONARIO
            and b.DESCRIPCION = 'Remuneracion Unificada y/o Salarios'
            and b.anio = a.anio) Remuneracion_Unificada,
       (select sum(b.VALOR) 
            from v_rol_mensual b
            where b.CODIGO_FUNCIONARIO = a.CODIGO_FUNCIONARIO
            and b.DESCRIPCION = 'Subsidio de Antiguedad'
            and b.anio = a.anio) Subsidio_Antiguedad,  
       (select sum(b.VALOR) 
            from v_rol_mensual b
            where b.CODIGO_FUNCIONARIO = a.CODIGO_FUNCIONARIO
            and b.DESCRIPCION = 'Horas Suplementarias'
            and b.anio = a.anio) Horas_Suplementarias,
       (select sum(b.VALOR) 
            from v_rol_mensual b
            where b.CODIGO_FUNCIONARIO = a.CODIGO_FUNCIONARIO
            and b.DESCRIPCION = 'Horas Extras'
            and b.anio = a.anio) Horas_Extras          
from v_rol_anual a
--where a.codigo_funcionario = 345
WHERE a.ANIo = 2014
group by a.codigo_funcionario, a.anio


select distinct(a.descripcion) from v_rol_anual a
where upper(descripcion) LIKE ('%APOR%')