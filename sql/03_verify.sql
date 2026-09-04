USE escuela;

-- 1) Verifica tablas
SHOW TABLES;

-- 2) Lista de cursos con materia/docente/periodo (creditos desde materias)
SELECT
    c.id_curso,
    m.clave AS materia_clave,
    m.nombre AS materia_nombre,
    CONCAT(d.nombre, ' ', d.apellidos) AS docente,
    p.nombre AS periodo,
    m.creditos,
    c.cupo_max,
    IF(c.esta_lleno, 'SI', 'NO') AS esta_lleno
FROM cursos c
JOIN materias m ON m.id_materia = c.id_materia
JOIN docentes d ON d.id_docente = c.id_docente
JOIN periodos p ON p.id_periodo = c.id_periodo
ORDER BY c.id_curso;

-- 3) Lista de alumnos con su carrera y facultad (via inscripciones tipo carrera)
SELECT
    a.id_alumno,
    CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
    cr.nombre AS carrera,
    f.nombre AS facultad,
    a.estatus
FROM alumnos a
JOIN inscripciones i ON i.id_alumno = a.id_alumno AND i.tipo = 'carrera'
JOIN carreras cr ON cr.id_carrera = i.id_carrera
JOIN facultades f ON f.id_facultad = cr.id_facultad
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

-- 5) Evaluaciones por curso (periodos con nombre, porcentaje, orden)
SELECT
    e.id_evaluacion,
    m.clave AS materia,
    e.nombre AS evaluacion_nombre,
    e.porcentaje,
    e.orden
FROM evaluaciones e
JOIN cursos c ON c.id_curso = e.id_curso
JOIN materias m ON m.id_materia = c.id_materia
ORDER BY c.id_curso, e.orden;

-- 5b) Calificaciones por alumno y materia
SELECT
    a.id_alumno,
    CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
    m.clave AS materia,
    e.nombre AS evaluacion,
    c.calificacion
FROM calificaciones c
JOIN inscripciones i ON i.id_inscripcion = c.id_inscripcion
JOIN evaluaciones e ON e.id_evaluacion = c.id_evaluacion
JOIN alumnos a ON a.id_alumno = i.id_alumno
JOIN cursos cu ON cu.id_curso = i.id_curso
JOIN materias m ON m.id_materia = cu.id_materia
WHERE i.tipo = 'curso'
ORDER BY a.id_alumno, m.clave, e.orden;

-- 6) Alumnos que NO han pagado Colegiatura Enero en el periodo activo
SELECT
    a.id_alumno,
    CONCAT(a.nombre, ' ', a.apellidos) AS alumno,
    cr.nombre AS carrera,
    p.nombre AS periodo,
    c.concepto AS concepto_adeudado
FROM alumnos a
JOIN inscripciones i ON i.id_alumno = a.id_alumno AND i.tipo = 'carrera'
JOIN carreras cr ON cr.id_carrera = i.id_carrera
JOIN periodos p ON p.nombre = '2026-1'
JOIN cargos c
    ON c.id_alumno = a.id_alumno
    AND c.id_periodo = p.id_periodo
    AND c.concepto = 'Colegiatura Enero'
LEFT JOIN pagos pa
    ON pa.id_concepto = c.id_cargo
WHERE pa.id_pago IS NULL
GROUP BY a.id_alumno, a.nombre, a.apellidos, cr.nombre, p.nombre, c.concepto;
