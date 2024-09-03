select emi01codi numero_emision, emi01anio anio, pk_uti.find_impuesto(emi01seri) tributo, 
       pk_uti.gen01_com(gen01codi) contribuyente, 
       pk_uti.gen01_ruc(gen01codi) cedula_ruc, 
       emi01fpag, 
       nvl(case when emi01seri = 130 then
           case when nvl((select ren31atot from ren31 where ren31.ren30nemi = emi01.emi01codi),0) - 
                     nvl((select ren31pcorr from ren31 where ren31.ren30nemi = emi01.emi01codi),0) = 0 
                        then nvl((select ren55valo03 from ren05 where ren05.gen01codi = emi01.gen01codi
                                  and ren05codi in (select ren05codi from ren31 where ren30nemi = emi01.emi01codi)),0)  
                else nvl((select ren31atot from ren31 where ren31.ren30nemi = emi01.emi01codi),0) - 
                     nvl((select ren31pcorr from ren31 where ren31.ren30nemi = emi01.emi01codi),0)
           end   
           else 
           case when nvl((select ren31atot from ren31 where ren31.ren30nemi = emi01.emi01codi),0) - 
                     nvl((select ren31pcorr from ren31 where ren31.ren30nemi = emi01.emi01codi),0) = 0 
                        then nvl((select ren55valo01 from ren05 where ren05.gen01codi = emi01.gen01codi
                                  and ren05codi in (select ren05codi from ren31 where ren30nemi = emi01.emi01codi)),0) 
                else nvl((select ren31atot from ren31 where ren31.ren30nemi = emi01.emi01codi),0) - 
                     nvl((select ren31pcorr from ren31 where ren31.ren30nemi = emi01.emi01codi),0)
           end 
       end,0) base_imponible
from emi01
where emi01seri in (130, 5)
and to_date(emi01fcre,'dd-mm-rrrr') >= to_date('01-09-2019','dd-mm-rrrr')
and to_date(emi01fcre,'dd-mm-rrrr') <= to_date('31-03-2022','dd-mm-rrrr') 
and to_char(emi01fcre,'rrrr') = '2022'
order by 3,2,4 
--and emi01codi = 1803401


pk_emi


select * from emi03
where emi03codi in (130, 5) 


select * from ren31
where ren30nemi = 1803401


select * from ren05 where ren05codi = 6970

select * from sysaudren05


F01300404