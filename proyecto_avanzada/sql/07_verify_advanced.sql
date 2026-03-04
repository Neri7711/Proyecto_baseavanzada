USE escuela;

-- Conteos generales
SELECT 'carreras' AS tabla, COUNT(*) AS total FROM carreras
UNION ALL SELECT 'alumnos', COUNT(*) FROM alumnos
UNION ALL SELECT 'docentes', COUNT(*) FROM docentes
UNION ALL SELECT 'periodos', COUNT(*) FROM periodos
UNION ALL SELECT 'materias', COUNT(*) FROM materias
UNION ALL SELECT 'aulas', COUNT(*) FROM aulas
UNION ALL SELECT 'grupos', COUNT(*) FROM grupos
UNION ALL SELECT 'horarios', COUNT(*) FROM horarios
UNION ALL SELECT 'inscripciones', COUNT(*) FROM inscripciones
UNION ALL SELECT 'evaluaciones', COUNT(*) FROM evaluaciones
UNION ALL SELECT 'calificaciones', COUNT(*) FROM calificaciones
UNION ALL SELECT 'pagos', COUNT(*) FROM pagos;

-- Validación: ningún grupo excede cupo
SELECT g.id_grupo, g.cupo_max, COUNT(i.id_inscripcion) AS inscritos
FROM grupos g
LEFT JOIN inscripciones i ON i.id_grupo = g.id_grupo
GROUP BY g.id_grupo, g.cupo_max
HAVING COUNT(i.id_inscripcion) > g.cupo_max;

-- Validación: porcentajes por grupo no exceden 100 (y se espera 100)
SELECT e.id_grupo, SUM(e.porcentaje) AS suma_porcentaje
FROM evaluaciones e
GROUP BY e.id_grupo
HAVING SUM(e.porcentaje) <> 100;

-- Demo de vistas
SELECT * FROM vw_grupos_detalle ORDER BY id_grupo LIMIT 10;
SELECT * FROM vw_horario_grupo ORDER BY id_grupo, dia_semana, hora_inicio LIMIT 10;
SELECT * FROM vw_lista_grupo ORDER BY id_grupo, matricula LIMIT 10;
SELECT * FROM vw_kardex ORDER BY matricula, periodo, materia_clave LIMIT 10;
SELECT * FROM vw_estado_cuenta ORDER BY matricula, periodo LIMIT 10;
