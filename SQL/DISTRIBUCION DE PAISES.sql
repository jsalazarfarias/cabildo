SELECT A.REN21CODI COD_PAIS, A.REN21DESC PAIS, 
       B.REN21CODI COD_PROVINCIA, B.REN21DESC PROVINCIA, 
       C.REN21CODI COD_CANTON, C.REN21DESC CANTON 
FROM REN21 A, REN21 B, REN21 C
WHERE B.REN21SUBF = TO_CHAR(A.REN21CODI)
AND C.REN21SUBF = TO_CHAR(B.REN21CODI)
AND A.REN20CODI = 166
AND B.REN20CODI = 115
AND C.REN20CODI = 167
