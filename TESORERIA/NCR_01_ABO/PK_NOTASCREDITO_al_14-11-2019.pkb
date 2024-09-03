CREATE OR REPLACE PACKAGE BODY SISESMER.pk_notascredito IS

FUNCTION Aprobar (P_IdNC        IN NUMBER,
                  O_Mensaje IN OUT VARCHAR2) RETURN BOOLEAN IS

V_Estado             VARCHAR2(2)  := NULL;
V_NroReg             NUMBER(10)    := NULL;
V_Suma               NUMBER(16,2) := NULL;
V_NroComprobante     VARCHAR2(20) := NULL;
V_ValorNotaCredito   NUMBER(16,2) := NULL;
V_FechaActual        DATE         := NULL;
V_CodEmi01           NUMBER(8)    := NULL;
V_Tipo               VARCHAR2(2)  := NULL;

CURSOR PAGOS_MALOS IS
       SELECT a.id_ncr01, a.emi01codi, a.gen01codi, a.emi01seri, a.emi01clave,
              a.emi01anio, a.emi01mes, a.emi01dia, a.emi01fobl, a.emi01femi,
              a.emi01neli, a.emi01feli, a.emi01leli, a.emi01fest, a.emi01fpag,
              a.emi01lpag, a.emi01npag, a.emi01vtot, a.emi01inte, a.emi01desc,
              a.emi01reca, a.emi01exo, a.emi01esta, a.emi01titu, a.emi01fcre,
              a.emi01lcre, a.emi01lmod, a.emi0fmod, a.emi01ncre, a.emi01nrotit,
              a.emi01pmer, a.emi01evalo, a.emi01coa, a.emi01merca, a.emi01iva,
              a.emi01descmerca, a.emi01msri, a.emi01isri, a.emi01motbaja,
              a.emi01motlanc, a.emi01planc, a.emi01rlanc, a.emi01crenta,
              a.emi01nrotras, a.emi01nrocoa, a.pur01tmp, a.gen01codi_recaud
         FROM ncr02 a
        WHERE a.id_ncr01 = P_IdNC;

