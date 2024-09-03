select codigo_empleado,
       nombre_empleado,
       cedula_empleado,
       titulo,
       departamento,
       fecha_ingreso_empleado,
       (select re01desc
        from reg01
        where reg01codi in (select d.car09reg01codi
                            from car09 d
                            where d.nom01codi = a.codigo_empleado
                            and d.car09codi in (select min(b.car09codi)
                                                from car09 b
                                                where b.nom01codi = a.codigo_empleado
                                                and car09fini = (select min(c.car09fini)
                                                                 from car09 c
                                                                 where c.nom01codi = a.codigo_empleado)))) regimen_inicial,
       nom_fprim_regimen2(codigo_empleado) fecha_ingreso_regimen_actual, 
       regimen regimen_actual,
       salario_unificado,
       decode(estado_empleado,1,'ACTIVO',2,'INACTIVO') estado_empleado,
       NVL(nvl(e_mail,correo_institucional),'SIN CORREO REGISTRADO') e_mail
from v_empleados a
where estado_empleado = 1
and regimen not in ('JUBILADOS')