-- Esquema SQLite alineado con sql/01_schema.sql (MySQL).
-- Fuente canonica: proyecto_avanzada/sql/01_schema.sql

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS docentes (
    id_docente INTEGER PRIMARY KEY AUTOINCREMENT,
    num_empleado TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL,
    apellidos TEXT NOT NULL,
    correo TEXT
);

CREATE TABLE IF NOT EXISTS periodos (
    id_periodo INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    fecha_inicio TEXT NOT NULL,
    fecha_fin TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS aulas (
    id_aula INTEGER PRIMARY KEY AUTOINCREMENT,
    edificio TEXT NOT NULL,
    nombre_aula TEXT NOT NULL,
    capacidad INTEGER NOT NULL CHECK (capacidad > 0)
);

CREATE TABLE IF NOT EXISTS facultades (
    id_facultad INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    clave TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS materias (
    id_materia INTEGER PRIMARY KEY AUTOINCREMENT,
    clave TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL,
    creditos INTEGER NOT NULL CHECK (creditos > 0)
);

CREATE TABLE IF NOT EXISTS carreras (
    id_carrera INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    id_facultad INTEGER NOT NULL,
    UNIQUE (id_facultad, nombre),
    FOREIGN KEY (id_facultad) REFERENCES facultades(id_facultad)
);

CREATE TABLE IF NOT EXISTS carreras_materias (
    id_carrera INTEGER NOT NULL,
    id_materia INTEGER NOT NULL,
    PRIMARY KEY (id_carrera, id_materia),
    FOREIGN KEY (id_carrera) REFERENCES carreras(id_carrera) ON DELETE CASCADE,
    FOREIGN KEY (id_materia) REFERENCES materias(id_materia)
);

CREATE TABLE IF NOT EXISTS alumnos (
    id_alumno INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    apellidos TEXT NOT NULL,
    correo TEXT,
    telefono TEXT,
    fecha_nacimiento TEXT,
    estatus TEXT NOT NULL DEFAULT 'Activo' CHECK (estatus IN ('Activo','Baja'))
);

CREATE TABLE IF NOT EXISTS cursos (
    id_curso INTEGER PRIMARY KEY AUTOINCREMENT,
    id_materia INTEGER NOT NULL,
    id_docente INTEGER NOT NULL,
    id_periodo INTEGER NOT NULL,
    cupo_max INTEGER NOT NULL CHECK (cupo_max > 0),
    esta_lleno INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (id_materia) REFERENCES materias(id_materia),
    FOREIGN KEY (id_docente) REFERENCES docentes(id_docente),
    FOREIGN KEY (id_periodo) REFERENCES periodos(id_periodo)
);

CREATE TABLE IF NOT EXISTS horarios (
    id_horario INTEGER PRIMARY KEY AUTOINCREMENT,
    id_curso INTEGER NOT NULL,
    id_aula INTEGER NOT NULL,
    dia_semana INTEGER NOT NULL CHECK (dia_semana BETWEEN 1 AND 7),
    hora_inicio TEXT NOT NULL,
    hora_fin TEXT NOT NULL,
    CHECK (hora_inicio < hora_fin),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso) ON DELETE CASCADE,
    FOREIGN KEY (id_aula) REFERENCES aulas(id_aula)
);

CREATE TABLE IF NOT EXISTS evaluaciones (
    id_evaluacion INTEGER PRIMARY KEY AUTOINCREMENT,
    id_curso INTEGER NOT NULL,
    nombre TEXT NOT NULL,
    porcentaje REAL NOT NULL CHECK (porcentaje > 0 AND porcentaje <= 100),
    orden INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso) ON DELETE CASCADE,
    UNIQUE (id_curso, nombre)
);

CREATE TABLE IF NOT EXISTS inscripciones (
    id_inscripcion INTEGER PRIMARY KEY AUTOINCREMENT,
    id_alumno INTEGER NOT NULL,
    tipo TEXT NOT NULL CHECK (tipo IN ('carrera','curso')),
    id_carrera INTEGER,
    id_curso INTEGER,
    fecha_inscripcion TEXT NOT NULL,
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno),
    FOREIGN KEY (id_carrera) REFERENCES carreras(id_carrera) ON DELETE SET NULL,
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS calificaciones (
    id_calificacion INTEGER PRIMARY KEY AUTOINCREMENT,
    id_inscripcion INTEGER NOT NULL,
    id_evaluacion INTEGER NOT NULL,
    calificacion REAL NOT NULL CHECK (calificacion >= 0 AND calificacion <= 100),
    FOREIGN KEY (id_inscripcion) REFERENCES inscripciones(id_inscripcion) ON DELETE CASCADE,
    FOREIGN KEY (id_evaluacion) REFERENCES evaluaciones(id_evaluacion) ON DELETE CASCADE,
    UNIQUE (id_inscripcion, id_evaluacion)
);

CREATE TABLE IF NOT EXISTS pagos (
    id_pago INTEGER PRIMARY KEY AUTOINCREMENT,
    id_alumno INTEGER NOT NULL,
    id_periodo INTEGER NOT NULL,
    concepto TEXT NOT NULL,
    monto REAL NOT NULL CHECK (monto > 0),
    fecha_pago TEXT NOT NULL,
    referencia TEXT UNIQUE,
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno),
    FOREIGN KEY (id_periodo) REFERENCES periodos(id_periodo)
);
