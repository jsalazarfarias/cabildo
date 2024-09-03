CREATE OR REPLACE procedure SISESMER.p_nomca02distrib(dias_h in number, dias_nh in number, v_nom01codi in number, v_nomca01codi in number, v_idpermiso in number, nh in number, nm in number) is
    
    cursor c1 is 
    select disponibilidad nomprv01disp,
           codigo_funcionario nom01codi,
           dias_habiles_disponibles nomprv01nd,
           dias_nhabiles_disponibles nomprv01ndfs,
           codigo_periodo nomprv01codi,
           nomprv01fperini, nomprv01fperfin,
           disponibilidad_horas,
           disponibilidad_minutos
           from v_nomprv01_disp
    where codigo_funcionario = v_nom01codi
    and nomprv01esta = 'E'
    order by codigo_periodo asc;

    dias_h_restantes number(8,2);
    dias_nh_restantes number(8,2);
    mensaje varchar2(500);
    periodo number;
    nh_restantes number;
    nm_restantes number;
    minutostmp number := 480;
    
begin
    
    dias_h_restantes := dias_h;
    dias_nh_restantes := dias_nh;
    nh_restantes := nh;
    nm_restantes := nm;

    for i in c1 loop
     if nvl(dias_h_restantes,0) + nvl(dias_nh_restantes,0) + nvl(nh_restantes,0) + nvl(nm_restantes,0) > 0 then
      
      if dias_h_restantes >= (nvl(i.nomprv01disp,0) - nvl(i.nomprv01ndfs,0)) and dias_nh_restantes >= i.nomprv01ndfs then --AQUI
               
        if dias_h_restantes > (nvl(i.nomprv01disp,0) - nvl(i.nomprv01ndfs,0)) and (i.disponibilidad_horas*60+i.disponibilidad_minutos) > 0 then --AQUI
        
           periodo := to_number(to_char(i.nomprv01fperfin,'rrrr'));
            
           dias_h_restantes := nvl(dias_h_restantes,0) - 1;
           
           dias_h_restantes := dias_h_restantes - (nvl(i.nomprv01disp,0) - nvl(i.nomprv01ndfs,0)); 
           dias_nh_restantes := dias_nh_restantes - i.nomprv01ndfs;
           minutostmp := (nvl(minutostmp,0) - 60 * i.disponibilidad_horas) - i.disponibilidad_minutos;
           nh_restantes := trunc(minutostmp/60);
           nm_restantes := mod(minutostmp,60); 
            
           insert into nomca02(nomca02codi, nomca01codi, nomca02per, nomca02nd, nomca02nh, nomca02nm, 
                                nomca02esta, nomca02lcre, nomca02fcre, nomca02ndfs, nomprv01codi, id_solicitud)
                         values(sq_nomca02.nextval, v_nomca01codi, periodo,
                                i.nomprv01disp,i.disponibilidad_horas,i.disponibilidad_minutos, 'AP', 'INTRANET', sysdate, i.nomprv01ndfs, i.nomprv01codi, v_idpermiso);
          
           update nomprv01 set nomprv01esta = 'C'
           where nomprv01codi = i.nomprv01codi;   
        
        elsif dias_h_restantes <= (nvl(i.nomprv01disp,0) - nvl(i.nomprv01ndfs,0)) and (i.disponibilidad_horas*60+i.disponibilidad_minutos) > 0 then
          
            if dias_h_restantes > 0 and (i.disponibilidad_horas*60+i.disponibilidad_minutos) > 0 then
                periodo := to_number(to_char(i.nomprv01fperfin,'rrrr'));
                
                insert into nomca02(nomca02codi, nomca01codi, nomca02per, nomca02nd, nomca02nh, nomca02nm, 
                                    nomca02esta, nomca02lcre, nomca02fcre, nomca02ndfs, nomprv01codi, id_solicitud)
                             values(sq_nomca02.nextval, v_nomca01codi, periodo,
                                    dias_h_restantes ,nvl(nh,0),nvl(nm,0), 'AP', 'INTRANET', sysdate, dias_nh_restantes, i.nomprv01codi, v_idpermiso);
                
                dias_nh_restantes := 0;
                dias_h_restantes := 0;
                nh_restantes := 0;
                nm_restantes := 0;
                
            elsif (nvl(i.nomprv01disp,0) - nvl(i.nomprv01ndfs,0)) = 0 and dias_nh_restantes >= nvl(i.nomprv01ndfs,0) and (i.disponibilidad_horas*60+i.disponibilidad_minutos) > 0 then
                periodo := to_number(to_char(i.nomprv01fperfin,'rrrr'));
                
                insert into nomca02(nomca02codi, nomca01codi, nomca02per, nomca02nd, nomca02nh, nomca02nm, 
                                    nomca02esta, nomca02lcre, nomca02fcre, nomca02ndfs, nomprv01codi, id_solicitud)
                             values(sq_nomca02.nextval, v_nomca01codi, periodo,
                                    dias_h_restantes ,nvl(nh,0),nvl(nm,0), 'AP', 'INTRANET', sysdate, dias_nh_restantes, i.nomprv01codi, v_idpermiso);
                
                dias_nh_restantes := 0;
                dias_h_restantes := 0;
                nh_restantes := 0;
                nm_restantes := 0;
                
                update nomprv01 set nomprv01esta = 'C'
                where nomprv01codi = i.nomprv01codi;
                
            end if;
            
        else
        
            update nomprv01 set nomprv01esta = 'C'
            where nomprv01codi = i.nomprv01codi;
        
        
            periodo := to_number(to_char(i.nomprv01fperfin,'rrrr'));
            
            dias_h_restantes := dias_h_restantes - (nvl(i.nomprv01disp,0) - nvl(i.nomprv01ndfs,0)); 
            dias_nh_restantes := dias_nh_restantes - i.nomprv01ndfs;
        
            insert into nomca02(nomca02codi, nomca01codi, nomca02per, nomca02nd, nomca02nh, nomca02nm, 
                                nomca02esta, nomca02lcre, nomca02fcre, nomca02ndfs, nomprv01codi, id_solicitud)
                         values(sq_nomca02.nextval, v_nomca01codi, periodo,
                                (nvl(i.nomprv01disp,0) - nvl(i.nomprv01ndfs,0)) ,nvl(nh,0),nvl(nm,0), 'AP', 'INTRANET', sysdate, nvl(i.nomprv01ndfs,0), i.nomprv01codi, v_idpermiso);
            
                            
        end if;
      
      elsif dias_h_restantes >= (nvl(i.nomprv01disp,0) - nvl(i.nomprv01ndfs,0)) and dias_nh_restantes <= i.nomprv01ndfs then
               
        periodo := to_number(to_char(i.nomprv01fperfin,'rrrr'));
        
        dias_h_restantes := dias_h_restantes - (nvl(i.nomprv01disp,0) - nvl(i.nomprv01ndfs,0)); 
        
        insert into nomca02(nomca02codi, nomca01codi, nomca02per, nomca02nd, nomca02nh, nomca02nm, 
                            nomca02esta, nomca02lcre, nomca02fcre, nomca02ndfs, nomprv01codi, id_solicitud)
                     values(sq_nomca02.nextval, v_nomca01codi, periodo,
                            (nvl(i.nomprv01disp,0) - nvl(i.nomprv01ndfs,0)),nvl(nh_restantes,0),nvl(nm_restantes,0), 'AP', 'INTRANET', sysdate, dias_nh_restantes, i.nomprv01codi, v_idpermiso);
                            
        dias_nh_restantes := 0;
        nh_restantes := 0;
        nm_restantes := 0;
      
      elsif dias_h_restantes < (nvl(i.nomprv01disp,0) - nvl(i.nomprv01ndfs,0)) then
        
        periodo := to_number(to_char(i.nomprv01fperfin,'rrrr'));  
      
        insert into nomca02(nomca02codi, 
                            nomca01codi, 
                            nomca02per, 
                            nomca02nd, 
                            nomca02nh, 
                            nomca02nm, 
                            nomca02esta, 
                            nomca02lcre, 
                            nomca02fcre, 
                            nomca02ndfs, 
                            nomprv01codi, 
                            id_solicitud)
                     values(sq_nomca02.nextval, 
                            v_nomca01codi, 
                            periodo,
                            dias_h_restantes,
                            nvl(nh_restantes,0),
                            nvl(nm_restantes,0), 
                            'AP', 
                            'INTRANET', 
                            sysdate, 
                            dias_nh_restantes, 
                            i.nomprv01codi, 
                            v_idpermiso);
                            
        dias_h_restantes := 0;
        dias_nh_restantes := 0;
        nh_restantes := 0;
        nm_restantes := 0;
      
      elsif dias_h_restantes = 0 and (nh_restantes > 0 or nm_restantes > 0) then
        
       if (nvl(i.nomprv01disp,0) - nvl(i.nomprv01ndfs,0)) <= 0 then
          if nvl(nh_restantes,0)*60 + nvl(nm_restantes,0) >= nvl(i.disponibilidad_horas,0)*60 + nvl(i.disponibilidad_minutos,0) then
            update nomprv01 set nomprv01esta = 'C'
            where nomprv01codi = i.nomprv01codi;
          end if;
       end if;
                
       periodo := to_number(to_char(i.nomprv01fperfin,'rrrr'));
             
       if nvl(dias_nh_restantes,0)*8*60 + nvl(nh_restantes,0)*60 + nvl(nm_restantes,0) >= ((nvl(i.nomprv01disp,0)*8)*60) + nvl(i.disponibilidad_horas,0)*60 + nvl(i.disponibilidad_minutos,0) then
          insert into nomca02(nomca02codi, nomca01codi, nomca02per, nomca02nd, nomca02nh, nomca02nm, 
                                nomca02esta, nomca02lcre, nomca02fcre, nomca02ndfs, nomprv01codi, id_solicitud)
                         values(sq_nomca02.nextval, v_nomca01codi, periodo,
                                nvl(dias_h,0),nvl(i.disponibilidad_horas,0),nvl(i.disponibilidad_minutos,0), 'AP', 'INTRANET', sysdate, nvl(dias_nh,0), i.nomprv01codi, v_idpermiso);
          
          nh_restantes := nh_restantes - i.disponibilidad_horas;
          nm_restantes := nm_restantes - i.disponibilidad_minutos;
          
          update nomprv01 set nomprv01esta = 'C'
          where nomprv01codi = i.nomprv01codi;
          
       elsif ((nvl(i.nomprv01disp,0)*8)*60) + nvl(i.disponibilidad_horas,0)*60 + nvl(i.disponibilidad_minutos,0) > nvl(dias_nh_restantes,0)*8*60 + nvl(nh_restantes,0)*60 + nvl(nm_restantes,0) then
                
          insert into nomca02(nomca02codi, nomca01codi, nomca02per, nomca02nd, nomca02nh, nomca02nm, 
                                nomca02esta, nomca02lcre, nomca02fcre, nomca02ndfs, nomprv01codi, id_solicitud)
                         values(sq_nomca02.nextval, v_nomca01codi, periodo,
                                nvl(dias_h,0),nvl(nh_restantes,0),nvl(nm_restantes,0), 'AP', 'INTRANET', sysdate, nvl(dias_nh,0), i.nomprv01codi, v_idpermiso); 
                                
          nh_restantes := 0;
          nm_restantes := 0;
          
       end if;
               
       if nh_restantes <= 0 then              
            nh_restantes := 0;
       end if;
       
       if nm_restantes <= 0 then              
            nm_restantes := 0;
       end if;
                   
      end if;      
     end if; 
       
    end loop;
      
    commit;
      
exception when others then
    mensaje := SQLERRM;
end;
/
