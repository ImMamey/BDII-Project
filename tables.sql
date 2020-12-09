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
dia day,
mes month,
ano year
);

CREATE TYPE TIEMPO AS(
hora HOUR,
minuto MINUTE,
segundo SECOND
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
 nacionalidad VARCHAR NOT NULL,
 fk_marca_auto_id BIGINT,
 fk_vehiculo_id BIGINT,
 PRIMARY KEY(id)
);

CREATE TABLE VEHICULO(
 id BIGINT NOT NULL,
 nombre VARCHAR NOT NULL,
 foto BYTEA NOT NULL,
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
 nacionalidad VARCHAR[] NOT NULL,
 genero VARCHAR NOT NULL,
 coeficientes Varchar[][] NOT NULL,
 PRIMARY KEY(id)
);

CREATE TABLE SECCION(

)

CREATE TABLE E_P(
 fk_piloto_id BIGINT NOT NULL,
 fk_suceso_id BIGINT NOT NULL,
 PRIMARY KEY(fk_piloto_id,fk_suceso_id)
);