--PRIMER REPORTE

SELECT e.nombre, e.nacionalidad,
 er.numero_equipo, er.foto, er.categoria, 
   ((ev.ano).ano) as año,
  (pil1.identificacion).primer_nombre, (pil1.identificacion).segundo_nombre, (pil1.identificacion).primer_apellido, (pil1.identificacion).segundo_apellido, 
  pil1.nacionalidad,pil1.foto,
  (pil2.identificacion).primer_nombre, (pil2.identificacion).segundo_nombre, (pil2.identificacion).primer_apellido, (pil2.identificacion).segundo_apellido,
  pil2.nacionalidad, pil2.foto,
  (v.nombre) as vehiculo, (m.nombre) as motor,m.cilindraje,
  (er.numero_equipo) as puesto_ensayo,

    (SELECT en.vuelta_rapida
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = 1950 AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

   
    (SELECT en.velocidad_media
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = 1950 AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

  (ca.puesto) as puesto_carrera, ca.velocidad_media, ca.vuelta_rapida, ca.numero_vuelta, ca.distancia_km,
  (ROUND((LAG(ca.distancia_km, 1) OVER (ORDER BY ca.id) - ca.distancia_km ))) as diferencia
--ca.distancia_km, (LAG(ca.distancia_km, 1) OVER (ORDER BY ca.id)) as puesto_anterior ,
   
FROM E_R er
JOIN E_P ep on ep.id = er.fk_e_p_id
JOIN RANKING ca on ca.id = er.fk_ranking_id
JOIN EQUIPO e on e.id = ep.fk_equipo_id
JOIN PILOTO pil1 on pil1.id = ep.fk_piloto_id
JOIN PILOTO pil2 on pil2.id = ep.fk_piloto_id+1
JOIN V_M vm on vm.fk_vehiculo_id = e.fk_v_m_vehiculo_id
JOIN VEHICULO v on v.id = vm.fk_vehiculo_id
JOIN MOTOR m on m.id = vm.fk_motor_id
JOIN EVENTO ev on ev.id = ca.fk_evento_id

WHERE (ev.ano).ano = 1950 AND ev.tipo = 'Carrera' AND er.categoria = '3001-5000' ;
--WHERE (ev.ano).ano = 1950 AND ev.tipo = 'Carrera' AND er.categoria is not null ;

--SEGUNDO REPORTE


SELECT e.nombre, e.nacionalidad,
 er.numero_equipo, er.foto, er.categoria, --areglar identificacion solo nombre
   ((ev.ano).ano) as año,rh.hora,
  (pil1.identificacion).primer_nombre, (pil1.identificacion).segundo_nombre, (pil1.identificacion).primer_apellido, (pil1.identificacion).segundo_apellido, 
  pil1.nacionalidad,pil1.foto,
  (pil2.identificacion).primer_nombre, (pil2.identificacion).segundo_nombre, (pil2.identificacion).primer_apellido, (pil2.identificacion).segundo_apellido,
  pil2.nacionalidad, pil2.foto,
  (v.nombre) as vehiculo, (m.nombre) as motor,m.cilindraje,
  (er.numero_equipo) as puesto_ensayo,

    (SELECT en.vuelta_rapida
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = 1950 AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

   
    (SELECT en.velocidad_media
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = 1950 AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

  (ca.puesto) as puesto_carrera, ca.velocidad_media, ca.vuelta_rapida, ca.numero_vuelta, ca.distancia_km,
  (ROUND((LAG(ca.distancia_km, 1) OVER (ORDER BY ca.id) - ca.distancia_km ))) as diferencia
--ca.distancia_km, (LAG(ca.distancia_km, 1) OVER (ORDER BY ca.id)) as puesto_anterior ,
   
FROM E_R er
JOIN E_P ep on ep.id = er.fk_e_p_id
JOIN RANKING ca on ca.id = er.fk_ranking_id
JOIN EQUIPO e on e.id = ep.fk_equipo_id
JOIN PILOTO pil1 on pil1.id = ep.fk_piloto_id
JOIN PILOTO pil2 on pil2.id = ep.fk_piloto_id+1
JOIN V_M vm on vm.fk_vehiculo_id = e.fk_v_m_vehiculo_id
JOIN VEHICULO v on v.id = vm.fk_vehiculo_id
JOIN MOTOR m on m.id = vm.fk_motor_id
JOIN EVENTO ev on ev.id = ca.fk_evento_id
JOIN RANKING_HORA rh on rh.fk_e_r_ranking_id = er.fk_ranking_id

WHERE (ev.ano).ano = 1950 AND ev.tipo = 'Carrera' AND er.categoria is not null 
ORDER BY rh.puesto ;

--TERCER REPORTE

SELECT e.nombre, e.nacionalidad,
 er.numero_equipo, er.foto, er.categoria, 
   ((ev.ano).ano) as año,
  (pil1.identificacion).primer_nombre, (pil1.identificacion).segundo_nombre, (pil1.identificacion).primer_apellido, (pil1.identificacion).segundo_apellido, 
  pil1.nacionalidad,pil1.foto,
  (pil2.identificacion).primer_nombre, (pil2.identificacion).segundo_nombre, (pil2.identificacion).primer_apellido, (pil2.identificacion).segundo_apellido,
  pil2.nacionalidad, pil2.foto,
  (v.nombre) as vehiculo, (m.nombre) as motor,m.cilindraje,
  (er.numero_equipo) as puesto_ensayo,

    (SELECT en.vuelta_rapida
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = 1950 AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

   
    (SELECT en.velocidad_media
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = 1950 AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

  (ca.puesto) as puesto_carrera, ca.velocidad_media, ca.vuelta_rapida, ca.numero_vuelta, ca.distancia_km,
  (ROUND((LAG(ca.distancia_km, 1) OVER (ORDER BY ca.id) - ca.distancia_km ))) as diferencia
--ca.distancia_km, (LAG(ca.distancia_km, 1) OVER (ORDER BY ca.id)) as puesto_anterior ,
   
FROM E_R er
JOIN E_P ep on ep.id = er.fk_e_p_id
JOIN RANKING ca on ca.id = er.fk_ranking_id
JOIN EQUIPO e on e.id = ep.fk_equipo_id
JOIN PILOTO pil1 on pil1.id = ep.fk_piloto_id
JOIN PILOTO pil2 on pil2.id = ep.fk_piloto_id+1
JOIN V_M vm on vm.fk_vehiculo_id = e.fk_v_m_vehiculo_id
JOIN VEHICULO v on v.id = vm.fk_vehiculo_id
JOIN MOTOR m on m.id = vm.fk_motor_id
JOIN EVENTO ev on ev.id = ca.fk_evento_id

WHERE (ev.ano).ano = 1950 AND ev.tipo = 'Carrera' AND ca.puesto<4;