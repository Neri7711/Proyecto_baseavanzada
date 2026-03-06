USE escuela;

DROP VIEW IF EXISTS vw_promedio_por_materia;
DROP VIEW IF EXISTS vw_calificaciones_por_materia;
DROP VIEW IF EXISTS vw_calificaciones_detalle;
DROP VIEW IF EXISTS vw_boleta_alumno;
DROP VIEW IF EXISTS vw_lista_curso;
DROP VIEW IF EXISTS vw_lista_grupo;
DROP VIEW IF EXISTS vw_horario_curso;
DROP VIEW IF EXISTS vw_horario_grupo;
DROP VIEW IF EXISTS vw_cursos_detalle;
DROP VIEW IF EXISTS vw_grupos_detalle;
DROP VIEW IF EXISTS vw_kardex;
DROP VIEW IF EXISTS vw_estado_cuenta;
DROP VIEW IF EXISTS vw_alumnos_carrera;
DROP VIEW IF EXISTS vw_docentes_cursos;
DROP VIEW IF EXISTS vw_resumen_pagos;
DROP VIEW IF EXISTS vw_facultades_carreras;

-- ========== Views con nombres originales (compatibilidad) ==========

CREATE VIEW vw_grupos_detalle AS
SELECT
  c.id_curso AS id_grupo,
  m.clave AS materia_clave,
  m.nombre AS materia_nombre,
  d.num_empleado,
  CONCAT(d.nombre, ' ', d.apellidos) AS docente,
  p.nombre AS periodo,
  m.creditos,
  c.cupo_max
FROM cursos c
JOIN materias m ON m.id_materia = c.id_materia
JOIN docentes d ON d.id_docente = c.id_docente
JOIN periodos p ON p.id_periodo = c.id_periodo;

CREATE VIEW vw_horario_grupo AS
SELECT
  h.id_horario,
  h.id_curso AS id_grupo,
  gd.materia_clave,
  gd.materia_nombre,
  gd.docente,
  gd.periodo,
  h.dia_semana,
  CASE h.dia_semana
    WHEN 1 THEN 'Lunes'
    WHEN 2 THEN 'Martes'
    WHEN 3 THEN 'Miercoles'
    WHEN 4 THEN 'Jueves'
    WHEN 5 THEN 'Viernes'
    WHEN 6 THEN 'Sabado'
    WHEN 7 THEN 'Domingo'
  END AS dia_nombre,
  h.hora_inicio,
  h.hora_fin,
  a.edificio,
  a.nombre_aula
FROM horarios h
JOIN vw_grupos_detalle gd ON gd.id_grupo = h.id_curso
JOIN aulas a ON a.id_aula = h.id_aula;

CREATE VIEW vw_lista_grupo AS
SELECT
  i.id_curso AS id_grupo,
  gd.materia_clave,
  gd.materia_nombre,
  gd.docente,
  gd.periodo,
  a.id_alumno,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  i.fecha_inscripcion
FROM inscripciones i
JOIN alumnos a ON a.id_alumno = i.id_alumno
JOIN vw_grupos_detalle gd ON gd.id_grupo = i.id_curso
WHERE i.tipo = 'curso';

-- Kardex: alumno, periodo, curso, materia, calificacion_final ponderada
CREATE VIEW vw_kardex AS
SELECT
  a.id_alumno,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  gd.periodo,
  gd.id_grupo AS id_curso,
  gd.materia_clave,
  gd.materia_nombre,
  ROUND(k.final_ponderado, 2) AS calificacion_final
FROM (
  SELECT
    i.id_inscripcion,
    i.id_alumno,
    i.id_curso,
    SUM(c.calificacion * (e.porcentaje / 100.0)) AS final_ponderado
  FROM inscripciones i
  JOIN calificaciones c ON c.id_inscripcion = i.id_inscripcion
  JOIN evaluaciones e ON e.id_evaluacion = c.id_evaluacion
  WHERE i.tipo = 'curso'
  GROUP BY i.id_inscripcion, i.id_alumno, i.id_curso
) k
JOIN alumnos a ON a.id_alumno = k.id_alumno
JOIN vw_grupos_detalle gd ON gd.id_grupo = k.id_curso;