BEGIN

    SELECT SYSDATE
      INTO V_FechaActual
      FROM dual;

    Begin
       SELECT nvl(trunc(par00valor),1)
         INTO V_NroComprobante
         FROM par00
        WHERE par00desc = 'SECUENCIAL DE NOTAS DE CREDITO'
        FOR UPDATE;

	    UPDATE par00
	       SET par00valor = to_number(V_NroComprobante) + 1
	     WHERE par00desc = 'SECUENCIAL DE NOTAS DE CREDITO';

       EXCEPTION
         WHEN NO_DATA_FOUND THEN
            O_Mensaje := 'Parametro <SECUENCIAL DE NOTAS DE CREDITO> para secuencia de comprobantes de Notas de Credito no existe';
            rollback;
            return(false);
         WHEN TOO_MANY_ROWS THEN
            O_Mensaje := 'Parametro <SECUENCIAL DE NOTAS DE CREDITO> para secuencia de comprobantes de Notas de Credito existe mas de una vez';
            rollback;
            return(false);
         WHEN OTHERS THEN
            O_Mensaje := 'Error no definido al buscar la secuencia de comprobantes de Notas de Credito';
            rollback;
            return(false);
    End;

    SELECT a.estado, a.tipo
      INTO V_Estado, V_Tipo
      FROM ncr01 a
     WHERE id = P_IdNC;

    if nvl(V_estado,'AP') <> 'DI' then
       O_Mensaje := 'Transaccion no valida .... Solo se pueden Aprobar transacciones en estado de DIGITADO';
       rollback;
       return(false);
    end if;

    SELECT COUNT(*)
      INTO V_NroReg
      FROM ncr02
     WHERE id_ncr01 = P_IdNC;

    if nvl(V_NroReg,0) = 0 then
       O_Mensaje := 'Transaccion no valida .... No se ha encontrado los pagos que sustentan la Nota de credito....';
       rollback;
       return(false);
    end if;

    for i in PAGOS_MALOS loop
        SELECT nvl(sum(nvl(valor_devuelto,0)),0)
          INTO V_Suma
          FROM ncr03
         WHERE id_ncr01  = P_IdNC
           AND emi01codi = i.emi01codi;

        if nvl(V_Suma,0) = 0 then
           O_Mensaje := 'Transaccion no valida .... sobre el pago <'||i.emi01codi||'> no se han registrado valores...';
           rollback;
           return(false);
        end if;
    end loop;



    IF V_Tipo = 'IN' then
       for i in PAGOS_MALOS loop
          select sq_emi01.nextval
            into V_CodEmi01
            from dual;

          INSERT INTO emi01(EMI01CODI,GEN01CODI,EMI01SERI,EMI01CLAVE,EMI01ANIO,
                            EMI01MES,EMI01DIA,EMI01FOBL,EMI01FEMI,EMI01NELI,
                            EMI01FELI,EMI01LELI,EMI01FEST,EMI01FPAG,EMI01LPAG,
                            EMI01NPAG,EMI01VTOT,EMI01INTE,EMI01DESC,EMI01RECA,
                            EMI01EXO,EMI01ESTA,EMI01TITU,EMI01FCRE,EMI01LCRE,
                            EMI01LMOD,EMI0FMOD,EMI01NCRE,EMI01NROTIT,EMI01PMER,
                            EMI01EVALO,EMI01COA,EMI01MERCA,EMI01IVA,EMI01DESCMERCA,
                            EMI01MSRI,EMI01ISRI,EMI01MOTBAJA,EMI01MOTLANC,EMI01PLANC,
                            EMI01RLANC,EMI01CRENTA,EMI01NROTRAS,EMI01NROCOA,PUR01TMP,
                            GEN01CODI_RECAUD)
          VALUES(V_CodEmi01, i.gen01codi, i.emi01seri, i.emi01clave,i.emi01anio,
                 i.emi01mes, i.emi01dia, i.emi01fobl, i.emi01femi,i.emi01neli,
                 i.emi01feli, i.emi01leli, i.emi01fest, NULL,NULL,
                 NULL, i.emi01vtot, 0, 0,0,
                 i.emi01exo, 'E', i.emi01titu, V_FechaActual, USER,
                 i.emi01lmod, i.emi0fmod, i.emi01ncre, i.emi01nrotit,i.emi01pmer,
                 0, 0, i.emi01merca, 0,0,
                 0, 0, i.emi01motbaja,i.emi01motlanc, i.emi01planc,
                 i.emi01rlanc, i.emi01crenta,i.emi01nrotras, i.emi01nrocoa, i.pur01tmp,
                 i.gen01codi_recaud);

          INSERT INTO emi02(EMI02CODI,EMI01CODI,EMI04CODI,EMI02VDET)
          SELECT sq_emi02.nextval, V_CodEmi01, emi04codi, emi02vdet
            FROM emi02
           WHERE emi01codi = i.emi01codi
             AND emi04codi not in (2500, 2501, 2502, 2503, 2504, 2505, 2506, 2507, 2508);

          INSERT INTO NCR04(id_ncr01, emi01codi_original, emi01codi,
                            GEN01CODI,EMI01SERI,EMI01CLAVE,EMI01ANIO,
                            EMI01MES,EMI01DIA,EMI01FOBL,EMI01FEMI,EMI01NELI,
                            EMI01FELI,EMI01LELI,EMI01FEST,EMI01FPAG,EMI01LPAG,
                            EMI01NPAG,EMI01VTOT,EMI01INTE,EMI01DESC,EMI01RECA,
                            EMI01EXO,EMI01ESTA,EMI01TITU,EMI01FCRE,EMI01LCRE,
                            EMI01LMOD,EMI0FMOD,EMI01NCRE,EMI01NROTIT,EMI01PMER,
                            EMI01EVALO,EMI01COA,EMI01MERCA,EMI01IVA,EMI01DESCMERCA,
                            EMI01MSRI,EMI01ISRI,EMI01MOTBAJA,EMI01MOTLANC,EMI01PLANC,
                            EMI01RLANC,EMI01CRENTA,EMI01NROTRAS,EMI01NROCOA,PUR01TMP,
                            GEN01CODI_RECAUD,
                            creacion,f_creacion,modificacion,fu_modificacion)
          VALUES(P_IdNC, i.emi01codi, V_CodEmi01,
                 i.gen01codi, i.emi01seri, i.emi01clave,i.emi01anio,
                 i.emi01mes, i.emi01dia, i.emi01fobl, i.emi01femi,i.emi01neli,
                 i.emi01feli, i.emi01leli, i.emi01fest, NULL,NULL,
                 NULL, i.emi01vtot, 0, 0,0,
                 i.emi01exo, 'E', i.emi01titu, V_FechaActual, USER,
                 i.emi01lmod, i.emi0fmod, i.emi01ncre, i.emi01nrotit,i.emi01pmer,
                 0, 0, i.emi01merca, 0,0,
                 0, 0, i.emi01motbaja,i.emi01motlanc, i.emi01planc,
                 i.emi01rlanc, i.emi01crenta,i.emi01nrotras, i.emi01nrocoa, i.pur01tmp,
                 i.gen01codi_recaud,
                 user, sysdate, user, sysdate);
       end loop;
   END IF;

   SELECT nvl(sum(nvl(valor_devuelto,0)),0)
     INTO V_ValorNotaCredito
     FROM ncr03
    WHERE id_ncr01 = P_IdNC;

    if nvl(V_ValorNotaCredito,0) = 0 then
       O_Mensaje := 'Transaccion no valida .... El valor de la nota de credito es igual a cero';
       rollback;
       return(false);
    end if;

    update NCR01
       set estado       = 'AP',
           comprobante  = V_NroComprobante,
           valor_total  = V_ValorNotaCredito,
           saldo_migrado = V_ValorNotaCredito,
           aprobado_por = user,
           f_aprobacion = sysdate,
           migrado      = 'NO'
     where id = P_IdNC;

    O_Mensaje := 'Transaccion terminada con exito';
    commit;
    return(true);

    EXCEPTION
       WHEN OTHERS THEN
         O_Mensaje := 'Transaccion no valida .... Error no definido...'||sqlerrm;
         rollback;
         return(false);
