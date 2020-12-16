SELECT e.nombre, e.nacionalidad,
 er.numero_equipo, er.foto, er.categoria,
  pil1.identificacion, pil2.identificacion, pil1.nacionalidad, pil2.nacionalidad, pil1.foto, pil2.foto,
  (er.numero_equipo) as puesto_ensayo, en.velocidad_media, en.vuelta_rapida,
  ca.puesto, ca.velocidad_media, ca.vuelta_rapida, ca.numero_vuelta, ca.distancia_km

FROM E_R er
JOIN RANKING ca on ca.id = er.fk_ranking_id
JOIN RANKING en on en.id = er.fk_ranking_id
JOIN E_P ep on ep.id = er.fk_e_p_id
JOIN EQUIPO e on e.id = ep.fk_equipo_id
JOIN PILOTO pil1 on pil1.id = ep.fk_piloto_id
JOIN PILOTO pil2 on pil2.id = ep.fk_piloto_id+1

WHERE ca.fk_evento_id = 1





  