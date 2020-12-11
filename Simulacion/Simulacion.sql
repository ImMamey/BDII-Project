---Función que inicia la carrera
---1) Empieza la iteración de la competencia, Interactuan cada uno de los competidores de la carrera.


---===============================================================
CREATE OR REPLACE FUNCTION start_race(competitor E_P.fk_equipo_id%TYPE) RETURNS TABLE(
    team_name EQUIPO.nombre%TYPE,
    race_position BIGINT,
    distance FLOAT,
    loops BIGINT,
    issues BIGINT,
) as 
$func$
DECLARE
     r E_P%ROWTYPE;
BEGIN
 --init variables
  competitor_id := 0;
  tiempo_h:=0 BIGINT;
  tiempo_m:=0 BIGINT;
  tiempo_s:=0 BIGINT;

  FOR competitor_id IN 
       SELECT *
       FROM E_P tabla
       ORDER BY tabla.fk_equipo_id 
  LOOP
     ---CODIGO AQUI
     --- SELECT "startTimer"()
  END LOOP;

RETURNS TABLE; 
END;
$func$LANGUAGE plpgsql;

---================================


CREATE OR REPLACE FUNCTION startTimer()
RETURNS voids as $func$
BEGIN
END;
$func$ LANGUAGE plpgsql;