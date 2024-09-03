CREATE OR REPLACE PACKAGE BODY SISESMER.PK_AVALUOSPUR  AS


FUNCTION FAvaluoTotal(CLAVE  IN VARCHAR2, PActualiza IN VARCHAR2, MENSAJE  OUT VARCHAR2, ANIO IN NUMBER)  RETURN NUMBER
--FUNCTION FAvaluoTotal(CLAVE  IN VARCHAR2 )  RETURN NUMBER

-- PARA PODER TOMAR EL VALOR PARA FINES TRIBUTARIOS, EL ATRIBUTO PACTUALIZA DEBERA RECIBIR EL VALOR 3: DEVUELVE EL VALOR REGISTRADO EN TABLA PURVM2XMZ, PERO NO REALIZA CAMBIOS EN LA
--VALORACION PREDIAL 

  IS
  total NUMBER(25,8);
  valor NUMBER(8);
   e_avaluo EXCEPTION;
   parroquia VARCHAR2(1):= 'N';
  FECACTAVAL  DATE;
  AVALUO_PARROQUIA NUMBER(25,8):=0;
  TXT VARCHAR2(2500);
  
  BEGIN
   ClaveCatastral             := clave;
   total :=0;
   LActualiza :=PActualiza;

    ANIO_VALORACION := ANIO;
--  
   
     SELECT NVL(pur01parr,'N'),PUR01FECACTAVAL,PUR01TAVRE
     INTO parroquia,FECACTAVAL,AVALUO_PARROQUIA
      FROM PUR01
      WHERE pur01pred = ClaveCatastral;
      
       ResumenTotalAvaluoTerreno   := 0;
       ResumenTotalAvaluoConstruccion := 0;
       ResumenTotalAvaluoTerreno      :=  Pk_Avaluospur.FAvaluoTerreno;
       ResumenTotalAvaluoConstruccion :=  Pk_Avaluospur.FAvaluoConstrucciones;
       
       
 
  
     total :=  ResumenTotalAvaluoTerreno + ResumenTotalAvaluoConstruccion;
    ---   lactualiza 
  --   '1'  SIMULA
  -- '2'    ACTUALIZA AVALUO
  -- '3' FINES TRIBUTARIOS
  -- '0'   SOLO HACE  
     
       
    IF    LActualiza = '2'  AND total > 0 THEN
  
       valor := Pk_Avaluospur.FActAvalProp(0,total);
       TXT := 'El avaluo total fue cambiado de : ...'||
             LTRIM(RTRIM(TO_CHAR( AVALUO_PARROQUIA,'99g999g990d99')))||CHR(10)||
             '  Por el nuevo avaluo de :'||LTRIM(RTRIM(TO_CHAR( total,'99g999g990d99')));
            Pk_Obspur.FGENERA_OBSERVA(ClaveCatastral ,USER,'PC',TXT);
    --BIEN SI SE TRATA DE SIMULACION O PARA FINES TRIBUTARIOS, EL SISTEMA GUARDA EL VALOR DE LA VALORACION EN LOS MISMOS ATRIBUTOS
    ELSIF  (LActualiza = '1') OR (LActualiza = '3')   THEN
        NULL;
       /*UPDATE pur01
       SET  PUR01AVTSIM = total ,  PUR01AVTTS=ResumenTotalAvaluoTerreno ,PUR01AVTCS =ResumenTotalAvaluoConstruccion, PUR01BIM = total
       WHERE pur01pred = clave;*/               --***ALEXA 18/MAYO2/018    
       
    END IF;
    
  IF total=0 THEN
     RAISE e_avaluo;
  END IF;
 
   COMMIT;
   RETURN  Total;

EXCEPTION
  WHEN e_avaluo THEN
   mensaje :=  'av-01 Avaluo es 0 revise los datos del predio '||mensajeerror ;
   RETURN 0;
  WHEN OTHERS THEN
  MENSAJE :=  SQLERRM;
   mensaje :=  'av-01....'||MENSAJE||'..'||mensajeerror ;
   RETURN 0;
 END;

FUNCTION  FActAvalTerr(lpur02codi IN NUMBER , lavaluo IN NUMBER) RETURN NUMBER IS
    LPUR05ACOM NUMBER(14,2):=0;
 Lpur01bim          NUMBER(14,2):=0;
BEGIN
  UPDATE PUR02 SET  PUR02AREAL =    NVL(lavaluo,0)
   WHERE PUR02CODI  = lpur02codi
   AND        PUR01PRED = ClaveCatastral;
   RETURN 1;
END;
FUNCTION  FActAvalConst(Lpur05codi IN NUMBER,  lavaluo IN NUMBER) RETURN NUMBER IS
    LPUR05ACOM NUMBER(25,8):=0;
 Lpur01bim          NUMBER(25,8):=0;
BEGIN
  UPDATE PUR05 SET  PUR05AREAL =    nvl(lavaluo,0)
   WHERE PUR05CODI  = lpur05codi
   AND        PUR01PRED = ClaveCatastral;
   RETURN 1;
END;
-------------------------------------------------------
FUNCTION  FActAvalProp(Lpur01codi IN NUMBER, lavaluo IN NUMBER) RETURN NUMBER IS
    LPUR05ACOM NUMBER(25,8):=0;
 Lpur01bim          NUMBER(25,8):=0;
BEGIN
   UPDATE PUR01
   SET pur01tavre = lavaluo,
   pur01fecactaval = SYSDATE
    WHERE pur01pred = ClaveCatastral;
   RETURN 1;
END;


FUNCTION FAvaluoTerreno  RETURN NUMBER
 IS
CURSOR C1(lclave IN VARCHAR2) IS
SELECT *
FROM PUR01
WHERE pur01pred = lclave;

CURSOR c2(lclave IN VARCHAR2) IS
SELECT *
FROM PUR02
WHERE pur01pred = lclave
AND pur02estt IN ('IG','MD');


l_PUR01AVALTERRENO  NUMBER(25,8);

valor NUMBER(8);
------- VARIABLES DE COEFICIENTES -----
CtnSerVicios number(8);
CtnInfra    number(8);

TXTO        VARCHAR2(2000);
val_real number(18,2);
FACT_VAL_MIN    NUMBER(8,2);
FACT_VAL_MAX    NUMBER(8,2);


BEGIN
/*  Verificar Datos Basicos */
  TotalAvaluoTerreno := 0;
  AvaluoTerreno      := 0;
  mensajeerror       := NULL;
CtnSerVicios :=0;
CtnInfra :=0;
 FactorOcupacionSuelo  :=0;
 FactorTopoGrafia      :=0;
 FactorLocalizacion    :=0;
 FactorCaractSuelo     :=0;
 FactorFormaTerreno    :=0;
 FactorViaUso          :=0;  
 FactorViaMaterial     :=0;
 FactorFrenteFondo     :=0;
 FactorSuperficie      :=0;    
 /*  indicadores servicios  */   
 IndicCoeAguaAlcEner    :=0;
 /* Aceras y bordillos */
 IndAceraBorTelAseReco    :=0;
 TotalFactores          :=0;
 FactorFrente           := 0;
 FactorFondo            := 0; 
 FactorEsquina          := 1;
 val_real  := 0;
 
 
 
FOR J IN c1( ClaveCatastral ) LOOP
   
 IF NVL(J.PUR01AGUA,'2') = '2' THEN
   CtnSerVicios := CtnSerVicios+1;
 END IF;
 
 IF NVL(J.PUR01EEL,'S') = 'S' THEN
   CtnSerVicios := CtnSerVicios+1;
 END IF;
 
 IF NVL(J.PUR01ALC,'2') = '2' THEN
   CtnSerVicios := CtnSerVicios+1;
 END IF;
 
 IF NVL(J.PUR01ACER,'2') = '2' THEN
   CtnInfra := CtnInfra+1;
 END IF;
  
