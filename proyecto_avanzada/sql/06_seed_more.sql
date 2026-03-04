USE escuela;

INSERT IGNORE INTO carreras (nombre) VALUES
('Administracion'),
('Derecho'),
('Ingenieria Industrial');

INSERT IGNORE INTO periodos (nombre, fecha_inicio, fecha_fin) VALUES
('2025-2','2025-08-11','2025-12-12'),
('2026-2','2026-08-10','2026-12-11');

INSERT IGNORE INTO materias (clave, nombre, creditos, id_carrera)
SELECT 'ALGO1', 'Algoritmos I', 8, c.id_carrera FROM carreras c WHERE c.nombre = 'Ingenieria en Software'
UNION ALL
SELECT 'WEB1', 'Desarrollo Web I', 7, c.id_carrera FROM carreras c WHERE c.nombre = 'Ingenieria en Software'
UNION ALL
SELECT 'RED1', 'Redes I', 7, c.id_carrera FROM carreras c WHERE c.nombre = 'Ingenieria en Software'
UNION ALL
SELECT 'ADM1', 'Administracion I', 7, c.id_carrera FROM carreras c WHERE c.nombre = 'Administracion'
UNION ALL
SELECT 'DER1', 'Introduccion al Derecho', 7, c.id_carrera FROM carreras c WHERE c.nombre = 'Derecho'
UNION ALL
SELECT 'IND1', 'Procesos Industriales', 8, c.id_carrera FROM carreras c WHERE c.nombre = 'Ingenieria Industrial';

INSERT IGNORE INTO aulas (edificio, nombre_aula, capacidad)
SELECT 'C', CONCAT('C', seq.n), 25 + MOD(seq.n, 30)
FROM (
  SELECT ROW_NUMBER() OVER (ORDER BY table_schema, table_name, column_name) AS n
  FROM information_schema.columns
  LIMIT 400
) seq;

