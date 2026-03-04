USE escuela;

DROP VIEW IF EXISTS vw_cursos_detalle;
DROP VIEW IF EXISTS vw_horario_curso;
DROP VIEW IF EXISTS vw_lista_curso;
DROP VIEW IF EXISTS vw_kardex;
DROP VIEW IF EXISTS vw_estado_cuenta;
DROP VIEW IF EXISTS vw_alumnos_carrera;
DROP VIEW IF EXISTS vw_docentes_cursos;
DROP VIEW IF EXISTS vw_resumen_pagos;

-- Vista con detalles de cursos (equivalente a vw_grupos_detalle)
CREATE VIEW vw_cursos_detalle AS
SELECT 
  c.id_curso,
  m.clave AS materia_clave,
  m.nombre AS materia_nombre,
  d.num_empleado,
  CONCAT(d.nombre, ' ', d.apellidos) AS docente,
  p.nombre AS periodo,
  c.creditos,
  c.cupo_max,
  IF(c.esta_lleno, 'SI', 'NO') AS esta_lleno
FROM cursos c
JOIN materias m ON m.id_materia = c.id_materia
JOIN docentes d ON d.id_docente = c.id_docente
JOIN periodos p ON p.id_periodo = c.id_periodo;

-- Vista de horarios por curso
CREATE VIEW vw_horario_curso AS
SELECT
  h.id_horario,
  h.id_curso,
  cd.materia_clave,
  cd.materia_nombre,
  cd.docente,
  cd.periodo,
  h.dia_semana,
  CASE h.dia_semana
    WHEN 1 THEN 'Lunes'
    WHEN 2 THEN 'Martes'
    WHEN 3 THEN 'Miércoles'
    WHEN 4 THEN 'Jueves'
    WHEN 5 THEN 'Viernes'
    WHEN 6 THEN 'Sábado'
    WHEN 7 THEN 'Domingo'
  END AS dia_nombre,
  h.hora_inicio,
  h.hora_fin,
  a.edificio,
  a.nombre_aula
FROM horarios h
JOIN vw_cursos_detalle cd ON cd.id_curso = h.id_curso
JOIN aulas a ON a.id_aula = h.id_aula;

-- Vista de lista de alumnos por curso
CREATE VIEW vw_lista_curso AS
SELECT
  i.id_curso,
  cd.materia_clave,
  cd.materia_nombre,
  cd.docente,
  cd.periodo,
  a.id_alumno,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  i.fecha_inscripcion
FROM inscripciones i
JOIN alumnos a ON a.id_alumno = i.id_alumno
JOIN vw_cursos_detalle cd ON cd.id_curso = i.id_curso
WHERE i.tipo = 'curso';

-- Vista de kardex (calificaciones por alumno)
CREATE VIEW vw_kardex AS
SELECT
  a.id_alumno,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  cr.nombre AS carrera,
  cd.periodo,
  cd.id_curso,
  cd.materia_clave,
  cd.materia_nombre,
  ROUND(AVG(e.calificacion), 2) AS calificacion_final,
  COUNT(e.id_evaluacion) AS num_evaluaciones
FROM alumnos a
JOIN inscripciones i ON i.id_alumno = a.id_alumno AND i.tipo = 'curso'
JOIN vw_cursos_detalle cd ON cd.id_curso = i.id_curso
JOIN evaluaciones e ON e.id_curso = i.id_curso
LEFT JOIN inscripciones ic ON ic.id_alumno = a.id_alumno AND ic.tipo = 'carrera'
LEFT JOIN carreras cr ON cr.id_carrera = ic.id_carrera
GROUP BY a.id_alumno, alumno, cr.nombre, cd.periodo, cd.id_curso, cd.materia_clave, cd.materia_nombre;

-- Vista de estado de cuenta (pagos por alumno)
CREATE VIEW vw_estado_cuenta AS
SELECT
  a.id_alumno,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  cr.nombre AS carrera,
  p.nombre AS periodo,
  COUNT(pg.id_pago) AS pagos_realizados,
  ROUND(IFNULL(SUM(pg.monto), 0), 2) AS total_pagado,
  CASE 
    WHEN COUNT(pg.id_pago) = 0 THEN 'SIN PAGOS'
    WHEN COUNT(pg.id_pago) < 3 THEN 'PARCIAL'
    ELSE 'COMPLETO'
  END AS estatus_pago
FROM alumnos a
CROSS JOIN periodos p
LEFT JOIN pagos pg ON pg.id_alumno = a.id_alumno AND pg.id_periodo = p.id_periodo
LEFT JOIN inscripciones ic ON ic.id_alumno = a.id_alumno AND ic.tipo = 'carrera'
LEFT JOIN carreras cr ON cr.id_carrera = ic.id_carrera
GROUP BY a.id_alumno, a.nombre, a.apellidos, cr.nombre, p.id_periodo, p.nombre;

-- Vista de alumnos por carrera
CREATE VIEW vw_alumnos_carrera AS
SELECT
  a.id_alumno,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  a.correo,
  a.telefono,
  a.estatus AS estatus_alumno,
  cr.nombre AS carrera,
  m.nombre AS materia_carrera,
  i.fecha_inscripcion AS fecha_inscripcion_carrera
FROM alumnos a
JOIN inscripciones i ON i.id_alumno = a.id_alumno AND i.tipo = 'carrera'
JOIN carreras cr ON cr.id_carrera = i.id_carrera
JOIN materias m ON m.id_materia = cr.id_materia;

-- Vista de docentes y sus cursos
CREATE VIEW vw_docentes_cursos AS
SELECT
  d.id_docente,
  d.num_empleado,
  CONCAT(d.nombre, ' ', d.apellidos) AS docente,
  d.correo,
  COUNT(c.id_curso) AS total_cursos,
  GROUP_CONCAT(DISTINCT p.nombre ORDER BY p.nombre) AS periodos,
  GROUP_CONCAT(DISTINCT m.nombre ORDER BY m.nombre) AS materias
FROM docentes d
LEFT JOIN cursos c ON c.id_docente = d.id_docente
LEFT JOIN vw_cursos_detalle cd ON cd.id_curso = c.id_curso
LEFT JOIN materias m ON m.id_materia = c.id_materia
LEFT JOIN periodos p ON p.id_periodo = c.id_periodo
GROUP BY d.id_docente, d.num_empleado, d.nombre, d.apellidos, d.correo;

-- Vista resumen de pagos por periodo y concepto
CREATE VIEW vw_resumen_pagos AS
SELECT
  p.nombre AS periodo,
  pg.concepto,
  COUNT(pg.id_pago) AS cantidad_pagos,
  ROUND(SUM(pg.monto), 2) AS total_recaudado,
  ROUND(AVG(pg.monto), 2) AS promedio_pago,
  MIN(pg.monto) AS pago_minimo,
  MAX(pg.monto) AS pago_maximo
FROM pagos pg
JOIN periodos p ON p.id_periodo = pg.id_periodo
GROUP BY p.nombre, pg.concepto
ORDER BY p.nombre, pg.concepto;
