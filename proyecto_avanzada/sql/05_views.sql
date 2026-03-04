USE escuela;

DROP VIEW IF EXISTS vw_grupos_detalle;
DROP VIEW IF EXISTS vw_horario_grupo;
DROP VIEW IF EXISTS vw_lista_grupo;
DROP VIEW IF EXISTS vw_kardex;
DROP VIEW IF EXISTS vw_estado_cuenta;

CREATE VIEW vw_grupos_detalle AS
SELECT 
  g.id_grupo,
  m.clave AS materia_clave,
  m.nombre AS materia_nombre,
  d.num_empleado,
  CONCAT(d.nombre, ' ', d.apellidos) AS docente,
  p.nombre AS periodo,
  g.clave_grupo,
  g.cupo_max
FROM grupos g
JOIN materias m ON m.id_materia = g.id_materia
JOIN docentes d ON d.id_docente = g.id_docente
JOIN periodos p ON p.id_periodo = g.id_periodo;

CREATE VIEW vw_horario_grupo AS
SELECT
  h.id_horario,
  h.id_grupo,
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
JOIN vw_grupos_detalle gd ON gd.id_grupo = h.id_grupo
JOIN aulas a ON a.id_aula = h.id_aula;

CREATE VIEW vw_lista_grupo AS
SELECT
  i.id_grupo,
  gd.materia_clave,
  gd.materia_nombre,
  gd.docente,
  gd.periodo,
  gd.clave_grupo,
  a.id_alumno,
  a.matricula,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  i.fecha_inscripcion
FROM inscripciones i
JOIN alumnos a ON a.id_alumno = i.id_alumno
JOIN vw_grupos_detalle gd ON gd.id_grupo = i.id_grupo;

CREATE VIEW vw_kardex AS
SELECT
  a.id_alumno,
  a.matricula,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  gd.periodo,
  gd.id_grupo,
  gd.materia_clave,
  gd.materia_nombre,
  ROUND(x.final_ponderado, 2) AS calificacion_final
FROM (
  SELECT
    i.id_inscripcion,
    i.id_alumno,
    i.id_grupo,
    SUM(c.calificacion * (e.porcentaje / 100.0)) AS final_ponderado
  FROM inscripciones i
  JOIN calificaciones c ON c.id_inscripcion = i.id_inscripcion
  JOIN evaluaciones e ON e.id_evaluacion = c.id_evaluacion
  GROUP BY i.id_inscripcion, i.id_alumno, i.id_grupo
) x
JOIN alumnos a ON a.id_alumno = x.id_alumno
JOIN vw_grupos_detalle gd ON gd.id_grupo = x.id_grupo;

CREATE VIEW vw_estado_cuenta AS
SELECT
  a.id_alumno,
  a.matricula,
  CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
  p.nombre AS periodo,
  COUNT(pg.id_pago) AS pagos_realizados,
  ROUND(IFNULL(SUM(pg.monto), 0), 2) AS total_pagado
FROM alumnos a
CROSS JOIN periodos p
LEFT JOIN pagos pg ON pg.id_alumno = a.id_alumno AND pg.id_periodo = p.id_periodo
GROUP BY a.id_alumno, a.matricula, a.nombre, a.apellidos, p.id_periodo, p.nombre;
