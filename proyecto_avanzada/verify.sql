-- Verificacion SQLite alineada con sql/03_verify.sql (MySQL).
PRAGMA foreign_keys = ON;

-- 1) Tablas
SELECT name AS tabla
FROM sqlite_master
WHERE type = 'table' AND name NOT LIKE 'sqlite_%'
ORDER BY name;

-- 2) Cursos con materia, docente, periodo, creditos desde materias
SELECT
    c.id_curso,
    m.clave AS materia_clave,
    m.nombre AS materia_nombre,
    d.nombre || ' ' || d.apellidos AS docente,
    p.nombre AS periodo,
    m.creditos,
    c.cupo_max
FROM cursos c
JOIN materias m ON m.id_materia = c.id_materia
JOIN docentes d ON d.id_docente = c.id_docente
JOIN periodos p ON p.id_periodo = c.id_periodo
ORDER BY c.id_curso;

-- 3) Alumnos con carrera y facultad
SELECT
    a.id_alumno,
    a.nombre || ' ' || a.apellidos AS alumno,
    cr.nombre AS carrera,
    f.nombre AS facultad,
    a.estatus
FROM alumnos a
JOIN inscripciones i ON i.id_alumno = a.id_alumno AND i.tipo = 'carrera'
JOIN carreras cr ON cr.id_carrera = i.id_carrera
JOIN facultades f ON f.id_facultad = cr.id_facultad
ORDER BY a.id_alumno;

-- 4) Lista por curso
SELECT
    c.id_curso,
    m.clave AS materia,
    a.nombre || ' ' || a.apellidos AS alumno,
    i.fecha_inscripcion
FROM inscripciones i
JOIN alumnos a ON a.id_alumno = i.id_alumno
JOIN cursos c ON c.id_curso = i.id_curso
JOIN materias m ON m.id_materia = c.id_materia
WHERE i.tipo = 'curso'
ORDER BY c.id_curso, a.id_alumno;

-- 5) Evaluaciones por curso (periodos)
SELECT
    e.id_evaluacion,
    c.id_curso,
    m.clave AS materia,
    e.nombre,
    e.porcentaje,
    e.orden
FROM evaluaciones e
JOIN cursos c ON c.id_curso = e.id_curso
JOIN materias m ON m.id_materia = c.id_materia
ORDER BY c.id_curso, e.orden;
