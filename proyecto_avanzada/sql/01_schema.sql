CREATE DATABASE IF NOT EXISTS escuela CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE escuela;

SET FOREIGN_KEY_CHECKS = 0;
DROP VIEW IF EXISTS vw_lista_curso;
DROP VIEW IF EXISTS vw_lista_grupo;
DROP VIEW IF EXISTS vw_horario_curso;
DROP VIEW IF EXISTS vw_horario_grupo;
DROP VIEW IF EXISTS vw_cursos_detalle;
DROP VIEW IF EXISTS vw_grupos_detalle;
DROP VIEW IF EXISTS vw_kardex;
DROP VIEW IF EXISTS vw_estado_cuenta;
DROP VIEW IF EXISTS vw_alumnos_carrera;
DROP VIEW IF EXISTS vw_docentes_cursos;
DROP VIEW IF EXISTS vw_resumen_pagos;
DROP VIEW IF EXISTS vw_facultades_carreras;
DROP VIEW IF EXISTS vw_boleta_alumno;
DROP VIEW IF EXISTS vw_calificaciones_detalle;
DROP VIEW IF EXISTS vw_calificaciones_por_materia;
DROP VIEW IF EXISTS vw_promedio_por_materia;
DROP TABLE IF EXISTS pagos;
DROP TABLE IF EXISTS calificaciones;
DROP TABLE IF EXISTS evaluaciones;
DROP TABLE IF EXISTS inscripciones;
DROP TABLE IF EXISTS horarios;
DROP TABLE IF EXISTS cursos;
DROP TABLE IF EXISTS grupos;
DROP TABLE IF EXISTS alumnos;
DROP TABLE IF EXISTS carreras_materias;
DROP TABLE IF EXISTS carreras;
DROP TABLE IF EXISTS facultades;
DROP TABLE IF EXISTS materias;
DROP TABLE IF EXISTS aulas;
DROP TABLE IF EXISTS periodos;
DROP TABLE IF EXISTS docentes;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE docentes (
  id_docente INT AUTO_INCREMENT PRIMARY KEY,
  num_empleado VARCHAR(20) NOT NULL,
  nombre VARCHAR(80) NOT NULL,
  apellidos VARCHAR(120) NOT NULL,
  correo VARCHAR(120) NULL,
  UNIQUE KEY uq_docentes_num_empleado (num_empleado)
) ENGINE=InnoDB;

