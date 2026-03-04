PRAGMA foreign_keys = ON;

INSERT INTO carreras (nombre) VALUES
('Ingenieria en Software'),
('Contaduria');

INSERT INTO alumnos (matricula, nombre, apellidos, correo, telefono, fecha_nacimiento, estatus) VALUES
('A001','Emanuel','Lopez','emanuel@uni.mx','5551112233','2004-05-10','Activo'),
('A002','Maria','Hernandez','maria@uni.mx','5552223344','2004-08-21','Activo'),
('A003','Carlos','Perez','carlos@uni.mx','5553334455','2003-11-03','Activo');

INSERT INTO docentes (num_empleado, nombre, apellidos, correo) VALUES
('D100','Laura','Gomez','laura.gomez@uni.mx'),
('D101','Ruben','Santos','ruben.santos@uni.mx');

INSERT INTO periodos (nombre, fecha_inicio, fecha_fin) VALUES
('2026-1','2026-01-13','2026-06-20');

INSERT INTO materias (clave, nombre, creditos, id_carrera) VALUES
('BDAV','Base de Datos Avanzada',8,1),
('PROG2','Programacion II',8,1),
('CONTA1','Contabilidad I',7,2);

INSERT INTO aulas (edificio, nombre_aula, capacidad) VALUES
('A','A1',35),
('A','A2',40),
('B','B1',25);

INSERT INTO grupos (id_materia, id_docente, id_periodo, clave_grupo, cupo_max) VALUES
(1,1,1,'A',30),
(2,2,1,'A',35),
(3,1,1,'A',25);

INSERT INTO horarios (id_grupo, id_aula, dia_semana, hora_inicio, hora_fin) VALUES
(1,1,2,'10:00','12:00'),
(1,1,4,'10:00','12:00'),
(2,2,1,'08:00','10:00'),
(3,3,3,'12:00','14:00');

INSERT INTO inscripciones (id_alumno, id_grupo, fecha_inscripcion) VALUES
(1,1,'2026-01-10'),
(2,1,'2026-01-10'),
(3,2,'2026-01-10');

INSERT INTO evaluaciones (id_grupo, nombre, porcentaje) VALUES
(1,'Parcial 1',30),
(1,'Parcial 2',30),
(1,'Final',40),
(2,'Proyecto',50),
(2,'Final',50);

INSERT INTO calificaciones (id_inscripcion, id_evaluacion, calificacion) VALUES
(1,1,85),
(1,2,90),
(1,3,88),
(2,1,70),
(2,2,75),
(2,3,80),
(3,4,92),
(3,5,89);

INSERT INTO pagos (id_alumno, id_periodo, concepto, monto, fecha_pago, referencia) VALUES
(1,1,'Inscripcion',1500,'2026-01-09','REF-0001'),
(1,1,'Colegiatura Enero',1200,'2026-01-20','REF-0002'),
(2,1,'Inscripcion',1500,'2026-01-09','REF-0003');
