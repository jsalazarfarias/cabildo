select b.gen01codi ciu, pk_uti.gen01_com(b.gen01codi) contribuyente, a.emi02vdet emision, decode(b.emi01esta,'E','PENDIENTE DE PAGO','A','TITULO EN ABONO','R','RECAUDADO','J','RECAUDADO POR ABONO', 'B','DADO DE BAJA') estado_titulo
from emi02 a, emi01 b
where a.emi01codi = b.emi01codi
and a.emi04codi = 510 
and b.emi01esta in ('E','A')
order by 2

select b.gen01codi ciu, pk_uti.gen01_com(b.gen01codi) contribuyente, a.emi02vdet emision, decode(b.emi01esta,'E','PENDIENTE DE PAGO','A','TITULO EN ABONO','R','RECAUDADO','J','RECAUDADO POR ABONO', 'B','DADO DE BAJA') estado_titulo
from emi02 a, emi01 b
where a.emi01codi = b.emi01codi
and a.emi04codi = 510 
and b.emi01esta in ('R','J')
order by 2

select b.gen01codi ciu, pk_uti.gen01_com(b.gen01codi) contribuyente, a.emi02vdet emision, decode(b.emi01esta,'E','PENDIENTE DE PAGO','A','TITULO EN ABONO','R','RECAUDADO','J','RECAUDADO POR ABONO', 'B','DADO DE BAJA') estado_titulo
from emi02 a, emi01 b
where a.emi01codi = b.emi01codi
and a.emi04codi = 510
and b.emi01c4 = 'EMISION GLOBAL 2022' 
--and b.emi01esta = 'R'
order by 2





select * from emi04
where emi04desd like ('%CEM%')