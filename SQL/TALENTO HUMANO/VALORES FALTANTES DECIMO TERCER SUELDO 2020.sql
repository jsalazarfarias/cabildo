SELECT a.codigo_funcionario,
       a.NOMBRE_FUNCIONARIO,
       pk_nomtitulos.FD_CEDULA(a.codigo_funcionario) cedula,
       a.DESCRIPCION_INGRESO,
       Nom13_Dec_Tra_2015(a.CODIGO_FUNCIONARIO, 64,to_date('01-12-2020','dd-mm-rrrr'), to_date('31-12-2020','dd-mm-rrrr')) valor_a_pagar,
       a.INGRESO valor_pagado,
       Nom13_Dec_Tra_2015_falt(a.CODIGO_FUNCIONARIO, 64,to_date('01-12-2020','dd-mm-rrrr'), to_date('31-12-2020','dd-mm-rrrr')) valor_faltante
FROM v_rol_individual a
--where codigo_funcionario = 345
where anio = 2020
and descripcion_rol like ('TRABAJADORES%DECIMO%TERCER%')
AND NOT CON02CODI IS NOT NULL
order by a.nombre_funcionario