END LOOP;     

BEGIN
   SELECT REN21VALO
   INTO IndicCoeAguaAlcEner
   FROM REN21
   WHERE REN20CODI = 1007
   AND   REN21SUBF = TO_CHAR(CtnSerVicios);

EXCEPTION
  WHEN OTHERS THEN
     IndicCoeAguaAlcEner := 1;
END;

-- LActualiza 1 simulacion  2 valor real 

  ValorM2Manzana := Pk_Avaluospur.FValorM2Mz(ClaveCatastral,LActualiza);
  

  IF ValorM2Manzana = 0 AND mensajeerror  IS NULL THEN
      RAISE f_1;
  END IF;
  AreaLote := 0;

FOR c1r IN c2( ClaveCatastral ) LOOP
     IF NVL(C1R.PUR02TP,'2') = '2' THEN
       CtnInfra := CtnInfra+1;
     END IF; 
     IF NVL(C1R.PUR02TEPRI,'2') = '2' THEN
       CtnInfra := CtnInfra+1;
     END IF; 
     IF NVL(C1R.PUR02RBASUDOMI,'2') = '2' THEN
       CtnInfra := CtnInfra+1;
     END IF; 
     IF NVL(C1R.PUR02RBASUCALLE,'2') = '2' THEN
       CtnInfra := CtnInfra+1;
     END IF; 
END LOOP;

BEGIN
   SELECT REN21VALO
   INTO IndAceraBorTelAseReco
   FROM REN21
   WHERE REN20CODI = 14
   AND   REN21SUBF = TO_CHAR(CtnInfra);

EXCEPTION
  WHEN OTHERS THEN
     IndAceraBorTelAseReco := 1;
END;

FOR c1r IN c2( ClaveCatastral ) LOOP
  
  AreaLote       := NVL(c1r.pur02aterr,0) +   AreaLote;

  l_PUR01AVALTERRENO := c1r.PUR02AREAL;
 
 
 
 IF AreaLote = 0 THEN
   RAISE f_2;
 END IF;

/* ALEXANDRA, AJUSTES EN VALORACION DE ACUERDO A ORDENANZA 
 FactorSuperficie    := Pk_Avaluospur.FFactoresSuperficie(5018,NVL(c1r.pur02aterr,0));
 FactorCaractSuelo   :=   NVL(Pk_Avaluospur.FFactoresTerreno(6063, c1r.pur02CARAC),1); --A
 FactorTopoGrafia    :=  NVL(Pk_Avaluospur.FFactoresTerreno(5042, c1r.pur02topo),1); --A
 FactorLocalizacion  :=  NVL(Pk_Avaluospur.FFactoresTerreno(5041,c1r.pur02loca),1); --  B
 FactorFormaTerreno  :=  NVL(Pk_Avaluospur.FFactoresTerreno(6064,c1r.PUR02FORMA),1); --  B
 FactorFrenteFondo   := Pk_Avaluospur.FFactoresFrenteFondo(c1r.PUR02LONG,c1r.PUR02FONDRELA,NVL(c1r.pur02aterr,0)); --C
 FactorViaMaterial  := NVL(Pk_Avaluospur.FFactoresTerreno(6066,C1R.PUR02VIASMATE),1);
 
                    ---* (FactorFrenteFondo) 
 TotalFactores  := ROUND(FactorSuperficie *  FactorCaractSuelo * 
                   FactorTopoGrafia *  FactorLocalizacion * 
                   FactorFormaTerreno *  FactorFrenteFondo * 
                   FactorViaMaterial  * IndicCoeAguaAlcEner *  IndAceraBorTelAseReco,6) ;
                   
                   */
   
  /* cambios  para calculo de factores - ALEXANDRA GONZAGA 26FEB2014*/
 
 FactorTopoGrafia    :=  NVL(Pk_Avaluospur.FFactoresTerreno(5042, c1r.pur02topo),1); -- NUEVOS VALORES
 FactorLocalizacion  :=  NVL(Pk_Avaluospur.FFactoresTerreno(5041,c1r.pur02loca),1); --  UBICACION  *** De momento, el valor de factorlocalizacion siempre db ser 1, para ser considerado como esquina 
 if c1r.pur02loca = 1 then  
    FactorEsquina  := NVL(Pk_Avaluospur.FFactorEsquina(c1r.PUR01PRED),1);
 else
    FactorEsquina  := 1;
 end if;
--    factorVia := 1; -- PARA NO AFECTAR LA VALORACION
 --ELSE
--    FactorEsquina := 1; -- PARA NO AFECTAR LA VALORACION
    FactorVia := NVL(Pk_Avaluospur.FFactorVia(c1r.PUR01PRED),1);
 --end if;   
 --FactorFormaTerreno  :=  NVL(Pk_Avaluospur.FFactoresTerreno(6064,c1r.PUR02FORMA),1); --  B
 FactorFormaTerreno  :=  NVL(Pk_Avaluospur.FFactorForma(c1r.PUR02LONG,AreaLote, CLAVECATASTRAL),1); --  B
 FactorFrente   :=  NVL(Pk_Avaluospur.FFactor_Frente(c1r.PUR02LONG, c1r.PUR01PRED),1); --NVL(Pk_Avaluospur.FFactor_Frente(c1r.PUR02LONG, c1r.pur01pred),1); --C
 FactorFondo   := NVL(Pk_Avaluospur.FFactorFondo(c1r.PUR02FONDRELA,c1r.pur01pred),1); --C
 --FactorFondo := c1r.PUR02FONDRELA;
 --FactorSuperficie    := NVL(PK_Avaluospur.FFactorTama?o(c1r.PUR02LONG * c1r.PUR02FONDRELA, AreaLote),1); -- = FACTOR TAMA?O
 FactorSuperficie    := NVL(PK_Avaluospur.FFactorTamaño(ClaveCatastral, AreaLote),1); -- = FACTOR TAMA?O
 
 
TotalFactores  := ROUND(FactorSuperficie *   
                   FactorTopoGrafia *  FactorEsquina * FactorVia * 
                   FactorFormaTerreno *  FactorFrente,6);

