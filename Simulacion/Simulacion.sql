---Función que inicia la carrera
---1) Empieza la iteración de la competencia, interactuan cada uno de los competidores de la carrera (dependiendo del año), para ello se inserta un numero del 1 al 10 (1950 a 1959)
---2) El año se decide con numero del 1 al 10. 1= 1950, 2=1951, 3=1952, 4=1953, etc.


---=======================Funcion principal, inicia la carrera con un año dado=================================
CREATE OR REPLACE FUNCTION start_race(IN carrera_anno int) 
returns bigint as 
$func$
DECLARE
  competidores CURSOR FOR SELECT * FROM E_R tabla ORDER BY tabla.fk_e_p_id; 

  --variables por equipo
  new_categoria VARCHAR;
  new_equipo_num BIGINT;
  new_marca_cauchos VARCHAR;
  nuevo_ranking BIGINT;
  new_foto bytea;
  evento_id BIGINT;
  E_P_id BIGINT;
  nuevo_E_R BIGINT;

  verificar_evento boolean;
  ---Dato del nuevo evento de revalida
  nuevo_evento BIGINT;
  nuevo_clima BIGINT;
    
    i int;
BEGIN
  verificar_evento:=false;
  nuevo_evento:=(SELECT "crear_evento"(carrera_anno));
  return nuevo_evento;
  nuevo_clima:=(SELECT "generar_clima_sucesso"(nuevo_evento));
 
 --Inicia y prepara los datos de los competidores para la siguiente competencia
  FOR E_R IN competidores LOOP
    --si el numero ingresado del año es iugal a el numero del evento de ese año.
    IF carrera_anno=E_R.fk_ranking_evento_id  then

      --guardado de los datos del equipo a competir (de la tabla E_R)

      new_categoria:= E_R.categoria;
      new_equipo_num:= E_R.numero_equipo;
      new_marca_cauchos:= E_R.marca_cauchos;
      --ranking:= E_R.fk_ranking_id;
      new_foto:=E_R.foto;
      --evento_id:=E_R.fk_ranking_evento_id;
      E_P_id:=E_R.fk_e_p_id;
       
      nuevo_ranking:= (SELECT "crear_ranking"(nuevo_evento));
      nuevo_E_R    := (SELECT "crear_e_r"(new_categoria,new_equipo_num,new_marca_cauchos,nuevo_ranking,new_foto,nuevo_evento,E_P_id));
    END IF;
  END LOOP;
 
  --Inicia el proceso de la simulacion
  
  i:=(SELECT "start_simulation"(nuevo_evento,nuevo_clima));
  return i;
END;
$func$LANGUAGE plpgsql;

---===========FUncion que inicia la simulacion vuelta por vuelta=====================

---crear estimulado coeficiente manejo dificultad de la pista y clima
CREATE OR REPLACE FUNCTION start_simulation(id_evento BIGINT,id_clima BIGINT)
returns bigint as $body$
DECLARE
 competidores CURSOR FOR SELECT * FROM E_R tabla ORDER BY tabla.fk_e_p_id; 
 rankings     CURSOR FOR SELECT * FROM ranking e ORDER BY e.id;
 climas       CURSOR FOR SELECT * FROM SUCESO c ORDER BY c.id;
---datos por vuelta
 clima_actual INT[4];
 vuelta_numero BIGINT;
---======
 --datos del competidor
 km_esta_vuelta float;
 distancia_total float;
 este_id BIGINT;
 tiempo_total BIGINT;

 tiempo_esta_vuelta float;
 velocidad_esta_vuelta float;
 velocidad_media_esta_vuelta float;
