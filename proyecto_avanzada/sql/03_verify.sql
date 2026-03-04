USE escuela;

-- 1) Verifica tablas
SHOW TABLES;

-- 2) Lista de cursos con materia/docente/periodo
SELECT
    c.id_curso,
    m.clave AS materia_clave,
    m.nombre AS materia_nombre,
    CONCAT(d.nombre, ' ', d.apellidos) AS docente,
    p.nombre AS periodo,
    c.creditos,
    c.cupo_max,
    IF(c.esta_lleno, 'SI', 'NO') AS esta_lleno
FROM cursos c
JOIN materias m ON m.id_materia = c.id_materia
JOIN docentes d ON d.id_docente = c.id_docente
JOIN periodos p ON p.id_periodo = c.id_periodo
ORDER BY c.id_curso;

-- 3) Lista de alumnos con su carrera (via inscripciones)
SELECT
    a.id_alumno,
    CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
    cr.nombre AS carrera,
    m.nombre AS materia_carrera,
    a.estatus
FROM alumnos a
JOIN inscripciones i ON i.id_alumno = a.id_alumno AND i.tipo = 'carrera'
JOIN carreras cr ON cr.id_carrera = i.id_carrera
JOIN materias m ON m.id_materia = cr.id_materia
ORDER BY a.id_alumno;

-- 4) Inscripciones por tipo (carrera vs curso)
SELECT
    i.id_inscripcion,
    CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
    i.tipo,
    cr.nombre AS carrera,
    m.clave AS materia_curso,
    i.fecha_inscripcion
FROM inscripciones i
JOIN alumnos a ON a.id_alumno = i.id_alumno
LEFT JOIN carreras cr ON cr.id_carrera = i.id_carrera
LEFT JOIN cursos c ON c.id_curso = i.id_curso
LEFT JOIN materias m ON m.id_materia = c.id_materia
ORDER BY i.tipo, a.id_alumno;

-- 5) Evaluaciones por curso
SELECT
    e.id_evaluacion,
    m.clave AS materia,
    e.calificacion,
    e.porcentaje
FROM evaluaciones e
JOIN cursos c ON c.id_curso = e.id_curso
JOIN materias m ON m.id_materia = c.id_materia
ORDER BY c.id_curso, e.id_evaluacion;

-- 6) Alumnos que NO han pagado Colegiatura Enero en el periodo activo
SELECT
    a.id_alumno,
    CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
    cr.nombre AS carrera,
    p.nombre AS periodo,
    'Colegiatura Enero' AS concepto_adeudado
FROM alumnos a
JOIN carreras cr ON cr.id_carrera = a.id_carrera
JOIN inscripciones i ON i.id_alumno = a.id_alumno AND i.tipo = 'carrera'
JOIN carreras icr ON icr.id_carrera = i.id_carrera
JOIN cursos cu ON cu.id_periodo = (SELECT id_periodo FROM periodos WHERE nombre = '2026-1' LIMIT 1)
JOIN periodos p ON p.id_periodo = cu.id_periodo
LEFT JOIN pagos pa
    ON pa.id_alumno = a.id_alumno
    AND pa.id_periodo = p.id_periodo
    AND pa.concepto = 'Colegiatura Enero'
WHERE p.nombre = '2026-1'
  AND pa.id_pago IS NULL
GROUP BY a.id_alumno, alumno, cr.nombre, p.nombre;
