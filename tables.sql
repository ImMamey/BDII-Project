---============TDA==============
CREATE TYPE NOMBRE AS(
primer_nombre VARCHAR(15),
segundo_nombre VARCHAR(15),
primer_apellido VARCHAR(15),
segundo_apellido VARCHAR(15),
fecha_nacimiento DATE, 
fecha_fallecimiento DATE 
--CALL edad(fecha_nacimiento); 
) ;

CREATE TYPE  FECHA AS(
dia BIGINT,
mes BIGINT,
ano BIGINT
);

CREATE TYPE TIEMPO AS(
hora BIGINT,
minuto BIGINT,
segundo BIGINT
);
---========== TABLE's================
CREATE TABLE MARCA_AUTO(
 id BIGINT  NOT NULL,
 nombre VARCHAR NOT NULL,
 PRIMARY KEY(id)
);

CREATE TABLE MOTOR(
    id BIGINT NOT NULL,
    nombre VARCHAR NOT NULL,
    cilindraje INT NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE VEHICULO(
 id BIGINT NOT NULL,
 nombre VARCHAR NOT NULL,
 tipo VARCHAR NOT NULL,
 fk_marca_auto_id BIGINT NOT NULL,
 PRIMARY KEY (id)
);

ALTER TABLE VEHICULO ADD CONSTRAINT vehiculo_marca_id_fk FOREIGN KEY (fk_marca_auto_id) REFERENCES MARCA_AUTO (id);

CREATE TABLE V_M(
fk_motor_id BIGINT NOT NULL,
fk_vehiculo_id BIGINT NOT NULL,
PRIMARY KEY(fk_motor_id,fk_vehiculo_id)
);

ALTER TABLE V_M ADD CONSTRAINT v_m_motor_id_fk FOREIGN KEY (fk_motor_id) REFERENCES MOTOR (id);
ALTER TABLE V_M ADD CONSTRAINT v_m_vehiculo_id_fk FOREIGN KEY (fk_vehiculo_id) REFERENCES VEHICULO (id);

CREATE TABLE EQUIPO(
 id BIGINT NOT NULL,
 nombre VARCHAR NOT NULL,
 nacionalidad VARCHAR NOT NULL,
 fk_marca_auto_id BIGINT,
 fk_v_m_vehiculo_id BIGINT NOT NULL,
 fk_v_m_motor_id BIGINT NOT NULL,
 PRIMARY KEY(id)
);

ALTER TABLE EQUIPO ADD CONSTRAINT equipo_marca_id_fk FOREIGN KEY (fk_marca_auto_id) REFERENCES MARCA_AUTO (id);
ALTER TABLE EQUIPO ADD CONSTRAINT equipo_v_m_id_fk FOREIGN KEY (fk_v_m_motor_id,fk_v_m_vehiculo_id) REFERENCES V_M (fk_motor_id,fk_vehiculo_id);

CREATE TABLE INVENTARIO(
 id BIGINT NOT NULL,
 producto VARCHAR[][] NOT NULL, --ó producto ARRAY NOT NULL
 ---https://www.postgresql.org/docs/9.2/arrays.html
 cantidad BIGINT NOT NULL,
 fk_equipo_id BIGINT NOT NULL,
 PRIMARY KEY(id)
);

ALTER TABLE INVENTARIO ADD CONSTRAINT inventario_equipo_id_fk FOREIGN KEY (fk_equipo_id) REFERENCES EQUIPO (id);

CREATE TABLE PILOTO(
 id BIGINT NOT NULL,
 identificacion NOMBRE NOT NULL,
 foto BYTEA NOT NULL,
 lugar_nacimiento VARCHAR NOT NULL,
 nacionalidad VARCHAR NOT NULL,
 manejo INT NOT NULL,
 genero VARCHAR NOT NULL,
 coeficientes VARCHAR[2][2] NOT NULL,--ó producto ARRAY NOT NULL
  ---https://www.postgresql.org/docs/9.2/arrays.html
 PRIMARY KEY(id)
);

CREATE TABLE SECCION(
 id BIGINT NOT NULL,
 nombre VARCHAR NOT NULL,
 dificultad INT NOT NULL,
 ancho_sec  INT NOT NULL,
 PRIMARY KEY(id)
);

CREATE TABLE PISTA(
    id BIGINT NOT NULL,
    nombre VARCHAR NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE EVENTO(
 id BIGINT NOT NULL,
 ano DATE NOT NULL,
 tipo VARCHAR NOT NULL,
 fk_pista_id BIGINT NOT NULL,
 PRIMARY KEY(id)
);

ALTER TABLE EVENTO ADD CONSTRAINT evento_pista_id_fk FOREIGN KEY (fk_pista_id) REFERENCES PISTA (id);

CREATE TABLE P_S(
 fk_seccion_id BIGINT NOT NULL, --revisar
 fk_pista_id BIGINT NOT NULL, --revisar
 PRIMARY KEY(fk_seccion_id,fk_pista_id)
);

ALTER TABLE P_S ADD CONSTRAINT p_s_seccion_id_fk FOREIGN KEY (fk_seccion_id) REFERENCES SECCION (id);
ALTER TABLE P_S ADD CONSTRAINT p_s_pista_id_fk FOREIGN KEY (fk_pista_id) REFERENCES PISTA (id);

CREATE TABLE SUCESO(
 id BIGINT NOT NULL,
 tipo_suceso VARCHAR NOT NULL,
 momento_suceso TIEMPO,  --TDA TIEMPO
 clima_momento VARCHAR(4) NOT NULL,
 causa VARCHAR(3),
 tipo_bandera VARCHAR,
 fk_p_s_fk_seccion_id BIGINT,
 fk_p_s_fk_pista_id BIGINT,
 PRIMARY KEY(id)
);

ALTER TABLE SUCESO ADD CONSTRAINT suceso_p_s_id_fk FOREIGN KEY (fk_p_s_fk_seccion_id,fk_p_s_fk_pista_id) REFERENCES P_S (fk_seccion_id,fk_pista_id);

CREATE TABLE E_P(
 fk_piloto_id BIGINT NOT NULL,
 fk_equipo_id BIGINT NOT NULL,
 PRIMARY KEY(fk_piloto_id,fk_equipo_id)
);

ALTER TABLE E_P ADD CONSTRAINT e_p_piloto_id_fk FOREIGN KEY (fk_piloto_id) REFERENCES PILOTO (id);
ALTER TABLE E_P ADD CONSTRAINT e_p_equipo_id_fk FOREIGN KEY (fk_equipo_id) REFERENCES EQUIPO (id);

CREATE TABLE S_P(
 fk_suceso_id BIGINT NOT NULL,
 fk_piloto_id BIGINT NOT NULL,
 PRIMARY KEY(fk_suceso_id,fk_piloto_id)
);

ALTER TABLE S_P ADD CONSTRAINT s_p_piloto_id_fk FOREIGN KEY (fk_piloto_id) REFERENCES PILOTO (id);
ALTER TABLE S_P ADD CONSTRAINT s_p_suceso_id_fk FOREIGN KEY (fk_suceso_id) REFERENCES SUCESO (id);

CREATE TABLE S_I(
 fk_inventario_id BIGINT NOT NULL,
 fk_suceso_id BIGINT NOT NULL,
 PRIMARY KEY(fk_suceso_id,fk_inventario_id )
);

ALTER TABLE S_I ADD CONSTRAINT s_i_inventario_id_fk FOREIGN KEY (fk_inventario_id) REFERENCES INVENTARIO (id);
ALTER TABLE S_I ADD CONSTRAINT s_i_suceso_id_fk FOREIGN KEY (fk_suceso_id) REFERENCES SUCESO (id);

CREATE TABLE RANKING(
    id BIGINT NOT NULL,
    hora BIGINT NOT NULL,
    puesto BIGINT NOT NULL,
    velocidad_media FLOAT,
    vuelta_rapida TIEMPO, --TDA tiempo
    numero_vuelta BIGINT,
    distancia_km FLOAT,
    fk_evento_id BIGINT NOT NULL,
    PRIMARY KEY(id, fk_evento_id)
);

ALTER TABLE RANKING ADD CONSTRAINT ranking_evento_id_fk FOREIGN KEY (fk_evento_id) REFERENCES EVENTO (id);

CREATE TABLE E_R(
    categoria VARCHAR NOT NULL,
    numero_equipo BIGINT NOT NULL,
    marca_cauchos VARCHAR NOT NULL,
    fk_ranking_id BIGINT NOT NULL,
    foto BYTEA NOT NULL,
    fk_ranking_evento_id BIGINT NOT NULL,
    fk_e_p_fk_piloto_id BIGINT NOT NULL,
    fk_e_p_fk_equipo_id BIGINT NOT NULL,
    PRIMARY KEY(
        fk_ranking_id,
        fk_ranking_evento_id,
        fk_e_p_fk_piloto_id,
        fk_e_p_fk_equipo_id
        )
);

ALTER TABLE E_R ADD CONSTRAINT e_r_ranking_fk FOREIGN KEY (fk_ranking_id,fk_ranking_evento_id) REFERENCES RANKING (id,fk_evento_id);
ALTER TABLE E_R ADD CONSTRAINT e_r_p_id_fk FOREIGN KEY (fk_e_p_fk_piloto_id,fk_e_p_fk_equipo_id) REFERENCES E_P (fk_piloto_id,fk_equipo_id);


CREATE TABLE RANKING_HORA(
    id BIGINT NOT NULL,
    hora BIGINT NOT NULL,
    puesto BIGINT NOT NULL,
    fk_e_r_ranking_id BIGINT NOT NULL,
    fk_e_r_ranking_evento_id BIGINT NOT NULL,
    fk_e_r_fk_piloto_id BIGINT NOT NULL,
    fk_e_r_fk_equipo_id BIGINT NOT NULL,
        PRIMARY KEY(
        id,
        fk_e_r_ranking_id,
        fk_e_r_ranking_evento_id,
        fk_e_r_fk_piloto_id,
        fk_e_r_fk_equipo_id
        )
);

ALTER TABLE RANKING_HORA ADD CONSTRAINT hora_e_r_id_fk FOREIGN KEY (fk_e_r_ranking_id,fk_e_r_ranking_evento_id,fk_e_r_fk_piloto_id,fk_e_r_fk_equipo_id) REFERENCES E_R (fk_ranking_id,fk_ranking_evento_id,fk_e_p_fk_piloto_id,fk_e_p_fk_equipo_id);


