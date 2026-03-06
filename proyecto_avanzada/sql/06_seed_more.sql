USE escuela;

-- Mas facultades y carreras
INSERT IGNORE INTO facultades (nombre, clave) VALUES
('Facultad de Derecho','FDER'),
('Facultad de Administracion','FADM');

INSERT IGNORE INTO carreras (nombre, id_facultad) VALUES
('Derecho',3),
('Administracion',4),
('Ingenieria Industrial',1);

-- Mas periodos
INSERT IGNORE INTO periodos (nombre, fecha_inicio, fecha_fin) VALUES
('2025-2','2025-08-11','2025-12-12'),
('2026-2','2026-08-10','2026-12-11');

-- Mas materias (con creditos)
INSERT IGNORE INTO materias (clave, nombre, creditos) VALUES
('ALGO1','Algoritmos I',8),
('WEB1','Desarrollo Web I',7),
('RED1','Redes I',7),
('ADM1','Administracion I',7),
('DER1','Introduccion al Derecho',7),
('IND1','Procesos Industriales',8);

-- Vincular materias a carreras (carreras_materias)
INSERT IGNORE INTO carreras_materias (id_carrera, id_materia)
SELECT 1, id_materia FROM materias WHERE clave IN ('ALGO1','WEB1','RED1');
INSERT IGNORE INTO carreras_materias (id_carrera, id_materia)
SELECT 2, id_materia FROM materias WHERE clave = 'CONTA1';
INSERT IGNORE INTO carreras_materias (id_carrera, id_materia)
SELECT 3, id_materia FROM materias WHERE clave = 'DER1';
INSERT IGNORE INTO carreras_materias (id_carrera, id_materia)
SELECT 4, id_materia FROM materias WHERE clave = 'ADM1';
INSERT IGNORE INTO carreras_materias (id_carrera, id_materia)
SELECT 5, id_materia FROM materias WHERE clave IN ('IND1','RED1');

-- Mas aulas
INSERT IGNORE INTO aulas (edificio, nombre_aula, capacidad) VALUES
('C','C1',30),
('C','C2',35),
('C','C3',25);

-- Mas cursos (sin columna creditos)
INSERT IGNORE INTO cursos (id_materia, id_docente, id_periodo, cupo_max, esta_lleno)
SELECT m.id_materia, 1, p.id_periodo, 40, 0
FROM materias m
CROSS JOIN periodos p
WHERE m.clave IN ('ALGO1','WEB1') AND p.nombre IN ('2026-1','2026-2')
LIMIT 4;

INSERT IGNORE INTO horarios (id_curso, id_aula, dia_semana, hora_inicio, hora_fin)
SELECT c.id_curso, 1, 1, '08:00:00', '10:00:00'
FROM cursos c
JOIN periodos p ON p.id_periodo = c.id_periodo
WHERE p.nombre = '2026-2'
LIMIT 2;

-- Evaluaciones para nuevos cursos (3 periodos, 33.33% c/u, orden 1-3)
INSERT IGNORE INTO evaluaciones (id_curso, nombre, porcentaje, orden)
SELECT c.id_curso, 'Parcial 1', 33.33, 1
FROM cursos c
JOIN periodos p ON p.id_periodo = c.id_periodo
WHERE p.nombre = '2026-2'
  AND NOT EXISTS (SELECT 1 FROM evaluaciones e WHERE e.id_curso = c.id_curso AND e.nombre = 'Parcial 1');
INSERT IGNORE INTO evaluaciones (id_curso, nombre, porcentaje, orden)
SELECT c.id_curso, 'Parcial 2', 33.33, 2
FROM cursos c
JOIN periodos p ON p.id_periodo = c.id_periodo
WHERE p.nombre = '2026-2'
  AND NOT EXISTS (SELECT 1 FROM evaluaciones e WHERE e.id_curso = c.id_curso AND e.nombre = 'Parcial 2');
INSERT IGNORE INTO evaluaciones (id_curso, nombre, porcentaje, orden)
SELECT c.id_curso, 'Parcial 3', 33.34, 3
FROM cursos c
JOIN periodos p ON p.id_periodo = c.id_periodo
WHERE p.nombre = '2026-2'
  AND NOT EXISTS (SELECT 1 FROM evaluaciones e WHERE e.id_curso = c.id_curso AND e.nombre = 'Parcial 3');

-- Pagos adicionales por periodo
INSERT IGNORE INTO pagos (id_alumno, id_periodo, concepto, monto, fecha_pago, referencia)
SELECT a.id_alumno, p.id_periodo, 'Inscripcion', 1500.00, p.fecha_inicio,
  CONCAT('PAY-', p.nombre, '-', a.id_alumno, '-I')
FROM alumnos a
CROSS JOIN periodos p
WHERE p.nombre IN ('2026-1','2026-2')
  AND NOT EXISTS (
    SELECT 1 FROM pagos pg
    WHERE pg.id_alumno = a.id_alumno AND pg.id_periodo = p.id_periodo AND pg.concepto = 'Inscripcion'
  );