-- AQUI AGREGAR EL CONTROL DE RANGO POR ORDENANZA   **BIENIO 2016-2017 ART. 32

     SELECT NVL(REN21VALO, 0)/100, NVL(REN21VALO01, 0)/100
        INTO FACT_VAL_MIN, FACT_VAL_MAX
     FROM REN21
     WHERE ANIO_VALORACION BETWEEN TO_CHAR(TO_DATE(REN21SUBF, 'DD-MM-RRRR'), 'RRRR') AND TO_CHAR(TO_DATE(REN21VDEFA, 'DD-MM-RRRR'), 'RRRR')  
        AND REN20CODI = 152;            --- *********** OJO CODIGO DE RANGO DEMERITO Y MERITO FACTORES CONSTRUCCION

     FACT_VAL_MAX := 1 + FACT_VAL_MAX;
     FACT_VAL_MIN := 1 - FACT_VAL_MIN; 
       

     if totalfactores > FACT_VAL_MAX then
        totalfactores := FACT_VAL_MAX;
     else if totalfactores < FACT_VAL_MIN then
            totalfactores := FACT_VAL_MIN;
          end if;
     end if;
 
 val_real := ROUND(NVL(ValorM2Manzana,0) * NVL(TotalFactores,0),2);
 
 AvaluoTerreno :=    ROUND(NVL(AreaLote,0) *  val_real ,2) ;
                           
  
 TotalAvaluoTerreno := NVL(TotalAvaluoTerreno,0)  + AvaluoTerreno;        
     
         

      
   IF  LActualiza = '1' OR LActualiza = '3' THEN
  
        null;
  
  ELSIF  LActualiza = '2' THEN
  
    UPDATE PUR01 SET     PUR01AVTTS = AvaluoTerreno,
                             PUR01VM2           =  NVL(ValorM2Manzana,0),
                             PURTopoGrafia      = FactorTopoGrafia,
                             PURLocalizacion    = FactorLocalizacion,
                             PURFrenteFondo     = FactorFrente,
                             PURTOTFACT         = TotalFactores,
                             PURCARACTSUELO     = FactorCaractSuelo,
                             PURFORMATERRENO    = FactorFormaTerreno,
                             PURSUPERFICIE      = FactorSuperficie,
                             PURVIAMATERIAL     = FactorFondo,  -- FactorViaMaterial,
                             PURINDACERABORTE   = IndAceraBorTelAseReco,
                              PURINDICCOEAGUAA  = IndicCoeAguaAlcEner,
                              PUR01FESQ         = FactorEsquina,
                              PUR01FVIA         = FactorVia
          WHERE PUR01PRED = c1r.pur01pred;
  
    valor :=  Pk_Avaluospur.FActAvalTerr(c1r.pur02codi,AvaluoTerreno);
    
    IF l_PUR01AVALTERRENO <> AvaluoTerreno THEN 
       
       TXTO := ' Factor Ubicacion = '||RTRIM(LTRIM(TO_CHAR(FactorLocalizacion,'90D99')))||CHR(10)||
               ' Factor Topografia = '||RTRIM(LTRIM(TO_CHAR(FactorTopoGrafia,'90D99')))||CHR(10)||
               ' Factor Forma = '||RTRIM(LTRIM(TO_CHAR(FactorFormaTerreno,'90D99')))||CHR(10)||
               ' Factor Frente '||RTRIM(LTRIM(TO_CHAR(FactorFrente,'90D99')))||CHR(10)||
               ' Factor Fondo = '||RTRIM(LTRIM(TO_CHAR(FactorFondo,'90D99')))||CHR(10)||
               ' Valor Zona = '||RTRIM(LTRIM(TO_CHAR(ValorM2Manzana,'999G990D99')))||CHR(10)||
                ' Area = '||RTRIM(LTRIM(TO_CHAR(NVL(AreaLote,0),'999G990D99')))||CHR(10)||
                ' Avaluo Actual = '||RTRIM(LTRIM(TO_CHAR(l_PUR01AVALTERRENO,'99g999g990d99')))||CHR(10)||
                '  Por el nuevo avaluo de  = '||LTRIM(RTRIM(TO_CHAR(   AvaluoTerreno,'99g999g990d99')));

           Pk_Obspur.FGENERA_OBSERVA(ClaveCatastral ,USER,'PC',TXTO);
    END IF;    
    
  END IF;



END LOOP;

  mensajeerror := 'ok';

  RETURN   TotalAvaluoTerreno;
  
EXCEPTION
  WHEN   F_1 THEN
       RETURN 0;
  WHEN   F_2 THEN
                mensajeerror :=  'No existe Area de Terreno, Revise los Datos'||mensajeerror;
      RETURN 0;
  WHEN   F_3 THEN
                mensajeerror :=  'No selecciono El tipo de Localizacion  '||mensajeerror;
      RETURN 0;
  WHEN   F_4 THEN
                mensajeerror :=  'No existe valores para la topografia ';
      RETURN 0;
  WHEN OTHERS THEN
       mensajeerror :=  'No existe datos ';
       RETURN 0;
END;

FUNCTION FValorM2Mz(L3_clave in varchar2,lsimu in varchar2)  RETURN NUMBER IS
     valor NUMBER(25,8);
     valor_simu NUMBER(25,8);
     FECHA_VALOR DATE;
     lvalsim varchar2(1);
     
BEGIN
---------------------------
---- GERARQUIA CLAVES
---------------------------
--- SI TIENE VALOR POR PREDIO
--  150150010203002  15
 

   VG_NROLOTE :=  SUBSTR( L3_clave ,8,3);
   lvalsim := lsimu;
      
   
  begin
    
    --LECTURA DE VALORES DE EXCEPCION
    SELECT P.PURVM2VALOR,p.PURVM2SIMULA 
    into valor,valor_simu
    FROM PURVM2_TERR P
    where P.PURVM2ANIO = (select max(A.PURVM2ANIO) from purvm2_terr A where substr(A.PURVM2ZONIFICA,1,10) = L3_clave)
    and substr(P.PURVM2ZONIFICA,1,10) = L3_clave;

       if lvalsim = '2' OR lvalsim = '3'  then
          return valor;
       elsif lvalsim = '1' then
            return valor_simu;
       end if; 
    

     EXCEPTION
      WHEN OTHERS THEN
        NULL;
   END;
   
   /*  aca valores de la manzan 02 */
   BEGIN
   /* DESHABILITADO PARA DAR PASO A LECTURA SEGUN A?O DE VALORACION
   SELECT PLA02VALORXMZ,  PLA02VSIMU 
   INTO valor,valor_simu
   FROM PLA02
   WHERE PLA01HOJ = SUBSTR(L3_CLAVE,f_POSZONASEC,4)
   AND PLA02MANZ =  SUBSTR(L3_CLAVE, f_POS_MZ,f_purnrodigmz);
   */              --ALEXA 18NOV2015        
        --LECTURA DEL VALOR DE SUELO PARA EL A?O A VALORAR                                  ****ALEXA 18NOV2015
        -- ALEXA 29-ENERO-2016:  
        -- CAMBIOS EN LECTURA DE VALOR, POR APLICACION REFORMA ORDENANZA, SE TIENEN 2 VALORES PARA 2016, EL VALOR VIGENTE ENTRE 01-01-2016 HASTA 28-ENE-2016 DEBE QUEDAR FUERA PARA EL FUTURO
       /*SELECT A.PURVM2XMZVALOR
            INTO valor
       FROM PURVM2XMZ A
       WHERE TO_DATE(TO_CHAR('31-01-') || ANIO_VALORACION, 'DD-MM-RRRR') BETWEEN PURVM2XMZFINI AND A.PURVM2XMZFFIN
            AND A.PURVM2XMZZONIFICA = SUBSTR(L3_CLAVE, 1,7);*/
            
       -- CAMBIOS POR AJUSTE DE CONTROL POR ORDENANZA
       --A.PURVM2XMZZONIFICA, A.PURVM2XMZOBSE,  
       
       SELECT A.PURVM2XMZVALOR
            INTO VALOR
       FROM PURVM2XMZ A, REN21 B
       WHERE A.REN21CODI = B.REN21CODI
            AND TO_DATE(TO_CHAR( '01-01-') || ANIO_VALORACION, 'DD-MM-RRRR') BETWEEN TO_DATE(B.REN21SUBF, 'DD-MM-RRRR') 
            AND TO_DATE(B.REN21VDEFA, 'DD-MM-RRRR')
            AND A.PURVM2XMZZONIFICA = SUBSTR(L3_CLAVE, 1,7);     
            
       
       --LECTURA DEL VALORA PARA SIMULACION, SIEMPRE GUARDAR EN LA PLA02        *           ***ALEXA 18NOV2015
       SELECT PLA02VSIMU 
        INTO valor_simu
       FROM PLA02
        WHERE PLA01HOJ = SUBSTR(L3_CLAVE, 1,4)   --f_POSZONASEC,4)                          ****ALEXA 18NOV2015
            AND PLA02MANZ =  SUBSTR(L3_CLAVE, 5, 3); -- f_POS_MZ,f_purnrodigmz);            ****ALEXA 18NOV2015
        
    EXCEPTION
      WHEN OTHERS THEN
        return -1;
   END;
      
   if lvalsim = '2' OR lvalsim = '3' then
      return valor;
   elsif lvalsim = '1' then
        return valor_simu;
   end if; 
   

   RETURN valor;
   