BEGIN
 vuelta_numero:=0;
 --obtencion de datos de clima
 FOR SUCESO IN climas LOOP
    if SUCESO.id=id_clima then
      clima_actual:=SUCESO.clima_momento;
    end if;
 END LOOP;
 --Final de la obtencion de datos de clima

 --la longitud de la pista es 13.0 a 13.2
 --velocidad media dependera del tiempo
 --tiempo tiene formula

 vuelta_numero:=vuelta_numero+1;

  FOR E_R IN competidores LOOP                   --Este loop inicia los datos de todos los competidores en ER
    if E_R.fk_ranking_evento_id = id_evento then --Pero solo iterará sus datos si cumplen con la condicion de que estan activos en esta simulacion
        
      FOR ranking IN rankings LOOP               --Este loop buscara el ranking de l corredor
        if E_R.fk_ranking_id = ranking.id then    --Y solo iniciará los datos del corredor
          vuelta_numero:=0;
          este_id:=E_R.fk_ranking_id;

          WHILE (ranking.hora<86400) LOOP
            vuelta_numero:=vuelta_numero+1;
            km_esta_vuelta:=(SELECT "random_f"(13.0,13.2));
            tiempo_esta_vuelta:=(SELECT "generar_tiempo_vuelta"(E_R.fk_e_p_id,clima_actual,id_evento));
            velocidad_esta_vuelta:=((km_esta_vuelta)/(tiempo_esta_vuelta/(3600)));

            distancia_total:=((ranking.distancia_km+km_esta_vuelta));
            velocidad_media_esta_vuelta:=((ranking.velocidad_media+velocidad_esta_vuelta)/2);
            tiempo_total:=(ranking.hora+tiempo_esta_vuelta);

            UPDATE ranking SET hora=tiempo_total,velocidad_media=velocidad_media_esta_vuelta, numero_vuelta=vuelta_numero, distancia_km=distancia_total WHERE id=este_id;
          END LOOP;

        end if;
      END LOOP; 

    end if; --Final del loop que inicia los datos de todos los competidores
  END LOOP; 
  return 1;
END;
$body$LANGUAGE plpgsql;
---===========funcion genrar tiempo de vuelta=======
--Esta es la funcion mas larga, recorre arias tablas y genera el tiempo que duro en recorrer una vuelta dpendiendo de calculos estadisticos
                                               --5
CREATE OR REPLACE FUNCTION generar_tiempo_vuelta(equipo_piloto_id BIGINT,clima_actual INT[4],id_evento BIGINT) returns int as $body$
DECLARE
 --declaracion de cursores para coeficientes
 competidores CURSOR FOR SELECT * FROM E_R tabla ORDER BY tabla.fk_e_p_id;
 pilotos CURSOR FOR SELECT * FROM piloto p ORDER BY p.id;
 eps CURSOR FOR SELECT * FROM E_P ep ORDER BY ep.id;

 tiempo_vuelta int;

 --equipos CURSOR FOR SELECT * FROM equipo e ORDER BY e.id;
 
 coeficiente1 VARCHAR[2][2];
 coeficiente2 VARCHAR[2][2];
 --'{{"uwu","2"},{"owo","5"}}'

--competidor 1
 coeficiente_Físico1 VARCHAR;
 coeficiente_Mental1 VARCHAR;
 dato_coeficiente_Físico1 int; --CAST ('100' AS INTEGER)
 dato_coeficiente_Mental1 int;
 manejo1 INT;

--competidor 2
 coeficiente_Físico2 VARCHAR;
 coeficiente_Mental2 VARCHAR;
 dato_coeficiente_Físico2 int; --CAST ('100' AS INTEGER)
 dato_coeficiente_Mental2 int;
 manejo2 INT;
 --datos coeficientes finales por equipo
 coeficiente_fisico_total float;
 coeficiente_mental_total float;
 calculo_coeficiente float;
 manejo_total float;

 --datos del clima
 clima1 int;
 clima2 int;
 clima3 int;
 clima4 int;
 promedio_clima float;

 --datos de la dificutad de la pista
 dificultad_pista BIGINT;
