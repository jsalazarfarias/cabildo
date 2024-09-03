CREATE OR REPLACE procedure SISESMER.llena_cartera_banco(codigo in number) is
  
    v_secuencia number;
    mensaje varchar2(250);
    
begin
    
    begin
        insert into bco02car(bco02carcodi, 
                             bco02codi, 
                             emi01codi, 
                             --emi01femi, 
                             emi01seri,
                             gen01codi, 
                             --gen01ruc, 
                             --gen01tiden, 
                             emi01anio, 
                             emi01vtot, 
                             emi01inte,
                             emi01reca, 
                             emi01desc, 
                             emi01coa, 
                             --emi01frep, 
                             emi01vpagot,
                             emi01esta)--, 
                             --gen01com, 
                             --impuesto)
                      select sq_bco02car.nextval, 
                             codigo, 
                             i.numero_emision, 
                             --i.fecha_emision, 
                             i.emi01seri,
                             i.ciu, 
                             --i.identificacion, 
                             --i.tipo_identificacion, 
                             i.anio_titulo,
                             nvl(i.valor_emision,0), 
                             nvl(i.interes,0), 
                             nvl(i.recargo,0), 
                             nvl(i.descuento,0), 
                             nvl(i.coactiva,0),
                             --i.fecha_actual, 
                             nvl(i.total,0), 
                             i.estado_titulo--, 
                             --pk_uti.gen01_com(i.ciu),
                             --pk_uti.find_impuesto(i.emi01seri)
                      from v_cartera_banco_pichincha i;
                      --where i.ciu = 28204;
            
        commit;
    exception when others then
        rollback;
        mensaje := sqlerrm;
    end;
    
exception when others then
    mensaje := sqlerrm;
end;
/
