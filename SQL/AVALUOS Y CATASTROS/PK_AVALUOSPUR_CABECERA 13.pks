CREATE OR REPLACE PACKAGE SISESMER.pk_avaluospur AS
/******************************************************************************
   NAME:       pk_avaluoPRU
   PURPOSE:   permite calcular los avaluos de un predio urbano
   ---- version Municipio de COTACACHI  
--------------------------------------------------------------------------------------------------
-------------    REVISIONS:
---------------------------------------------------------------------------------------------------
   Ver         Date        Author           Description
   ---------    ----------  ---------------  --------------------------------------------------------
   1.0          26/09/2006  prishard wsandoval
   2.0          NOV/2014    GADMCE - Alexa Gonzaga  CAMBIOS EN FORMA DE VALORACION: USO DE FACTORES
   2.1          16/11/2015  ADMCE - Alexa Gonzaga  CAMBIOS EN FORMA DE VALORACION: VALORACION DE SUELO Y CONSTRUCCION
*********   ******************************************************************** 
*/
 AvaluoConstruccion            NUMBER(25,8):=0;
 TotalAvaluoConstruccion       NUMBER(25,8):=0;
 AreaConstruccion              NUMBER(25,8):=0;
 FactoresConstruccion          NUMBER(25,8):=0;
 CoeficienteEstadoCons         NUMBER(25,8):=0;
 CalculoDepreciacion           NUMBER(25,8):=0;
 VidaUtilConstruccion          NUMBER(25,8):=0;

 AvaluoTerreno          NUMBER(25,8):=0;
 TotalAvaluoTerreno     NUMBER(25,8):=0;
 TotalAvaluo            NUMBER(25,8):=0;
 ClaveCatastral         VARCHAR2(30);
 AreaLote               NUMBER(25,8):=0;
 ValorM2Manzana         NUMBER(25,8):=0;
 SFrentesLote           NUMBER(25,8):=0;
 FFdepre                NUMBER(25,8):=0;

 OcupacionSuelo         NUMBER(8):=0;
 TopoGrafia             NUMBER(8):=0;
 Localizacion           NUMBER(8):=0;
 CaractSuelo            NUMBER(8):=0;
 FormaTerreno           NUMBER(8):=0;  
 ViaUso                 NUMBER(8):=0;  
 ViaMaterial            NUMBER(8):=0;  

 FactorOcupacionSuelo   NUMBER(25,8):=0;
 FactorTopoGrafia       NUMBER(25,8):=0;
 FactorLocalizacion     NUMBER(25,8):=0;
 FactorCaractSuelo      NUMBER(12,4):=0;
 FactorFormaTerreno     NUMBER(25,8):=0;
 FactorViaUso           NUMBER(25,8):=0;  
 FactorViaMaterial      NUMBER(25,8):=0;
 FactorFrenteFondo      NUMBER(25,8):=1;
 FactorSuperficie       NUMBER(25,8):=0;  
 
 
  /*  indicadores servicios  */   
 IndicCoeAguaAlcEner         number(25,8):=1;
 /* Aceras y bordillos */
 IndAceraBorTelAseReco      number(25,8):=1;
 TotalFactores          NUMBER(25,8):=0; 
 
 --AEXANDRA, PARA INCORPORAR RE-VALORACION
 
  FactorFrente           NUMBER(25,8):=1;
 FactorFondo            NUMBER(25,8):=1; 
 FactorVia              NUMBER(25,8):=0;    --Alexandra 4Nov2014
 FactorEsquina          NUMBER(25,8):=0;    --Alexandra 4Nov2014

 FactorUsoBloque        NUMBER(25,8):=1;    --Alexandra 4Nov2014
 FactorEtapaConstructiva NUMBER(25,8):=1;   --Alexandra 4Nov2014
   
 SumaFrentes                     NUMBER(25,8):=0;
 NumeroFrentes          NUMBER(25,8);

    ResumenTotalAvaluoConstruccion      NUMBER(25,8):=0;
    ResumenTotalAvaluoTerreno      NUMBER(25,8):=0;

 MARCAMACROLOTES   VARCHAR2(2):='00';
 
    VG_NROLOTE VARCHAR2(3):='000'; 
    
    
 -- ALEXA, CAMBIOS BIENIO 2016-2017  (NOV2015)
 
 ANIO_VALORACION NUMBER(4);
 
 F_1  EXCEPTION;
 F_2  EXCEPTION;
 F_3  EXCEPTION;
 F_4  EXCEPTION;
 F_5  EXCEPTION;

 F_1c  EXCEPTION;
 F_2c  EXCEPTION;
 F_3c  EXCEPTION;
 F_4c  EXCEPTION;
 F_5c  EXCEPTION;

 e_error            EXCEPTION;
 mensajeerror       VARCHAR2(3000) := NULL;
 lactualiza         VARCHAR2(20):= NULL;


