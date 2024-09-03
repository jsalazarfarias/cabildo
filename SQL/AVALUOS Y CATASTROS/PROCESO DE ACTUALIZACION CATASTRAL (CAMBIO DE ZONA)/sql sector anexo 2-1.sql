select pla01hoj, pla02manz, pla02larg, pla02anc, pla02area, pla02nlote, NVL(pla02nlreg,0), NVL(pla02pred, 0), NVL(pla02poli, 0), 'SISESMER' FCREA, 
       SYSDATE FCREA, NULL pla02lmod, NULL pla02fmod, 5 CODparr, pla02barrio, pla02valorxmz, NVL(pla02npis, 0), NVL(pla02cus, 0), NVL(pla02cos, 0), 
       NVL(pla02ado, 0), NVL(pla02rlizq, 0), NVL(pla02rlder, 0), NVL(pla02rpos, 0), NVL(pla02rfron, 0), NVL(pla02amin, 0), NVL(pla02vsimu, 0), 
       NVL(pla02pormil, 0), NVL(pla02vventa, 0),
       'insert into pla02(pla01hoj, pla02manz, pla02larg, pla02anc, pla02area, pla02nlote, pla02nlreg, pla02pred, pla02poli, pla02lcrea, pla02fcrea, pla02lmod, pla02fmod, pla02parr, pla02barrio, pla02valorxmz, pla02npis, pla02cus, pla02cos, pla02ado, pla02rlizq, pla02rlder, pla02rpos, pla02rfron, pla02amin, pla02vsimu, pla02pormil, pla02vventa) values ('''
       ||'0908'||''','''||pla02manz||''','''||pla02larg||''','''||pla02anc||''','''||pla02area||''','''||pla02nlote||''','''||pla02nlreg||''','''||pla02pred||''','''|| 
       pla02poli||''','''|| 
       user||substr(''',to_date('''||to_char(sysdate,'dd-mm-rrrr hh24:mi:ss')||',''dd-mm-rrrr hh24:mi:ss'')',1,30)||''''||substr(''',to_date('''||to_char(sysdate,'dd-mm-rrrr hh24:mi:ss')||',''dd-mm-rrrr hh24:mi:ss'')',31)||','''|| 
       pla02lmod||''','''||pla02fmod||''','''||pla02parr||''','''||pla02barrio||''','''||pla02valorxmz||''','''||pla02npis||''','''||pla02cus||''','''||pla02cos||''','''|| 
       pla02ado||''','''||pla02rlizq||''','''||pla02rlder||''','''||pla02rpos||''','''||pla02rfron||''','''||pla02amin||''','''||pla02vsimu||''','''||pla02pormil||''','''|| 
       pla02vventa||''')' as insersion
from pla02
where pla01hoj = '1701'
and pla02manz in (601,602,603,604,605,608,609,610,611,612,620,621,650,651,652,653,654,655,656,657)
