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

INSERT INTO facultades (nombre, clave) VALUES
('Facultad de Ingenieria','FING'),
('Facultad de Contaduria','FCON');

INSERT INTO materias (clave, nombre, creditos) VALUES
('BDAV','Base de Datos Avanzada',8),
('PROG2','Programacion II',8),
('CONTA1','Contabilidad I',7);

INSERT INTO carreras (nombre, id_facultad) VALUES
('Ingenieria en Software',1),
('Contaduria',2);

INSERT INTO carreras_materias (id_carrera, id_materia) VALUES
(1,1),
(1,2),
(2,3);

INSERT INTO alumnos (nombre, apellidos, correo, telefono, fecha_nacimiento, estatus) VALUES
('Emanuel','Lopez','emanuel@uni.mx','5551112233','2004-05-10','Activo'),
('Maria','Hernandez','maria@uni.mx','5552223344','2004-08-21','Activo'),
('Carlos','Perez','carlos@uni.mx','5553334455','2003-11-03','Activo');

INSERT INTO cursos (id_materia, id_docente, id_periodo, cupo_max, esta_lleno) VALUES
(1,1,1,30,0),
(2,2,1,35,0),
(3,1,1,25,0);

INSERT INTO horarios (id_curso, id_aula, dia_semana, hora_inicio, hora_fin) VALUES
(1,1,2,'10:00:00','12:00:00'),
(1,1,4,'10:00:00','12:00:00'),
(2,2,1,'08:00:00','10:00:00'),
(3,3,3,'12:00:00','14:00:00');

-- Evaluaciones: periodos por curso (nombre, porcentaje, orden). Suma = 100%
-- Curso 1 (BDAV): 3 parciales 33.33% c/u
INSERT INTO evaluaciones (id_curso, nombre, porcentaje, orden) VALUES
(1,'Parcial 1',33.33,1),
(1,'Parcial 2',33.33,2),
(1,'Parcial 3',33.34,3);
-- Curso 2 (PROG2): 2 evaluaciones 50% c/u
INSERT INTO evaluaciones (id_curso, nombre, porcentaje, orden) VALUES
(2,'Parcial 1',50.00,1),
(2,'Parcial 2',50.00,2);
-- Curso 3 (CONTA1): 3 parciales
INSERT INTO evaluaciones (id_curso, nombre, porcentaje, orden) VALUES
(3,'Parcial 1',33.33,1),
(3,'Parcial 2',33.33,2),
(3,'Final',33.34,3);

INSERT INTO inscripciones (id_alumno, tipo, id_carrera, id_curso, fecha_inscripcion) VALUES
(1,'carrera',1,NULL,'2026-01-10'),
(2,'carrera',1,NULL,'2026-01-10'),
(3,'carrera',2,NULL,'2026-01-10'),
(1,'curso',NULL,1,'2026-01-10'),
(2,'curso',NULL,1,'2026-01-10'),
(3,'curso',NULL,2,'2026-01-10');

-- Calificaciones: nota de cada alumno en cada evaluacion
-- Inscripcion 4 = alumno 1 en curso 1 (BDAV). Evaluaciones 1,2,3
-- Inscripcion 5 = alumno 2 en curso 1 (BDAV). Evaluaciones 1,2,3
-- Inscripcion 6 = alumno 3 en curso 2 (PROG2). Evaluaciones 4,5
INSERT INTO calificaciones (id_inscripcion, id_evaluacion, calificacion) VALUES
(4,1,85),
(4,2,90),
(4,3,88),
(5,1,72),
(5,2,78),
(5,3,80),
(6,4,92),
(6,5,89);

INSERT INTO cargos (id_alumno, id_periodo, monto, concepto, referencia, fecha_vencimiento, estado) VALUES
(1,1,1500,'Inscripcion','CAR-0001','2026-01-13','pagado'),
(1,1,1200,'Colegiatura Enero','CAR-0002','2026-01-31','pagado'),
(2,1,1500,'Inscripcion','CAR-0003','2026-01-13','pagado'),
(3,1,1200,'Colegiatura Enero','CAR-0004','2026-01-31','pendiente');

INSERT INTO pagos (id_alumno, id_periodo, id_concepto, monto, fecha_pago, referencia) VALUES
(1,1,(SELECT id_cargo FROM cargos WHERE referencia = 'CAR-0001'),1500,'2026-01-09','REF-0001'),
(1,1,(SELECT id_cargo FROM cargos WHERE referencia = 'CAR-0002'),1200,'2026-01-20','REF-0002'),
(2,1,(SELECT id_cargo FROM cargos WHERE referencia = 'CAR-0003'),1500,'2026-01-09','REF-0003');
