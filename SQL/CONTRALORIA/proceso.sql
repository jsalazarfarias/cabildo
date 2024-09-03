select * from sigcal01 where npur01pred = '08016611116018000000P00'

select * from pur01 where PUR01PRED = '08016611116018000000P00'

select * from pur01 where pur01cant = '0906101006'

SELECT * FROM PUR06 WHERE PUR01PRED = '08015081028005000000P00'


select * from emi01 where emi01clave = '08015098016012000000P00'


delete pur10 where pur01pred = '08015098016012000000P00' and pur10anio = 2024;
delete pur05 where pur01pred = '08015098016012000000P00';
delete pur04 where pur01pred = '08015098016012000000P00';
delete pur02 where pur01pred = '08015098016012000000P00';
delete pur06 where pur01pred = '08015098016012000000P00';
delete pur08 where pur01pred = '08015098016012000000P00';
delete pur01 where pur01pred = '08015098016012000000P00';

-- 08015096010005000000P00
-- 08016611118005000000P00

SELECT * FROM GEN01 WHERE GEN01CODI = 103414

SELECT * FROM GEN01 WHERE GEN01RUC = '0800643603'

select * from rc10


select * from v_gen01urbanorustico where clave in ('08015081028005000000P00')



select * from emi01 where gen01codi = 83643
and emi01codi = 1688860


select * from v_funcio_opcion
where upper(opcion) like('%TRASPAS%')