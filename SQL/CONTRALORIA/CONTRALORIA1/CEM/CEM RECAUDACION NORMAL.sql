select emi01codi num_titulo, to_number(to_char(emi01fpag,'rrrr')) anio_recauda, emi01anio anio_titulo ,gen01codi ciu, pk_uti.gen01_com(gen01codi) contribuyente, 
emi01n2 base_imponible,
pk_uti.gen01_ruc(gen01codi) ruc_cedula,PK_UTI.FIND_IMPUESTO(EMI01SERI) IMPUESTO, 
emi01vtot valor_emision,  nvl((select emi02vdet 
                            from emi02 b
                            where b.emi01codi = emi01.emi01codi
                            and emi04codi in (402,444,511)),0) impuesto_redial_urbano,
                          nvl((select emi02vdet 
                            from emi02 b
                            where b.emi01codi = emi01.emi01codi
                            and emi04codi = 510),0) CEM,
                          nvl((select emi02vdet 
                            from emi02 b
                            where b.emi01codi = emi01.emi01codi
                            and emi04codi = 185),0) servicios_adminis,
                          nvl((select emi02vdet 
                            from emi02 b
                            where b.emi01codi = emi01.emi01codi
                            and emi04codi = 134),0) SOLAR,
                          nvl((select emi02vdet 
                            from emi02 b
                            where b.emi01codi = emi01.emi01codi
                            and emi04codi = 176),0) BOMBEROS, 
--instr(substr(emi01titu, instr(emi01titu,'Base imponible :')),'Observaciones')-1),'Base imponible :',''))base_imponible,
emi01inte,  emi01reca, emi01coa, emi01desc, 
((emi01vtot + emi01inte + emi01reca + emi01coa) - emi01desc) valor_recaudado, emi01femi fecha_emisiom, emi01lcre usario,(select seg03com from st_seg03 a where a.seg03codi = emi01.EMI01LCRE) funcionario_emite,
emi01fpag fecha_pago, emi01lpag usuario_recaudador, (select seg03com from st_seg03 a where a.seg03codi = emi01.EMI01Lpag) funcionario_reca ,emi01npag num_pago
from emi01 
where to_date(emi01fpag,'dd-mm-rrrr') >= to_date('15-05-2019','dd-mm-rrrr')
and to_date(emi01fpag,'dd-mm-rrrr') <= to_date('31-12-2023','dd-mm-rrrr')
and emi01esta = 'R'
and emi01seri = '140'
and emi01anio in ('2019', '2020','2021','2022','2023')


SELECT * FROM EMI04
WHERE EMI04CODI IN (SELECT EMI04CODI FROM EMI02 WHERE EMI01CODI IN (SELECT EMI01CODI FROM EMI01 WHERE emi01seri = '140'
and emi01anio in ('2019', '2020','2021','2022','2023') AND EMI01ESTA = 'R')
GROUP BY EMI04CODI)


select * from emi01
where emi01anio = 2022