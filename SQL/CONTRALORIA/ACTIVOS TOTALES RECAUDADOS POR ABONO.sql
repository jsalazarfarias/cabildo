select * from emi04
where emi04codi in (select emi04codi 
                    from emi02 
                    where emi01codi in (select emi01codi 
                                        from emi01 
                                        where to_date(emi01fpag,'dd-mm-rrrr') >= to_date('15-05-2019','DD-MM-RRRR')
                                        and to_date(emi01fpag,'dd-mm-rrrr') <= to_date('31-12-2023','DD-MM-RRRR')
                                        and emi01seri = 130
                                        and emi01anio in (2019,2020,2021,2022,2023))
                    group by emi04codi);

select emi01codi, emi01anio, pk_uti.gen01_com(gen01codi) contribuyente,
       pk_uti.gen01_ruc(gen01codi) identificacion, to_char(emi01fcre,'rrrr-mm-dd') fecha_creacion,
       emi01lcre login_emision, (select seg03com from st_seg03 a where a.seg03codi = a.emi01lcre) usuario_emision,
       replace(replace((replace(substr(substr(emi01titu, instr(emi01titu,'Base imponible :')),1,instr(substr(emi01titu, instr(emi01titu,'Base imponible :')),'Observaciones')-1),'Base imponible :','')),'Base imponible :'),'.',',') base_imponible,
       (select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 404
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)) valor,
        (select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 113
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)) servicios_adm, emi01vtot,
        (select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 2503
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)) recargos,
        (select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 2505
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)) interes,
        (select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 2504
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)) coactiva,
        (select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 404
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)) valor,
        (select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 113
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)) servicios_adm, emi01vtot +
    nvl((select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 2503
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)),0) +
    nvl((select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 2505
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)),0) +
    nvl((select sum(fpd02valorabo) 
        from fpd02 d
        where d.emi01codi = a.emi01codi
        and emi04codi = 2504
        and fpd01codi in (select e.fpd01codi 
                          from fpd01 e 
                          where e.fpd01estado = 'RE' 
                          and e.fpd01codi = d.fpd01codi)),0) valor_total,
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
and emi01seri = 130
and emi01anio in (2019,2020,2021,2022,2023)