INSERT IGNORE INTO alumnos (matricula, nombre, apellidos, correo, telefono, fecha_nacimiento, estatus)
SELECT
  CONCAT('A', LPAD(seq.n, 5, '0')),
  CASE MOD(seq.n, 50)
    WHEN 0 THEN 'Juan' WHEN 1 THEN 'Maria' WHEN 2 THEN 'Carlos' WHEN 3 THEN 'Ana' WHEN 4 THEN 'Luis'
    WHEN 5 THEN 'Rosa' WHEN 6 THEN 'Miguel' WHEN 7 THEN 'Isabel' WHEN 8 THEN 'Antonio' WHEN 9 THEN 'Carmen'
    WHEN 10 THEN 'Francisco' WHEN 11 THEN 'Dolores' WHEN 12 THEN 'Manuel' WHEN 13 THEN 'Pilar' WHEN 14 THEN 'Diego'
    WHEN 15 THEN 'Lucia' WHEN 16 THEN 'Rafael' WHEN 17 THEN 'Josefina' WHEN 18 THEN 'Pedro' WHEN 19 THEN 'Francisca'
    WHEN 20 THEN 'Javier' WHEN 21 THEN 'Antonia' WHEN 22 THEN 'Enrique' WHEN 23 THEN 'Consuelo' WHEN 24 THEN 'Andres'
    WHEN 25 THEN 'Esperanza' WHEN 26 THEN 'Ruben' WHEN 27 THEN 'Margarita' WHEN 28 THEN 'Guillermo' WHEN 29 THEN 'Soledad'
    WHEN 30 THEN 'Alfredo' WHEN 31 THEN 'Amparo' WHEN 32 THEN 'Arturo' WHEN 33 THEN 'Beatriz' WHEN 34 THEN 'Benito'
    WHEN 35 THEN 'Blanca' WHEN 36 THEN 'Cesar' WHEN 37 THEN 'Catalina' WHEN 38 THEN 'Cristobal' WHEN 39 THEN 'Concepcion'
    WHEN 40 THEN 'Domingo' WHEN 41 THEN 'Dolores' WHEN 42 THEN 'Eduardo' WHEN 43 THEN 'Elena' WHEN 44 THEN 'Emilio'
    WHEN 45 THEN 'Encarnacion' WHEN 46 THEN 'Esteban' WHEN 47 THEN 'Estela' WHEN 48 THEN 'Eugenio' WHEN 49 THEN 'Eugenia'
  END AS nombre,
  CASE MOD(seq.n, 40)
    WHEN 0 THEN 'Garcia' WHEN 1 THEN 'Rodriguez' WHEN 2 THEN 'Martinez' WHEN 3 THEN 'Hernandez' WHEN 4 THEN 'Lopez'
    WHEN 5 THEN 'Gonzalez' WHEN 6 THEN 'Sanchez' WHEN 7 THEN 'Perez' WHEN 8 THEN 'Torres' WHEN 9 THEN 'Ramirez'
    WHEN 10 THEN 'Flores' WHEN 11 THEN 'Rivera' WHEN 12 THEN 'Morales' WHEN 13 THEN 'Gutierrez' WHEN 14 THEN 'Vargas'
    WHEN 15 THEN 'Castillo' WHEN 16 THEN 'Romero' WHEN 17 THEN 'Herrera' WHEN 18 THEN 'Medina' WHEN 19 THEN 'Vega'
    WHEN 20 THEN 'Soto' WHEN 21 THEN 'Fuentes' WHEN 22 THEN 'Campos' WHEN 23 THEN 'Dominguez' WHEN 24 THEN 'Reyes'
    WHEN 25 THEN 'Ruiz' WHEN 26 THEN 'Ortiz' WHEN 27 THEN 'Jimenez' WHEN 28 THEN 'Diaz' WHEN 29 THEN 'Cruz'
    WHEN 30 THEN 'Rojas' WHEN 31 THEN 'Acosta' WHEN 32 THEN 'Aguilar' WHEN 33 THEN 'Alonso' WHEN 34 THEN 'Alvarez'
    WHEN 35 THEN 'Arellano' WHEN 36 THEN 'Arenas' WHEN 37 THEN 'Arias' WHEN 38 THEN 'Armenta' WHEN 39 THEN 'Arriaga'
  END AS apellidos,
  CONCAT(
    LOWER(SUBSTRING(CASE MOD(seq.n, 50)
      WHEN 0 THEN 'Juan' WHEN 1 THEN 'Maria' WHEN 2 THEN 'Carlos' WHEN 3 THEN 'Ana' WHEN 4 THEN 'Luis'
      WHEN 5 THEN 'Rosa' WHEN 6 THEN 'Miguel' WHEN 7 THEN 'Isabel' WHEN 8 THEN 'Antonio' WHEN 9 THEN 'Carmen'
      WHEN 10 THEN 'Francisco' WHEN 11 THEN 'Dolores' WHEN 12 THEN 'Manuel' WHEN 13 THEN 'Pilar' WHEN 14 THEN 'Diego'
      WHEN 15 THEN 'Lucia' WHEN 16 THEN 'Rafael' WHEN 17 THEN 'Josefina' WHEN 18 THEN 'Pedro' WHEN 19 THEN 'Francisca'
      WHEN 20 THEN 'Javier' WHEN 21 THEN 'Antonia' WHEN 22 THEN 'Enrique' WHEN 23 THEN 'Consuelo' WHEN 24 THEN 'Andres'
      WHEN 25 THEN 'Esperanza' WHEN 26 THEN 'Ruben' WHEN 27 THEN 'Margarita' WHEN 28 THEN 'Guillermo' WHEN 29 THEN 'Soledad'
      WHEN 30 THEN 'Alfredo' WHEN 31 THEN 'Amparo' WHEN 32 THEN 'Arturo' WHEN 33 THEN 'Beatriz' WHEN 34 THEN 'Benito'
      WHEN 35 THEN 'Blanca' WHEN 36 THEN 'Cesar' WHEN 37 THEN 'Catalina' WHEN 38 THEN 'Cristobal' WHEN 39 THEN 'Concepcion'
      WHEN 40 THEN 'Domingo' WHEN 41 THEN 'Dolores' WHEN 42 THEN 'Eduardo' WHEN 43 THEN 'Elena' WHEN 44 THEN 'Emilio'
      WHEN 45 THEN 'Encarnacion' WHEN 46 THEN 'Esteban' WHEN 47 THEN 'Estela' WHEN 48 THEN 'Eugenio' WHEN 49 THEN 'Eugenia'
    END, 1, 1)),
    '.',
    LOWER(SUBSTRING(CASE MOD(seq.n, 40)
      WHEN 0 THEN 'Garcia' WHEN 1 THEN 'Rodriguez' WHEN 2 THEN 'Martinez' WHEN 3 THEN 'Hernandez' WHEN 4 THEN 'Lopez'
      WHEN 5 THEN 'Gonzalez' WHEN 6 THEN 'Sanchez' WHEN 7 THEN 'Perez' WHEN 8 THEN 'Torres' WHEN 9 THEN 'Ramirez'
      WHEN 10 THEN 'Flores' WHEN 11 THEN 'Rivera' WHEN 12 THEN 'Morales' WHEN 13 THEN 'Gutierrez' WHEN 14 THEN 'Vargas'
      WHEN 15 THEN 'Castillo' WHEN 16 THEN 'Romero' WHEN 17 THEN 'Herrera' WHEN 18 THEN 'Medina' WHEN 19 THEN 'Vega'
      WHEN 20 THEN 'Soto' WHEN 21 THEN 'Fuentes' WHEN 22 THEN 'Campos' WHEN 23 THEN 'Dominguez' WHEN 24 THEN 'Reyes'
      WHEN 25 THEN 'Ruiz' WHEN 26 THEN 'Ortiz' WHEN 27 THEN 'Jimenez' WHEN 28 THEN 'Diaz' WHEN 29 THEN 'Cruz'
      WHEN 30 THEN 'Rojas' WHEN 31 THEN 'Acosta' WHEN 32 THEN 'Aguilar' WHEN 33 THEN 'Alonso' WHEN 34 THEN 'Alvarez'
      WHEN 35 THEN 'Arellano' WHEN 36 THEN 'Arenas' WHEN 37 THEN 'Arias' WHEN 38 THEN 'Armenta' WHEN 39 THEN 'Arriaga'
    END, 1, 5)),
    seq.n,
    '@uni.mx'
  ) AS correo,
  CONCAT('55', LPAD(MOD(seq.n * 13, 99999999), 8, '0')) AS telefono,
  DATE_ADD('2003-01-01', INTERVAL MOD(seq.n * 17, 730) DAY) AS fecha_nacimiento,
  'Activo'