EXCEPTION
   WHEN NO_DATA_FOUND THEN
    mensajeerror:= 'No Existe Valor Para esta manzana :'||ClaveCatastral;
      RETURN 0;
    WHEN OTHERS THEN
      mensajeerror:= 'No Existe Valor Para esta manzana  o el valor definido es 0 :'||ClaveCatastral;
      RETURN 0;
END;
---* ***************************************   -----------
--- ***  INCIO DE FACTORES   **********
FUNCTION FFactoresTerreno(codigo in number,HIJO IN NUMBER)   RETURN NUMBER
IS
     valor NUMBER(25,8);
BEGIN
   SELECT REN21VALO
   INTO valor
   FROM REN21
   WHERE   REN20CODI = codigo
   AND TO_NUMBER(ren21subf )   =  HIJO;
   RETURN valor;
   
EXCEPTION
  WHEN OTHERS THEN
       RETURN 1;
END;
FUNCTION FFactoresSuperficie(codigo in number,larea IN NUMBER)    RETURN NUMBER
is
    valor NUMBER(25,8);
begin
   select ren21base
   into valor
   from ren21
   where ren20codi = codigo
   and   larea between ren21vmin and ren21vmax;
   
   return valor;
   
EXCEPTION
  WHEN OTHERS THEN
       RETURN 1;
end; 
 FUNCTION FFactoresFrenteFondo(Frente in number, fondo In Number,AREA IN NUMBER)    RETURN NUMBER
 is
   valorRetorno         NUMBER(16,4);
   ValorDiferencia      NUMBER(16,4);
   ValorDiferencia1     NUMBER(16,4);   
   RelacionFrenteFondo  NUMBER(16,4);
   V_ValorMayor         NUMBER(16,4);
   V_ValorMenor         NUMBER(16,4);
   valorRetorno1        NUMBER(16,4);
   V_cod                NUMBER(16,4); 
   V_CodMenor           NUMBER(16,4);
   V_CodMayor           NUMBER(16,4);
   
   cursor c1 is
   select ren21vmin,ren21vmax
   from ren21
   where ren20codi = 3
   order by ren21vmin;
   
   NIVEL NUMBER(8);
 begin
   
  
 
 
   IF FONDO > 0 THEN
     V_cod :=  ROUND(FRENTE/FONDO,4);
   ELSE
     RelacionFrenteFondo := 1;
   END IF;
   
  
   begin
      select ren21BASE
     into RelacionFrenteFondo
     from ren21
     where ren20codi = 3
       and  V_cod  BETWEEN ren21vmin AND REN21VMAX;
    exception
    when others then
       return 1;
    end;   
 
   return(RelacionFrenteFondo);
   
 exception
   when others then
     return 1;
 
 end;
 
   --ALEXANDRA: NUEVO CALCULO PARA FACTORES FRENTE, FONDO, TAMA?O, FORMA, VIA Y ESQUINAS
 


FUNCTION FFactor_Frente(Frente in number, clave In varchar2) RETURN NUMBER
 is

   FactorFrente         NUMBER(16,4);
   V_FrenteTipo         NUMBER(16,4);
   V_cod                NUMBER(16,4);    
   NIVEL NUMBER(8);
   
 begin
    
    SELECT PLA02LARG  
    into V_FrenteTipo
    FROM PLA02
    WHERE PLA01HOJ = SUBSTR(clave,1,4)
        AND PLA02MANZ = SUBSTR(clave,5,3); 
   
 
   IF V_FRENTETIPO > 0 THEN
     V_cod :=  ROUND(FRENTE/V_FRENTETIPO,4);
     FactorFrente:= round(sqrt(sqrt(v_cod)),4);
   ELSE
     FactorFrente := 1;
   END IF;
   
  return(FactorFrente);
   
 exception
   when others then
     return 1;
 
 end;


  FUNCTION FFactorFondo(Fondo in number, clave in varchar2) RETURN NUMBER
 is
   V_FactorFondo       NUMBER(16,4);
   V_FondoTipo         NUMBER(16,4);
   V_FondoPredio       NUMBER(16,4);
   V_cod                NUMBER(16,4); 
   
 begin
 
    SELECT PLA02ANC
    inTO V_FondoTipo
     FROM PLA02 
    WHERE PLA01HOJ = SUBSTR(clave,1,4) 
        AND PLA02MANZ = SUBSTR(clave,5,3);
     
  
   IF v_FondoTipo > 0 THEN
     V_cod :=  ROUND(V_FondoTipo/FONDO,4);
     v_FactorFondo := round(sqrt(v_cod),4);
   ELSE
     V_FactorFondo := 1;
   END IF;
   
  
   return(V_FactorFondo);
   
 exception
   when others then
     return 1;
 
 end;

 
 FUNCTION FFactorTamaño(clave in varchar2, AreaLote In number)    RETURN NUMBER
 is

   V_FactorTamanio         NUMBER(16,4);
   V_cod                NUMBER(16,4);    
   Rel_Tamanio NUMBER(8,2);
   AreaLT NUMBER(8,2);
   ANIO     NUMBER(8);
   ANIO_VALORACION  NUMBER(8) := 2017;
   
 begin

    select pla02larg * pla02anc area_lote
    into AreaLT
    from pla02
    where pla01hoj = substr(clave,1,4) and pla02manz = substr(clave,5,3);
  
    Rel_Tamanio := ROUND(AreaLote/AreaLT,4)*10;  --SOLICITUD KAREN - ENERO-4-2015
    /*
   SELECT REN21VALO
   INTO V_FactorTamanio
   FROM REN21
   WHERE   REN20CODI = 52 --54       --CATALOGO FACTOR TAMA?O -- ALEXANDRA 31 JULIO 2014
   AND Rel_Tamanio BETWEEN ren21ANIO AND TO_NUMBER(REN21SUBF);
   
      */                             
        --CAMBIOS POR ORDENANZA VALORACION BIENIO 2016- 2017     ALEXANDRA 28 DICIEMBRE 2015
        
        -- 1. DETERMINA EL AÑO A APLICAR
        SELECT NVL(MAX(REN21ANIO), 0)
            INTO ANIO
         FROM REN21
         WHERE REN21ANIO = ANIO_VALORACION 
            AND REN20CODI = 52;
        
        IF ANIO = 0 THEN
             SELECT NVL(MIN(REN21ANIO), 0)
                INTO ANIO
             FROM REN21
             WHERE REN21ANIO > ANIO_VALORACION 
                AND REN20CODI = 52;
             IF ANIO = 0 THEN
                 SELECT NVL(MAX(REN21ANIO), 0)
                    INTO ANIO
                 FROM REN21
                 WHERE REN21ANIO < ANIO_VALORACION;
             END IF;
        END IF;
        
        
        SELECT MIN(REN21VALO01)
            INTO V_FactorTamanio
           FROM REN21
           WHERE   REN20CODI = 52       
                AND REN21ANIO = ANIO
           AND Rel_Tamanio BETWEEN TO_NUMBER(ren21SUBF) AND TO_NUMBER(REN21VALO);
 
   
 return(V_FactorTamanio);
   
 exception
   when others then
     return 1;
 end;



--FUNCTION FFactorForma(Frente in number, AreaLote In number, CLAVE IN VARCHAR2)    RETURN NUMBER
-- is

--   V_FactorForma        NUMBER(16,4);
--   V_cod                NUMBER(16,4);  
--   V_FONDO_RELATIVO     NUMBER(16,4);  
--   NIVEL NUMBER(8);
--   V_FRENTE_LT       NUMBER(16,4);
--   
-- begin
--  
--  V_FONDO_RELATIVO := AreaLote/Frente;  --Alexandra 29dic2014

--    select pla02larg
--    into V_FRENTE_LT
--    from pla02
--    where pla01hoj = substr(clave,1,4) and pla02manz = substr(clave,5,3);  
--  
--   V_FactorForma := ROUND(SQRT(V_FRENTE_LT / V_FONDO_RELATIVO),4);
--  
--  return(V_FactorForma);
--   
-- exception
--   when others then
--     return 1;
-- 
-- end;


