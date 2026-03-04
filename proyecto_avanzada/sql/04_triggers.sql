USE escuela;

DROP TRIGGER IF EXISTS trg_inscripciones_cupo_bi;
DROP TRIGGER IF EXISTS trg_inscripciones_cupo_bu;
DROP TRIGGER IF EXISTS trg_evaluaciones_porcentaje_bi;
DROP TRIGGER IF EXISTS trg_evaluaciones_porcentaje_bu;
DROP TRIGGER IF EXISTS trg_horarios_conflicto_bi;
DROP TRIGGER IF EXISTS trg_horarios_conflicto_bu;
DROP TRIGGER IF EXISTS trg_calificaciones_consistencia_bi;
DROP TRIGGER IF EXISTS trg_calificaciones_consistencia_bu;

DELIMITER //

CREATE TRIGGER trg_inscripciones_cupo_bi
BEFORE INSERT ON inscripciones
FOR EACH ROW
BEGIN
  DECLARE v_cupo INT;
  DECLARE v_inscritos INT;

  SELECT cupo_max INTO v_cupo
  FROM grupos
  WHERE id_grupo = NEW.id_grupo;

  SELECT COUNT(*) INTO v_inscritos
  FROM inscripciones
  WHERE id_grupo = NEW.id_grupo;

  IF v_inscritos >= v_cupo THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cupo maximo alcanzado para el grupo';
  END IF;
END//

CREATE TRIGGER trg_inscripciones_cupo_bu
BEFORE UPDATE ON inscripciones
FOR EACH ROW
BEGIN
  DECLARE v_cupo INT;
  DECLARE v_inscritos INT;

  IF NEW.id_grupo <> OLD.id_grupo THEN
    SELECT cupo_max INTO v_cupo
    FROM grupos
    WHERE id_grupo = NEW.id_grupo;

    SELECT COUNT(*) INTO v_inscritos
    FROM inscripciones
    WHERE id_grupo = NEW.id_grupo;

    IF v_inscritos >= v_cupo THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cupo maximo alcanzado para el grupo';
    END IF;
  END IF;
END//

CREATE TRIGGER trg_evaluaciones_porcentaje_bi
BEFORE INSERT ON evaluaciones
FOR EACH ROW
BEGIN
  DECLARE v_sum INT;

  SELECT IFNULL(SUM(porcentaje), 0) INTO v_sum
  FROM evaluaciones
  WHERE id_grupo = NEW.id_grupo;

  IF v_sum + NEW.porcentaje > 100 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La suma de porcentajes por grupo no puede exceder 100';
  END IF;
END//

CREATE TRIGGER trg_evaluaciones_porcentaje_bu
BEFORE UPDATE ON evaluaciones
FOR EACH ROW
BEGIN
  DECLARE v_sum INT;

  SELECT IFNULL(SUM(porcentaje), 0) INTO v_sum
  FROM evaluaciones
  WHERE id_grupo = NEW.id_grupo
    AND id_evaluacion <> OLD.id_evaluacion;

  IF v_sum + NEW.porcentaje > 100 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La suma de porcentajes por grupo no puede exceder 100';
  END IF;
END//

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
    WHERE h.id_grupo = NEW.id_grupo
      AND h.dia_semana = NEW.dia_semana
      AND NOT (NEW.hora_fin <= h.hora_inicio OR NEW.hora_inicio >= h.hora_fin)
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conflicto de horario: el grupo ya tiene clase en ese horario';
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
      AND h.id_grupo = NEW.id_grupo
      AND h.dia_semana = NEW.dia_semana
      AND NOT (NEW.hora_fin <= h.hora_inicio OR NEW.hora_inicio >= h.hora_fin)
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conflicto de horario: el grupo ya tiene clase en ese horario';
  END IF;
END//

CREATE TRIGGER trg_calificaciones_consistencia_bi
BEFORE INSERT ON calificaciones
FOR EACH ROW
BEGIN
  DECLARE v_grupo_insc INT;
  DECLARE v_grupo_eval INT;

  SELECT id_grupo INTO v_grupo_insc
  FROM inscripciones
  WHERE id_inscripcion = NEW.id_inscripcion;

  SELECT id_grupo INTO v_grupo_eval
  FROM evaluaciones
  WHERE id_evaluacion = NEW.id_evaluacion;

  IF v_grupo_insc IS NULL OR v_grupo_eval IS NULL OR v_grupo_insc <> v_grupo_eval THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La evaluacion no pertenece al grupo de la inscripcion';
  END IF;
END//

CREATE TRIGGER trg_calificaciones_consistencia_bu
BEFORE UPDATE ON calificaciones
FOR EACH ROW
BEGIN
  DECLARE v_grupo_insc INT;
  DECLARE v_grupo_eval INT;

  SELECT id_grupo INTO v_grupo_insc
  FROM inscripciones
  WHERE id_inscripcion = NEW.id_inscripcion;

  SELECT id_grupo INTO v_grupo_eval
  FROM evaluaciones
  WHERE id_evaluacion = NEW.id_evaluacion;

  IF v_grupo_insc IS NULL OR v_grupo_eval IS NULL OR v_grupo_insc <> v_grupo_eval THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La evaluacion no pertenece al grupo de la inscripcion';
  END IF;
END//

DELIMITER ;
