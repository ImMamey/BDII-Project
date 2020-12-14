INSERT INTO MARCA_AUTO (id, nombre) VALUES
    (1,'HEALEY'),
    (2,'ASTON MARTIN')
    (3,'ALLARD')
    (4,'TALBOT')

INSERT INTO MOTOR (id, nombre, cilindraje) VALUES
    (1,'TALBOT L6',4483),
    (2,'CADILLAC V8',5434),
    (3,'NASH L6',3846),
    (4,'ASTON MARTIN L6',2581)

INSERT INTO VEHICULO (id, nombre, tipo, fk_marca_auto_id) VALUES
    (1,'TALBOT LAGO T 26 GS','NO HIBRIDO',4),
    (2,'TALBOT','NO HIBRIDO',4),
    (3,'ALLARD J2','NO HIBRIDO',3),
    (4,'HEALEY','NO HIBRIDO',1),
    (5,'ASTON MARTIN DB 2','NO HIBRIDO',2)

INSERT INTO V_M (fk_motor_id,fk_vehiculo_id) VALUES
    (1,1)
    (1,2)
    (2,3)
    (3,4)
    (4,5)

INSERT INTO EQUIPO (id, nombre, nacionalidad, fk_marca_auto_id,fk_vehiculo_id) VALUES
    (1,'L. Rosier','frances',4,1)
    (2,'P. Meyrat','frances',4,2)
    (3,'L. Rosier','frances',4,1)
    (4,'L. Rosier','frances',4,1)
    (5,'L. Rosier','frances',4,1)