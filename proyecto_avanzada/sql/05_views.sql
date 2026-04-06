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
DROP VIEW IF EXISTS vw_morosidad_alumnos;
DROP VIEW IF EXISTS vw_alumnos_por_estatus;
DROP VIEW IF EXISTS vw_alumnos_carrera;
DROP VIEW IF EXISTS vw_docentes_cursos;
DROP VIEW IF EXISTS vw_resumen_pagos;
DROP VIEW IF EXISTS vw_facultades_carreras;
DROP VIEW IF EXISTS vw_rendimiento_por_carrera;
DROP VIEW IF EXISTS vw_materias_criticas;
DROP VIEW IF EXISTS vw_ranking_docentes_promedio;
DROP VIEW IF EXISTS vw_saturacion_cursos;
DROP VIEW IF EXISTS vw_ingresos_mensuales;
DROP VIEW IF EXISTS vw_distribucion_ingresos_concepto;
DROP VIEW IF EXISTS vw_top_reprobados;
DROP VIEW IF EXISTS vw_carga_docente;
DROP VIEW IF EXISTS vw_inscripciones_periodo;
DROP VIEW IF EXISTS vw_cargos_vs_pagos;

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
LEFT JOIN inscripciones i ON i.id_alumno = a.id_alumno AND i.tipo = 'carrera'
LEFT JOIN (
  SELECT z.id_alumno, z.id_carrera
  FROM (
    SELECT
      ic.id_alumno,
      cm.id_carrera,
      COUNT(*) AS cursos_en_carrera,
      ROW_NUMBER() OVER (
        PARTITION BY ic.id_alumno
        ORDER BY COUNT(*) DESC, cm.id_carrera
      ) AS rn
    FROM inscripciones ic
    JOIN cursos cu ON cu.id_curso = ic.id_curso
    JOIN carreras_materias cm ON cm.id_materia = cu.id_materia
    WHERE ic.tipo = 'curso'
    GROUP BY ic.id_alumno, cm.id_carrera
  ) z
  WHERE z.rn = 1
) ap ON ap.id_alumno = a.id_alumno
LEFT JOIN carreras cr ON cr.id_carrera = COALESCE(i.id_carrera, ap.id_carrera)
LEFT JOIN facultades f ON f.id_facultad = cr.id_facultad;

-- Conteo de alumnos por estatus (Activo, Baja, Egresado)
CREATE VIEW vw_alumnos_por_estatus AS
SELECT estatus, COUNT(*) AS total
FROM alumnos
GROUP BY estatus;

-- Alumnos activos sin pagos (morosidad)
CREATE VIEW vw_morosidad_alumnos AS
SELECT DISTINCT a.nombre, a.apellidos, a.correo, a.estatus
FROM alumnos a
JOIN cargos c ON c.id_alumno = a.id_alumno
WHERE a.estatus = 'Activo'
  AND c.estado IN ('pendiente', 'parcial');

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
  c.concepto,
  COUNT(pg.id_pago) AS cantidad_pagos,
  ROUND(SUM(pg.monto), 2) AS total_recaudado,
  ROUND(AVG(pg.monto), 2) AS promedio_pago,
  MIN(pg.monto) AS pago_minimo,
  MAX(pg.monto) AS pago_maximo
FROM pagos pg
JOIN periodos p ON p.id_periodo = pg.id_periodo
JOIN cargos c ON c.id_cargo = pg.id_concepto
GROUP BY p.nombre, c.concepto
ORDER BY p.nombre, c.concepto;

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

CREATE VIEW vw_rendimiento_por_carrera AS
SELECT
  cr.nombre AS carrera,
  ROUND(AVG(c.calificacion), 2) AS promedio_general
FROM carreras cr
JOIN carreras_materias cm ON cm.id_carrera = cr.id_carrera
JOIN cursos cu ON cu.id_materia = cm.id_materia
JOIN inscripciones ic ON ic.id_curso = cu.id_curso AND ic.tipo = 'curso'
JOIN calificaciones c ON c.id_inscripcion = ic.id_inscripcion
GROUP BY cr.id_carrera, cr.nombre;

CREATE VIEW vw_materias_criticas AS
SELECT
  m.nombre AS materia,
  m.clave AS clave,
  ROUND(AVG(ca.calificacion), 2) AS promedio
FROM materias m
JOIN cursos cu ON cu.id_materia = m.id_materia
JOIN inscripciones i ON i.id_curso = cu.id_curso AND i.tipo = 'curso'
JOIN calificaciones ca ON ca.id_inscripcion = i.id_inscripcion
GROUP BY m.id_materia, m.nombre, m.clave
HAVING ROUND(AVG(ca.calificacion), 2) < 70;

