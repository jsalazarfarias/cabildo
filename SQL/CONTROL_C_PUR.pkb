CREATE OR REPLACE PACKAGE BODY SISESMER.Control_C_Pur AS

/* BODY:
   Permite Registrar los cambios de auditoria de todo los movimientos
   de catastro urbano
   PRISHARD CIA. LTDA.
   Autor        :    Wladimir Sandoval
   Modicado por :
   Fecha Creacion              Fecha Modificacion
   08/01/2003                   09/09/2003

*/


/****************************************************************/

PROCEDURE P_H_PUR (CLAVE VARCHAR2 ,CAMPO VARCHAR2,DATOA VARCHAR2 ,DATON VARCHAR2)
/* procedimiento:
   Permite llenar la tabla de auditoria del sistema de catastro urbano
   forma general para todos los datos
   PRISHARD CIA. LTDA.
   Autor      :    wladimir Sandoval
   Modicado por :
   Fecha Creacion              Fecha Modificacion
   08/01/2003                   09/09/2003

*/
IS
WVA VARCHAR2(30);
WVN VARCHAR2(30);

BEGIN
WVA := NVL(SUBSTR(DATOA,1,30),'ERROR');
WVN := NVL(SUBSTR(DATON,1,30),'ERROR');
IF WVA <> wvn THEN
IF CAMPO = 'CAMBIO DE NOMBRE' THEN
		WVA :=  SUBSTR(Pk_Uti.gen01_com(DATOA),1,30);
		WVN :=  SUBSTR(Pk_Uti.gen01_com(DATON),1,30);
END IF;

 INSERT INTO PUR11 (PUR11FCAM,PUR01PRED,PUR11CMOD,PUR11VANT ,PUR11VNUE,PUR11LCRE,PUR11FCRE,PUR11TERM)
 VALUES (SYSDATE,CLAVE,CAMPO,WVA,WVN,USER,SYSDATE,USERENV('terminal'));

END IF;

EXCEPTION
 WHEN OTHERS THEN
   NULL;
END;



END Control_C_Pur;
/
