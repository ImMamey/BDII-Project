---Función que inicia la carrera
---1) Empieza la iteración de la competencia, interactuan cada uno de los competidores de la carrera (dependiendo del año), para ello se inserta un numero del 1 al 10 (1950 a 1959)
---2) El año se decide con numero del 1 al 10. 1= 1950, 2=1951, 3=1952, 4=1953, etc.


---=======================Funcion principal, inicia la carrera con un año dado=================================

CREATE OR REPLACE PROCEDURE start_race(IN carrera_anno int) as 
$func$
DECLARE
     --r E_P%ROWTYPE; --fila
     competidores CURSOR FOR SELECT * FROM E_R tabla ORDER BY tabla.fk_e_p_fk_equipo_id; 
      
BEGIN
 --===init variables==

  --variables por equipo !!!!!!!!!revisar
  equipo_num BIGINT;
  marca_cauchos CHAR VARYING;
  ranking BIGINT;
  foto bytea;
  evento_id BIGINT;

  ---Dato del nuevo evento de revalida
  nuevo_evento BIGINT;

  --Declaracion de boolean de verificacion de pariticpacion de evento
  verificar_evento:=false boolean;

  --=== end  of INIT==
  nuevo_evento:=SELECT "crear_evento"(carrera_anno);

  FOR E_R IN competidores LOOP
  ---NO, tengo que usar el fk_ranking_evento_id de E_R o de ranking para buscar el año, revisar!!!!!!!!!!!!!!!!!!!

      --si el numero ingresado del año es iugal a el numero del evento de ese año.
      IF carrera_anno=E_R.fk_ranking_evento_id  = true then

       --guardado de los datos del competidor

       equipo_num:= E_R.numero_equipo;
       marca_cauchos:= E_R.marca_cauchos;
       ranking:= E_R.fk_ranking_id;
       foto:= E_R.foto;
       evento_id:=E_R.fk_ranking_evento_id;


        /*
          new_id BIGINT;
          new_hora BIGINT;
          new_puesto BIGINT;
          new_velocidad_media DOUBLE PRECISION;
          new_vuelta_rapida TIEMPO;
          new_numero_vuelta BIGINT;
          new_distancia_km DOUBLE PRECISION;
          new_fk_evento_id BIGINT;
        */
       
        nuevo_ranking:= SELECT "crear_ranking"(nuevo_evento);
        --SELECT crear_E_R();
        --SELECT "startTimer"();
      END IF;


     SELECT "startTimer"() -- por cada competidor
  END LOOP;
RETURNS TABLE; 
END;
$func$LANGUAGE plpgsql;


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

---===========funcion que regresa un dato tipo boolean si encuentra un año especifico en un evento=================
---Revisar, no util en el momento

CREATE OR REPLACE FUNCTION verificar_ano_corredor(numero int) RETURNS boolean as $function$
DECLARE
  eventos CURSOR FOR SELECT * FROM EVENTO tablaDos ORDER BY tablaDos.id;
BEGIN
       FOR EVENTO IN eventos LOOP
        IF EVENTO.ano = numero then
          RETURN true;
        END IF;
      END LOOP;
      RETURN FALSE;
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
--id, hora, puesto, , vuelta_rapida, numero_vuelta, distancia_km, fk_evento_id
CREATE OR REPLACE FUNCTION crear_ranking(evento BIGINT) as $body$
DECLARE
 new_id BIGINT;
 new_hora BIGINT;
 new_puesto BIGINT;
 new_velocidad_media DOUBLE PRECISION;
 new_vuelta_rapida TIEMPO;
 new_numero_vuelta BIGINT;
 new_distancia_km DOUBLE PRECISION;
 new_fk_evento_id BIGINT;

  rankings CURSOR FOR SELECT * FROM RANKING r ORDER BY r.id;
BEGIN
 FOR ranking in rankings LOOP
  new_id:= ranking.id;
 END LOOP;
  new_id:=new_id+1;
  INSERT INTO RANKING (id, hora, puesto, velocidad_media, vuelta_rapida, numero_vuelta, distancia_km, fk_evento_id) VALUES
  (new_id,0 ,0,0     ,(0,0,0),0   ,0      ,0);
--(1     ,24,1,144.38,(4,53,3),256,3465.12,1),
END; 
$body$ LANGUAGE plpgsql;