select '0908'||'|'||pla02manz||'|'||pla02larg||'|'||pla02anc||'|'||pla02area||'|'||pla02nlote||'|'||NVL(pla02nlreg,0)||'|'||NVL(pla02pred, 0)||'|'|| 
       NVL(pla02poli, 0)||'|'||pla02parr||'|'||pla02barrio||'|'||
            (SELECT B.PURVM2XMZVALOR
            FROM PURVM2XMZ B
            WHERE B.PURVM2XMZZONIFICA = A.PLA01HOJ || A.PLA02MANZ
                AND TO_CHAR(B.PURVM2XMZFINI, 'RRRR') <= 2020
                AND TO_CHAR(B.PURVM2XMZFFIN, 'RRRR') >= 2020)||'|'||NVL(pla02npis, 0)||'|'||NVL(pla02cus, 0)||'|'||NVL(pla02cos, 0)||'|'|| 
       NVL(pla02ado, 0)||'|'||NVL(pla02rlizq, 0)||'|'||NVL(pla02rlder, 0)||'|'||NVL(pla02rpos, 0)||'|'||NVL(pla02rfron, 0)||'|'||NVL(pla02amin, 0)||'|'||NVL(pla02vsimu, 0)||'|'||NVL(pla02pormil, 0)||'|'|| 
       NVL(pla02vventa, 0)||'' as insercion
from pla02 a
where pla01hoj = '0906' 
and pla02manz in (118,171,226,227,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,284,309,310,311,312,313,317,318,319,320,321,322,
                  323,324,325,326,327,328,329,330,331,400,401,402,403,404,405,406,407,408,409,410,412,413,414,415,416,417,418,419,420,421,422,423,424,451,452,
                  453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,494,495,496,497,513,515,516,517,518,519,
                  520,521,522,528,529,531,532,533,534,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,
                  575,576,577,578,579,597,598,599,650,654,672,687,712,724,725,726,727,728,729,730,731,732,733,771,772,773,774,775,776,777,820,851,874,876,881,
                  882,883,884,887,888,889,890,891,892,893,894,895,896,897,898,982)


DELETE placmas02

PURCMAS02