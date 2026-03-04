USE escuela;

INSERT INTO docentes (num_empleado, nombre, apellidos, correo) VALUES
('D100','Laura','Gomez','laura.gomez@uni.mx'),
('D101','Ruben','Santos','ruben.santos@uni.mx');

INSERT INTO periodos (nombre, fecha_inicio, fecha_fin) VALUES
('2026-1','2026-01-13','2026-06-20');

INSERT INTO aulas (edificio, nombre_aula, capacidad) VALUES
('A','A1',35),
('A','A2',40),
('B','B1',25);

INSERT INTO materias (clave, nombre) VALUES
('BDAV','Base de Datos Avanzada'),
('PROG2','Programacion II'),
('CONTA1','Contabilidad I');

INSERT INTO carreras (nombre, id_materia) VALUES
('Ingenieria en Software',1),
('Contaduria',3);

INSERT INTO alumnos (nombre, apellidos, correo, telefono, fecha_nacimiento, estatus) VALUES
('Emanuel','Lopez','emanuel@uni.mx','5551112233','2004-05-10','Activo'),
('Maria','Hernandez','maria@uni.mx','5552223344','2004-08-21','Activo'),
('Carlos','Perez','carlos@uni.mx','5553334455','2003-11-03','Activo');

INSERT INTO cursos (id_materia, creditos, id_docente, id_periodo, cupo_max, esta_lleno) VALUES
(1,8,1,1,30,0),
(2,8,2,1,35,0),
(3,7,1,1,25,0);

INSERT INTO horarios (id_curso, id_aula, dia_semana, hora_inicio, hora_fin) VALUES
(1,1,2,'10:00:00','12:00:00'),
(1,1,4,'10:00:00','12:00:00'),
(2,2,1,'08:00:00','10:00:00'),
(3,3,3,'12:00:00','14:00:00');

INSERT INTO evaluaciones (id_curso, calificacion, porcentaje) VALUES
(1,85,30),
(1,90,30),
(1,88,40),
(2,92,50),
(2,89,50);

INSERT INTO inscripciones (id_alumno, tipo, id_carrera, id_curso, fecha_inscripcion) VALUES
(1,'carrera',1,NULL,'2026-01-10'),
(2,'carrera',1,NULL,'2026-01-10'),
(3,'carrera',2,NULL,'2026-01-10'),
(1,'curso',NULL,1,'2026-01-10'),
(2,'curso',NULL,1,'2026-01-10'),
(3,'curso',NULL,2,'2026-01-10');

INSERT INTO pagos (id_alumno, id_periodo, concepto, monto, fecha_pago, referencia) VALUES
(1,1,'Inscripcion',1500,'2026-01-09','REF-0001'),
(1,1,'Colegiatura Enero',1200,'2026-01-20','REF-0002'),
(2,1,'Inscripcion',1500,'2026-01-09','REF-0003');