BEGIN
 --llenado de datos del competidor 1
 FOR E_P IN eps LOOP
    if E_P.id=equipo_piloto_id then
   
     FOR piloto IN pilotos LOOP
       if E_P.fk_piloto_id=piloto.id then
         coeficiente1:=piloto.coeficientes;
         manejo1:=piloto.manejo;
       end if;
     END LOOP;

    end if;
 END LOOP;
 --llenado de datos del competidor 2
 FOR E_P IN eps LOOP
    if E_P.id=equipo_piloto_id+1 then
   
     FOR piloto IN pilotos LOOP
       if E_P.fk_piloto_id=piloto.id then
          coeficiente2:=piloto.coeficientes;
          manejo2:=piloto.manejo;
       end if;
     END LOOP;

    end if;
 END LOOP;
 
  --coeficientes del piloto 1
  coeficiente_Físico1:=coeficiente1[1][2];
  dato_coeficiente_Físico1:=(CAST (coeficiente_Físico1 AS int));
  coeficiente_Mental1:=coeficiente1[2][2];
  dato_coeficiente_Mental1:=(CAST (coeficiente_Mental1 AS int));
  --coeficientes del piloto 2
  coeficiente_Físico2:=coeficiente2[1][2];
  dato_coeficiente_Físico2:=(CAST (coeficiente_Físico2 AS int));
  coeficiente_Mental2:=coeficiente2[2][2];
  dato_coeficiente_Mental2:=(CAST (coeficiente_Mental2 AS int));
  --Promedio de los dos coeficientes de los 2 competidores
  coeficiente_fisico_total:=(dato_coeficiente_Físico1 + dato_coeficiente_Físico2)/2;
  coeficiente_mental_total:=(dato_coeficiente_Mental1 + dato_coeficiente_Mental2)/2;
  --Se suman el promedio de los coeficientes en una sola variable
  calculo_coeficiente:=coeficiente_mental_total+coeficiente_fisico_total;
  --manejo promedio
  manejo_total:=((manejo1+manejo2)/2);

 --Datos del clima actual
 --dato1 
  clima1:=clima_actual[1];
 --dato2
 if clima_actual[2]=null then
    clima2:=0;
 else
   clima2:=clima_actual[2];
 end if;
 --dato3
 if clima_actual[3]=null then
   clima3:=0;
 else
   clima3:=clima_actual[3];
 end if;
 --dato4
if clima_actual[4]=null then
   clima4:=0;
 else
   clima4:=clima_actual[4];
 end if;

 if clima_actual[2]=null then
    promedio_clima:=clima_actual[1];
 else
    promedio_clima:= (clima1+clima2+clima3+clima4)/4;
    promedio_clima:= round( CAST( promedio_clima as numeric), 2);
 end if;
--obtencion de datos de dificultad de pista
 dificultad_pista:=( SELECT "obtener_dificultad_pista"(id_evento));

 --==CALCULOS DEL TIEMPO DE VUELTA==
 --avg por vuelta son rango 290-300
 tiempo_vuelta:=(SELECT "random_i"( 290, 300));
 -- le añado segundos si difficultad_pista >5, else le quito segundos
 IF dificultad_pista>5 then
   tiempo_vuelta:=(tiempo_vuelta+(dificultad_pista*2));
 else
   tiempo_vuelta:=(tiempo_vuelta-(dificultad_pista*2));
 end if;
 -- le bajo un segundo por nivel          
 tiempo_vuelta:=(tiempo_vuelta-coeficiente_mental_total);  
 -- le bajo un segundo por nivel
 tiempo_vuelta:=(tiempo_vuelta-coeficiente_fisico_total);
 --clima sumo 5 segundos por nivel
 tiempo_vuelta:=tiempo_vuelta+(promedio_clima*5);
 -- por cada nivel de manejo lo quito 2 segundos
 tiempo_vuelta:=tiempo_vuelta-(manejo_total*2);

 return tiempo_vuelta;
END;
$body$LANGUAGE plpgsql;
---===========funcion que obtiene dificultad de pista
CREATE or REPLACE FUNCTION obtener_dificultad_pista(id_evento BIGINT)returns BIGINT as $$
DECLARE
 eventos CURSOR FOR SELECT * FROM evento e ORDER BY e.id;
 p_ss CURSOR FOR SELECT * FROM P_S ps ORDER BY ps.fk_pista_id;
 secciones CURSOR FOR SELECT * FROM seccion s ORDER BY s.id;

 id_pista BIGINT;
 id_seccion BIGINT;
 dificultad BIGINT;
BEGIN
  FOR evento in eventos LOOP --loop para obtener el id de la pista
    if evento.id=id_evento then 
      id_pista:=evento.fk_pista_id;
    end if;
 end loop;
  FOR P_S in p_ss LOOP --loop para obtener el id de la seccion
    if P_S.fk_pista_id=id_pista then
       id_seccion:=P_S.fk_seccion_id; 
    end if;
 end loop;
  FOR seccion in secciones LOOP
   if seccion.id=id_seccion then
      dificultad:=seccion.dificultad;
   end if;
  end loop;
  return dificultad;