FUNCTION FFactorForma(Frente in number, AreaLote In number, CLAVE IN VARCHAR2)    RETURN NUMBER
 is

   V_FactorForma        NUMBER(16,4);
   V_cod                NUMBER(16,4);  
   V_FONDO_RELATIVO     NUMBER(16,4);  
   NIVEL NUMBER(8);
   V_FONDO_LT       NUMBER(16,4);
   
 begin
  
  V_FONDO_RELATIVO := AreaLote/Frente;  --Alexandra 29dic2014

    select pla02anc
    into V_FONDO_LT
    from pla02
    where pla01hoj = substr(clave,1,4) and pla02manz = substr(clave,5,3); 
    
     
  
   V_FactorForma := ROUND(SQRT(V_FONDO_LT / V_FONDO_RELATIVO),4);
  
  return(V_FactorForma);
   
 exception
   when others then
     return 1;
 
 end;


--ALEXANDRA 04/NOV/2014
--La verificacion de si el predio tiene o no esquina se lo hace al nivel superior Funcion FAvaluoTerreno
FUNCTION FFactorEsquina(clave In varchar2) RETURN NUMBER
 is

   V_Factor_Esquina     NUMBER(16,4);
   V_cod                NUMBER(16,4);    
   NIVEL NUMBER(8);
   
 begin
 --- Funcion devuelve el factor esquina, siempre que el predio tenga al menos una esquina.
    -- factor esquinas = suma(factor_x_via)  /  numero vias que concurren en la esquina (numero frentes)
    -- si area_via > 0 , entonces: via es frentista
    select sum(B.cat03long) / count(A.purvia01codi)
    into V_Factor_Esquina
    from purvia01 A, cat03 B
    where A.cat03codi = B.cat03codi
    and A.purvia01areaf > 0 and A.pur01pred = clave;
  
   
  return(V_Factor_Esquina);
   
 exception
   when others then
     return 1;
 
 end;

-- Si el predio no tiene esquinas, debe calcular el frente con mayor factor via
FUNCTION FFactorVia(clave In varchar2) RETURN NUMBER
 is

   V_Factor_Esquina     NUMBER(16,4);
   V_cod                NUMBER(16,4);    
   NIVEL NUMBER(8);
   
 begin
 --- Funcion devuelve el factor esquina, siempre que el predio tenga al menos una esquina.
    -- se toma el factor de via con mayor peso
    IF ANIO_VALORACION < 2016 THEN 
        select max(B.cat03long)
        into V_Factor_Esquina
        from purvia01 A, cat03 B
        where A.cat03codi = B.cat03codi
        and A.purvia01areaf > 0 and A.pur01pred = clave;
    ELSE
        SELECT B.REN21VALO
        into V_Factor_Esquina
        FROM CAT03 A, REN21 B, PURVIA01 C
        WHERE A.CAT03NCLA = B.REN21DESC
            AND A.CAT03CODI = C.CAT03CODI
            AND C.PURVIA01AREAF > 0 AND C.PUR01PRED = CLAVE;
    END IF;
  
   
  return(V_Factor_Esquina);
   
 exception
   when others then
     return 1;
 
 end;


---*****************fin de factores de depreciacion de terreno **************  -----------
/*
  Avaluos de la Construccion
*/
FUNCTION FAvaluoConstrucciones  RETURN NUMBER
 IS

CURSOR C1(lclave IN VARCHAR2) IS
SELECT *
FROM PUR01
WHERE pur01pred = lclave;

CURSOR c2(lclave IN VARCHAR2) IS
SELECT *
FROM PUR05
WHERE pur01pred = lclave
AND pur05esta IN ('IG','MD');

valor NUMBER(8);
DIFANIOS NUMBER(8);
ValorConstante NUMBER(25,8):=0;
FactorDepreciacion NUMBER(25,8):=0;
TXT VARCHAR2(2500);
PISO_V NUMBER(8);
TOTAL_FACTORE NUMBER(12,2):=0;
Vidautil    NUMBER(3) :=0;
PorcentajeEdad NUMBER(12,2):=0;
R NUMBER(3,2) := 0;
ANIO_CALCULO NUMBER(4);
VALOR_CONST NUMBER(25,8):=0;

FACTOR1 NUMBER(25,8);
FACTOR2 NUMBER(25,8);
FACTOR3 NUMBER(25,8);
FACTOR4 NUMBER(25,8);
FACTOR5 NUMBER(25,8);

X   NUMBER(12,2):= 0;
Y   NUMBER(12,2):= 0;
Vt  NUMBER(12,2):= 0;
Vp  NUMBER(12,2):= 0;
FactorCorreccion    NUMBER(12,2):= 0;

BEGIN
TotalAvaluoConstruccion:=0;
 AvaluoConstruccion :=0;
  FOR c2r IN c2(ClaveCatastral) LOOP
  TOTAL_FACTORE := 0;
          AreaConstruccion := c2r.pur05acons;
      IF NVL(C2R.PUR05NPISO,1)  = 1 THEN
         PISO_V := 1;
       ELSE
        PISO_V := 2;
       END IF;
       /*
      FActoresConstruccion := 
    Pk_Avaluospur.FFactoresConst(5138,c2r.PUR05ESTCOLU)  +
    Pk_Avaluospur.FFactoresConst(5139,c2r.PUR05ESTVIGAS)  +
    Pk_Avaluospur.FFactoresConst(5146,c2r.PUR05ACAENLU) +  
    Pk_Avaluospur.FFactoresConst(6089,c2r.PUR05REVESCA)+
    Pk_Avaluospur.FFactoresConst(5140,c2r.PUR05ESTEPISO)  +
    Pk_Avaluospur.FFactoresConst(5141 ,c2r.PUR05ESTPARE)  +
    Pk_Avaluospur.FFactoresConst(6086 ,c2r.PUR05ESCALERA)  +
    Pk_Avaluospur.FFactoresConst(5142 ,c2r.PUR05ESTCUBIER)  +
    Pk_Avaluospur.FFactoresConst(6087 ,c2r.PUR05ACAPISOS)  +
    Pk_Avaluospur.FFactoresConst(5144 ,c2r.PUR05ACAPUER)  +
    Pk_Avaluospur.FFactoresConst(5147 ,c2r.PUR05ACATUMB)  +
    Pk_Avaluospur.FFactoresConst(6090 ,c2r.PUR05CUBIACAB)  +
    Pk_Avaluospur.FFactoresConst(5145 ,c2r.PUR05ACAVENTA)  +
    Pk_Avaluospur.FFactoresConst(6091 ,c2r.PUR05CUBRVENT)  +
    Pk_Avaluospur.FFactoresConst(6092 ,c2r.PUR05CLOSER)  +
    Pk_Avaluospur.FFactoresConst(5149 ,c2r.PUR05ISANI)  +
    Pk_Avaluospur.FFactoresConst(6093 ,c2r.PUR05INBANIOS)  +
    Pk_Avaluospur.FFactoresConst(5148 ,c2r.PUR05IELEC)  +
    Pk_Avaluospur.FFactoresConst(6094 ,c2r.PUR05IESPE) +
    Pk_Avaluospur.FFactoresConst(5146 ,c2r.PUR05revinterior)+ 
    Pk_Avaluospur.FFactoresConst(5515 ,PISO_V);
    
    */
    
    --FActoresConstruccion := Pk_Avaluospur.FFactoresConst(6085 ,c2r.PUR05ESTRUCTURA);
    
    ANIO_CALCULO := ANIO_VALORACION;

    BEGIN
        
        SELECT  C.REN21VALO
            INTO VALOR_CONST
        FROM REN21 C, REN21 B
        WHERE C.REN21SUBF = TO_CHAR(B.REN21CODI)
            AND B.REN20CODI = 6085
            AND B.REN21SUBF =  c2r.PUR05ESTRUCTURA
            AND C.REN21ANIO = (SELECT MIN(D.REN21ANIO)
                                FROM REN21 D
                                WHERE REN21ANIO >= ANIO_CALCULO
                                      AND REN20CODI = 77) ;    
                                      
       
                                                                         
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