CREATE VIEW vw_ranking_docentes_promedio AS
SELECT
  d.nombre AS nombre,
  d.apellidos AS apellidos,
  d.num_empleado AS num_empleado,
  ROUND(AVG(ca.calificacion), 2) AS promedio_alumnos
FROM docentes d
JOIN cursos cu ON cu.id_docente = d.id_docente
JOIN inscripciones i ON i.id_curso = cu.id_curso AND i.tipo = 'curso'
JOIN calificaciones ca ON ca.id_inscripcion = i.id_inscripcion
GROUP BY d.id_docente, d.nombre, d.apellidos, d.num_empleado;

CREATE VIEW vw_saturacion_cursos AS
SELECT
  m.nombre AS materia,
  cu.cupo_max AS cupo_max,
  (
    SELECT COUNT(*)
    FROM inscripciones i
    WHERE i.id_curso = cu.id_curso AND i.tipo = 'curso'
  ) AS inscritos,
  ROUND(
    (
      (
        SELECT COUNT(*)
        FROM inscripciones i
        WHERE i.id_curso = cu.id_curso AND i.tipo = 'curso'
      ) / cu.cupo_max
    ) * 100,
    2
  ) AS porcentaje_llenado,
  cu.esta_lleno AS esta_lleno
FROM cursos cu
JOIN materias m ON m.id_materia = cu.id_materia;

CREATE VIEW vw_ingresos_mensuales AS
SELECT
  DATE_FORMAT(p.fecha_pago, '%Y-%m') AS mes,
  SUM(p.monto) AS total_ingresos,
  COUNT(p.id_pago) AS numero_transacciones
FROM pagos p
GROUP BY DATE_FORMAT(p.fecha_pago, '%Y-%m');

CREATE VIEW vw_distribucion_ingresos_concepto AS
SELECT
  c.concepto AS concepto,
  SUM(p.monto) AS monto_total
FROM pagos p
JOIN cargos c ON c.id_cargo = p.id_concepto
GROUP BY c.concepto;

-- Top materias con mas reprobados
CREATE VIEW vw_top_reprobados AS
SELECT
  t.materia,
  t.clave,
  SUM(CASE WHEN t.calificacion_final < 70 THEN 1 ELSE 0 END) AS total_reprobados,
  COUNT(*) AS total_alumnos,
  ROUND(
    SUM(CASE WHEN t.calificacion_final < 70 THEN 1 ELSE 0 END) / COUNT(*) * 100,
    1
  ) AS porcentaje_reprobacion
FROM (
  SELECT
    m.id_materia,
    m.nombre AS materia,
    m.clave AS clave,
    i.id_alumno,
    SUM(ca.calificacion * (e.porcentaje / 100.0)) AS calificacion_final
  FROM calificaciones ca
  JOIN inscripciones i ON i.id_inscripcion = ca.id_inscripcion AND i.tipo = 'curso'
  JOIN evaluaciones e ON e.id_evaluacion = ca.id_evaluacion
  JOIN cursos cu ON cu.id_curso = i.id_curso
  JOIN materias m ON m.id_materia = cu.id_materia
  GROUP BY m.id_materia, m.nombre, m.clave, i.id_alumno
) t
GROUP BY t.materia, t.clave
ORDER BY total_reprobados DESC;

-- Carga docente (cursos y alumnos por profesor)
CREATE VIEW vw_carga_docente AS
SELECT
  CONCAT(d.nombre, ' ', d.apellidos) AS docente,
  d.num_empleado,
  COUNT(DISTINCT cu.id_curso) AS total_cursos,
  COUNT(DISTINCT i.id_alumno) AS total_alumnos
FROM docentes d
JOIN cursos cu ON d.id_docente = cu.id_docente
LEFT JOIN inscripciones i ON cu.id_curso = i.id_curso AND i.tipo = 'curso'
GROUP BY d.id_docente, d.nombre, d.apellidos, d.num_empleado;

-- Inscripciones por periodo (tendencia)
CREATE VIEW vw_inscripciones_periodo AS
SELECT
  p.nombre AS periodo,
  COUNT(*) AS total_inscripciones
FROM inscripciones i
JOIN cursos cu ON cu.id_curso = i.id_curso
JOIN periodos p ON p.id_periodo = cu.id_periodo
WHERE i.tipo = 'curso'
GROUP BY p.id_periodo, p.nombre
ORDER BY p.fecha_inicio;

-- Cargos vs pagos por periodo
CREATE VIEW vw_cargos_vs_pagos AS
SELECT
  p.nombre AS periodo,
  SUM(c.monto) AS total_cargado,
  COALESCE(SUM(pa.monto), 0) AS total_pagado
FROM cargos c
JOIN periodos p ON c.id_periodo = p.id_periodo
LEFT JOIN pagos pa ON pa.id_concepto = c.id_cargo
GROUP BY p.id_periodo, p.nombre
ORDER BY p.fecha_inicio;

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
