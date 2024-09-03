select * from pru10 where pru01cla in (select clave from v_urbanorustico
WHERE CIU IN (37546,127767))


select * from pur06 where pur01pred = '1301225037' 

select * from pur06
where pur06fing >= to_date('01-01-2017','dd-mm-rrrr')
and pur06fing <= to_date('31-12-2019','dd-mm-rrrr')
and gen01codi in (37546,127767)


select * from pru10 
where pru10fing >= to_date('01-01-2017','dd-mm-rrrr')
and pru10fing <= to_date('31-12-2019','dd-mm-rrrr')
and gen01codi in (37546,127767)

select * from gen01 where gen01com like ('%SEGURIDAD%SOCIAL%FUERZAS%ARMADAS%')


