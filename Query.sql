--PRIMER REPORTE

CREATE OR REPLACE FUNCTION ranking_por_ano (anno INT, category varchar, orden varchar)
RETURNS TABLE 
(
    nombre_equipo EQUIPO.nombre%TYPE, nacionalidad_equipo EQUIPO.nacionalidad%TYPE,
    n_equipo E_R.numero_equipo%TYPE,foto_equipo E_R.foto%TYPE, categoria E_R.categoria%TYPE,
    año BIGINT,
    primer_nombre1 VARCHAR,segundo_nombre1 VARCHAR,primer_apellido1 VARCHAR,segundo_apellido1 VARCHAR,
    nacionalidad1 PILOTO.nacionalidad%TYPE,foto_piloto1 PILOTO.foto%TYPE,
    primer_nombre2 VARCHAR,segundo_nombre2 VARCHAR,primer_apellido2 VARCHAR,segundo_apellido2 VARCHAR,
    nacionalidad2 PILOTO.nacionalidad%TYPE,foto_piloto2 PILOTO.foto%TYPE,
    vehiculo VEHICULO.nombre%TYPE,motor MOTOR.nombre%TYPE, cilindraje MOTOR.cilindraje%TYPE,
    puesto_equipo_ensayo E_R.numero_equipo%TYPE,
    vuelta_rapida_ensayo RANKING.vuelta_rapida%TYPE,velocidad_media_ensayo RANKING.velocidad_media%TYPE,
    puesto_carrera RANKING.puesto%TYPE,
    velocidad_media RANKING.velocidad_media%TYPE,vuelta_rapida RANKING.vuelta_rapida%TYPE,
    n_vuelta RANKING.numero_vuelta%TYPE,distancia_en_KM RANKING.distancia_km%TYPE,
    diferencia_de_km RANKING.distancia_km%TYPE

) AS $$
BEGIN
    IF(category='')THEN
        RETURN QUERY
    --equipo