-- EXCEPCIONALIDAD PARA VALORACION INDIVIDUAL ******++ ALEXANDRA 21 MARZO 2014

  begin
    SELECT PURVM2VALOR 
    into FActoresConstruccion
    FROM PURVM2_CONST 
    where PURVM2ANIO = TO_CHAR(SYSDATE,'rrrr')
    and substr(PURVM2ZONIFICA,1,10) = ClaveCatastral;

     EXCEPTION
      WHEN OTHERS THEN
        NULL;
   END;
    
   
   

--        UPDATE PUR05
--        SET VPUR05ESTCOLU=     Pk_Avaluospur.FFactoresConst(5138,c2r.PUR05ESTCOLU) ,
--        VESTVIGAS     =        Pk_Avaluospur.FFactoresConst(5139,c2r.PUR05ESTVIGAS) ,
--        VACAENLU     =        Pk_Avaluospur.FFactoresConst(5146,c2r.PUR05ACAENLU) ,  
--        VREVESCA     =        Pk_Avaluospur.FFactoresConst(6089,c2r.PUR05REVESCA),
--        VESTEPISO     =        Pk_Avaluospur.FFactoresConst(5140,c2r.PUR05ESTEPISO)  ,
--        VESTPARE     =        Pk_Avaluospur.FFactoresConst(5141 ,c2r.PUR05ESTPARE)  ,
--        VESCALERA     =        Pk_Avaluospur.FFactoresConst(6086 ,c2r.PUR05ESCALERA)  ,
--        VESTCUBIER     =        Pk_Avaluospur.FFactoresConst(5142 ,c2r.PUR05ESTCUBIER)  ,
--        VACAPISOS     =        Pk_Avaluospur.FFactoresConst(6087 ,c2r.PUR05ACAPISOS)  ,
--        VACAPUER     =        Pk_Avaluospur.FFactoresConst(5144 ,c2r.PUR05ACAPUER)  ,
--        VACATUMB     =        Pk_Avaluospur.FFactoresConst(5147 ,c2r.PUR05ACATUMB)  ,
--        VCUBIACAB     =        Pk_Avaluospur.FFactoresConst(6090 ,c2r.PUR05CUBIACAB)  ,
--        VACAVENTA     =        Pk_Avaluospur.FFactoresConst(5145 ,c2r.PUR05ACAVENTA)  ,
--        VCUBRVENT     =        Pk_Avaluospur.FFactoresConst(6091 ,c2r.PUR05CUBRVENT)  ,
--        VCLOSER     =        Pk_Avaluospur.FFactoresConst(6092 ,c2r.PUR05CLOSER)  ,
--        VISANI       =        Pk_Avaluospur.FFactoresConst(5149 ,c2r.PUR05ISANI)  ,
--        VINBANIOS     =        Pk_Avaluospur.FFactoresConst(6093 ,c2r.PUR05INBANIOS)  ,
--        VIELEC         =        Pk_Avaluospur.FFactoresConst(5148 ,c2r.PUR05IELEC)  ,
--        VIESPE         =        Pk_Avaluospur.FFactoresConst(6094 ,c2r.PUR05IESPE) ,
--        Vrevinterior     =        Pk_Avaluospur.FFactoresConst(5146 ,c2r.PUR05revinterior) ,
--        VTPUR05ESTCOLU=     PK_UTI.TITULOSUBF(5138,c2r.PUR05ESTCOLU) ,
--        VTESTVIGAS     =        PK_UTI.TITULOSUBF(5139,c2r.PUR05ESTVIGAS) ,
--        VTACAENLU     =        PK_UTI.TITULOSUBF(5146,c2r.PUR05ACAENLU) ,  
--        VTREVESCA     =        PK_UTI.TITULOSUBF(6089,c2r.PUR05REVESCA),
--        VTESTEPISO     =       PK_UTI.TITULOSUBF(5140,c2r.PUR05ESTEPISO)  ,
--        VTESTPARE     =        PK_UTI.TITULOSUBF(5141 ,c2r.PUR05ESTPARE)  ,
--        VTESCALERA     =        PK_UTI.TITULOSUBF(6086 ,c2r.PUR05ESCALERA)  ,
--        VTESTCUBIER     =        PK_UTI.TITULOSUBF(5142 ,c2r.PUR05ESTCUBIER)  ,
--        VTACAPISOS     =       PK_UTI.TITULOSUBF(6087 ,c2r.PUR05ACAPISOS)  ,
--        VTACAPUER     =        PK_UTI.TITULOSUBF(5144 ,c2r.PUR05ACAPUER)  ,
--        VTACATUMB     =        PK_UTI.TITULOSUBF(5147 ,c2r.PUR05ACATUMB)  ,
--        VTCUBIACAB     =        PK_UTI.TITULOSUBF(6090 ,c2r.PUR05CUBIACAB)  ,
--        VTACAVENTA     =        PK_UTI.TITULOSUBF(5145 ,c2r.PUR05ACAVENTA)  ,
--        VTCUBRVENT     =        PK_UTI.TITULOSUBF(6091 ,c2r.PUR05CUBRVENT)  ,
--        VTCLOSER     =       PK_UTI.TITULOSUBF(6092 ,c2r.PUR05CLOSER)  ,
--        VTISANI       =       PK_UTI.TITULOSUBF(5149 ,c2r.PUR05ISANI)  ,
--        VTINBANIOS     =       PK_UTI.TITULOSUBF(6093 ,c2r.PUR05INBANIOS)  ,
--        VTIELEC         =        PK_UTI.TITULOSUBF(5148 ,c2r.PUR05IELEC)  ,
--        VTIESPE         =      PK_UTI.TITULOSUBF(6094 ,c2r.PUR05IESPE) ,
--        VTrevinterior     =     PK_UTI.TITULOSUBF(5146 ,c2r.PUR05revinterior) ,
--        PUR05VVCOEPISO  =  Pk_Avaluospur.FFactoresConst(5515 ,PISO_V)
--        WHERE pur05codi =c2r.pUr05codi; 

        BEGIN
            DIFANIOS := TO_NUMBER(TO_CHAR(SYSDATE,'rrrr')) - c2r.PUR05ANIOC;
        EXCEPTION
          WHEN OTHERS THEN
           DIFANIOS := 1;
        END;    
        BEGIN
            CoeficienteEstadoCons  :=  Pk_Avaluospur.FFactoresConst(5095,c2r.PUR05ESTADOCONS );
        EXCEPTION
          WHEN OTHERS THEN
                 CoeficienteEstadoCons  := 1;
        END;
        
        VidaUtil     := pk_avaluospur.VidaUtil(c2r.pur05estructura);  --calculo de a?os de vida util


        --*********** ALEXANDRA 4-NOV-2014
        -- INCREMENTO DE NUEVOS FACTORES: USO DE BLOQUE CONSTRUCTIVO Y ETAPA CONSTRUCTIVA        
         FactorUsoBloque := pk_uti.VALORREN21(54, c2r.pur05cate);
         
        FactorEtapaConstructiva := PK_UTI.VALORREN21(16 ,c2r.PUR05ACA);

    --- *** SE INGRESA CONTROL DE AÑO DE VALORACION PARA CONTROLAR LA FORMULA A APLICAR     *** ALEXA DIC2019
    
    IF ANIO_CALCULO < 2020 THEN
        ValorConstante := 0;--Pk_Avaluospur.Ffactor_Constante(0);
        
        R := pk_avaluospur.ValorResidual(c2r.pur05estructura); 
        
        PorcentajeEdad := ROUND(nvl(difanios, 0)/nvl(VidaUtil,1),2)*100;
             
        FactorDepreciacion := PK_avaluospur.FFactorDepEstConserv(PorcentajeEdad,c2r.PUR05ESTADOCONS); -- Factor de Depreciacion
        
           
        -- FactorDepreciacion     := Pk_Avaluospur.Ffactor_Depreciacion(DIFANIOS ,c2r.PUR05ESTRUCTURA,c2r.PUR05ESTCOLU);
        ------------ AQUI SE DEBE INSERTAR LA LECTURA DEL CATALOGO PARA DETERMINAR EL FACTOR DE DEPRECIACION EN BASE A LOS A?OS DE CONSTRUCCION
        -------INCREMENTAR EL CATALOGO CORRESPONDIENTE PARA HACER EL CALCULO
        
        
        /*  ELIMINADO POR ALEXA 28 JULIO 2014
        IF DIFANIOS > 20 THEN
          FactorDepreciacion := 95;
          
        ELSE
        
         BEGIN
            SELECT REN21VMAX
            INTO FactorDepreciacion
            FROM REN21
            WHERE REN20CODI= 33
            AND REN21VMIN= DIFANIOS;
            
        EXCEPTION
         WHEN OTHERS THEN
              FactorDepreciacion  := 1;
        END;
        END IF; 
        */
        
        -- DESDE AQUI, DESHABILITACION DE CALCULO DE AVALUO CONSTRUCCION *********** ALEXANDRA 30 JULIO 2014
        /*FActoresConstruccion := FActoresConstruccion - (FActoresConstruccion*FactorDepreciacion/100);
        
        
        TOTAL_FACTORE := ROUND((CoeficienteEstadoCons  * FactorDepreciacion) ,4);

         --AvaluoConstruccion      := round( AreaConstruccion * round( FActoresConstruccion,2) * CoeficienteEstadoCons  * FactorDepreciacioN,2); 
         
         AvaluoConstruccion      := round( AreaConstruccion * round( FActoresConstruccion,2) * CoeficienteEstadoCons,2); 

         TotalAvaluoConstruccion  := TotalAvaluoConstruccion  + nvl(AvaluoConstruccion,0);    */
        -- HASTA AQUI, DESHABILITACION DE CALCULO DE AVALUO

        --DESDE AQUI, NUEVO CALCULO AVALUO CONSTRUCCION         ALEXANDRA- 30JUL2014
        
        --AvaluoConstruccion      := round( AreaConstruccion * round( FActoresConstruccion,2),2);
        
        FActoresConstruccion:=VALOR_CONST;
        
        FACTOR1 := AreaConstruccion;        -- ****PARA VERIFICACION PASO A PASO
        
        TOTAL_FACTORE := R + ((1 - R)*(1 - FactorDepreciacion));
        
        AVALUOCONSTRUCCION := round(AreaConstruccion *  FActoresConstruccion * (R + ((1 - R)*(1 - FactorDepreciacion))),2);
        
        FACTOR2 := AVALUOCONSTRUCCION;      -- ****PARA VERIFICACION PASO A PASO
        
        
        AVALUOCONSTRUCCION := round(AVALUOCONSTRUCCION * FactorUsoBloque * FactorEtapaConstructiva, 2);
        
        FACTOR3 := AVALUOCONSTRUCCION;      -- ****PARA VERIFICACION PASO A PASO
        
        --AVALUOCONSTRUCCION := round(AvaluoConstruccion * (R + (1 - R)*(1 - FactorDepreciacion)),2);
        
        
        
        -- HASTA AQUI, NUEVO CALCULO AVALUO DE CONSTRUCCION     ALEXANDRA- 30JUL2014

    ELSE        ---***** AÑO 2020
    
        IF VIDAUTIL <= DIFANIOS THEN
        
            Y := 75;
        
        ELSE
            X := (DIFANIOS / VidaUtil) *100;
            
            IF c2r.PUR05ESTADOCONS = 1 THEN
                Y := 0.0051 * X * X + 0.4581 * X + 2.3666;
                ELSE IF c2r.PUR05ESTADOCONS = 2 THEN
                        Y := 0.0043 * X * X + 0.3850 * X + 17.968;
                    ELSE IF c2r.PUR05ESTADOCONS = 3 THEN
                        Y := 0.0025 * X * X + 0.0222 * X + 52.556;
                    END IF;
                END IF;
            END IF;
            
            
        END IF;
        
        FactorDepreciacion :=  1 - (Y/100);
        
        FactorCorreccion := FactorDepreciacion * FactorUsoBloque * FactorEtapaConstructiva;
        
        AvaluoConstruccion := round(AreaConstruccion * VALOR_CONST * FactorCorreccion, 2); 
       
       
    END IF;     --- FIN DE CONTROL POR AÑO DE VALORACION    
    
    TotalAvaluoConstruccion  := TotalAvaluoConstruccion  + nvl(AvaluoConstruccion,0);
        
        FACTOR4 := TotalAvaluoConstruccion;      -- ****PARA VERIFICACION PASO A PASO
   
 IF    LActualiza = '1'  THEN

     null; 

   ELSIF LActualiza = '2' THEN
   
    UPDATE pur05 
    SET PURAVSI        =  AvaluoConstruccion,           --avaluo construccion
        PURbl01        =  FActoresConstruccion,         -- vm2 construccion
        PURcebl01      =  CoeficienteEstadoCons,        -- estado de conservacion
        PURctbl01      =  R,                            -- Valor Residual
        PURfdpr01      =  FactorDepreciacion,           -- Factor de depreciacion
        PUR05VALOM2CON =  FActoresConstruccion,           -- VM2 de construccion
        PUR05FUSOBL    =   FactorUsoBloque,             -- FACTOR USO DE BLOQUE
        PUR05FETAPACONS =  FactorEtapaConstructiva      --  FACTOR ETAPA CONSTRUCTIVA
    WHERE pur05codi =c2r.pUr05codi;   
   
    valor :=  Pk_Avaluospur.FActAvalConst(c2r.pur05codi,AvaluoConstruccion);
    
    IF c2r.PUR05AREAL <> AvaluoConstruccion THEN
      
      
          TXT := SUBSTR(TXT||' Avaluo de bloque Nro ='||RTRIM(LTRIM(C2R.PUR05NBLO))||' Piso Nro ='||RTRIM(LTRIM( c2r.pur05npiso))||
                 CHR(10)||'    Actual ='||RTRIM(LTRIM(TO_CHAR(c2r.PUR05AREAL,'99g999g990d99')))||
                          ' Por  = '||LTRIM(RTRIM(TO_CHAR(AvaluoConstruccion,'99g999g990d99')))||CHR(10)|| 
                          ' Area = '||LTRIM(RTRIM(TO_CHAR(AreaConstruccion,'99g999g990d99')))||CHR(10)|| 
                     ' V.m2.= '||LTRIM(RTRIM(TO_CHAR(FActoresConstruccion,'990d99')))|| 
                     ' Coe.Est.= '||LTRIM(RTRIM(TO_CHAR(CoeficienteEstadoCons,'990d99')))||  
                     ' Factores Total.= '||LTRIM(RTRIM(TO_CHAR(TOTAL_FACTORE ,'9g990d99')))|| 
                     ' Fac.Dep.= '||LTRIM(RTRIM(TO_CHAR(FactorDepreciacion,'9g990d99')))||
                     ' Edad= '||ltrim(rtrim(DIFANIOS))||chr(10)||
                     '***************************************************'||chr(10),1,2489);
   
    END IF;        
   
   END IF;

   
  END LOOP;
  if txt is not null then
    Pk_Obspur.FGENERA_OBSERVA(ClaveCatastral ,USER,'PC',TXT);
  end if;  
   
  RETURN    TotalAvaluoConstruccion;