FROM (
  SELECT (ROW_NUMBER() OVER (ORDER BY t.table_schema, t.table_name, c.table_schema, c.table_name, c.column_name) + 3) AS n
  FROM information_schema.tables t
  JOIN information_schema.columns c
  LIMIT 4997
) seq;

INSERT IGNORE INTO docentes (num_empleado, nombre, apellidos, correo)
SELECT
  CONCAT('D', seq.n),
  CASE MOD(seq.n, 30)
    WHEN 0 THEN 'Dr. Juan' WHEN 1 THEN 'Dra. Maria' WHEN 2 THEN 'Dr. Carlos' WHEN 3 THEN 'Dra. Ana' WHEN 4 THEN 'Dr. Luis'
    WHEN 5 THEN 'Dra. Rosa' WHEN 6 THEN 'Dr. Miguel' WHEN 7 THEN 'Dra. Isabel' WHEN 8 THEN 'Dr. Antonio' WHEN 9 THEN 'Dra. Carmen'
    WHEN 10 THEN 'Dr. Francisco' WHEN 11 THEN 'Dra. Dolores' WHEN 12 THEN 'Dr. Manuel' WHEN 13 THEN 'Dra. Pilar' WHEN 14 THEN 'Dr. Diego'
    WHEN 15 THEN 'Dra. Lucia' WHEN 16 THEN 'Dr. Rafael' WHEN 17 THEN 'Dra. Josefina' WHEN 18 THEN 'Dr. Pedro' WHEN 19 THEN 'Dra. Francisca'
    WHEN 20 THEN 'Dr. Javier' WHEN 21 THEN 'Dra. Antonia' WHEN 22 THEN 'Dr. Enrique' WHEN 23 THEN 'Dra. Consuelo' WHEN 24 THEN 'Dr. Andres'
    WHEN 25 THEN 'Dra. Esperanza' WHEN 26 THEN 'Dr. Ruben' WHEN 27 THEN 'Dra. Margarita' WHEN 28 THEN 'Dr. Guillermo' WHEN 29 THEN 'Dra. Soledad'
  END AS nombre,
  CASE MOD(seq.n, 35)
    WHEN 0 THEN 'Garcia' WHEN 1 THEN 'Rodriguez' WHEN 2 THEN 'Martinez' WHEN 3 THEN 'Hernandez' WHEN 4 THEN 'Lopez'
    WHEN 5 THEN 'Gonzalez' WHEN 6 THEN 'Sanchez' WHEN 7 THEN 'Perez' WHEN 8 THEN 'Torres' WHEN 9 THEN 'Ramirez'
    WHEN 10 THEN 'Flores' WHEN 11 THEN 'Rivera' WHEN 12 THEN 'Morales' WHEN 13 THEN 'Gutierrez' WHEN 14 THEN 'Vargas'
    WHEN 15 THEN 'Castillo' WHEN 16 THEN 'Romero' WHEN 17 THEN 'Herrera' WHEN 18 THEN 'Medina' WHEN 19 THEN 'Vega'
    WHEN 20 THEN 'Soto' WHEN 21 THEN 'Fuentes' WHEN 22 THEN 'Campos' WHEN 23 THEN 'Dominguez' WHEN 24 THEN 'Reyes'
    WHEN 25 THEN 'Ruiz' WHEN 26 THEN 'Ortiz' WHEN 27 THEN 'Jimenez' WHEN 28 THEN 'Diaz' WHEN 29 THEN 'Cruz'
    WHEN 30 THEN 'Rojas' WHEN 31 THEN 'Acosta' WHEN 32 THEN 'Aguilar' WHEN 33 THEN 'Alonso' WHEN 34 THEN 'Alvarez'
  END AS apellidos,
  CONCAT(
    LOWER(SUBSTRING(CASE MOD(seq.n, 30)
      WHEN 0 THEN 'Juan' WHEN 1 THEN 'Maria' WHEN 2 THEN 'Carlos' WHEN 3 THEN 'Ana' WHEN 4 THEN 'Luis'
      WHEN 5 THEN 'Rosa' WHEN 6 THEN 'Miguel' WHEN 7 THEN 'Isabel' WHEN 8 THEN 'Antonio' WHEN 9 THEN 'Carmen'
      WHEN 10 THEN 'Francisco' WHEN 11 THEN 'Dolores' WHEN 12 THEN 'Manuel' WHEN 13 THEN 'Pilar' WHEN 14 THEN 'Diego'
      WHEN 15 THEN 'Lucia' WHEN 16 THEN 'Rafael' WHEN 17 THEN 'Josefina' WHEN 18 THEN 'Pedro' WHEN 19 THEN 'Francisca'
      WHEN 20 THEN 'Javier' WHEN 21 THEN 'Antonia' WHEN 22 THEN 'Enrique' WHEN 23 THEN 'Consuelo' WHEN 24 THEN 'Andres'
      WHEN 25 THEN 'Esperanza' WHEN 26 THEN 'Ruben' WHEN 27 THEN 'Margarita' WHEN 28 THEN 'Guillermo' WHEN 29 THEN 'Soledad'
    END, 1, 1)),
    '.',
    LOWER(SUBSTRING(CASE MOD(seq.n, 35)
      WHEN 0 THEN 'Garcia' WHEN 1 THEN 'Rodriguez' WHEN 2 THEN 'Martinez' WHEN 3 THEN 'Hernandez' WHEN 4 THEN 'Lopez'
      WHEN 5 THEN 'Gonzalez' WHEN 6 THEN 'Sanchez' WHEN 7 THEN 'Perez' WHEN 8 THEN 'Torres' WHEN 9 THEN 'Ramirez'
      WHEN 10 THEN 'Flores' WHEN 11 THEN 'Rivera' WHEN 12 THEN 'Morales' WHEN 13 THEN 'Gutierrez' WHEN 14 THEN 'Vargas'
      WHEN 15 THEN 'Castillo' WHEN 16 THEN 'Romero' WHEN 17 THEN 'Herrera' WHEN 18 THEN 'Medina' WHEN 19 THEN 'Vega'
      WHEN 20 THEN 'Soto' WHEN 21 THEN 'Fuentes' WHEN 22 THEN 'Campos' WHEN 23 THEN 'Dominguez' WHEN 24 THEN 'Reyes'
      WHEN 25 THEN 'Ruiz' WHEN 26 THEN 'Ortiz' WHEN 27 THEN 'Jimenez' WHEN 28 THEN 'Diaz' WHEN 29 THEN 'Cruz'
      WHEN 30 THEN 'Rojas' WHEN 31 THEN 'Acosta' WHEN 32 THEN 'Aguilar' WHEN 33 THEN 'Alonso' WHEN 34 THEN 'Alvarez'
    END, 1, 5)),
    seq.n,
    '@uni.mx'
  ) AS correo
