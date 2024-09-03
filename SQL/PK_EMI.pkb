CREATE OR REPLACE PACKAGE BODY SISESMER.Pk_Emi AS
/* PAQUETE:
   Paquete de utilidades del sistema de cabildo
   PRISHARD CIA. LTDA.
   Autor        :    Wladimir Sandoval
   Modicado por :
   Fecha Creacion              Fecha Modificacion
   08/01/2003                   09/09/2003

*/
/* INICIA PROCESO DE EMISION RETORNA EL VALOR DE LA EMISION 0 -1 SI LA EMISION TUBO UN ERROR*/ 

FUNCTION FEMI01_ESTA(CODEMI IN NUMBER) RETURN VARCHAR2 IS

    ESTADO VARCHAR2(2);
BEGIN
    SELECT EMI01ESTA
        INTO ESTADO 
    FROM EMI01 
    WHERE EMI01CODI = CODEMI;

    RETURN (ESTADO);
EXCEPTION
    WHEN OTHERS THEN
        RETURN (NULL);
END;

FUNCTION FGENERA_EMISION(VCLAVE    IN VARCHAR2,
                          VIMPUESTO IN NUMBER,
                          VANIO  IN NUMBER,
                         VMES   IN NUMBER,
                         PGEN01 IN NUMBER,
                         OBSE   IN VARCHAR2,
                         PERIODO IN NUMBER,
                         LSIMULA IN NUMBER,LFOBLIGA IN DATE, LCLAVE IN VARCHAR2,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER
IS
BEGIN
/*  VARIABLE PARA QUE INSERTE LAS EMISIONES EN LA TABLA DE SIMULACION */
  SIMULAR  :=  LSIMULA;

  NRO_VERIFICA:= F_VERIFICA_EMISION(VCLAVE,VIMPUESTO,VANIO,VMES,PGEN01,MENSAJE);

   IF NRO_VERIFICA = -1 THEN
      RAISE E_EXISTE;
   END IF;

   NRO_EMISION := F_EMI01(VCLAVE,VIMPUESTO,VANIO,VMES,PGEN01,OBSE,PERIODO,LFOBLIGA, LCLAVE,MENSAJE);

   IF NRO_EMISION = -1 THEN
         RAISE E_EMISION;
   END IF;

   RETURN NRO_EMISION;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
           MENSAJE := 'Atencion '||SQLERRM;
        ROLLBACK;
        RETURN -1;
   WHEN E_EXISTE THEN
           MENSAJE := ' 1 Atencion Error al generar Emision , ya existe una emision con los mismos datos'||MENSAJE;
        ROLLBACK;
        RETURN -1;
   WHEN E_EMISION THEN
           MENSAJE := '!Atencion!'||MENSAJE;
        ROLLBACK;
        RETURN -1;
   WHEN OTHERS THEN
           MENSAJE := 'Atencion '||SQLERRM;
        ROLLBACK;
        RETURN -1;
END;
/* VERIFICA LA EMISION */
FUNCTION F_VERIFICA_EMISION(VCLAVE IN VARCHAR2,VIMPUESTO IN NUMBER,
                          VANIO  IN NUMBER,
                         VMES   IN NUMBER,
                         PGEN01 IN NUMBER,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER

IS
BEGIN
    /* P pagado, LK bloqueado, D deshabilitado , E listo para cobro, B baja de titulo , C coactiva  */
    SELECT COUNT(*) INTO CTN
    FROM EMI01
    WHERE  EMI01CLAVE = VCLAVE
    AND    EMI01SERI  = VIMPUESTO
    AND       EMI01ANIO  = VANIO
    AND       EMI01MES      = VMES
    AND       GEN01CODI  = PGEN01
    AND    EMI01ESTA  IN ('E');
    IF CTN  <>  0 THEN
       MENSAJE := '2 Atencion ya existe un titulo emitido con estas condiciones...Verifique';
       RETURN -1;
    END IF;

    SELECT COUNT(*) INTO CTN
    FROM EMI01
    WHERE  EMI01CLAVE = VCLAVE
    AND    EMI01SERI  = VIMPUESTO
    AND       EMI01ANIO  = VANIO
    AND       EMI01MES      = VMES
    AND       GEN01CODI  = PGEN01
    AND    EMI01ESTA  IN ('LK','D');
    IF CTN <>  0 THEN
       MENSAJE := ' 3 Atencion el titulo ya fue emitido y esta bloqueado o desactivado ...Verifique';
       RETURN -1;
    END IF;

    SELECT COUNT(*) INTO CTN
    FROM EMI01
    WHERE  EMI01CLAVE = VCLAVE
    AND    EMI01SERI  = VIMPUESTO
    AND       EMI01ANIO  = VANIO
    AND       EMI01MES      = VMES
    AND       GEN01CODI  = PGEN01
    AND    EMI01ESTA  IN ('R');
    IF CTN <>  0 THEN
       MENSAJE := ' 4 Atencion el titulo ya fue pagado emita para proximo periodo ...Verifique';
       RETURN -1;
    END IF;


    RETURN 1;

EXCEPTION
  WHEN OTHERS THEN
    MENSAJE := 'Atencion...'||SQLERRM;
    RETURN -1;
END;

 /* retorna el nombre del contribuyente */
FUNCTION F_EMI01(VCLAVE IN VARCHAR2,VIMPUESTO IN NUMBER,
                          VANIO  IN NUMBER,
                         VMES   IN NUMBER,
                         PGEN01 IN NUMBER,
                         OBSE   IN VARCHAR2,
                         PERIODO IN NUMBER,
                         LFOBLIGA IN DATE, 
                         LCLAVE IN VARCHAR2,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER
IS
VTIPOEMI VARCHAR2(2);
LEYENDA VARCHAR2(80);
NUM_REG NUMBER(2);
ANIO NUMBER(8);
CODEMI04    NUMBER(8);
CONTRIBUYENTE   VARCHAR2(250);
SALARIOSANIO NUMBER;
EXONERA_AVALUO NUMBER;
V_AVALUO NUMBER;
V_CLAVE VARCHAR2(250);

BEGIN

     
    BEGIN
        SELECT emi03tpem  INTO VTIPOEMI
        FROM EMI03
        WHERE emi03codi = VIMPUESTO;
    EXCEPTION
       WHEN OTHERS THEN
                 VTIPOEMI := 'U';
    END;

            FECHA_EMISION       := TO_DATE('01/'||TO_CHAR(VMES  )||'/'||TO_CHAR( VANIO),'dd/mm/yyyy');
            
            CONTRIBUYENTE := PK_UTI.GEN01_COM(PGEN01) ;
            

   IF LFOBLIGA IS NULL THEN
        IF VTIPOEMI = 'A' THEN
           FECHA_OBLIGACION    := TO_DATE('01/'||TO_CHAR(VMES  )||'/'||TO_CHAR( VANIO),'dd/mm/yyyy')+364;
        ELSIF VTIPOEMI = 'M' THEN
           FECHA_OBLIGACION    := TO_DATE('06/'||TO_CHAR(VMES  )||'/'||TO_CHAR( VANIO),'dd/mm/yyyy')+30;
         ELSIF VTIPOEMI = 'U' THEN
             FECHA_OBLIGACION    := TO_DATE('01/'||TO_CHAR(VMES  )||'/'||TO_CHAR( VANIO),'dd/mm/yyyy');
         ELSE
            FECHA_OBLIGACION    := TO_DATE('01/'||TO_CHAR(VMES  )||'/'||TO_CHAR( VANIO),'dd/mm/yyyy');
        END IF;
    ELSE
        FECHA_OBLIGACION    :=LFOBLIGA;
    END IF;

        IF SIMULAR = 0 THEN
            SELECT SQ_EMI01.NEXTVAL INTO SQ_NUMBER FROM DUAL;
            INSERT INTO EMI01 ( EMI01CODI, GEN01CODI, EMI01SERI, EMI01CLAVE, EMI01ANIO, EMI01MES, EMI01DIA,
            EMI01FOBL, EMI01FEMI, EMI01NELI, EMI01FELI, EMI01LELI, EMI01FEST, EMI01FPAG, EMI01LPAG, EMI01NPAG,
            EMI01VTOT, EMI01INTE, EMI01DESC, EMI01RECA, EMI01EXO, EMI01ESTA, EMI01TITU, EMI01FCRE, EMI01LCRE,
            EMI01LMOD, EMI0FMOD, EMI01NCRE, EMI01C3) VALUES (
            SQ_NUMBER, PGEN01, VIMPUESTO,LCLAVE , VANIO, VMES,01,
             FECHA_OBLIGACION,FECHA_EMISION, NULL, NULL, NULL,SYSDATE, NULL, NULL, NULL
            , 0, 0, 0, 0, 'N', 'E', OBSE,  SYSDATE,USER, NULL, NULL, NULL, CONTRIBUYENTE);
        ELSE

            SELECT SQ_SIMULA.NEXTVAL INTO SQ_NUMBER FROM DUAL;
            INSERT INTO EMI01P ( EMI01CODI, GEN01CODI, EMI01SERI, EMI01CLAVE, EMI01ANIO, EMI01MES, EMI01DIA,
            EMI01FOBL, EMI01FEMI, EMI01NELI, EMI01FELI, EMI01LELI, EMI01FEST, EMI01FPAG, EMI01LPAG, EMI01NPAG,
            EMI01VTOT, EMI01INTE, EMI01DESC, EMI01RECA, EMI01EXO, EMI01ESTA, EMI01TITU, EMI01FCRE, EMI01LCRE,
            EMI01LMOD, EMI0FMOD, EMI01NCRE ) VALUES (
            SQ_NUMBER, PGEN01, VIMPUESTO, VCLAVE, VANIO, VMES,01,
             FECHA_OBLIGACION,FECHA_EMISION, NULL, NULL, NULL,SYSDATE, NULL, NULL, NULL
            , 0, 0, 0, 0, 'N', 'E', OBSE,  SYSDATE,USER, NULL, NULL, NULL);
        END IF;

        ctn := F_EMI02(VCLAVE,VIMPUESTO,VANIO ,VMES,PGEN01,SQ_NUMBER,PERIODO,MENSAJE,VALOR_TOTAL);
        
        IF CTN = -1 THEN
           RAISE E_DETALLE;
        END IF;

        IF VALOR_TOTAL < 0 THEN
              RAISE E_VALOR_NEGATIVO;
        END IF;
        
        
        /* PARA SIMULACION */
        IF SIMULAR = 0 THEN
                UPDATE EMI01 SET EMI01VTOT = VALOR_TOTAL WHERE EMI01CODI =  SQ_NUMBER;
                
                IF VIMPUESTO = 140 THEN
                ---------------------------CARGA DE SBU SUSY ANGEL-----------------------------------------
                          SELECT REN21VMIN
                          INTO  SALARIOSANIO
                          FROM REN21
                          WHERE REN20CODI = 5046
                          AND REN21ANIO = VANIO;
                          
                          SELECT PUR01TAVRE, PUR01PRED 
                          INTO V_AVALUO, V_CLAVE
                          FROM pur01
                          WHERE PUR01PRED = (select pur01pred from pur10 where pur10codi = vclave);
                          
                          -----VARIABLE PARA VERIFICACION ANGEL SUSY       
                           EXONERA_AVALUO := SALARIOSANIO * 25;
                          --------------------------------------------------
                
                END IF;
                --------------------------------------------------------------------------
                
                
                
                                --VERIFICACION DE LA APLICACION DE ART.509 COOTAD
                IF VIMPUESTO = 140 THEN
                
                    BEGIN
                       SELECT COUNT(EMI02CODI)
                           INTO NUM_REG
                       FROM EMI02 
                        WHERE EMI01CODI = SQ_NUMBER 
                        AND EMI04CODI = CODEMI04;  --CODIGO CORRESPONDIENTE AL IMPUESTO PREDIAL URBANO (NETO)
                     EXCEPTION
                       WHEN OTHERS THEN
                         NUM_REG := 0;
                    END; 
                    
                    IF NVL(NUM_REG,0) = 0 THEN
                        IF F_PROPURB_TIPUBLIC(V_CLAVE) = 'S' THEN
                            LEYENDA := '. EXONERACION INSTITUCION DEL ESTADO. COOTAD Art.509'; 
                        ELSE
                          if V_AVALUO <  EXONERA_AVALUO then
                            LEYENDA :=  '.EXONERACION AL IMPUESTO PREDIAL URBANO-COOTAD Art.509';
                          end if;
                        END IF;
                    END IF;
                    
                END IF;
               
                -----------------------------------------ROTULO CON CONDICION DE EXONERACION ANGEL SUSY-------------------------- 

                UPDATE EMI01 SET EMI01VTOT = VALOR_TOTAL, EMI01TITU = EMI01TITU ||', '|| LEYENDA WHERE EMI01CODI =  SQ_NUMBER;
               
               --------------------------------------------------------------------------------------------------------------------
        ELSE
                CODEMI04 :=  PK_UTI.COD_COMPTRIBPPAL(VANIO);
                
                 IF VIMPUESTO = 140 THEN
                ---------------------------CARGA DE SBU SUSY ANGEL-----------------------------------------
                          SELECT REN21VMIN
                          INTO  SALARIOSANIO
                          FROM REN21
                          WHERE REN20CODI = 5046
                          AND REN21ANIO = VANIO;
                          
                          SELECT PUR01TAVRE, PUR01PRED 
                          INTO V_AVALUO, V_CLAVE
                          FROM pur01
                          WHERE PUR01PRED = (select pur01pred from pur10 where pur10codi = vclave);
                          
                          -----VARIABLE PARA VERIFICACION ANGEL SUSY       
                           EXONERA_AVALUO := SALARIOSANIO * 25;
                          --------------------------------------------------
                
                END IF;
                --------------------------------------------------------------------------

                --VERIFICACION DE LA APLICACION DE ART.509 COOTAD
                IF VIMPUESTO = 140 THEN
                    BEGIN
                       SELECT COUNT(EMI02CODI)
                           INTO NUM_REG
                       FROM EMI02P 
                        WHERE EMI01CODI = SQ_NUMBER 
                        AND EMI04CODI = CODEMI04;  --CODIGO CORRESPONDIENTE AL IMPUESTO PREDIAL URBANO (NETO)
                     EXCEPTION
                       WHEN OTHERS THEN
                         NUM_REG := 0;
                    END; 
                    
                    IF NUM_REG = 0 THEN
                          if V_AVALUO <  EXONERA_AVALUO then
                            LEYENDA :=  '.EXONERACION AL IMPUESTO PREDIAL URBANO-COOTAD Art.509';
                          end if;
                    END IF;
                END IF;
                
                UPDATE EMI01P SET EMI01VTOT = VALOR_TOTAL, EMI01TITU = EMI01TITU ||', '|| LEYENDA WHERE EMI01CODI =  SQ_NUMBER;
        END IF;

        RETURN SQ_NUMBER;
EXCEPTION
   WHEN E_VALOR_NEGATIVO THEN
       MENSAJE := 'REFERENCIA ...'|| VCLAVE || '... Existe error en formulas consulte con el administrador o los datos son incorrectos...'|| mensaje;
       ROLLBACK;
       RETURN -1;
   WHEN E_DETALLE THEN
       MENSAJE := 'REFERENCIA ...'|| VCLAVE || '... 5 Titulo no puede generar detalles...'|| mensaje;
       ROLLBACK;
       RETURN -1;
   WHEN OTHERS THEN
          ROLLBACK;
       MENSAJE := 'REFERENCIA... '|| VCLAVE || '... 4 Error no determinado...'||SQLERRM;
      RETURN -1;
END;

FUNCTION F_EMI02(VCLAVE IN VARCHAR2,VIMPUESTO IN NUMBER,
                          VANIO  IN NUMBER,
                         VMES   IN NUMBER,
                         PGEN01 IN NUMBER,
                         VEMI01 IN NUMBER,
                         PERIODO IN NUMBER,
                         MENSAJE OUT VARCHAR2,
                         VALOR_TOTAL OUT NUMBER) RETURN NUMBER
IS
/* Permite identificar que rubros esta adicional*/
CURSOR C1 IS
SELECT EMI04CODI,EMI04DESD,emi05codi,emi04cpag,emi04caju,EMI04FINICIO,EMI04FFINAL,EMI04VALORCONST,EMI04FUNCION
FROM EMI04
WHERE EMI03CODI = VIMPUESTO
AND   emi04acti = 'S'
AND     FECHA_EMISION  BETWEEN EMI04FINICIO AND  EMI04FFINAL;

/* LAS EXCEPCIONES */
wval NUMBER(12,2);
BEGIN
/* datos de la cabecera */
/*------------------------*/
    VALOR_TOTAL := 0;
    FOR c1rec IN C1 LOOP

        IF c1rec.emi04cpag = 'F' THEN
          VALOR_DETALLE := Pk_Uti.ejecuta(c1rec.emi04codi,VCLAVE,MENSAJE);
          IF VALOR_DETALLE = -1 THEN
            --MENSAJE := ' 3 Valor componente ...'||MENSAJE || ' REFERENCIA ' || VCLAVE;
            MENSAJE := 'REFERENCIA...'|| VCLAVE || '...3 Valor componente';
            RAISE E_FORMULA;
          END IF;
        ELSE
              VALOR_DETALLE := c1rec.EMI04VALORCONST;
        END IF;

        VALOR_TOTAL   := VALOR_TOTAL + VALOR_DETALLE;
        IF SIMULAR = 0 THEN
          if nvl(VALOR_DETALLE,0) > 0 then
            SELECT SQ_EMI02.NEXTVAL INTO SQ_DNUMBER  FROM DUAL;
            INSERT INTO EMI02 ( EMI02CODI, EMI01CODI, EMI04CODI, EMI02VDET )
            VALUES (SQ_DNUMBER, VEMI01, c1rec.emi04codi, VALOR_DETALLE);
          end if;  
        ELSE
            --SELECT NVL(MAX(emi02codi),0)+1 INTO SQ_DNUMBER  FROM EMI02P;
            if nvl(VALOR_DETALLE,0) > 0 then
            SELECT SQ_SIMULA_DETALLE.NEXTVAL INTO SQ_DNUMBER  FROM DUAL;
            INSERT INTO EMI02P ( EMI02CODI, EMI01CODI, EMI04CODI, EMI02VDET, EMI02EXO, EMI02VEXO, EMI02VCOB,
            EMI02NPAG, EMI02FPAG, EMI02LPAG, EMI02NELI, EMI02FELI, EMI02LELI, EMI02FEMI,EMI02LEMI )
            VALUES (SQ_DNUMBER, VEMI01, c1rec.emi04codi, VALOR_DETALLE, 'N', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL,
            SYSDATE, USER);
            end if;
        END IF;

    END LOOP;

    RETURN 1;

EXCEPTION
   WHEN E_FORMULA THEN
      ROLLBACK;
      --MENSAJE := ' 2 OJO ERROR EN FORMULA..'||SQLERRM || ' REFERENCIA ' || VCLAVE;
      MENSAJE := 'REFERENCIA...'||VCLAVE || '..2 ERROR EN FORMULA';
      RETURN -1;
   WHEN OTHERS THEN
      ROLLBACK;
      --MENSAJE := '3 Atencion error no determinado...'||VEMI01||' OJO '||SQLERRM || ' REFERENCIA ' || VCLAVE;
      MENSAJE := 'REFERENCIA...'||VCLAVE || '...3 error no determinado...Nro.Emision' ||VEMI01;
      RETURN -1;
END;

FUNCTION F_SELECCION(       CODIGO   IN NUMBER,
                          EMISION  IN NUMBER,
                         IMPUESTO IN NUMBER,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER
IS
BEGIN


    IF IMPUESTO = 140 THEN
       CTN := Pk_Emi.F_140(CODIGO,EMISION,MENSAJE);
       RETURN CTN;

    ELSIF IMPUESTO IN( 130,5,49) THEN
       CTN := Pk_Emi.F_130(CODIGO,EMISION,MENSAJE);
       RETURN CTN;

    ELSIF IMPUESTO = 95 THEN
       CTN := Pk_Emi.F_95(CODIGO,EMISION,MENSAJE);
       RETURN CTN;

   ELSIF IMPUESTO = 100 THEN
       CTN := Pk_Emi.F_100(CODIGO,EMISION,MENSAJE);
       RETURN CTN;

   ELSIF IMPUESTO = 135 THEN
       CTN := Pk_Emi.F_135(CODIGO,EMISION,MENSAJE);
       RETURN CTN;
   ELSIF  IMPUESTO  = 1029 OR  IMPUESTO  =1030 OR IMPUESTO  = 1028  THEN
       CTN := Pk_Emi.F_traspaso(CODIGO,EMISION,MENSAJE);
       RETURN CTN;
   ELSIF  IMPUESTO  = 131   THEN
       CTN := Pk_Emi.F_131(CODIGO,EMISION,MENSAJE);
       RETURN CTN;
   ELSE
       CTN := Pk_Emi.F_otros(CODIGO,EMISION,MENSAJE);
   END IF;
    IF  CTN = -1  THEN
        RETURN -1;
  END IF;

  RETURN CTN;

EXCEPTION
  WHEN OTHERS THEN
      RETURN -1;
END;

/* ACTUALIZA LA EMISION DEL PREDIO URBANO */
FUNCTION F_140(             CODIGO   IN NUMBER,
                          EMISION  IN NUMBER,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER
IS
   v_val number;
BEGIN
   
   UPDATE PUR10 SET PUR10LEMI = USER, PUR10FEMI = SYSDATE,PUR10NEMI = EMISION, pur10esta = 'E'
   WHERE PUR10CODI = CODIGO;
   
   RETURN 1;
   
EXCEPTION
   WHEN NO_DATA_FOUND THEN
           MENSAJE := ' 1 No existe la Emision';
        RETURN -1;
    WHEN OTHERS THEN
           MENSAJE := ' 0 Error...'||SQLERRM;
        RETURN -1;
END;

FUNCTION F_130(             CODIGO   IN NUMBER,
                          EMISION  IN NUMBER,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER
IS
BEGIN
   UPDATE REN31 SET  REN30LEMI = USER,  REN30FEMI= SYSDATE,REN30NEMI = EMISION, REN30ESTA = 'E'
   WHERE REN31CODI = CODIGO;
   RETURN 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
           MENSAJE := ' 8 No existe la Emision';
        RETURN -1;
    WHEN OTHERS THEN
           MENSAJE := ' 9 Error...'||SQLERRM;
        RETURN -1;
END;

FUNCTION F_131(             CODIGO   IN NUMBER,
                          EMISION  IN NUMBER,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER
IS
BEGIN
   UPDATE REN30AGUA SET  REN30LEMI = USER,  REN30FEMI= SYSDATE,REN30NEMI = EMISION, REN30ESTA = 'E'
   WHERE REN30CODI = CODIGO;
   RETURN 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
           MENSAJE := ' 8 No existe la Emision';
        RETURN -1;
    WHEN OTHERS THEN
           MENSAJE := ' 9 Error...'||SQLERRM;
        RETURN -1;
END;


FUNCTION F_95(             CODIGO   IN NUMBER,
                          EMISION  IN NUMBER,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER
IS
   v_val number;
BEGIN
   UPDATE PRU60 SET  REN30LEMI = USER,  REN30FEMI= SYSDATE,REN30NEMI = EMISION, REN30ESTA = 'E'
   WHERE PRU60CODI = CODIGO;
   
   RETURN 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
           MENSAJE := '0 No existe la Emision';
        RETURN -1;
    WHEN OTHERS THEN
           MENSAJE := ' 0 Error...'||SQLERRM;
        RETURN -1;
END;

FUNCTION F_100(             CODIGO   IN NUMBER,
                          EMISION  IN NUMBER,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER
IS
BEGIN

   UPDATE REN32 SET  REN30LEMI = USER,  REN30FEMI= SYSDATE,REN30NEMI = EMISION, REN30ESTA = 'E'
   WHERE REN32CODI = CODIGO;
   RETURN 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
           MENSAJE := '0 No existe la Emision';
        RETURN -1;
    WHEN OTHERS THEN
           MENSAJE := '5 Error...'||SQLERRM;
        RETURN -1;
END;


FUNCTION F_5(             CODIGO   IN NUMBER,
                          EMISION  IN NUMBER,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER
IS
BEGIN

   UPDATE REN33 SET  REN30LEMI = USER,  REN30FEMI= SYSDATE,REN30NEMI = EMISION, REN30ESTA = 'E'
   WHERE REN33CODI = CODIGO;
   RETURN 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
           MENSAJE := '3 No existe la Emision';
        RETURN -1;
    WHEN OTHERS THEN
           MENSAJE := '3 Error...'||SQLERRM;
        RETURN -1;
END;

FUNCTION F_135(             CODIGO   IN NUMBER,
                          EMISION  IN NUMBER,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER
IS
BEGIN
   UPDATE REN34 SET  REN30LEMI = USER,  REN30FEMI= SYSDATE,REN30NEMI = EMISION, REN30ESTA = 'E'
   WHERE REN34CODI = CODIGO;
   RETURN 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
           MENSAJE := '6 No existe la Emision';
        RETURN -1;
    WHEN OTHERS THEN
           MENSAJE := '8 Error...'||SQLERRM;
        RETURN -1;
END;

FUNCTION F_traspaso(             CODIGO   IN NUMBER,
                          EMISION  IN NUMBER,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER
IS
BEGIN

   UPDATE TRA40  SET  REN30LEMI = USER,  REN30FEMI= SYSDATE,REN30NEMI = EMISION, REN30ESTA = 'E'
   WHERE tra40CODI = CODIGO;
   RETURN 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
           MENSAJE := '9 No existe la Emision';
        RETURN -1;
    WHEN OTHERS THEN
           MENSAJE := '0 Error...'||SQLERRM;
        RETURN -1;
END;

FUNCTION F_otros(         CODIGO   IN NUMBER,
                          EMISION  IN NUMBER,
                         MENSAJE OUT VARCHAR2) RETURN NUMBER
IS
    CLA_REN30 VARCHAR2(30); --CLAVE CATASTRAL PARA EMISIONES VARIAS EN CASO DE QUE LA EMISION TENGA UNA CLAVE CATASTRAL ENVIARA UNA ACTUALIZACION A LA EMI01
    CLA_REN04 VARCHAR2(30); --RESPALDARA LA CLAVE CATASTRAL QUE SE GENERA POR DEFECTO Y LA ENVIARA A LA EMI01TMP PARA PODER CONTAR CON DICHO NUMERO EN CASO DE NECESITARLO
    V_IVA VARCHAR2(1);
BEGIN
    
   UPDATE REN30 SET  REN30LEMI = USER,  REN30FEMI= SYSDATE,REN30NEMI = EMISION, REN30ESTA = 'E'
   WHERE REN30CODI = CODIGO;
   
   UPDATE REN30T SET  REN30LEMI = USER,  REN30FEMI= SYSDATE,REN30NEMI = EMISION, REN30ESTA = 'E'
   WHERE REN30CODI = CODIGO;
   
   SELECT PUR01PRED 
    INTO CLA_REN30
   FROM REN04
   WHERE REN04CODI IN (SELECT REN04CODI FROM REN30 
                       WHERE REN30NEMI = EMISION);

   SELECT REN04CODI
    INTO CLA_REN04
   FROM REN30
   WHERE REN30NEMI = EMISION;
            
   IF NOT CLA_REN30 IS NULL THEN
        UPDATE EMI01 SET EMI01CLAVE = CLA_REN30, PUR01TMP = CLA_REN04 WHERE EMI01CODI = EMISION;
   END IF;
   
   begin
    select emi03iva 
    into v_iva
    from emi03
    where emi03codi in (select emi01seri from emi01 where emi01codi = emision);
   exception when others then
    v_iva := 'N';
   end;

   if nvl(v_iva,'N') = 'S' then
        p_genera_factura(emision);
   end if; 
   
   RETURN 1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
           MENSAJE := '3 No existe la Emision';
        RETURN -1;
    WHEN OTHERS THEN
           MENSAJE := '4 Error...'||SQLERRM;
        RETURN -1;
END;


END Pk_Emi;
/
