select emi01codi num_titulo, to_number(to_char(emi01feli,'rrrr')) anio_baja, emi01anio anio_titulo,gen01codi ciu, pk_uti.gen01_com(gen01codi) contribuyente, 
replace((replace(substr(substr(emi01titu, instr(emi01titu,'Base imponible :')),1,instr(substr(emi01titu, instr(emi01titu,'Base imponible :')),'Observaciones')-1),'Base imponible :','')),'Base imponible :','') base_imponible,
pk_uti.gen01_ruc(gen01codi) ruc_cedula,PK_UTI.FIND_IMPUESTO(EMI01SERI) IMPUESTO, 
emi01vtot valor_emision, (select emi02vdet 
                            from emi02 b
                            where b.emi01codi = emi01.emi01codi
                            and emi04codi = 404) valor_patente,
                          (select emi02vdet 
                            from emi02 b
                            where b.emi01codi = emi01.emi01codi
                            and emi04codi = 113) servicios_adminis, 
emi01inte, emi01reca, emi01coa, emi01desc, 
(emi01vtot + nvl(emi01inte,0) + nvl(emi01reca,0)  + nvl(emi01coa,0)) - nvl(emi01desc,0) valor_titulo, emi01femi fecha_emisiom, emi01lcre usario,(select seg03com from st_seg03 a where a.seg03codi = emi01.EMI01LCRE) funcionario_emite,
emi01fpag fecha_pago, emi01lpag usuario_recaudador, (select seg03com from st_seg03 a where a.seg03codi = emi01.EMI01Lpag) funcionario_reca ,emi01npag num_pago
from emi01 
where to_date(emi01feli,'dd-mm-rrrr') >= to_date('15-05-2019','dd-mm-rrrr')
and to_date(emi01feli,'dd-mm-rrrr') <= to_date('31-12-2023','dd-mm-rrrr')
and emi01esta = 'B'
and emi01seri in ('130')
and emi01anio in('2019', '2020','2021','2022','2023')


select * from emi04 where emi04codi in (
select EMI04CODI from emi02
where emi01codi in (select emi01codi from emi01 where emi01anio in('2019', '2020','2021','2022','2023') and emi01seri = 130)
GROUP BY EMI04CODI)
