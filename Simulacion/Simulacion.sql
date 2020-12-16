---Función que inicia la carrera
---1) Empieza la iteración de la competencia, interactuan cada uno de los competidores de la carrera (dependiendo del año), para ello se inserta un numero del 1 al 10 (1950 a 1959)
---2) El año se decide con numero del 1 al 10. 1= 1950, 2=1951, 3=1952, 4=1953, etc.


---=======================Funcion principal, inicia la carrera con un año dado=================================
CREATE OR REPLACE PROCEDURE start_race(IN carrera_anno int) as 
$func$
DECLARE
  --r E_P%ROWTYPE; --fila
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
      
BEGIN
  verificar_evento:=false;
  nuevo_evento:=(SELECT "crear_evento"(carrera_anno));
 
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
  SELECT "startSimulation"(nuevo_evento);
END;
$func$LANGUAGE plpgsql;

---===========FUncion que inicia la simulacion vuelta por vuelta=====================
---crear estimulado coeficiente manejo dificultad de la pista y clima
CREATE OR REPLACE FUNCTION startSimulation(id_evento BIGINT) as $body$
DECLARE
 competidores CURSOR FOR SELECT * FROM E_R tabla ORDER BY tabla.fk_e_p_id; 
 rankings     CURSOR FOR SELECT * FROM ranking e ORDER BY e.id;
 todos_terminaron_competencia boolean;
BEGIN
 todos_terminaron_competencia:=true;
 Loop
    FOR E_R IN competidores LOOP

      if E_R.fk_ranking_evento_id = id_evento then
        FOR ranking IN rankings LOOP
         if E_R.fk_ranking_id = ranking.id then
            --condicinoal de entrade por 24h de corredor

            ---SIMULACION
         end if;
        END LOOP;
        --iff tiempo -24 then todos_terminaron_competencia:= false nd if;
      end if;
    END LOOP;
  EXIT WHEN todos_terminaron_competencia=true;
  END LOOP;
 --while todos_terminaron competenica=true; 
END;
$body$LANGUAGE plpgsql;


---===========funcion que genera un evento---------
CREATE Or REPLACE FUNCTION crear_evento(num int) RETURNS BIGINT as $function$
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

  INSERT INTO evento (id, ano, tipo, fk_pista_id) VALUES
   (new_id,(nuevo_dia,nuevo_mes,nuevo_ano), tipo, id_pista);

 RETURN new_id;
END;
$function$ LANGUAGE plpgsql;


---===========Funcion que genera numeros aleatoreos controlados para el uso del proyecto==========
CREATE OR REPLACE FUNCTION random_i(prob competidor.coeficiente%TYPE, prob_race competidor.habilidad%TYPE) RETURNS interger as $function$
DECLARE
 result interger;
BEGIN
 IF prob==1 then
  returns result:= random()*(1-0.01)+0.01;
 END IF;
 IF i>1 and i<5 then
  returns  result:= random()*(a-b)+b; --donde a es el mayor tiempo posible de completar circuito, b es el menor tiempo posible de completar circuito.
 END IF;
 --more random functions if needed
END;
$function$ LANGUAGE plpgsql; 

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
  INSERT INTO RANKING (id, hora, puesto, velocidad_media, vuelta_rapida, numero_vuelta, distancia_km, fk_evento_id) VALUES
  (new_id,0 ,0,0     ,(0,0,0),0   ,0      ,evento);
 RETURN new_id;
END; 
$body$ LANGUAGE plpgsql;

---==============FUNCION crear E_R para cada corredor e la nueva iteracion===========
CREATE OR REPLACE FUNCTION crear_e_r(new_categoria VARCHAR,new_equipo_num BIGINT,new_marca_cauchos VARCHAR,new_ranking_id BIGINT,new_foto bytea,new_evento_id BIGINT,new_E_P_id BIGINT) 
  returns BIGINT as $body$
DECLARE
 E_Rs CURSOR FOR SELECT * FROM E_R er ORDER BY er.fk_e_p_id;
BEGIN
 INSERT INTO E_R (categoria, numero_equipo, marca_cauchos, fk_ranking_id, foto, fk_ranking_evento_id, fk_e_p_id) VALUES
   (new_categoria,new_equipo_num,new_marca_cauchos,new_ranking_id,new_foto,new_evento_id,new_E_P_id);
 return new_E_P_id;
END;
$body$ LANGUAGE plpgsql;