END;
 FUNCTION FFactoresConst(catalogo IN NUMBER, lcodigo IN NUMBER ) RETURN NUMBER
 IS
 valor NUMBER(25,8);
 INCI  NUMBER(25,8);
 VALOR_01 NUMBER(25,8);
 valor_sim NUMBER(25,8);
 
BEGIN

        SELECT nvl(ren21valo,0),nvl(REN21VALOSIMU,0)
        INTO   valor, valor_sim
        FROM REN21
        WHERE ren20codi            = catalogo
        AND   TO_NUMBER(ren21subf) = lcodigo;


    if   LActualiza = '2'  then
         return valor;
    elsif   LActualiza = '1'  then
       return valor_sim;
    end if;
            
    
    RETURN valor;

  EXCEPTION
     WHEN NO_DATA_FOUND THEN
              mensajeerror  := 'No existe Datos... Revise los Bloques de Construcciones ';
        RETURN 0;
     WHEN  TOO_MANY_ROWS THEN
               mensajeerror  := 'El catalogo de los valores esta mal configurado revise los datos';
          RETURN 0;
      WHEN OTHERS THEN
                 mensajeerror  := 'Error no identificado llame al proveedor ';
           RETURN 0;
  
 END;
  
 FUNCTION Ffactor_Constante (ValorAreaTerreno IN NUMBER) RETURN NUMBER IS
 -- 5069  
 VALOR NUMBER(25,8):=0;