END;

FUNCTION Aprobar_abono (P_IdNC        IN NUMBER,
                  O_Mensaje IN OUT VARCHAR2) RETURN BOOLEAN IS

V_Estado             VARCHAR2(2)  := NULL;
V_NroReg             NUMBER(10)    := NULL;
V_Suma               NUMBER(16,2) := NULL;
V_NroComprobante     VARCHAR2(20) := NULL;
V_ValorNotaCredito   NUMBER(16,2) := NULL;
V_FechaActual        DATE         := NULL;
V_CodEmi01           NUMBER(8)    := NULL;
V_Tipo               VARCHAR2(2)  := NULL;
V_EMI01CODI          NUMBER(8) :=NULL;

CURSOR PAGOS_MALOS IS
       SELECT (select b.id_ncr01 from ncr02 b where b.id_ncr01 = P_IdNC), 
              a.emi01codi, a.gen01codi, a.emi01seri, a.emi01clave,
              a.emi01anio, a.emi01mes, a.emi01dia, a.emi01fobl, a.emi01femi,
              a.emi01neli, a.emi01feli, a.emi01leli, a.emi01fest, a.emi01fpag,
              a.emi01lpag, a.emi01npag, a.emi01vtot, a.emi01inte, a.emi01desc,
              a.emi01reca, a.emi01exo, a.emi01esta, a.emi01titu, a.emi01fcre,
              a.emi01lcre, a.emi01lmod, a.emi0fmod, a.emi01ncre, a.emi01nrotit,
              a.emi01pmer, a.emi01evalo, a.emi01coa, a.emi01merca, a.emi01iva,
              a.emi01descmerca, a.emi01msri, a.emi01isri, a.emi01motbaja,
              a.emi01motlanc, a.emi01planc, a.emi01rlanc, a.emi01crenta,
              a.emi01nrotras, a.emi01nrocoa, a.pur01tmp, a.gen01codi_recaud
         FROM EMI01 a
        WHERE a.emi01codi in (select emi01codi from ncr02 b where b.id_ncr01 = P_IdNC);

