exec p_ejecuta_dinardap('0801188905','CEDULA');

select nvl(extractvalue(xmltype(replace(xmlchar,':','')),'/soapEnvelope/soapBody/ns2consultarResponse/paquete/entidades/entidad/filas/fila/columnas/columna[1]/valor' ),'0') ACTA_DEFUNCION,
       nvl(extractvalue(xmltype(replace(xmlchar,':','')),'/soapEnvelope/soapBody/ns2consultarResponse/paquete/entidades/entidad/filas/fila/columnas/columna[2]/valor' ),'0') CEDULA,
       nvl(extractvalue(xmltype(replace(xmlchar,':','')),'/soapEnvelope/soapBody/ns2consultarResponse/paquete/entidades/entidad/filas/fila/columnas/columna[3]/valor' ),'0') ESTADO_CIVIL,
       nvl(extractvalue(xmltype(replace(xmlchar,':','')),'/soapEnvelope/soapBody/ns2consultarResponse/paquete/entidades/entidad/filas/fila/columnas/columna[4]/valor' ),'0') FECHA_DEFUNCION,
       nvl(extractvalue(xmltype(replace(xmlchar,':','')),'/soapEnvelope/soapBody/ns2consultarResponse/paquete/entidades/entidad/filas/fila/columnas/columna[5]/valor' ),'0') FECHA_EXP,
       nvl(extractvalue(xmltype(replace(xmlchar,':','')),'/soapEnvelope/soapBody/ns2consultarResponse/paquete/entidades/entidad/filas/fila/columnas/columna[6]/valor' ),'0') FECHA_NAC,
       nvl(extractvalue(xmltype(replace(xmlchar,':','')),'/soapEnvelope/soapBody/ns2consultarResponse/paquete/entidades/entidad/filas/fila/columnas/columna[7]/valor' ),'0') NOMBRES
from dintest
where idxml = 3