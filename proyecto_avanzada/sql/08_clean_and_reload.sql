USE escuela;

-- Limpiar datos dejando solo los primeros 3 alumnos y cursos 1,2,3
DELETE FROM pagos WHERE id_alumno > 3;
DELETE FROM calificaciones WHERE id_inscripcion IN (SELECT id_inscripcion FROM inscripciones WHERE id_alumno > 3);
DELETE FROM calificaciones WHERE id_evaluacion IN (SELECT id_evaluacion FROM evaluaciones WHERE id_curso NOT IN (1, 2, 3));
DELETE FROM inscripciones WHERE id_alumno > 3;
DELETE FROM horarios WHERE id_curso NOT IN (1, 2, 3);
DELETE FROM evaluaciones WHERE id_curso NOT IN (1, 2, 3);
DELETE FROM cursos WHERE id_curso NOT IN (1, 2, 3);
DELETE FROM alumnos WHERE id_alumno > 3;
DELETE FROM docentes WHERE id_docente > 2;