FUNCTION FAvaluoTotal(CLAVE  IN VARCHAR2, PActualiza IN VARCHAR2, MENSAJE  OUT VARCHAR2, ANIO IN NUMBER)  RETURN NUMBER;
--FUNCTION FAvaluoTotal(CLAVE  IN VARCHAR2 )  RETURN NUMBER;

/*
   Avaluo del Terreno
*/
    FUNCTION FAvaluoTerreno  RETURN NUMBER;

 FUNCTION  FActAvalTerr(lpur02codi IN NUMBER , lavaluo IN NUMBER) RETURN NUMBER;

 FUNCTION  FActAvalConst(Lpur05codi IN NUMBER,  lavaluo IN NUMBER) RETURN NUMBER;

 FUNCTION  FActAvalProp(Lpur01codi IN NUMBER, lavaluo IN NUMBER) RETURN NUMBER;

 FUNCTION FValorM2Mz (l3_clave in varchar2,lsimu in varchar2 ) RETURN NUMBER;

 FUNCTION FFactoresTerreno(codigo in number, HIJO IN NUMBER)    RETURN NUMBER;
 FUNCTION FFactoresSuperficie(codigo in number,larea IN NUMBER)    RETURN NUMBER;

 FUNCTION FFactoresFrenteFondo(Frente in number, fondo In Number,AREA IN NUMBER)    RETURN NUMBER; 

-- ALEXNANDRA, PARA REVALORACION
FUNCTION FFactor_Frente(Frente in number, clave In varchar2) RETURN NUMBER;

FUNCTION FFactorFondo(Fondo in number, clave in varchar2) RETURN NUMBER;

--FUNCTION FFactorTama?o(AreaLT in number, AreaLote In number)    RETURN NUMBER;

 FUNCTION FFactorTamaño(clave in varchar2, AreaLote In number)    RETURN NUMBER;

--FUNCTION FFactorForma(Frente in number, AreaLote In number)    RETURN NUMBER;
FUNCTION FFactorForma(Frente in number, AreaLote In number, CLAVE IN VARCHAR2)    RETURN NUMBER;

FUNCTION FFactorEsquina(clave In varchar2) RETURN NUMBER;

FUNCTION FFactorVia(clave In varchar2) RETURN NUMBER;

/*
   Avaluo de la Construccion
*/
   FUNCTION FAvaluoConstrucciones RETURN NUMBER;
   FUNCTION FFactoresConst(catalogo IN NUMBER, lcodigo IN NUMBER ) RETURN NUMBER;
   FUNCTION FEstadoConservacion(anio IN NUMBER,codigo in number ) RETURN NUMBER;   
   FUNCTION Ffactor_Constante (ValorAreaTerreno IN NUMBER) RETURN NUMBER ;
   FUNCTION Ffactor_Depreciacion(anios in number,CarGeneral in number, material in number ) RETURN NUMBER ;   
    FUNCTION FFactorDepEstConserv(anio IN NUMBER,codigo in number ) RETURN NUMBER;   --ALEXANDRA 28JUL2014
    FUNCTION VidaUtil(codigo in number ) RETURN NUMBER;  --ALEXANDRA 20JUL2014
    FUNCTION VAlorResidual(codigo in number ) RETURN NUMBER;   --ALEXANDRA 30JUL2014
END Pk_Avaluospur;
/
