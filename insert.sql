INSERT INTO MARCA_AUTO (id, nombre) VALUES
    (1,'HEALEY'),
    (2,'ASTON MARTIN'),
    (3,'ALLARD'),
    (4,'TALBOT');

INSERT INTO MOTOR (id, nombre, cilindraje) VALUES
    (1,'TALBOT L6',4483),
    (2,'CADILLAC V8',5434),
    (3,'NASH L6',3846),
    (4,'ASTON MARTIN L6',2581);

INSERT INTO VEHICULO (id, nombre, tipo, fk_marca_auto_id) VALUES
    (1,'TALBOT LAGO T 26 GS','NO HIBRIDO',4),
    (2,'TALBOT','NO HIBRIDO',4),
    (3,'ALLARD J2','NO HIBRIDO',3),
    (4,'HEALEY','NO HIBRIDO',1),
    (5,'ASTON MARTIN DB 2','NO HIBRIDO',2);

INSERT INTO V_M (fk_motor_id,fk_vehiculo_id) VALUES
    (1,1),
    (1,2),
    (2,3),
    (3,4),
    (4,5);

INSERT INTO EQUIPO (id, nombre, nacionalidad, fk_marca_auto_id,fk_v_m_vehiculo_id,fk_v_m_motor_id) VALUES
    (1,'L. Rosier','frances',4,1,1),
    (2,'P. Meyrat','frances',4,2,1),
    (3,'S. Allard','britanico',3,3,2),
    (4,'Healey motors company ltd','britanico',1,4,3),
    (5,'Aston Martin cars ltd','britanico',2,5,4);

INSERT INTO PISTA (id, nombre) VALUES
    (1,'1950-1955'),
    (2,'1956-1959');

INSERT INTO SECCION (id, nombre, dificultad, ancho_sec) VALUES
    (1,'Curva Dunlop',4,5),
    (2,'S de Tertre Rouge',6,3),
    (3,'Giro de Tertre Rouge',5,3),
    (4,'Curva de Antares',3,3),
    (5,'Hunaudiéres',1,3),
    (6,'Curva de Hunaudiéres',2,2),
    (7,'Giro de Mulsanne',10,2),
    (8,'Curva de Golf',5,2),
    (9,'Indianapolis',8,1),
    (10,'Giro de Amage',6,1),
    (11,'Curva de Buisson',7,1),
    (12,'Maison Blanche',7,3),
    (13,'Maison Blanche (Post choque)',6,3);

INSERT INTO P_S (fk_seccion_id,fk_pista_id) VALUES
    (1,1),
    (2,1),
    (3,1),
    (4,1),
    (5,1),
    (6,1),
    (7,1),
    (8,1),
    (9,1),
    (10,1),
    (11,1),
    (12,1),
    (1,2),
    (2,2),
    (3,2),
    (4,2),
    (5,2),
    (6,2),
    (7,2),
    (8,2),
    (9,2),
    (10,2),
    (11,2),
    (13,2);

INSERT INTO EVENTO (id, ano, tipo, fk_pista_id) VALUES
    (1,(24,6,1950),'Carrera',1),
    (2,(23,6,1951),'Carrera',1),
    (3,(14,6,1952),'Carrera',1),
    (4,(13,6,1953),'Carrera',1),
    (5,(12,6,1954),'Carrera',1),
    (6,(11,6,1955),'Carrera',1),
    (7,(28,7,1956),'Carrera',2),
    (8,(22,6,1957),'Carrera',2),
    (9,(21,6,1958),'Carrera',2),
    (10,(20,6,1959),'Carrera',2),
    (11,(23,6,1950),'Ensayo',1),
    (12,(22,6,1951),'Ensayo',1),
    (13,(13,6,1952),'Ensayo',1),
    (14,(12,6,1953),'Ensayo',1),
    (15,(11,6,1954),'Ensayo',1),
    (16,(10,6,1955),'Ensayo',1),
    (17,(27,7,1956),'Ensayo',2),
    (18,(21,6,1957),'Ensayo',2),
    (19,(20,6,1958),'Ensayo',2),
    (20,(19,6,1959),'Ensayo',2);


INSERT INTO E_P (fk_piloto_id, fk_equipo_id) VALUES
    (1,1),
    (2,1),
    (3,2),
    (4,2),
    (5,3),
    (6,3),
    (7,4),
    (8,4),
    (9,5),
    (10,5);

INSERT INTO RANKING (id, hora, puesto, velocidad_media, vuelta_rapida, numero_vuelta, distancia_km, fk_evento_id) VALUES
    (1,24,1,144.38,(4,53,3),256,3465.12,1),
    (2,24,2,143.337,(NULL,NULL,NULL),254,3440.09,1), 
    (3,24,3,141.21,(5,15,0),251,3389.05,1),
    (4,24,4,141.037,(5,19,00),250,3384.88,1),
    (5,24,5,140.427,(5,23,0),249,3370.24,1);

INSERT INTO E_R (categoria, numero_equipo, marca_cauchos, fk_ranking_id, foto, fk_ranking_evento_id, fk_e_p_fk_piloto_id, fk_e_p_fk_equipo_id) VALUES
    ()

INSERT INTO RANKING_HORA (fk_piloto_id, fk_equipo_id) VALUES
    ()
