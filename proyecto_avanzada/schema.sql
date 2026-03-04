PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS carreras (
    id_carrera INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS alumnos (
    id_alumno INTEGER PRIMARY KEY,
    matricula TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL,
    apellidos TEXT NOT NULL,
    correo TEXT UNIQUE,
    telefono TEXT,
    fecha_nacimiento TEXT,
    estatus TEXT NOT NULL DEFAULT 'Activo' CHECK (estatus IN ('Activo','Baja'))
);

CREATE TABLE IF NOT EXISTS docentes (
    id_docente INTEGER PRIMARY KEY,
    num_empleado TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL,
    apellidos TEXT NOT NULL,
    correo TEXT UNIQUE
);

CREATE TABLE IF NOT EXISTS periodos (
    id_periodo INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    fecha_inicio TEXT NOT NULL,
    fecha_fin TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS materias (
    id_materia INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL,
    creditos INTEGER NOT NULL CHECK (creditos > 0),
    id_carrera INTEGER NOT NULL,
    FOREIGN KEY (id_carrera) REFERENCES carreras(id_carrera)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS aulas (
    id_aula INTEGER PRIMARY KEY,
    edificio TEXT NOT NULL,
    nombre_aula TEXT NOT NULL,
    capacidad INTEGER NOT NULL CHECK (capacidad > 0),
    UNIQUE (edificio, nombre_aula)
);

CREATE TABLE IF NOT EXISTS grupos (
    id_grupo INTEGER PRIMARY KEY,
    id_materia INTEGER NOT NULL,
    id_docente INTEGER NOT NULL,
    id_periodo INTEGER NOT NULL,
    clave_grupo TEXT NOT NULL,
    cupo_max INTEGER NOT NULL CHECK (cupo_max > 0),
    FOREIGN KEY (id_materia) REFERENCES materias(id_materia)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (id_docente) REFERENCES docentes(id_docente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (id_periodo) REFERENCES periodos(id_periodo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    UNIQUE (id_materia, id_docente, id_periodo, clave_grupo)
);

CREATE TABLE IF NOT EXISTS horarios (
    id_horario INTEGER PRIMARY KEY,
    id_grupo INTEGER NOT NULL,
    id_aula INTEGER NOT NULL,
    dia_semana INTEGER NOT NULL CHECK (dia_semana BETWEEN 1 AND 7),
    hora_inicio TEXT NOT NULL,
    hora_fin TEXT NOT NULL,
    FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (id_aula) REFERENCES aulas(id_aula)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (hora_inicio < hora_fin)
);

CREATE TABLE IF NOT EXISTS inscripciones (
    id_inscripcion INTEGER PRIMARY KEY,
    id_alumno INTEGER NOT NULL,
    id_grupo INTEGER NOT NULL,
    fecha_inscripcion TEXT NOT NULL,
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    UNIQUE (id_alumno, id_grupo)
);

CREATE TABLE IF NOT EXISTS evaluaciones (
    id_evaluacion INTEGER PRIMARY KEY,
    id_grupo INTEGER NOT NULL,
    nombre TEXT NOT NULL,
    porcentaje INTEGER NOT NULL CHECK (porcentaje BETWEEN 0 AND 100),
    FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    UNIQUE (id_grupo, nombre)
);

CREATE TABLE IF NOT EXISTS calificaciones (
    id_calificacion INTEGER PRIMARY KEY,
    id_inscripcion INTEGER NOT NULL,
    id_evaluacion INTEGER NOT NULL,
    calificacion REAL NOT NULL CHECK (calificacion BETWEEN 0 AND 100),
    FOREIGN KEY (id_inscripcion) REFERENCES inscripciones(id_inscripcion)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (id_evaluacion) REFERENCES evaluaciones(id_evaluacion)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    UNIQUE (id_inscripcion, id_evaluacion)
);

CREATE TABLE IF NOT EXISTS pagos (
    id_pago INTEGER PRIMARY KEY,
    id_alumno INTEGER NOT NULL,
    id_periodo INTEGER NOT NULL,
    concepto TEXT NOT NULL,
    monto REAL NOT NULL CHECK (monto > 0),
    fecha_pago TEXT NOT NULL,
    referencia TEXT UNIQUE,
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (id_periodo) REFERENCES periodos(id_periodo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
