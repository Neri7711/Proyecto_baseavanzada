USE escuela;

DROP TRIGGER IF EXISTS trg_inscripciones_cupo_bi;
DROP TRIGGER IF EXISTS trg_inscripciones_cupo_bu;
DROP TRIGGER IF EXISTS trg_evaluaciones_porcentaje_bi;
DROP TRIGGER IF EXISTS trg_evaluaciones_porcentaje_bu;
DROP TRIGGER IF EXISTS trg_horarios_conflicto_bi;
DROP TRIGGER IF EXISTS trg_horarios_conflicto_bu;
DROP TRIGGER IF EXISTS trg_calificaciones_consistencia_bi;
DROP TRIGGER IF EXISTS trg_calificaciones_consistencia_bu;
DROP TRIGGER IF EXISTS trg_pagos_consistencia_bi;
DROP TRIGGER IF EXISTS trg_pagos_consistencia_bu;
DROP TRIGGER IF EXISTS trg_pagos_estado_ai;
DROP TRIGGER IF EXISTS trg_pagos_estado_au;
DROP TRIGGER IF EXISTS trg_pagos_estado_ad;

DELIMITER //

-- Cupo maximo por curso (inscripciones tipo curso)
CREATE TRIGGER trg_inscripciones_cupo_bi
BEFORE INSERT ON inscripciones
FOR EACH ROW
BEGIN
  DECLARE v_cupo INT;
  DECLARE v_inscritos INT;

  IF NEW.id_curso IS NOT NULL THEN
    SELECT cupo_max INTO v_cupo
    FROM cursos
    WHERE id_curso = NEW.id_curso;

    SELECT COUNT(*) INTO v_inscritos
    FROM inscripciones
    WHERE id_curso = NEW.id_curso
      AND tipo = 'curso';

    IF v_inscritos >= v_cupo THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cupo maximo alcanzado para el curso';
    END IF;
  END IF;
END//

CREATE TRIGGER trg_inscripciones_cupo_bu
BEFORE UPDATE ON inscripciones
FOR EACH ROW
BEGIN
  DECLARE v_cupo INT;
  DECLARE v_inscritos INT;

  IF NEW.id_curso IS NOT NULL AND (OLD.id_curso IS NULL OR NEW.id_curso <> OLD.id_curso) THEN
    SELECT cupo_max INTO v_cupo
    FROM cursos
    WHERE id_curso = NEW.id_curso;

    SELECT COUNT(*) INTO v_inscritos
    FROM inscripciones
    WHERE id_curso = NEW.id_curso
      AND tipo = 'curso';

    IF v_inscritos >= v_cupo THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cupo maximo alcanzado para el curso';
    END IF;
  END IF;
END//

-- Suma de porcentajes por curso no debe exceder 100
CREATE TRIGGER trg_evaluaciones_porcentaje_bi
BEFORE INSERT ON evaluaciones
FOR EACH ROW
BEGIN
  DECLARE v_sum DECIMAL(5,2);

  SELECT IFNULL(SUM(porcentaje), 0) INTO v_sum
  FROM evaluaciones
  WHERE id_curso = NEW.id_curso;

  IF v_sum + NEW.porcentaje > 100 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La suma de porcentajes por curso no puede exceder 100';
  END IF;
END//

CREATE TRIGGER trg_evaluaciones_porcentaje_bu
BEFORE UPDATE ON evaluaciones
FOR EACH ROW
BEGIN
  DECLARE v_sum DECIMAL(5,2);

  SELECT IFNULL(SUM(porcentaje), 0) INTO v_sum
  FROM evaluaciones
  WHERE id_curso = NEW.id_curso
    AND id_evaluacion <> OLD.id_evaluacion;

  IF v_sum + NEW.porcentaje > 100 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La suma de porcentajes por curso no puede exceder 100';
  END IF;
END//

-- Conflicto de horario: aula y curso no pueden solaparse
CREATE TRIGGER trg_horarios_conflicto_bi
BEFORE INSERT ON horarios
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1
    FROM horarios h
    WHERE h.id_aula = NEW.id_aula
      AND h.dia_semana = NEW.dia_semana
      AND NOT (NEW.hora_fin <= h.hora_inicio OR NEW.hora_inicio >= h.hora_fin)
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conflicto de horario: aula ocupada';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM horarios h
    WHERE h.id_curso = NEW.id_curso
      AND h.dia_semana = NEW.dia_semana
      AND NOT (NEW.hora_fin <= h.hora_inicio OR NEW.hora_inicio >= h.hora_fin)
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conflicto de horario: el curso ya tiene clase en ese horario';
  END IF;
END//

CREATE TRIGGER trg_horarios_conflicto_bu
BEFORE UPDATE ON horarios
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1
    FROM horarios h
    WHERE h.id_horario <> NEW.id_horario
      AND h.id_aula = NEW.id_aula
      AND h.dia_semana = NEW.dia_semana
      AND NOT (NEW.hora_fin <= h.hora_inicio OR NEW.hora_inicio >= h.hora_fin)
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conflicto de horario: aula ocupada';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM horarios h
    WHERE h.id_horario <> NEW.id_horario
      AND h.id_curso = NEW.id_curso
      AND h.dia_semana = NEW.dia_semana
      AND NOT (NEW.hora_fin <= h.hora_inicio OR NEW.hora_inicio >= h.hora_fin)
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conflicto de horario: el curso ya tiene clase en ese horario';
  END IF;
END//

