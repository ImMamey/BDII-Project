---Función que inicia la carrera
---1) Empieza la iteración de la competencia, Interactuan cada uno de los competidores de la carrera.


---===============================================================
CREATE OR REPLACE PROCEDURE start_race(competitor E_P.fk_equipo_id%TYPE) as 
$func$
DECLARE
     r E_P%ROWTYPE; --fila
     --a geto
 
     competidores CURSOR FOR SELECT *
       FROM E_P tabla
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
     -- else
    --- asdfasdfasdf
  END LOOP;

RETURNS TABLE; 
END;
$func$LANGUAGE plpgsql;

---================================


CREATE OR REPLACE FUNCTION startTimer(%ROWTYPE)
RETURNS voids as $teamito$
BEGIN
END;
$teamito$ LANGUAGE plpgsql;