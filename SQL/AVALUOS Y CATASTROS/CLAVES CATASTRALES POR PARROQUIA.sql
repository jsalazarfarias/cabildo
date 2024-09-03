select a.pur01pred clave, f_propietariopur (a.pur01pred) contribuyente, f_propietariopur_ciu (a.pur01pred) ciu,
       pk_uti.gen01_ruc (f_propietariopur_ciu (a.pur01pred)) cedula, a.pur01atter superficie, a.pur01atco area_construccion,
       b.pur02long frente_principal, b.PUR02FONDRELA fondo_relativo,  pk_uti.F_PARRQ_PLA02(substr(a.pur01pred,1,7)) parroquia      
from pur01 a, pur02 b
where a.pur01esta in ('MD', 'TT', 'CO', 'IG')
and b.pur01pred = a.pur01pred
and substr(a.pur01pred,1,4) = '1301'
and substr(a.pur01pred,5,3) in ('014','015','016','023','027','022','025','028')
union
select a.pur01pred clave, f_propietariopur (a.pur01pred) contribuyente, f_propietariopur_ciu (a.pur01pred) ciu,
       pk_uti.gen01_ruc (f_propietariopur_ciu (a.pur01pred)) cedula, a.pur01atter superficie, a.pur01atco area_construccion,
       b.pur02long frente_principal, b.PUR02FONDRELA fondo_relativo, pk_uti.F_PARRQ_PLA02(substr(a.pur01pred,1,7)) parroquia        
from pur01 a, pur02 b
where a.pur01esta in ('MD', 'TT', 'CO', 'IG')
and b.pur01pred = a.pur01pred
and substr(a.pur01pred,1,4) = '1701'
and substr(a.pur01pred,5,3) in ('093','032','034','038','091','031')
order by 9,1



v_urbanorustico