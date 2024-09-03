select nomca02per,
       nom01codi,
       sum(nomca02nd) + trunc(sum(nomca02nh)/8) + trunc((sum(nomca02nm)/60)/8) dias_consumidos,       
       nvl(case when mod(sum(nomca02nd) + trunc(sum(nomca02nh)/8) + trunc((sum(nomca02nm)/60)/8),7) >= 5
           then ((trunc((sum(nomca02nd) + trunc(sum(nomca02nh)/8) + trunc((sum(nomca02nm)/60)/8))/7))*5)+5
       else 
           (trunc((sum(nomca02nd) + trunc(sum(nomca02nh)/8) + trunc((sum(nomca02nm)/60)/8))/7))*5 + mod(sum(nomca02nd) + trunc(sum(nomca02nh)/8) + trunc((sum(nomca02nm)/60)/8),7)   
       end,0) dias_habiles_consumidos,
       nvl(case when mod(sum(nomca02nd) + trunc(sum(nomca02nh)/8) + trunc((sum(nomca02nm)/60)/8),7) >= 5
           then (trunc((sum(nomca02nd) + trunc(sum(nomca02nh)/8) + trunc((sum(nomca02nm)/60)/8))/7)) * 2 + mod(mod(sum(nomca02nd) + trunc(sum(nomca02nh)/8) + trunc((sum(nomca02nm)/60)/8),7),5)
           else
                (trunc((sum(nomca02nd) + trunc(sum(nomca02nh)/8) + trunc((sum(nomca02nm)/60)/8))/7)) * 2
       end,0) dias_nhabiles_consumidos,
       mod(sum(nomca02nh)+trunc(sum(nomca02nm)/60),8) horas_consumidas, 
       mod(sum(nomca02nm),60) 
from nomca02 a
where nomca02per in (select max(b.nomca02per) 
                   from nomca02 b 
                   where b.nom01codi = a.nom01codi)
and nomca02esta = 'AP'
and nomca02per > 2018
group by  nomca02per, nom01codi 




