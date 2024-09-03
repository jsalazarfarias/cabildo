select emi01codi, to_number(to_char((select max(fpd01fpago) 
         from fpd01 d
         where d.emi01codi = a.emi01codi),'rrrr')) anio_pago, emi01anio anio_titulo, gen01codi ciu,pk_uti.gen01_com(gen01codi) contribuyente,
       pk_uti.gen01_ruc(gen01codi) identificacion, to_char(emi01fcre,'rrrr-mm-dd') fecha_creacion,
       emi01lcre login_emision, (select seg03com from st_seg03 a where a.seg03codi = a.emi01lcre) usuario_emision,
       nvl(emi01n2,0) base_imponible,
       emi01vtot valor_emision,
       (select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi IN (444,402,511)
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)) impuesto_predial,
       (select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 510
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)) CEM,
        (select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 185
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)) servicios_adm, 
        (select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 176
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)) bomberos, 
        nvl((select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 2500
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)),0) interes,
        0 recargos,
        0 coactiva,
        emi01vtot +
        0 +
    nvl((select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 2500
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)),0) +
        0 valor_total,
        to_char((select max(fpd01fpago) 
         from fpd01 d
         where d.emi01codi = a.emi01codi),'rrrr-mm-dd') fecha_pago, 
         (select e.fpd01lpago 
                         from fpd01 e
                         where e.emi01codi = a.emi01codi
                         and e.fpd01fpago in (select max(fpd01fpago)
                                              from fpd01 f
                                              where f.emi01codi = e.emi01codi)) login_recauda,
         st_user((select e.fpd01lpago 
                         from fpd01 e
                         where e.emi01codi = a.emi01codi
                         and e.fpd01fpago in (select max(fpd01fpago)
                                              from fpd01 f
                                              where f.emi01codi = e.emi01codi))) nombre_recauda                  
from emi01 a 
where a.emi01codi in (select b.emi01codi 
                    from fpd01 b
                    where b.fpd01fpago in (select max(fpd01fpagO)
                                            from fpd01 b
                                            where emi01codi in (select emi01codi from emi01 where emi01esta = 'J')
                                            and to_date(fpd01fpago,'dd-mm-rrrr') >= to_date('15-05-2019','dd-mm-rrrr')
                                            and to_date(fpd01fpago,'dd-mm-rrrr') <= to_date('31-12-2023','dd-mm-rrrr')
                                            group by emi01codi)
                    and b.emi01codi = a.emi01codi)
and emi01esta = 'J'
and emi01seri = 140
and emi01anio in (2019,2020,2021,2022,2023)
and (select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 510
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)) > 0
--and a.emi01codi = 1806895


SELECT * FROM EMI04
WHERE EMI04CODI IN (SELECT EMI04CODI FROM EMI02 WHERE EMI01CODI IN (SELECT EMI01CODI FROM EMI01 WHERE emi01seri = '140'
and emi01anio in ('2019', '2020','2021','2022','2023') AND EMI01ESTA = 'J')
GROUP BY EMI04CODI)