---============TDA==============
CREATE TYPE NOMBRE AS(
primer_nombre VARCHAR(15),
segundo_nombre VARCHAR(15),
primer_apellido VARCHAR(15),
segundo_apellido VARCHAR(15),
fecha_nacimiento DATE, 
fecha_fallecimiento DATE, 
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

CREATE TABLE EQUIPO(
 id BIGINT NOT NULL,
 nombre VARCHAR NOT NULL,
 foto BYTEA NOT NULL,
 nacionalidad VARCHAR NOT NULL,
 fk_marca_auto_id BIGINT,
 fk_vehiculo_id BIGINT,
 PRIMARY KEY(id)
);

CREATE TABLE VEHICULO(
 id BIGINT NOT NULL,
 nombre VARCHAR NOT NULL,
 tipo VARCHAR NOT NULL,
 fk_marca_auto_id BIGINT NOT NULL,
 PRIMARY KEY (id)
);

CREATE TABLE V_M(
fk_motor_id BIGINT NOT NULL,
fk_vehiculo_id BIGINT NOT NULL,
PRIMARY KEY(fk_motor_id,fk_vehiculo_id)
);

CREATE TABLE MOTOR(
    id BIGINT NOT NULL,
    nombre VARCHAR NOT NULL,
    cilindraje VARCHAR NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE INVENTARIO(
 id BIGINT NOT NULL,
 producto VARCHAR[][] NOT NULL,
 cantidad BIGINT NOT NULL,
 fk_equipo_id BIGINT NOT NULL,
 PRIMARY KEY(id)
);

CREATE TABLE PILOTO(
 id BIGINT NOT NULL,
 identificacion  NOMBRE NOT NULL,
 foto BYTEA NOT NULL,
 lugar_nacimiento VARCHAR NOT NULL,
 nacionalidad VARCHAR() NOT NULL,
 genero VARCHAR NOT NULL,
 coeficientes Varchar[][] NOT NULL,
 PRIMARY KEY(id)
);

CREATE TABLE SECCION(
 id BIGINT NOT NULL,
 nombre VARCHAR NOT NULL,
 dificultad VARCHAR NOT NULL,
 ancho_sec VARCHAR NOT NULL,
 PRIMARY KEY(id)
)

CREATE TABLE EVENTO(
 id BIGINT NOT NULL,
 ano DATE NOT NULL,
 tipo VARCHAR,
 PRIMARY KEY(id)
)

CREATE TABLE PISTA(
    id BIGINT NOT NULL,
    nombre VARCHAR NOT NULL,
    fk_evento_id BIGINT,
    PRIMARY KEY (id)
)

CREATE TABLE P_S(
 fk_seccion_id BIGINT,
 fk_pista_id BIGINT,
 PRIMARY KEY(pk_seccion_id,pk_pista_id)
)

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
)

CREATE TABLE E_P(
 fk_piloto_id BIGINT NOT NULL,
 fk_equipo_id BIGINT NOT NULL,
 PRIMARY KEY(fk_piloto_id,fk_suceso_id)
);

CREATE TABLE S_P(
 fk_suceso_id BIGINT NOT NULL,
 fk_piloto_id BIGINT NOT NULL,
 PRIMARY KEY(fk_suceso_id,fk_piloto)
)