CREATE TABLE periodos (
  id_periodo INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(20) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE aulas (
  id_aula INT AUTO_INCREMENT PRIMARY KEY,
  edificio VARCHAR(20) NOT NULL,
  nombre_aula VARCHAR(30) NOT NULL,
  capacidad INT NOT NULL,
  CONSTRAINT chk_aulas_capacidad CHECK (capacidad > 0)
) ENGINE=InnoDB;

CREATE TABLE facultades (
  id_facultad INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  clave VARCHAR(20) NOT NULL,
  UNIQUE KEY uq_facultades_clave (clave)
) ENGINE=InnoDB;

CREATE TABLE materias (
  id_materia INT AUTO_INCREMENT PRIMARY KEY,
  clave VARCHAR(20) NOT NULL,
  nombre VARCHAR(120) NOT NULL,
  creditos INT NOT NULL,
  UNIQUE KEY uq_materias_clave (clave),
  CONSTRAINT chk_materias_creditos CHECK (creditos > 0)
) ENGINE=InnoDB;

CREATE TABLE carreras (
  id_carrera INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_facultad INT NOT NULL,
  UNIQUE KEY uq_carreras_facultad_nombre (id_facultad, nombre),
  CONSTRAINT fk_carreras_facultades FOREIGN KEY (id_facultad) REFERENCES facultades(id_facultad)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE carreras_materias (
  id_carrera INT NOT NULL,
  id_materia INT NOT NULL,
  PRIMARY KEY (id_carrera, id_materia),
  CONSTRAINT fk_cm_carreras FOREIGN KEY (id_carrera) REFERENCES carreras(id_carrera)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_cm_materias FOREIGN KEY (id_materia) REFERENCES materias(id_materia)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE alumnos (
  id_alumno INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL,
  apellidos VARCHAR(120) NOT NULL,
  correo VARCHAR(120) NULL,
  telefono VARCHAR(30) NULL,
  fecha_nacimiento DATE NULL,
  estatus ENUM('Activo','Baja') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB;

CREATE TABLE cursos (
  id_curso INT AUTO_INCREMENT PRIMARY KEY,
  id_materia INT NOT NULL,
  id_docente INT NOT NULL,
  id_periodo INT NOT NULL,
  cupo_max INT NOT NULL,
  esta_lleno BOOLEAN NOT NULL DEFAULT FALSE,
  CONSTRAINT chk_cursos_cupo_max CHECK (cupo_max > 0),
  CONSTRAINT fk_cursos_materias FOREIGN KEY (id_materia) REFERENCES materias(id_materia)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_cursos_docentes FOREIGN KEY (id_docente) REFERENCES docentes(id_docente)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_cursos_periodos FOREIGN KEY (id_periodo) REFERENCES periodos(id_periodo)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE horarios (
  id_horario INT AUTO_INCREMENT PRIMARY KEY,
  id_curso INT NOT NULL,
  id_aula INT NOT NULL,
  dia_semana TINYINT NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fin TIME NOT NULL,
  CONSTRAINT chk_horarios_dia_semana CHECK (dia_semana BETWEEN 1 AND 7),
  CONSTRAINT chk_horarios_horas CHECK (hora_inicio < hora_fin),
  CONSTRAINT fk_horarios_cursos FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_horarios_aulas FOREIGN KEY (id_aula) REFERENCES aulas(id_aula)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE evaluaciones (
  id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
  id_curso INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  porcentaje DECIMAL(5,2) NOT NULL,
  orden TINYINT NOT NULL DEFAULT 1,
  CONSTRAINT chk_evaluaciones_porcentaje CHECK (porcentaje > 0 AND porcentaje <= 100),
  CONSTRAINT fk_evaluaciones_cursos FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  UNIQUE KEY uq_evaluaciones_curso_nombre (id_curso, nombre)
) ENGINE=InnoDB;

CREATE TABLE inscripciones (
  id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
  id_alumno INT NOT NULL,
  tipo ENUM('carrera','curso') NOT NULL,
  id_carrera INT NULL,
  id_curso INT NULL,
  fecha_inscripcion DATE NOT NULL,
  CONSTRAINT fk_inscripciones_alumnos FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_inscripciones_carreras FOREIGN KEY (id_carrera) REFERENCES carreras(id_carrera)
    ON UPDATE CASCADE
    ON DELETE SET NULL,
  CONSTRAINT fk_inscripciones_cursos FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE calificaciones (
  id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
  id_inscripcion INT NOT NULL,
  id_evaluacion INT NOT NULL,
  calificacion DECIMAL(5,2) NOT NULL,
  CONSTRAINT chk_calificaciones_valor CHECK (calificacion >= 0 AND calificacion <= 100),
  CONSTRAINT fk_calificaciones_inscripcion FOREIGN KEY (id_inscripcion) REFERENCES inscripciones(id_inscripcion)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_calificaciones_evaluacion FOREIGN KEY (id_evaluacion) REFERENCES evaluaciones(id_evaluacion)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  UNIQUE KEY uq_calificaciones_inscripcion_evaluacion (id_inscripcion, id_evaluacion)
) ENGINE=InnoDB;

CREATE TABLE pagos (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_alumno INT NOT NULL,
  id_periodo INT NOT NULL,
  concepto VARCHAR(100) NOT NULL,
  monto DECIMAL(10,2) NOT NULL,
  fecha_pago DATE NOT NULL,
  referencia VARCHAR(50) NULL,
  UNIQUE KEY uq_pagos_referencia (referencia),
  CONSTRAINT chk_pagos_monto CHECK (monto > 0),
  CONSTRAINT fk_pagos_alumnos FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_pagos_periodos FOREIGN KEY (id_periodo) REFERENCES periodos(id_periodo)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;