BEGIN

    SELECT SYSDATE
      INTO V_FechaActual
      FROM dual;

    Begin
       SELECT nvl(trunc(par00valor),1)
         INTO V_NroComprobante
         FROM par00
        WHERE par00desc = 'SECUENCIAL DE NOTAS DE CREDITO'
        FOR UPDATE;

	    UPDATE par00
	       SET par00valor = to_number(V_NroComprobante) + 1
	     WHERE par00desc = 'SECUENCIAL DE NOTAS DE CREDITO';

       EXCEPTION
         WHEN NO_DATA_FOUND THEN
            O_Mensaje := 'Parametro <SECUENCIAL DE NOTAS DE CREDITO> para secuencia de comprobantes de Notas de Credito no existe';
            rollback;
            return(false);
         WHEN TOO_MANY_ROWS THEN
            O_Mensaje := 'Parametro <SECUENCIAL DE NOTAS DE CREDITO> para secuencia de comprobantes de Notas de Credito existe mas de una vez';
            rollback;
            return(false);
         WHEN OTHERS THEN
            O_Mensaje := 'Error no definido al buscar la secuencia de comprobantes de Notas de Credito';
            rollback;
            return(false);
    End;

    SELECT a.estado, a.tipo
      INTO V_Estado, V_Tipo
      FROM ncr01 a
     WHERE id = P_IdNC;

    if nvl(V_estado,'AP') <> 'DI' then
       O_Mensaje := 'Transaccion no valida .... Solo se pueden Aprobar transacciones en estado de DIGITADO';
       rollback;
       return(false);
    end if;

    SELECT COUNT(*)
      INTO V_NroReg
      FROM ncr02
     WHERE id_ncr01 = P_IdNC;

    if nvl(V_NroReg,0) = 0 then
       O_Mensaje := 'Transaccion no valida .... No se ha encontrado los pagos que sustentan la Nota de credito....';
       rollback;
       return(false);
    end if;

    for i in PAGOS_MALOS loop
        SELECT nvl(sum(nvl(valor_devuelto,0)),0)
          INTO V_Suma
          FROM ncr06
         WHERE id_ncr01  = P_IdNC
           AND emi01codi = i.emi01codi;

        if nvl(V_Suma,0) = 0 then
           O_Mensaje := 'Transaccion no valida .... sobre el pago <'||i.emi01codi||'> no se han registrado valores...';
           rollback;
           return(false);
        end if;
    end loop;



    IF V_Tipo = 'IN' then
       for i in PAGOS_MALOS loop
          select sq_emi01.nextval
            into V_CodEmi01
            from dual;

          INSERT INTO emi01(EMI01CODI,GEN01CODI,EMI01SERI,EMI01CLAVE,EMI01ANIO,
                            EMI01MES,EMI01DIA,EMI01FOBL,EMI01FEMI,EMI01NELI,
                            EMI01FELI,EMI01LELI,EMI01FEST,EMI01FPAG,EMI01LPAG,
                            EMI01NPAG,EMI01VTOT,EMI01INTE,EMI01DESC,EMI01RECA,
                            EMI01EXO,EMI01ESTA,EMI01TITU,EMI01FCRE,EMI01LCRE,
                            EMI01LMOD,EMI0FMOD,EMI01NCRE,EMI01NROTIT,EMI01PMER,
                            EMI01EVALO,EMI01COA,EMI01MERCA,EMI01IVA,EMI01DESCMERCA,
                            EMI01MSRI,EMI01ISRI,EMI01MOTBAJA,EMI01MOTLANC,EMI01PLANC,
                            EMI01RLANC,EMI01CRENTA,EMI01NROTRAS,EMI01NROCOA,PUR01TMP,
                            GEN01CODI_RECAUD)
          VALUES(V_CodEmi01, i.gen01codi, i.emi01seri, i.emi01clave,i.emi01anio,
                 i.emi01mes, i.emi01dia, i.emi01fobl, i.emi01femi,i.emi01neli,
                 i.emi01feli, i.emi01leli, i.emi01fest, NULL,NULL,
                 NULL, I.EMI01VTOT, 0, 0,0,
                 i.emi01exo, 'E', i.emi01titu || '. Nota Crédito #' || P_IdNC || '. Título #' || i.emi01codi, 
                 V_FechaActual, USER,
                 i.emi01lmod, i.emi0fmod, i.emi01ncre, i.emi01nrotit,i.emi01pmer,
                 0, 0, i.emi01merca, 0,0,
                 0, 0, i.emi01motbaja,i.emi01motlanc, i.emi01planc,
                 i.emi01rlanc, i.emi01crenta,i.emi01nrotras, i.emi01nrocoa, i.pur01tmp,
                 i.gen01codi_recaud);

          INSERT INTO emi02(EMI02CODI,EMI01CODI,EMI04CODI,EMI02VDET)
          SELECT sq_emi02.nextval, V_CodEmi01, emi04codi, emi02vdet
            FROM emi02
           WHERE emi01codi = i.emi01codi
             AND emi04codi not in (2500, 2501, 2502, 2503, 2504, 2505, 2506, 2507, 2508);

          INSERT INTO NCR04(id_ncr01, emi01codi_original, emi01codi,
                            GEN01CODI,EMI01SERI,EMI01CLAVE,EMI01ANIO,
                            EMI01MES,EMI01DIA,EMI01FOBL,EMI01FEMI,EMI01NELI,
                            EMI01FELI,EMI01LELI,EMI01FEST,EMI01FPAG,EMI01LPAG,
                            EMI01NPAG,EMI01VTOT,EMI01INTE,EMI01DESC,EMI01RECA,
                            EMI01EXO,EMI01ESTA,EMI01TITU,EMI01FCRE,EMI01LCRE,
                            EMI01LMOD,EMI0FMOD,EMI01NCRE,EMI01NROTIT,EMI01PMER,
                            EMI01EVALO,EMI01COA,EMI01MERCA,EMI01IVA,EMI01DESCMERCA,
                            EMI01MSRI,EMI01ISRI,EMI01MOTBAJA,EMI01MOTLANC,EMI01PLANC,
                            EMI01RLANC,EMI01CRENTA,EMI01NROTRAS,EMI01NROCOA,PUR01TMP,
                            GEN01CODI_RECAUD,
                            creacion,f_creacion,modificacion,fu_modificacion)
          VALUES(P_IdNC, i.emi01codi, V_CodEmi01,
                 i.gen01codi, i.emi01seri, i.emi01clave,i.emi01anio,
                 i.emi01mes, i.emi01dia, i.emi01fobl, i.emi01femi,i.emi01neli,
                 i.emi01feli, i.emi01leli, i.emi01fest, NULL,NULL,
                 NULL, I.EMI01VTOT, 0, 0,0,
                 i.emi01exo, 'E', i.emi01titu, V_FechaActual, USER,
                 i.emi01lmod, i.emi0fmod, i.emi01ncre, i.emi01nrotit,i.emi01pmer,
                 0, 0, i.emi01merca, 0,0,
                 0, 0, i.emi01motbaja,i.emi01motlanc, i.emi01planc,
                 i.emi01rlanc, i.emi01crenta,i.emi01nrotras, i.emi01nrocoa, i.pur01tmp,
                 i.gen01codi_recaud,
                 user, sysdate, user, sysdate);
       end loop;
   END IF;

   SELECT nvl(sum(nvl(valor_devuelto,0)),0)
     INTO V_ValorNotaCredito
     FROM ncr06
    WHERE id_ncr01 = P_IdNC;

    if nvl(V_ValorNotaCredito,0) = 0 then
       O_Mensaje := 'Transaccion no valida .... El valor de la nota de credito es igual a cero';
       rollback;
       return(false);
    end if;

    update NCR01
       set estado       = 'AP',
           comprobante  = V_NroComprobante,
           valor_total  = V_ValorNotaCredito,
           saldo_migrado = V_ValorNotaCredito,
           aprobado_por = user,
           f_aprobacion = sysdate,
           migrado      = 'NO'
     where id = P_IdNC;
     
    update emi01 set EMI01NCRE = P_IdNC 
    where emi01codi in (select emi01codi from ncr02 where ID_NCR01 = P_IdNC);
    
    SELECT EMI01CODI 
    INTO V_EMI01CODI 
    FROM NCR02
    WHERE ID_NCR01 = P_IdNC;
    
     ACTABONO(V_EMI01CODI);

    O_Mensaje := 'Transaccion terminada con exito';
    commit;
    return(true);

    EXCEPTION
       WHEN OTHERS THEN
         O_Mensaje := 'Transaccion no valida .... Error no definido...'||sqlerrm;
         rollback;
         return(false);
