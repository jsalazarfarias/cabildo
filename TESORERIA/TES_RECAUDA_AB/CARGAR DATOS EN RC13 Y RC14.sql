INSERT INTO rc13
                     (RC13CODI, 
                      RC09CODI, 
                      RC13EMI01ESTA, 
                      RC13EMI01FINI,                                 
                      RC13EMI01FFIN,                                  
                      RC13NROREG, 
                      RC13VAL1, 
                      RC13VAL2, 
                      RC13EMI01LCRE, 
                      RC13EMI01FCRE)
(SELECT (SELECT NVL(MAX(RC13CODI),0) + 1 FROM RC13),
        '24',
        'P'
        ,TO_date(SYSDATE -1 ,'DD/MM/RRRR HH24:MI:SS')
        ,TO_date(SYSDATE -1 ,'DD/MM/RRRR HH24:MI:SS')
        ,(SELECT COUNT(*)
                from emi01 where emi01esta = 'E'
                AND GEN01CODI = 57418
                AND EMI01SERI = 140)
        ,(SELECT SUM(((EMI01VTOT + 
                             NVL(WEB_INTERES(EMI01CODI),0) + 
                             NVL(WEB_RECARGO(EMI01CODI),0) +  
                             NVL(WEB_COACTIVA(EMI01CODI),0)) - WEB_DESCUENTO(EMI01CODI)))
                from emi01 where emi01esta = 'E'
                AND GEN01CODI = 57418
                AND EMI01SERI = 140)
        ,'0',
        user,
        sysdate -1
FROM DUAL);


INSERT INTO rc14(RC14CODI,
                 RC13CODI,
                 RC14ESTA,
                 EMI01CODI,
                 EMI01ANIO,
                 RC14VTOT,
                 RC14FREC,
                 REN21CODI,
                 PUR01PRED,
                 RC14CODIREF1,
                 RC14CODIREF2,
                 RC14CODIREF3,
                 RC14LCRE,
                 RC14FCRE)
(select SQ_RC13.NEXTVAL, 
       1,
       'P', 
       EMI01CODI, 
       EMI01ANIO, 
       ((EMI01VTOT + NVL(WEB_INTERES(EMI01CODI),0) + 
                    NVL(WEB_RECARGO(EMI01CODI),0) +  
                    NVL(WEB_COACTIVA(EMI01CODI),0)) - WEB_DESCUENTO(EMI01CODI)),
       TO_date(SYSDATE -1 ,'DD/MM/RRRR HH24:MI:SS'),
       43426,
       EMI01CLAVE,
       'A',
       'B',
       'C',
       USER,
       SYSDATE -1.
from emi01 where emi01esta = 'E'
AND GEN01CODI = 57418
AND EMI01SERI = 140)



SELECT EMI01ESTA FROM EMI01
WHERE EMI01CODI IN (SELECT EMI01CODI FROM RC14)