CREATE VIEW vw_estado_cuenta AS
SELECT
  a.id_alumno,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  p.nombre AS periodo,
  COUNT(pg.id_pago) AS pagos_realizados,
  ROUND(IFNULL(SUM(pg.monto), 0), 2) AS total_pagado
FROM alumnos a
CROSS JOIN periodos p
LEFT JOIN pagos pg ON pg.id_alumno = a.id_alumno AND pg.id_periodo = p.id_periodo
GROUP BY a.id_alumno, a.nombre, a.apellidos, p.id_periodo, p.nombre;

-- ========== Views adicionales ==========

CREATE VIEW vw_cursos_detalle AS
SELECT
  c.id_curso,
  m.clave AS materia_clave,
  m.nombre AS materia_nombre,
  m.creditos,
  d.num_empleado,
  CONCAT(d.nombre, ' ', d.apellidos) AS docente,
  p.nombre AS periodo,
  c.cupo_max,
  IF(c.esta_lleno, 'SI', 'NO') AS esta_lleno
FROM cursos c
JOIN materias m ON m.id_materia = c.id_materia
JOIN docentes d ON d.id_docente = c.id_docente
JOIN periodos p ON p.id_periodo = c.id_periodo;

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
    WHEN 3 THEN 'Miercoles'
    WHEN 4 THEN 'Jueves'
    WHEN 5 THEN 'Viernes'
    WHEN 6 THEN 'Sabado'
    WHEN 7 THEN 'Domingo'
  END AS dia_nombre,
  h.hora_inicio,
  h.hora_fin,
  a.edificio,
  a.nombre_aula
FROM horarios h
JOIN vw_cursos_detalle cd ON cd.id_curso = h.id_curso
JOIN aulas a ON a.id_aula = h.id_aula;

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

CREATE VIEW vw_alumnos_carrera AS
SELECT
  a.id_alumno,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  a.correo,
  a.telefono,
  a.estatus AS estatus_alumno,
  cr.nombre AS carrera,
  f.nombre AS facultad,
  f.clave AS facultad_clave,
  i.fecha_inscripcion AS fecha_inscripcion_carrera
FROM alumnos a
JOIN inscripciones i ON i.id_alumno = a.id_alumno AND i.tipo = 'carrera'
JOIN carreras cr ON cr.id_carrera = i.id_carrera
JOIN facultades f ON f.id_facultad = cr.id_facultad;

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
LEFT JOIN materias m ON m.id_materia = c.id_materia
LEFT JOIN periodos p ON p.id_periodo = c.id_periodo
GROUP BY d.id_docente, d.num_empleado, d.nombre, d.apellidos, d.correo;

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

CREATE VIEW vw_facultades_carreras AS
SELECT
  f.id_facultad,
  f.clave AS facultad_clave,
  f.nombre AS facultad_nombre,
  cr.id_carrera,
  cr.nombre AS carrera_nombre,
  (SELECT COUNT(*) FROM carreras_materias cm WHERE cm.id_carrera = cr.id_carrera) AS num_materias
FROM facultades f
JOIN carreras cr ON cr.id_facultad = f.id_facultad
ORDER BY f.nombre, cr.nombre;

-- ========== Views de calificaciones y boleta ==========

-- Detalle de calificaciones: alumno, materia, evaluacion (periodo), calificacion
CREATE VIEW vw_calificaciones_detalle AS
SELECT
  a.id_alumno,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  p.nombre AS periodo,
  m.clave AS materia_clave,
  m.nombre AS materia_nombre,
  e.nombre AS evaluacion_nombre,
  e.orden AS evaluacion_orden,
  e.porcentaje AS evaluacion_porcentaje,
  c.calificacion