END;
$$LANGUAGE plpgsql;
---===========funcion que genera un clima===========
CREATE or REPLACE FUNCTION generar_clima_sucesso(evento_id BIGINT) RETURNS BIGINT as $body$
DECLARE
 id_pista BIGINT;

 sucesos CURSOR FOR SELECT * FROM SUCESO s ORDER BY s.id;

 last_id_suceso BIGINT;
 clima_nuevo INT[4];
 random1 int;
 random2 int;
 random3 int;
 random4 int;

 --END OF VARIABLE DECLARATIONS
BEGIN

 last_id_suceso:=0;
 id_pista:=(SELECT return_pista_id(evento_id));

 --Randoms posibles para el clima.
 --1=soleado, 2=noche, 3=nublado, 4=lluvia, 5=tormenta

 random1:=(SELECT "random_i"(1,5));
 IF random1=1 then
    clima_nuevo:=ARRAY[random1,null,null,null];
 else
   random2:=(SELECT "random_i"(2,5));   --(SELECT floor(random()*(5-2+1))+2);
   random3:=(SELECT "random_i"(2,5));
   random4:=(SELECT "random_i"(2,5));
   clima_nuevo:=ARRAY[random1,random2,random3,random4];
 end IF;

 --este for loop permiterecuprar el ultimo id registrado
 FOR suceso IN sucesos LOOP
   last_id_suceso:=suceso.id;
 END LOOP;
  last_id_suceso:=last_id_suceso+1;
 --fin del forloop y creacion del nuevo id del suceso;
 /*
 INSERT INTO suceso (id, tipo_suceso, clima_momento, causa, tipo_bandera, fk_p_s_fk_seccion_id,fk_p_s_fk_pista_id) VALUES
 (last_id_suceso,'clima',clima_nuevo,null, null,null,null); */
 
 Call push_generar_clima_sucess(last_id_suceso,clima_nuevo);
 RETURN last_id_suceso;
END;
$body$LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE  push_generar_clima_sucesso(last_id_suceso BIGINT, clima_nuevo INT[4])as $$
BEGIN
INSERT INTO suceso (id, tipo_suceso, clima_momento, causa, tipo_bandera, fk_p_s_fk_seccion_id,fk_p_s_fk_pista_id) VALUES
 (last_id_suceso,'clima',clima_nuevo,null, null,null,null);
 return;
END;$$LANGUAGE plpgsql;

---===========funcion que regresa el id de una pista, pasandole por refrencia el id de un evento=========
CREATE OR REPLACE FUNCTION return_pista_id(evento_id BIGINT) RETURNS BIGINT as $$
DECLARE
 pistas CURSOR FOR SELECT * FROM evento p ORDER BY p.id;
BEGIN
FOR evento IN pistas LOOP
 if evento.id=evento_id then
  return evento.fk_pista_id;
 end if;
END LOOP;
END;
$$ LANGUAGE plpgsql;

---===========funcion que genera un evento---------
CREATE Or REPLACE FUNCTION crear_evento(num int)
RETURNS BIGINT as $function$
DECLARE

 eventos CURSOR FOR SELECT * FROM evento e ORDER BY e.id;

 new_id BIGINT;
 ano FECHA;

 nuevo_ano BIGINT;
 nuevo_mes BIGINT;
 nuevo_dia BIGINT;

 tipo CHAR VARYING;
 id_pista BIGINT;

BEGIN

 FOR evento IN eventos LOOP
   new_id:= evento.id;
   ano:= evento.ano;
   tipo:= evento.tipo;
   nuevo_ano := (SELECT ano.ano FROM evento e WHERE new_id=e.id);
   nuevo_mes := (SELECT ano.mes FROM evento e WHERE new_id=e.id);
   nuevo_dia := (SELECT ano.dia FROM evento e WHERE new_id=e.id);
 END LOOP;
  
 
 nuevo_ano:=nuevo_ano+1;
 new_id:=new_id+1;
 
 tipo:='Carrera';

 IF num <7 then
  id_pista:=1;
  else
  id_pista:=2;
 END IF;

  /*INSERT INTO evento (id, ano, tipo, fk_pista_id) VALUES
   (new_id,(nuevo_dia,nuevo_mes,nuevo_ano),tipo,id_pista);*/
   CALL push_evento(new_id,nuevo_dia,nuevo_mes,nuevo_ano,tipo,id_pista);

 RETURN new_id;