BEGIN
 SELECT NVL(REN21base,0)
 INTO VALOR
 FROM REN21
 WHERE REN20CODI = 5517;
 
 RETURN valor;
 
 EXCEPTION
  WHEN OTHERS THEN 
      RETURN 1; 
 END;
------------------------------------
----- FACTOR CORRECCION ESTADO
FUNCTION FEstadoConservacion(anio IN NUMBER,codigo in number ) RETURN NUMBER
    
IS
  valor NUMBER(25,8);
  nanios NUMBER(4);
  lanios NUMBER(4);

BEGIN

            -- CATALOGO ESTADO DE CONSERVACION
           begin
           SELECT ren21BASE
           INTO   valor
           FROM REN21
           WHERE ren20codi  = 5095   ---6000
           AND     NVL(anio,1) BETWEEN  ren21vmin AND ren21vmax;
           
           RETURN nvl(valor,2);
           
           EXCEPTION
             WHEN OTHERS THEN
            RETURN 1;
          END;
  

  RETURN VALOR;
  
 exception
  when others then
   return 1;
    
 end; 

---------------- 
FUNCTION FFactorDepEstConserv(anio IN NUMBER,codigo in number ) RETURN NUMBER
    
IS
  valor NUMBER(25,8);           --AQUI CAMBIAR EL CODIGO DEL CATALOGO DE A?OS DE DEPRECIACION
  nanios NUMBER(4);
  lanios NUMBER(4);

BEGIN

--- ---         CATALOGO DE A?OS DE DEPRECIACION 2015 

           begin
            if codigo = 1 then --estado de conservacion: Bueno
                SELECT ren21VMax
                INTO   valor
                FROM REN21
                WHERE ren20codi  = 53 and anio between ren21anio  and ren21vmin;
            else if codigo = 2 then --estado de conservacion: Regular
                SELECT ren21base
                INTO   valor
                FROM REN21
                WHERE ren20codi  = 53 and anio between ren21anio  and ren21vmin;

            else if codigo = 3 then
                SELECT ren21exec
                   INTO   valor
                   FROM REN21
                   WHERE ren20codi  = 53 and anio between ren21anio and ren21vmin;
            end if;  
            end if;
            end if;         
           
           RETURN nvl(valor,0);
           
           EXCEPTION
             WHEN OTHERS THEN
            RETURN 1;
          END;
  

  RETURN VALOR;
  
 exception
  when others then
   return 1;
    
 end; 


FUNCTION VidaUtil(codigo in number ) RETURN NUMBER  --recibe como codigo, el correspondiente a la estructura de edificacion, columna ren21subf
    
IS
  valor NUMBER(25,8);
  nanios NUMBER(4);
  lanios NUMBER(4);

BEGIN
            --- CATALOGO: VARIABLE A?OS DE CONSTRUCCION
                          ----CONDICION TEMPORAL: LEER DE ACUERDO A CODIGO DE ORDENANZA
        IF ANIO_VALORACION =2020 THEN
          begin
                SELECT ren21VALO
                    INTO   valor
                FROM REN21
                WHERE REN20CODI = 193
                    AND REN21SUBF = (SELECT REN21CODI
                                     FROM REN21
                                     WHERE REN20CODI = 6085
                                            AND REN21SUBF = CODIGO);
                        
                if valor = 0 then 
                    valor := 1;
                end if;           
               
               RETURN valor;
               
               EXCEPTION
                 WHEN OTHERS THEN
                RETURN 1;
          END;
        ELSE

           begin
            SELECT ren21subf
                INTO   valor
            FROM REN21
            WHERE ren20codi  = 56 and ren21anio = codigo;  --codigo municipio = 53
                    
            if valor = 0 then 
                valor := 1;
            end if;           
           
           RETURN valor;
           
           EXCEPTION
             WHEN OTHERS THEN
            RETURN 1;
          END;
        END IF;
  

  RETURN VALOR;
  
 exception
  when others then
   return 1;
    
 end; 


FUNCTION VAlorResidual(codigo in number ) RETURN NUMBER  --recibe como codigo, el correspondiente a la estructura de edificacion, columna ren21subf
    
IS
  valor NUMBER(25,8);
  nanios NUMBER(4);
  lanios NUMBER(4);

BEGIN

            --- CATALOGO: VARIABLE A?OS DE CONSTRUCCION

           begin
            SELECT ren21valo
                INTO   valor
            FROM REN21
            WHERE ren20codi  = 56 and ren21anio = codigo;
                    
            if valor = 0 then 
                valor := 1;
            end if;           
           
           RETURN (valor/100);
           
           EXCEPTION
             WHEN OTHERS THEN
            RETURN 0;
          END;
  

  RETURN VALOR;
  
 exception
  when others then
   return 1;
    
 end; 



  --------------------------------------   
 FUNCTION Ffactor_Depreciacion(anios in number,CarGeneral in number, material in number ) RETURN NUMBER 
 is
   valor NUMBER(25,8);   
   
   CURSOR C1(LAAN IN NUMBER) IS
    SELECT P.PURANIO, P.PURDESDE, P.PURHASTA, 
       P.PURHORM, P.PURHIER, P.PURMDFI, 
       P.PURMDCO, P.PURBLLA, P.PURBAHA, 
       P.PURADOB, P.PUROTRS,P.purcania
    FROM PUR_DEPRECIA P
    WHERE LAAN BETWEEN p.PURDESDE AND p.PURHASTA;

  begin
   
   for i in c1(anios) loop
      
      if material = 2 then
         valor := i.PURHORM;
      elsif material = 6 then   
        valor := i.PURhier;
      elsif material = 10 then   
        valor := i.PURMDFI;
      elsif material = 8 then   
        valor := i.PURMDCO;
      elsif material in(11,12)  then   
        valor := i.PURBLLA;
     elsif material in(5)  then   
        valor := i.PURBAHA;
     elsif material in(9)  then   
        valor := i.purcania;
     elsif material in(14,15)  then   
        valor := i.PURADOB;
     else
        valor := I.PUROTRS;
     end if;      
                
   
   end loop;
  
  
   RETURN valor;
   EXCEPTION
     WHEN OTHERS THEN
    RETURN 1;
  END;
 
END Pk_Avaluospur;
/
