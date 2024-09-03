select  pla01hoj, pla02manz, pla02larg, pla02anc, pla02area, pla02nlote, NVL(pla02nlreg,0), NVL(pla02pred, 0), NVL(pla02poli, 0), 'SISESMER' FCREA, 
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
where pla01hoj = '0906'
and pla02manz in (118,171,226,227,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,284,309,310,311,312,313,317,318,319,320,321,322,
                  323,324,325,326,327,328,329,330,331,400,401,402,403,404,405,406,407,408,409,410,412,413,414,415,416,417,418,419,420,421,422,423,424,451,452,
                  453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,494,495,496,497,513,515,516,517,518,519,
                  520,521,522,528,529,531,532,533,534,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,
                  575,576,577,578,579,597,598,599,650,654,672,687,712,724,725,726,727,728,729,730,731,732,733,771,772,773,774,775,776,777,820,851,874,876,881,
                  882,883,884,887,888,889,890,891,892,893,894,895,896,897,898,982)
