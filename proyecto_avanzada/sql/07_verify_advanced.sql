USE escuela;

-- Conteos generales (adaptado al esquema con facultades, carreras_materias, cursos)
SELECT 'facultades' AS tabla, COUNT(*) AS total FROM facultades
UNION ALL SELECT 'carreras', COUNT(*) FROM carreras
UNION ALL SELECT 'carreras_materias', COUNT(*) FROM carreras_materias
UNION ALL SELECT 'alumnos', COUNT(*) FROM alumnos
UNION ALL SELECT 'docentes', COUNT(*) FROM docentes
UNION ALL SELECT 'periodos', COUNT(*) FROM periodos
UNION ALL SELECT 'materias', COUNT(*) FROM materias
UNION ALL SELECT 'aulas', COUNT(*) FROM aulas
UNION ALL SELECT 'cursos', COUNT(*) FROM cursos
UNION ALL SELECT 'horarios', COUNT(*) FROM horarios
UNION ALL SELECT 'inscripciones', COUNT(*) FROM inscripciones
UNION ALL SELECT 'evaluaciones', COUNT(*) FROM evaluaciones
UNION ALL SELECT 'calificaciones', COUNT(*) FROM calificaciones
UNION ALL SELECT 'pagos', COUNT(*) FROM pagos;

-- Validacion: ningun curso excede cupo
SELECT c.id_curso, c.cupo_max, COUNT(i.id_inscripcion) AS inscritos
FROM cursos c
LEFT JOIN inscripciones i ON i.id_curso = c.id_curso AND i.tipo = 'curso'
GROUP BY c.id_curso, c.cupo_max
HAVING COUNT(i.id_inscripcion) > c.cupo_max;

-- Validacion: porcentajes por curso no exceden 100
SELECT e.id_curso, SUM(e.porcentaje) AS suma_porcentaje
FROM evaluaciones e
GROUP BY e.id_curso
HAVING SUM(e.porcentaje) > 100;

-- Validacion: suma de porcentajes por curso = 100
SELECT e.id_curso, SUM(e.porcentaje) AS suma_porcentaje
FROM evaluaciones e
GROUP BY e.id_curso
HAVING ABS(SUM(e.porcentaje) - 100) > 0.01;

-- Demo de vistas
SELECT * FROM vw_grupos_detalle ORDER BY id_grupo LIMIT 10;
SELECT * FROM vw_horario_grupo ORDER BY id_grupo, dia_semana, hora_inicio LIMIT 10;
SELECT * FROM vw_lista_grupo ORDER BY id_grupo, id_alumno LIMIT 10;
SELECT * FROM vw_kardex ORDER BY id_alumno, periodo, materia_clave LIMIT 10;
SELECT * FROM vw_estado_cuenta ORDER BY id_alumno, periodo LIMIT 10;

-- Demo vistas de calificaciones y boleta
SELECT * FROM vw_boleta_alumno ORDER BY id_alumno, periodo, materia_clave, orden LIMIT 20;
SELECT * FROM vw_calificaciones_detalle ORDER BY id_alumno, periodo, materia_clave, evaluacion_orden LIMIT 20;
SELECT * FROM vw_promedio_por_materia ORDER BY id_alumno, periodo, materia_clave LIMIT 10;
