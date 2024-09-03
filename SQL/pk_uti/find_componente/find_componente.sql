FUNCTION find_componente(codigo IN NUMBER) RETURN VARCHAR2
IS
BEGIN
     
     SELECT EMI04DESD 
     INTO completo
     FROM EMI04 A, EMI02 B
     WHERE A.EMI04CODI  = B.EMI04CODI  
     AND A.EMI04CODI = codigo;

      RETURN completo;
      
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    completo := 'EM01-00100';
    RETURN  completo;
  WHEN OTHERS THEN
    completo := 'EMI01-00100';
    RETURN  completo;
END;