FROM calificaciones c
JOIN inscripciones i ON i.id_inscripcion = c.id_inscripcion
JOIN evaluaciones e ON e.id_evaluacion = c.id_evaluacion
JOIN alumnos a ON a.id_alumno = i.id_alumno
JOIN cursos cu ON cu.id_curso = i.id_curso
JOIN materias m ON m.id_materia = cu.id_materia
JOIN periodos p ON p.id_periodo = cu.id_periodo
WHERE i.tipo = 'curso'
ORDER BY a.id_alumno, p.nombre, m.clave, e.orden;

-- Calificaciones por materia (pivot-like: cada evaluacion como columna conceptual)
-- Version simplificada: lista alumno, materia, periodo, cada evaluacion y su calificacion
CREATE VIEW vw_calificaciones_por_materia AS
SELECT
  a.id_alumno,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  p.nombre AS periodo,
  m.clave AS materia_clave,
  m.nombre AS materia_nombre,
  e.nombre AS evaluacion,
  e.orden,
  e.porcentaje,
  c.calificacion,
  ROUND(c.calificacion * (e.porcentaje / 100.0), 2) AS ponderado
FROM calificaciones c
JOIN inscripciones i ON i.id_inscripcion = c.id_inscripcion
JOIN evaluaciones e ON e.id_evaluacion = c.id_evaluacion
JOIN alumnos a ON a.id_alumno = i.id_alumno
JOIN cursos cu ON cu.id_curso = i.id_curso
JOIN materias m ON m.id_materia = cu.id_materia
JOIN periodos p ON p.id_periodo = cu.id_periodo
WHERE i.tipo = 'curso'
ORDER BY a.id_alumno, p.nombre, m.clave, e.orden;

-- Promedio ponderado por alumno y materia
CREATE VIEW vw_promedio_por_materia AS
SELECT
  a.id_alumno,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  p.nombre AS periodo,
  m.clave AS materia_clave,
  m.nombre AS materia_nombre,
  ROUND(SUM(c.calificacion * (e.porcentaje / 100.0)), 2) AS calificacion_final
FROM calificaciones c
JOIN inscripciones i ON i.id_inscripcion = c.id_inscripcion
JOIN evaluaciones e ON e.id_evaluacion = c.id_evaluacion
JOIN alumnos a ON a.id_alumno = i.id_alumno
JOIN cursos cu ON cu.id_curso = i.id_curso
JOIN materias m ON m.id_materia = cu.id_materia
JOIN periodos p ON p.id_periodo = cu.id_periodo
WHERE i.tipo = 'curso'
GROUP BY a.id_alumno, a.nombre, a.apellidos, p.id_periodo, p.nombre, m.id_materia, m.clave, m.nombre;

-- Boleta por alumno: cada materia inscrita con sus parciales/periodos y calificaciones
CREATE VIEW vw_boleta_alumno AS
SELECT
  a.id_alumno,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  cr.nombre AS carrera,
  f.nombre AS facultad,
  p.nombre AS periodo,
  m.clave AS materia_clave,
  m.nombre AS materia_nombre,
  m.creditos,
  e.nombre AS evaluacion,
  e.orden,
  e.porcentaje,
  c.calificacion
FROM alumnos a
LEFT JOIN inscripciones ic ON ic.id_alumno = a.id_alumno AND ic.tipo = 'carrera'
LEFT JOIN carreras cr ON cr.id_carrera = ic.id_carrera
LEFT JOIN facultades f ON f.id_facultad = cr.id_facultad
JOIN inscripciones i ON i.id_alumno = a.id_alumno AND i.tipo = 'curso'
JOIN cursos cu ON cu.id_curso = i.id_curso
JOIN materias m ON m.id_materia = cu.id_materia
JOIN periodos p ON p.id_periodo = cu.id_periodo
JOIN calificaciones c ON c.id_inscripcion = i.id_inscripcion
JOIN evaluaciones e ON e.id_evaluacion = c.id_evaluacion
ORDER BY a.id_alumno, p.nombre, m.clave, e.orden;
