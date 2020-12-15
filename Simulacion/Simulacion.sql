---Función que inicia la carrera
---1) Empieza la iteración de la competencia, interactuan cada uno de los competidores de la carrera (dependiendo del año), para ello se inserta un numero del 1 al 10 (1950 a 1959)
---2) El año se decide con numero del 1 al 10. 1= 1950, 2=1951, 3=1952, 4=1953, etc.


---===============================================================

--Falta que pilotos vana competir. se tiene que elegir un año.
CREATE OR REPLACE PROCEDURE start_race(competitor E_P.fk_equipo_id%TYPE,IN carrera_num int ) as 
$func$
DECLARE
     r E_P%ROWTYPE; --fila
     --a geto
     --anno number%type; IN 
 
     competidores CURSOR FOR SELECT * FROM E_R tabla ORDER BY tabla.fk_e_p_fk_equipo_id; 
     eventos CURSOR FOR SELECT * FROM EVENTO tablaDos ORDER BY tablaDos.id;
      
BEGIN
 --init variables
  competitor_id := 0;
  tiempo_h:=0 BIGINT;
  tiempo_m:=0 BIGINT;
  tiempo_s:=0 BIGINT;

  variable1 BIGINT;
  verificar:=false boolean;

  FOR E_R IN competidores LOOP
      variable1 := E_R.fk_ranking_evento_id; --puede eliminarse
      verificar:=false;

      FOR EVENTO IN eventos LOOP
        IF EVENTO.ano = carrera_num then
          verificar:=true;
        END IF;
      END LOOP;
      --si el numero ingresado del año es iugal a el numero del evento de ese año.
      IF carrera_num=E_R.fk_ranking_evento_id and then
       
      END IF;


     SELECT "startTimer"() -- por cada competidor
  END LOOP;
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