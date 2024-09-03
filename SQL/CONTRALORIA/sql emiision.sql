select a.gen01codi ciu, pk_uti.gen01_com(a.gen01codi) contribuyente, a.emi01codi numero_titulo, a.emi01anio anio,
       pk_uti.find_impuesto(a.emi01seri) tributo,
       (select c.emi04desd from emi04 c where c.emi04codi = b.emi04codi) componente,
       b.emi02vdet valor 
from emi01 a, emi02 b
where a.emi01codi = b.emi01codi
and a.emi01anio = 2020

select a.gen01codi ciu, pk_uti.gen01_com(a.gen01codi) contribuyente, pk_uti.find_impuesto(emi01seri) tributo,  
       emi01vtot valor_emision, emi01anio anio, emi01fobl fecha_obligacion, 
       emi01codi numero_titulo, emi01titu descripcion_titulo
from emi01 a where emi01anio = 2020