FROM (
  SELECT (ROW_NUMBER() OVER (ORDER BY t.table_schema, t.table_name, c.table_schema, c.table_name, c.column_name) + 101) AS n
  FROM information_schema.tables t
  JOIN information_schema.columns c
  LIMIT 399
) seq;

INSERT INTO grupos (id_materia, id_docente, id_periodo, clave_grupo, cupo_max)
SELECT
  m.id_materia,
  (
    SELECT d.id_docente
    FROM (
      SELECT id_docente, ROW_NUMBER() OVER (ORDER BY id_docente) AS rn
      FROM docentes
    ) d
    CROSS JOIN (SELECT COUNT(*) AS c FROM docentes) dc
    WHERE d.rn = (MOD(m.rn + p.rn + ASCII(l.clave) - 65, dc.c) + 1)
  ) AS id_docente,
  p.id_periodo,
  l.clave,
  100
FROM (
  SELECT id_materia, ROW_NUMBER() OVER (ORDER BY id_materia) AS rn
  FROM materias
) m
CROSS JOIN (
  SELECT id_periodo, ROW_NUMBER() OVER (ORDER BY id_periodo) AS rn
  FROM periodos
  WHERE nombre IN ('2026-1', '2026-2')
) p
CROSS JOIN (
  SELECT 'A' AS clave
  UNION ALL SELECT 'B'
  UNION ALL SELECT 'C'
  UNION ALL SELECT 'D'
  UNION ALL SELECT 'E'
  UNION ALL SELECT 'F'
  UNION ALL SELECT 'G'
  UNION ALL SELECT 'H'
) l
WHERE NOT EXISTS (
  SELECT 1
  FROM grupos g
  WHERE g.id_materia = m.id_materia
    AND g.id_periodo = p.id_periodo
    AND g.clave_grupo = l.clave
);

