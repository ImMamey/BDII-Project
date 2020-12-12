---Función que inicia la carrera
---1) Empieza la iteración de la competencia, Interactuan cada uno de los competidores de la carrera.


---===============================================================

--Falta que pilotos vana competir. se tiene que elegir un año.
CREATE OR REPLACE PROCEDURE start_race(competitor E_P.fk_equipo_id%TYPE) as 
$func$
DECLARE
     r E_P%ROWTYPE; --fila
     --a geto
     --anno number%type; IN 
 
     competidores CURSOR FOR SELECT *
       FROM E_P tabla --WHERE donde se especifique el año.
       ORDER BY tabla.fk_equipo_id; 
BEGIN
 --init variables
  competitor_id := 0;
  tiempo_h:=0 BIGINT;
  tiempo_m:=0 BIGINT;
  tiempo_s:=0 BIGINT;

  FOR E_P IN competidores LOOP
     /*
     If competidor tiempo is <=24h then:
     */
     SELECT "startTimer"() -- por cada competidor

     --END IF;
     -- else
    --- asdfasdfasdf
  END LOOP;
 -- END TIME LOOP;
RETURNS TABLE; 
END;
$func$LANGUAGE plpgsql;

---================================
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
---================================


CREATE OR REPLACE FUNCTION startTimer(%ROWTYPE)
RETURNS voids as $teamito$
BEGIN
END;
$teamito$ LANGUAGE plpgsql;