-- Calificacion: inscripcion y evaluacion deben pertenecer al mismo curso
CREATE TRIGGER trg_calificaciones_consistencia_bi
BEFORE INSERT ON calificaciones
FOR EACH ROW
BEGIN
  DECLARE v_curso_insc INT;
  DECLARE v_curso_eval INT;

  SELECT i.id_curso INTO v_curso_insc
  FROM inscripciones i
  WHERE i.id_inscripcion = NEW.id_inscripcion AND i.tipo = 'curso';

  SELECT e.id_curso INTO v_curso_eval
  FROM evaluaciones e
  WHERE e.id_evaluacion = NEW.id_evaluacion;

  IF v_curso_insc IS NULL OR v_curso_eval IS NULL OR v_curso_insc <> v_curso_eval THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La evaluacion no pertenece al curso de la inscripcion';
  END IF;
END//

CREATE TRIGGER trg_calificaciones_consistencia_bu
BEFORE UPDATE ON calificaciones
FOR EACH ROW
BEGIN
  DECLARE v_curso_insc INT;
  DECLARE v_curso_eval INT;

  SELECT i.id_curso INTO v_curso_insc
  FROM inscripciones i
  WHERE i.id_inscripcion = NEW.id_inscripcion AND i.tipo = 'curso';

  SELECT e.id_curso INTO v_curso_eval
  FROM evaluaciones e
  WHERE e.id_evaluacion = NEW.id_evaluacion;

  IF v_curso_insc IS NULL OR v_curso_eval IS NULL OR v_curso_insc <> v_curso_eval THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La evaluacion no pertenece al curso de la inscripcion';
  END IF;
END//

-- Pagos: el cargo debe pertenecer al mismo alumno y periodo del pago
CREATE TRIGGER trg_pagos_consistencia_bi
BEFORE INSERT ON pagos
FOR EACH ROW
BEGIN
  DECLARE v_alumno_cargo INT;
  DECLARE v_periodo_cargo INT;

  SELECT c.id_alumno, c.id_periodo
  INTO v_alumno_cargo, v_periodo_cargo
  FROM cargos c
  WHERE c.id_cargo = NEW.id_concepto;

  IF v_alumno_cargo IS NULL OR v_periodo_cargo IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cargo asociado no existe';
  END IF;

  IF v_alumno_cargo <> NEW.id_alumno OR v_periodo_cargo <> NEW.id_periodo THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pago no coincide con alumno/periodo del cargo';
  END IF;
END//

CREATE TRIGGER trg_pagos_consistencia_bu
BEFORE UPDATE ON pagos
FOR EACH ROW
BEGIN
  DECLARE v_alumno_cargo INT;
  DECLARE v_periodo_cargo INT;

  SELECT c.id_alumno, c.id_periodo
  INTO v_alumno_cargo, v_periodo_cargo
  FROM cargos c
  WHERE c.id_cargo = NEW.id_concepto;

  IF v_alumno_cargo IS NULL OR v_periodo_cargo IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cargo asociado no existe';
  END IF;

  IF v_alumno_cargo <> NEW.id_alumno OR v_periodo_cargo <> NEW.id_periodo THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pago no coincide con alumno/periodo del cargo';
  END IF;
END//

-- Actualizar estado del cargo con base en suma pagada
CREATE TRIGGER trg_pagos_estado_ai
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN
  UPDATE cargos c
  SET c.estado = CASE
    WHEN IFNULL((SELECT SUM(p.monto) FROM pagos p WHERE p.id_concepto = NEW.id_concepto), 0) >= c.monto THEN 'pagado'
    WHEN IFNULL((SELECT SUM(p.monto) FROM pagos p WHERE p.id_concepto = NEW.id_concepto), 0) > 0 THEN 'parcial'
    ELSE 'pendiente'
  END
  WHERE c.id_cargo = NEW.id_concepto;
END//

CREATE TRIGGER trg_pagos_estado_au
AFTER UPDATE ON pagos
FOR EACH ROW
BEGIN
  UPDATE cargos c
  SET c.estado = CASE
    WHEN IFNULL((SELECT SUM(p.monto) FROM pagos p WHERE p.id_concepto = OLD.id_concepto), 0) >= c.monto THEN 'pagado'
    WHEN IFNULL((SELECT SUM(p.monto) FROM pagos p WHERE p.id_concepto = OLD.id_concepto), 0) > 0 THEN 'parcial'
    ELSE 'pendiente'
  END
  WHERE c.id_cargo = OLD.id_concepto;

  UPDATE cargos c
  SET c.estado = CASE
    WHEN IFNULL((SELECT SUM(p.monto) FROM pagos p WHERE p.id_concepto = NEW.id_concepto), 0) >= c.monto THEN 'pagado'
    WHEN IFNULL((SELECT SUM(p.monto) FROM pagos p WHERE p.id_concepto = NEW.id_concepto), 0) > 0 THEN 'parcial'
    ELSE 'pendiente'
  END
  WHERE c.id_cargo = NEW.id_concepto;
END//

CREATE TRIGGER trg_pagos_estado_ad
AFTER DELETE ON pagos
FOR EACH ROW
BEGIN
  UPDATE cargos c
  SET c.estado = CASE
    WHEN IFNULL((SELECT SUM(p.monto) FROM pagos p WHERE p.id_concepto = OLD.id_concepto), 0) >= c.monto THEN 'pagado'
    WHEN IFNULL((SELECT SUM(p.monto) FROM pagos p WHERE p.id_concepto = OLD.id_concepto), 0) > 0 THEN 'parcial'
    ELSE 'pendiente'
  END
  WHERE c.id_cargo = OLD.id_concepto;
END//

DELIMITER ;