UPDATE grupos
SET cupo_max = 300
WHERE cupo_max < 300;

DELETE h
FROM horarios h
JOIN aulas a ON a.id_aula = h.id_aula
JOIN grupos g ON g.id_grupo = h.id_grupo
JOIN periodos p ON p.id_periodo = g.id_periodo
WHERE a.edificio = 'C'
  AND p.nombre IN ('2026-1', '2026-2');

INSERT INTO horarios (id_grupo, id_aula, dia_semana, hora_inicio, hora_fin)
SELECT
  grp.id_grupo,
  a.id_aula,
  MOD(grp.idx, 5) + 1 AS dia_semana,
  CASE MOD(FLOOR(grp.idx / 5), 5)
    WHEN 0 THEN '08:00:00'
    WHEN 1 THEN '10:00:00'
    WHEN 2 THEN '12:00:00'
    WHEN 3 THEN '14:00:00'
    WHEN 4 THEN '16:00:00'
  END AS hora_inicio,
  CASE MOD(FLOOR(grp.idx / 5), 5)
    WHEN 0 THEN '10:00:00'
    WHEN 1 THEN '12:00:00'
    WHEN 2 THEN '14:00:00'
    WHEN 3 THEN '16:00:00'
    WHEN 4 THEN '18:00:00'
  END AS hora_fin
