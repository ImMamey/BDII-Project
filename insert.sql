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
    (1,'Curva Dunlop',4,5)
    (2,'S de Tertre Rouge',6,3)
    (3,'Giro de Tertre Rouge',5,3)
    (4,'Curva de Antares',3,3)
    (5,'Hunaudiéres',1,3)
    (6,'Curva de Hunaudiéres',2,2)
    (7,'Giro de Mulsanne',10,2)
    (8,'Curva de Golf',5,2)
    (9,'Indianapolis',8,1)
    (10,'Giro de Amage',6,1)
    (11,'Curva de Buisson',7,1)
    (12,'Maison Blanche',7,3)
    (13,'Maison Blanche (Post choque)',6,3)