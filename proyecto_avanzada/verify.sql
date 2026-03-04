PRAGMA foreign_keys = ON;

-- 1) Verifica tablas
SELECT name AS tabla
FROM sqlite_master
WHERE type = 'table'
  AND name NOT LIKE 'sqlite_%'
ORDER BY name;

-- 2) Lista de grupos con materia/docente/periodo
SELECT 
    g.id_grupo,
    m.clave AS materia_clave,
    m.nombre AS materia_nombre,
    d.nombre || ' ' || d.apellidos AS docente,
    p.nombre AS periodo,
    g.clave_grupo,
    g.cupo_max
FROM grupos g
JOIN materias m ON m.id_materia = g.id_materia
JOIN docentes d ON d.id_docente = g.id_docente
JOIN periodos p ON p.id_periodo = g.id_periodo
ORDER BY g.id_grupo;

-- 3) Lista de alumnos por grupo
SELECT 
    g.id_grupo,
    m.clave AS materia,
    a.matricula,
    a.nombre || ' ' || a.apellidos AS alumno,
    i.fecha_inscripcion
FROM inscripciones i
JOIN alumnos a ON a.id_alumno = i.id_alumno
JOIN grupos g ON g.id_grupo = i.id_grupo
JOIN materias m ON m.id_materia = g.id_materia
ORDER BY g.id_grupo, a.matricula;

-- 4) Calificacion final ponderada por alumno (por grupo)
WITH calif AS (
    SELECT
        i.id_inscripcion,
        i.id_alumno,
        i.id_grupo,
        SUM(c.calificacion * (e.porcentaje / 100.0)) AS final_ponderado
    FROM inscripciones i
    JOIN calificaciones c ON c.id_inscripcion = i.id_inscripcion
    JOIN evaluaciones e ON e.id_evaluacion = c.id_evaluacion
    GROUP BY i.id_inscripcion, i.id_alumno, i.id_grupo
)
SELECT
    a.matricula,
    a.nombre || ' ' || a.apellidos AS alumno,
    g.id_grupo,
    m.clave AS materia,
    ROUND(calif.final_ponderado, 2) AS calificacion_final
FROM calif
JOIN alumnos a ON a.id_alumno = calif.id_alumno
JOIN grupos g ON g.id_grupo = calif.id_grupo
JOIN materias m ON m.id_materia = g.id_materia
ORDER BY a.matricula, g.id_grupo;
