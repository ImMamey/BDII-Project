CREATE TABLE DIMENSION_PILOTO(
 id_Dimension_Piloto INT  NOT NULL,
 id_tabla_original_piloto INT NOT NULL,
 primer_nombre VARCHAR,
 segundo_nombre VARCHAR,
 primer_apellido VARCHAR,
 segundo_apellido VARCHAR,
 sexo VARCHAR,
 nacionalidad VARCHAR,
 fecha_nacimiento DATE,
 fecha_fallecimiento DATE,
 foto BYTEA,
 lugar_nacimiento VARCHAR,
 PRIMARY KEY (id_Dimension_Piloto,id_tabla_original_piloto)
);

CREATE TABLE DIMENSION_VEHICULO(
    id_Dimension_Vehiculo INT NOT NULL,
    id_tabla_original_vehiculo INT NOT NULL,
    tipo VARCHAR,
    marca VARCHAR,
    nombre VARCHAR,
    cilindraje VARCHAR,
    nombre_motor VARCHAR,
  PRIMARY KEY ( id_Dimension_Vehiculo,id_tabla_original_vehiculo)
);

CREATE TABLE DIMENSION_FECHA(
    id_Dimension_Fecha INT NOT NULL,
    fecha_inicial DATE,
    anno INTEGER,
    PRIMARY KEY ( id_Dimension_Fecha)
);

CREATE TABLE DIMENSION_RANKING(
    id_Dimension_Ranking INT NOT NULL,
    id_tabla_original_ranking INT NOT NULL,
    hora INT,
    minutos INT,
    segundos INT,
    centesimas INT,
    puesto INT,
    velocidad_media REAL,
    numero_vuelta INT,
    distancia_recorrida_km real,
    marca_de_caucho VARCHAR,
    categoria VARCHAR,
    numero_equipo INT,
    foto BYTEA,
    PRIMARY KEY ( id_Dimension_Ranking,id_tabla_original_ranking)
);

CREATE TABLE DIMENSION_EVENTO(
    id_Dimension_Evento INT NOT NULL,
    id_tabla_original_evento INT NOT NULL,
    tipo VARCHAR,
    PRIMARY KEY(id_Dimension_Evento, id_tabla_original_evento)
);

CREATE TABLE DIMENSION_EQUIPO(
    id_Dimension_Equipo INT NOT NULL,
    id_tabla_original_equipo INT NOT NULL,
    nombre VARCHAR,
    nacionalidad VARCHAR,
    PRIMARY KEY(id_Dimension_Equipo, id_tabla_original_equipo)
);

CREATE TABLE HECHOS_PARTICIPACION(
    id_participacion INT NULL,
    fk_id_Dimension_Piloto INT NOT NULL,
     fk_id_tabla_original_piloto INT NOT NULL,
    fk_id_Dimension_Equipo INT NOT NULL,
     fk_id_tabla_original_equipo INT NOT NULL,
    fk_id_Dimension_Vehiculo INT NOT NULL,
     fk_id_tabla_original_vehiculo INT NOT NULL,
    fk_id_Dimension_Ranking INT NOT NULL,
     fk_id_tabla_original_ranking INT NOT NULL,
    fk_id_Dimension_Evento INT NOT NULL,
     fk_id_tabla_original_evento INT NOT NULL,
    fk_id_Dimension_Fecha INT NOT NULL,
    num_equipo INT NOT NULL,
    puesto INT NOT NULL,
    PRIMARY KEY(
        id_participacion,
        fk_id_Dimension_Piloto,
        fk_id_tabla_original_piloto,
        fk_id_Dimension_Equipo,
        fk_id_tabla_original_equipo,
        fk_id_Dimension_Vehiculo,
        fk_id_tabla_original_vehiculo,
        fk_id_Dimension_Ranking,
        fk_id_tabla_original_ranking,
        fk_id_Dimension_Evento,
        fk_id_tabla_original_evento,
        fk_id_Dimension_Fecha)
);

ALTER TABLE HECHOS_PARTICIPACION ADD CONSTRAINT id_Dimension_Piloto_fk FOREIGN KEY (fk_id_Dimension_Piloto,fk_id_tabla_original_piloto) REFERENCES DIMENSION_PILOTO (id_dimension_piloto,id_tabla_original_piloto);
ALTER TABLE HECHOS_PARTICIPACION ADD CONSTRAINT id_Dimension_Equipo_fk FOREIGN KEY (fk_id_Dimension_Equipo,fk_id_tabla_original_equipo) REFERENCES DIMENSION_EQUIPO (id_Dimension_Equipo,id_tabla_original_equipo);
ALTER TABLE HECHOS_PARTICIPACION ADD CONSTRAINT iid_Dimension_Vehiculo_fk FOREIGN KEY (fk_id_Dimension_Vehiculo,fk_id_tabla_original_vehiculo) REFERENCES DIMENSION_VEHICULO ( id_Dimension_Vehiculo,id_tabla_original_vehiculo);
ALTER TABLE HECHOS_PARTICIPACION ADD CONSTRAINT id_Dimension_Ranking_fk FOREIGN KEY (fk_id_Dimension_Ranking,fk_id_tabla_original_ranking) REFERENCES DIMENSION_RANKING (id_Dimension_Ranking,id_tabla_original_ranking);
ALTER TABLE HECHOS_PARTICIPACION ADD CONSTRAINT id_Dimension_Evento_fk FOREIGN KEY ( fk_id_Dimension_Evento,fk_id_tabla_original_evento) REFERENCES DIMENSION_EVENTO ( id_Dimension_Evento,id_tabla_original_evento);
ALTER TABLE HECHOS_PARTICIPACION ADD CONSTRAINT id_Dimension_Fecha_fk FOREIGN KEY ( fk_id_Dimension_Fecha) REFERENCES DIMENSION_FECHA (id_Dimension_Fecha);