END;
$function$ LANGUAGE plpgsql;

---======llamade de insert evento=================
CREATE OR REPLACE PROCEDURE push_evento(new_id BIGINT, new_dia BIGINT,new_mes BIGINT,new_ano BIGINT, new_tipo CHAR VARYING, new_fk_pista_id BIGINT) as $$
BEGIN
 INSERT INTO evento (id, ano, tipo, fk_pista_id) VALUES
   (new_id,(new_dia,new_mes,new_ano),new_tipo,new_fk_pista_id);
   return;
END;
$$ LANGUAGE plpgsql;


---===============Funcion crear ranking para cada corredor=================
CREATE OR REPLACE FUNCTION crear_ranking(evento BIGINT) returns BIGINT as $body$
DECLARE
  new_id BIGINT;
  rankings CURSOR FOR SELECT * FROM RANKING r ORDER BY r.id;
BEGIN
 FOR ranking in rankings LOOP
  new_id:= ranking.id;
 END LOOP;
  new_id:=new_id+1;
  CALL push_crear_ranking(new_id,evento);
 RETURN new_id;
END; 
$body$ LANGUAGE plpgsql;
---=============================================================
CREATE OR REPLACE PROCEDURE push_crear_ranking(new_id BIGINT,evento BIGINT) as $$
BEGIN
   INSERT INTO RANKING (id, hora, puesto, velocidad_media, vuelta_rapida, numero_vuelta, distancia_km, fk_evento_id) VALUES
  (new_id,0 ,0,0     ,(0,0,0),0   ,0      ,evento);
  return;
END
$$LANGUAGE plpgsql;

---==============FUNCION crear E_R para cada corredor e la nueva iteracion===========
CREATE OR REPLACE FUNCTION crear_e_r(new_categoria VARCHAR,new_equipo_num BIGINT,new_marca_cauchos VARCHAR,new_ranking_id BIGINT,new_foto bytea,new_evento_id BIGINT,new_E_P_id BIGINT) 
  returns BIGINT as $body$
DECLARE
 E_Rs CURSOR FOR SELECT * FROM E_R er ORDER BY er.fk_e_p_id;
BEGIN
 /*INSERT INTO E_R (categoria, numero_equipo, marca_cauchos, fk_ranking_id, foto, fk_ranking_evento_id, fk_e_p_id) VALUES
   (new_categoria,new_equipo_num,new_marca_cauchos,new_ranking_id,new_foto,new_evento_id,new_E_P_id); */
   CALL push_crear_e_r(new_categoria,new_equipo_num,new_marca_cauchos,new_ranking_id,new_foto,new_evento_id,new_E_P_id);
 return new_E_P_id;
END;
$body$ LANGUAGE plpgsql;

--===============
CREATE OR REPLACE PROCEDURE push_crear_e_r(new_categoria VARCHAR,new_equipo_num BIGINT,new_marca_cauchos VARCHAR,new_ranking_id BIGINT,new_foto bytea,new_evento_id BIGINT,new_E_P_id BIGINT)as $$
BEGIN
  INSERT INTO E_R (categoria, numero_equipo, marca_cauchos, fk_ranking_id, foto, fk_ranking_evento_id, fk_e_p_id) VALUES
   (new_categoria,new_equipo_num,new_marca_cauchos,new_ranking_id,new_foto,new_evento_id,new_E_P_id);
   return;
END
$$LANGUAGE plpgsql;

---===========Funcion que genera numeros aleatoreos de tipo int==========
CREATE OR REPLACE FUNCTION random_i( a int, b int) RETURNS int as $function$
BEGIN
  --donde "a" s el menor numero y b es el mayor
  return (SELECT floor(random()*(b-a+1))+a);
END;
$function$ LANGUAGE plpgsql;

---===========Funcion que genera numeros aleatoreos de tipo float=========
CREATE OR REPLACE FUNCTION random_f( a float, b float) RETURNS float as $function$
BEGIN
  --donde "a" s el menor numero y b es el mayor
  return (SELECT random()*(b-a)+a);
END;
$function$ LANGUAGE plpgsql;