SELECT e.nombre, e.nacionalidad,
 er.numero_equipo, er.foto, er.categoria, 
    --pilotos
   ((ev.ano).ano) as año,
  (pil1.identificacion).primer_nombre, (pil1.identificacion).segundo_nombre, (pil1.identificacion).primer_apellido, (pil1.identificacion).segundo_apellido, 
  pil1.nacionalidad,pil1.foto,
  (pil2.identificacion).primer_nombre, (pil2.identificacion).segundo_nombre, (pil2.identificacion).primer_apellido, (pil2.identificacion).segundo_apellido,
  pil2.nacionalidad, pil2.foto,  
   --vehiculo
  (v.nombre) as vehiculo, (m.nombre) as motor,m.cilindraje,
   --ensayo
  (er.numero_equipo) as puesto_ensayo,

    (SELECT en.vuelta_rapida
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

   
    (SELECT en.velocidad_media
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_media_ensayo,
  --carrera
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

WHERE (ev.ano).ano = anno AND
ev.tipo = 'Carrera' AND
er.categoria is not NULL

ORDER BY

CASE
    WHEN orden = 'Ensayo' THEN
    er.numero_equipo
ELSE
    ca.puesto
END;

    ELSE

RETURN QUERY
    --equipo
SELECT e.nombre, e.nacionalidad,
 er.numero_equipo, er.foto, er.categoria, 
    --pilotos
   ((ev.ano).ano) as año,
  (pil1.identificacion).primer_nombre, (pil1.identificacion).segundo_nombre, (pil1.identificacion).primer_apellido, (pil1.identificacion).segundo_apellido, 
  pil1.nacionalidad,pil1.foto,
  (pil2.identificacion).primer_nombre, (pil2.identificacion).segundo_nombre, (pil2.identificacion).primer_apellido, (pil2.identificacion).segundo_apellido,
  pil2.nacionalidad, pil2.foto,  
   --vehiculo
  (v.nombre) as vehiculo, (m.nombre) as motor,m.cilindraje,
   --ensayo
  (er.numero_equipo) as puesto_ensayo,

    (SELECT en.vuelta_rapida
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

   
    (SELECT en.velocidad_media
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_media_ensayo,
  --carrera
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

WHERE (ev.ano).ano = anno AND
ev.tipo = 'Carrera' AND
er.categoria = category

ORDER BY

CASE
    WHEN orden = 'Ensayo' THEN
    er.numero_equipo
ELSE
    ca.puesto
END;


END IF;

END; $$ LANGUAGE PLPGSQL;





--SEGUNDO REPORTE

CREATE OR REPLACE FUNCTION ranking_por_hora (anno INT, category varchar,heur int)
RETURNS TABLE 
(
    nombre_equipo EQUIPO.nombre%TYPE, nacionalidad_equipo EQUIPO.nacionalidad%TYPE,
    n_equipo E_R.numero_equipo%TYPE,foto_equipo E_R.foto%TYPE, categoria E_R.categoria%TYPE,
    año BIGINT, horas RANKING_HORA.hora%TYPE,
    primer_nombre1 VARCHAR,segundo_nombre1 VARCHAR,primer_apellido1 VARCHAR,segundo_apellido1 VARCHAR,
    nacionalidad1 PILOTO.nacionalidad%TYPE,foto_piloto1 PILOTO.foto%TYPE,
    primer_nombre2 VARCHAR,segundo_nombre2 VARCHAR,primer_apellido2 VARCHAR,segundo_apellido2 VARCHAR,
    nacionalidad2 PILOTO.nacionalidad%TYPE,foto_piloto2 PILOTO.foto%TYPE,
    vehiculo VEHICULO.nombre%TYPE,motor MOTOR.nombre%TYPE, cilindraje MOTOR.cilindraje%TYPE,
    puesto_equipo_ensayo E_R.numero_equipo%TYPE,
    vuelta_rapida_ensayo RANKING.vuelta_rapida%TYPE,velocidad_media_ensayo RANKING.velocidad_media%TYPE,
    puesto_carrera RANKING.puesto%TYPE,
    velocidad_media RANKING.velocidad_media%TYPE,vuelta_rapida RANKING.vuelta_rapida%TYPE,
    n_vuelta RANKING.numero_vuelta%TYPE,distancia_en_KM RANKING.distancia_km%TYPE,
    diferencia_de_km RANKING.distancia_km%TYPE

) AS $$
BEGIN
    IF(category='')THEN
        RETURN QUERY

SELECT e.nombre, e.nacionalidad,
 er.numero_equipo, er.foto, er.categoria, 
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
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

   
    (SELECT en.velocidad_media
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

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

WHERE (ev.ano).ano = anno AND
ev.tipo = 'Carrera' AND
er.categoria is not NULL AND
rh.hora = heur

ORDER BY rh.puesto;

ELSE

RETURN QUERY
SELECT e.nombre, e.nacionalidad,
 er.numero_equipo, er.foto, er.categoria, 
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
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

   
    (SELECT en.velocidad_media
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

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

WHERE (ev.ano).ano = anno AND
ev.tipo = 'Carrera' AND
er.categoria = category AND
rh.hora = heur

ORDER BY rh.puesto;

END IF;

END; $$ LANGUAGE PLPGSQL;




--TERCER REPORTE

CREATE OR REPLACE FUNCTION ganadores (anno INT, category varchar)
RETURNS TABLE 
(
    nombre_equipo EQUIPO.nombre%TYPE, nacionalidad_equipo EQUIPO.nacionalidad%TYPE,
    n_equipo E_R.numero_equipo%TYPE,foto_equipo E_R.foto%TYPE, categoria E_R.categoria%TYPE,
    año BIGINT,
    primer_nombre1 VARCHAR,segundo_nombre1 VARCHAR,primer_apellido1 VARCHAR,segundo_apellido1 VARCHAR,
    nacionalidad1 PILOTO.nacionalidad%TYPE,foto_piloto1 PILOTO.foto%TYPE,
    primer_nombre2 VARCHAR,segundo_nombre2 VARCHAR,primer_apellido2 VARCHAR,segundo_apellido2 VARCHAR,
    nacionalidad2 PILOTO.nacionalidad%TYPE,foto_piloto2 PILOTO.foto%TYPE,
    vehiculo VEHICULO.nombre%TYPE,motor MOTOR.nombre%TYPE, cilindraje MOTOR.cilindraje%TYPE,
    puesto_equipo_ensayo E_R.numero_equipo%TYPE,
    vuelta_rapida_ensayo RANKING.vuelta_rapida%TYPE,velocidad_media_ensayo RANKING.velocidad_media%TYPE,
    puesto_carrera RANKING.puesto%TYPE,
    velocidad_media RANKING.velocidad_media%TYPE,vuelta_rapida RANKING.vuelta_rapida%TYPE,
    n_vuelta RANKING.numero_vuelta%TYPE,distancia_en_KM RANKING.distancia_km%TYPE,
    diferencia_de_km RANKING.distancia_km%TYPE

) AS $$

BEGIN --1
    IF(category='') AND (anno='')THEN
        RETURN QUERY

SELECT 
  Distinct on ((ev.ano).ano) (ev.ano).ano,
  e.nombre, e.nacionalidad,
  er.numero_equipo, er.foto, er.categoria, 
 
  --row_number() over (partition by ((ev.ano).ano) order by ca.puesto asc) as ,
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
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

   
    (SELECT en.velocidad_media
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

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

WHERE (ev.ano).ano = is not null AND ev.tipo = 'Carrera' AND er.categoria = is not null
ORDER BY  (ev.ano).ano;
--2
ELSE IF(category='') AND (anno is not null)THEN
        RETURN QUERY

SELECT 
  Distinct on ((ev.ano).ano) (ev.ano).ano,
  e.nombre, e.nacionalidad,
  er.numero_equipo, er.foto, er.categoria, 
 
  --row_number() over (partition by ((ev.ano).ano) order by ca.puesto asc) as ,
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
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

   
    (SELECT en.velocidad_media
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

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

WHERE (ev.ano).ano = anno AND ev.tipo = 'Carrera' AND er.categoria is not null
ORDER BY  (ev.ano).ano;
--3
ELSE IF(category=is not null) AND (anno='')THEN
        RETURN QUERY

SELECT 
  Distinct on ((ev.ano).ano) (ev.ano).ano,
  e.nombre, e.nacionalidad,
  er.numero_equipo, er.foto, er.categoria, 
 
  --row_number() over (partition by ((ev.ano).ano) order by ca.puesto asc) as ,
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
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

   
    (SELECT en.velocidad_media
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

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

WHERE (ev.ano).ano = is not NULL AND ev.tipo = 'Carrera' AND er.categoria = category
ORDER BY  (ev.ano).ano;

ELSE --4
        RETURN QUERY

SELECT 
  Distinct on ((ev.ano).ano) (ev.ano).ano,
  e.nombre, e.nacionalidad,
  er.numero_equipo, er.foto, er.categoria, 
 
  --row_number() over (partition by ((ev.ano).ano) order by ca.puesto asc) as ,
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
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

    ) as vuelta_rapido_ensayo,

   
    (SELECT en.velocidad_media
    FROM RANKING en
    JOIN E_R er2 on er2.fk_ranking_id = en.id
    JOIN EVENTO ev2 on ev2.id = en.fk_evento_id
    JOIN E_P ep2 on ep2.id = er2.fk_e_p_id
    WHERE (ev2.ano).ano = anno AND ev2.tipo = 'Ensayo' AND e.id = ep2.fk_equipo_id

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

WHERE (ev.ano).ano = anno AND ev.tipo = 'Carrera' AND er.categoria = category
ORDER BY  (ev.ano).ano;

END IF;

END; $$ LANGUAGE PLPGSQL;










SELECT 
  Distinct on ((ev.ano).ano) (ev.ano).ano,
  e.nombre, e.nacionalidad,
  er.numero_equipo, er.foto, er.categoria, 
 
  --row_number() over (partition by ((ev.ano).ano) order by ca.puesto asc) as ,
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

WHERE (ev.ano).ano = 1950 AND ev.tipo = 'Carrera' AND er.categoria = '5001-8000' --= category
ORDER BY  (ev.ano).ano;