FROM (
  SELECT 
    g.id_grupo,
    ((g.id_grupo - 1) * 2 + s.ses) AS idx
  FROM grupos g
  CROSS JOIN (SELECT 0 AS ses UNION ALL SELECT 1) s
  JOIN periodos p ON p.id_periodo = g.id_periodo
  WHERE p.nombre IN ('2026-1', '2026-2')
) grp
JOIN (
  SELECT id_aula, ROW_NUMBER() OVER (ORDER BY id_aula) AS rn
  FROM aulas
  WHERE edificio = 'C'
) a
  ON a.rn = (FLOOR(grp.idx / 25) + 1);

INSERT IGNORE INTO inscripciones (id_alumno, id_grupo, fecha_inscripcion)
SELECT
  a.id_alumno,
  g2.id_grupo,
  '2026-01-10'
FROM alumnos a
CROSS JOIN (
  SELECT 0 AS n
  UNION ALL SELECT 1
  UNION ALL SELECT 2
  UNION ALL SELECT 3
  UNION ALL SELECT 4
  UNION ALL SELECT 5
) nums
CROSS JOIN (
  SELECT COUNT(*) AS c
  FROM grupos g
  JOIN periodos p ON p.id_periodo = g.id_periodo
  WHERE p.nombre IN ('2026-1', '2026-2')
) gc
JOIN (
  SELECT g.id_grupo, ROW_NUMBER() OVER (ORDER BY g.id_grupo) AS rn
  FROM grupos g
  JOIN periodos p ON p.id_periodo = g.id_periodo
  WHERE p.nombre IN ('2026-1', '2026-2')
) g2
  ON g2.rn = (MOD(a.id_alumno * 7 + nums.n, gc.c) + 1)
WHERE a.id_alumno BETWEEN 1 AND 5000;

INSERT INTO evaluaciones (id_grupo, nombre, porcentaje)
SELECT g.id_grupo, t.nombre, t.porcentaje
FROM grupos g
CROSS JOIN (
  SELECT 'Parcial 1' AS nombre, 30 AS porcentaje
  UNION ALL SELECT 'Parcial 2', 30
  UNION ALL SELECT 'Final', 40
) t
WHERE NOT EXISTS (SELECT 1 FROM evaluaciones e WHERE e.id_grupo = g.id_grupo);

INSERT INTO calificaciones (id_inscripcion, id_evaluacion, calificacion)
SELECT
  i.id_inscripcion,
  e.id_evaluacion,
  (60 + MOD(i.id_inscripcion * 7 + e.id_evaluacion * 3, 41))
FROM inscripciones i
JOIN evaluaciones e ON e.id_grupo = i.id_grupo
LEFT JOIN calificaciones c
  ON c.id_inscripcion = i.id_inscripcion
 AND c.id_evaluacion = e.id_evaluacion
WHERE c.id_calificacion IS NULL;

INSERT IGNORE INTO pagos (id_alumno, id_periodo, concepto, monto, fecha_pago, referencia)
SELECT
  a.id_alumno,
  p.id_periodo,
  'Inscripcion',
  1500.00,
  p.fecha_inicio,
  CONCAT('PAY-', p.nombre, '-', a.id_alumno, '-I')
FROM alumnos a
JOIN periodos p ON p.nombre IN ('2026-1', '2026-2');

INSERT IGNORE INTO pagos (id_alumno, id_periodo, concepto, monto, fecha_pago, referencia)
SELECT
  a.id_alumno,
  p.id_periodo,
  'Colegiatura',
  1200.00,
  DATE_ADD(p.fecha_inicio, INTERVAL 20 DAY),
  CONCAT('PAY-', p.nombre, '-', a.id_alumno, '-C')
FROM alumnos a
JOIN periodos p ON p.nombre IN ('2026-1', '2026-2');