END;


FUNCTION Anular (P_IdNC        IN NUMBER,
                 O_Mensaje IN OUT VARCHAR2) RETURN BOOLEAN IS

V_Estado         VARCHAR2(2)  := NULL;
V_FechaActual    DATE         := NULL;
V_NroReg         NUMBER(8)    := NULL;
V_Suma           NUMBER(16,2)    := NULL;

BEGIN
    SELECT SYSDATE
      INTO V_FechaActual
      FROM dual;

    SELECT a.estado
      INTO V_Estado
      FROM ncr01 a
     WHERE id = P_IdNC;

    if nvl(V_estado,'AP') <> 'AP' then
       O_Mensaje := 'Transaccion no valida .... Solo se pueden Anular transacciones en estado de APROBADO';
       rollback;
       return(false);
    end if;

    SELECT count(*), nvl(sum(nvl(b.rc10monto,0)),0)
      INTO V_NroReg, V_Suma
      FROM rc11 a, rc10 b
     WHERE a.rc11codigo = b.rc11codigo
       AND b.ncr01id    = P_IdNC
       AND a.rc11estado = 'PA';

    if nvl(V_NroReg,0) <> 0 then
       O_Mensaje := 'Transaccion no valida .... Se ha encontrado pagos sobre la Nota de Credito por un valor de <'||ltrim(rtrim(to_char(V_Suma,'999G999G990D00')))||'>';
       rollback;
       return(false);
    end if;

    update NCR01
       set estado       = 'AN',
           anulada_por = user,
           f_anulada  = V_FechaActual
     where id = P_IdNC;

    O_Mensaje := 'Transaccion terminada con exito';
    commit;
    return(true);

    EXCEPTION
       WHEN OTHERS THEN
         O_Mensaje := 'Transaccion no valida .... Error no definido...'||sqlerrm;
         rollback;
         return(false);
END;



END;
/
