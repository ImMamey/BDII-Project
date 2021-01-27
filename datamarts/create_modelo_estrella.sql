CREATE TABLE DIMENSION_PILOTO(
 id_Dimension_Piloto INT  NOT NULL,
 primer_nombre VARCHAR NOT NULL,
 segundo_nombre VARCHAR NOT NULL,
 primer_apellido VARCHAR NOT NULL,
 segundo_apellido VARCHAR NOT NULL,
 sexo VARCHAR NOT NULL,
 nacionalidad VARCHAR NOT NULL,
 fecha_nacimiento DATE NOT NULL,
 fecha_fallecimiento DATE NOT NULL,
 foto BYTEA NOT NULL,
 lugar_nacimiento VARCHAR,
 PRIMARY KEY (id_Dimension_Piloto)
);

CREATE TABLE DIMENSION_VEHICULO(
    id_Dimension_Vehiculo INT NOT NULL,
    tipo VARCHAR NOT NULL,
    marca VARCHAR NOT NULL,
    nombre VARCHAR NOT NULL,
    cilindraje INTEGER NOT NULL,
    nombre_motor VARCHAR NOT NULL,
  PRIMARY KEY ( id_Dimension_Vehiculo)
);

CREATE TABLE DIMENSION_FECHA(
    id_Dimension_Fecha INT NOT NULL,
    fecha_inicial DATE NOT NULL,
    decada INTEGER NOT NULL,
    PRIMARY KEY ( id_Dimension_Fecha)
);

CREATE TABLE DIMENSION_RANKING(
    id_Dimension_Ranking INT NOT NULL,
    hora INT NOT NULL,
    minutos INT NOT NULL,
    segundos INT NOT NULL,
    centesimas INT NOT NULL,
    puesto INT NOT NULL,
    velocidad_media REAL NOT NULL,
    numero_vuelta INT NOT NULL,
    distancia_recorrida_km real NOT NULL,
    marca_de_caucho VARCHAR NOT NULL,
    categoria VARCHAR NOT NULL,
    numero_equipo INT NOT NULL,
    foto BYTEA NOT NULL,
    PRIMARY KEY ( id_Dimension_Ranking)
);

CREATE TABLE DIMENSION_EVENTO(
    id_Dimension_Evento INT NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    PRIMARY KEY(id_Dimension_Evento)
);

CREATE TABLE DIMENSION_EQUIPO(
    id_Dimension_Equipo INT NOT NULL,
    nombre VARCHAR NOT NULL,
    nacionalidad VARCHAR NOT NULL,
    PRIMARY KEY(id_Dimension_Equipo)
);

CREATE TABLE HECHOS_PARTICIPACION(
    fk_id_Dimension_Piloto INT NOT NULL,
    fk_id_Dimension_Equipo INT NOT NULL,
    fk_id_Dimension_Vehiculo INT NOT NULL,
    fk_id_Dimension_Ranking INT NOT NULL,
    fk_id_Dimension_Evento INT NOT NULL,
    fk_id_Dimension_Fecha INT NOT NULL,
    num_equipo INT NOT NULL,
    puesto INT NOT NULL,
    PRIMARY KEY(
        fk_id_Dimension_Piloto,
        fk_id_Dimension_Equipo,
        fk_id_Dimension_Vehiculo,
        fk_id_Dimension_Ranking,
        fk_id_Dimension_Evento,
        fk_id_Dimension_Fecha)
);
ALTER TABLE HECHOS_PARTICIPACION ADD CONSTRAINT id_Dimension_Piloto_fk FOREIGN KEY ( fk_id_Dimension_Piloto) REFERENCES DIMENSION_PILOTO (id_Dimension_Piloto);
ALTER TABLE HECHOS_PARTICIPACION ADD CONSTRAINT id_Dimension_Equipo_fk FOREIGN KEY ( fk_id_Dimension_Equipo) REFERENCES DIMENSION_EQUIPO (id_Dimension_Equipo);
ALTER TABLE HECHOS_PARTICIPACION ADD CONSTRAINT iid_Dimension_Vehiculo_fk FOREIGN KEY ( fk_id_Dimension_Vehiculo) REFERENCES DIMENSION_VEHICULO ( id_Dimension_Vehiculo);
ALTER TABLE HECHOS_PARTICIPACION ADD CONSTRAINT id_Dimension_Ranking_fk FOREIGN KEY ( fk_id_Dimension_Ranking) REFERENCES DIMENSION_RANKING (id_Dimension_Ranking);
ALTER TABLE HECHOS_PARTICIPACION ADD CONSTRAINT id_Dimension_Evento_fk FOREIGN KEY ( fk_id_Dimension_Evento) REFERENCES DIMENSION_EVENTO ( id_Dimension_Evento);
ALTER TABLE HECHOS_PARTICIPACION ADD CONSTRAINT id_Dimension_Fecha_fk FOREIGN KEY ( fk_id_Dimension_Fecha) REFERENCES DIMENSION_FECHA (id_Dimension_Fecha);