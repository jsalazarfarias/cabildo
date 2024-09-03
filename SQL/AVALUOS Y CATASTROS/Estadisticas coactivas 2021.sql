select 2021 anio, count(id_plan) planes_nuevos,
       (select count(id_plan)
        from cc_planes
        where to_char(fu_modificacion,'rrrr') = '2021') planes_modificados,
       (select count(id_plan) 
        from cc_planes
        where to_char(f_creacion,'rrrr') = '2021'
        and estado = 'C') planes_coactivados,
       (select count(distinct(id_plan)) 
        from cc_mae_tit_br
        where to_char(decoafecha,'rrrr') = '2021') planes_descoactivados,
       (select count(emi01codi) 
        from cc_mae_tit_br
        where to_char(decoafecha,'rrrr') = '2021') titulos_descoactivados,
       (select count(conv01codi) 
        from cc_conv01
        where to_char(conv01fcre,'rrrr') = '2021') convenios_ingresados,
       (select count(conv01codi) 
        from cc_conv01
        where to_char(conv01fap,'rrrr') = '2021') convenios_aprobados
from cc_planes
where to_char(f_creacion,'rrrr') = '2021'
group by to_char(f_creacion,'rrrr')














, 
