USE escuela;

-- Deshabilitar verificación de FKs para poder truncar en cualquier orden
SET FOREIGN_KEY_CHECKS = 0;

-- Orden: tablas dependientes primero (hijos), luego independientes (padres)
-- Nivel 1: dependen de inscripciones, alumnos, cursos, periodos, evaluaciones
TRUNCATE TABLE calificaciones;
TRUNCATE TABLE pagos;
TRUNCATE TABLE cargos;
TRUNCATE TABLE inscripciones;

-- Nivel 2: dependen de cursos, aulas
TRUNCATE TABLE evaluaciones;
TRUNCATE TABLE horarios;

-- Nivel 3: dependen de materias, docentes, periodos
TRUNCATE TABLE cursos;

-- Nivel 4: dependen de carreras, materias
TRUNCATE TABLE carreras_materias;

-- Nivel 5: alumnos (sin FK a otras tablas de negocio), carreras (depende de facultades)
TRUNCATE TABLE alumnos;
TRUNCATE TABLE carreras;

-- Nivel 6: tablas base sin dependencias entre sí
TRUNCATE TABLE materias;
TRUNCATE TABLE periodos;
TRUNCATE TABLE aulas;
TRUNCATE TABLE docentes;
TRUNCATE TABLE facultades;

SET FOREIGN_KEY_CHECKS = 1;
