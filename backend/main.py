from fastapi import FastAPI
from sqlalchemy import create_engine, text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from fastapi.middleware.cors import CORSMiddleware

from decimal import Decimal
from enum import Enum


class EstatusAlumno(str, Enum):
    """Estatus permitido para alumnos."""
    ACTIVO = "Activo"
    BAJA = "Baja"
    EGRESADO = "Egresado"


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, restringe a tu dominio
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 1. Configuración de la URL (ajustada a tu YML)
DATABASE_URL = "mysql+pymysql://app:app123@localhost:3306/escuela"

# 2. Crear el motor y la sesión
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


# ───────────── Utilidades ─────────────

def _to_number(value, default=0):
    if value is None:
        return default
    if isinstance(value, (int, float)):
        return value
    if isinstance(value, Decimal):
        return float(value)
    try:
        return float(value)
    except Exception:
        return default


def _fetch_all_query(sql: str, params: dict | None = None):
    with engine.connect() as connection:
        result = connection.execute(text(sql), params or {})
        return [dict(row._mapping) for row in result]


def _safe_fetch_all(
    primary_sql: str,
    fallback_sql: str | None = None,
    *,
    fallback_if_empty: bool = False,
    params: dict | None = None,
):
    try:
        data = _fetch_all_query(primary_sql, params)
        if fallback_if_empty and not data and fallback_sql:
            return _fetch_all_query(fallback_sql, params)
        return data
    except Exception:
        if fallback_sql:
            return _fetch_all_query(fallback_sql, params)
        raise


# ───────────── Rutas de salud ─────────────

@app.get("/")
def read_root():
    return {"status": "Backend en Python funcionando"}


@app.get("/test-db")
def test_db():
    try:
        with engine.connect() as connection:
            result = connection.execute(text("SELECT 1"))
            row = result.fetchone()
            return {
                "message": "Conexión exitosa a MySQL",
                "data": row[0] if row is not None else None,
            }
    except Exception as e:
        return {"error": str(e)}


# ───────────── Dashboard KPIs ─────────────

@app.get("/api/dashboard/kpis")
def get_dashboard_kpis():
    """
    Indicadores principales del dashboard:
    - rendimiento_global
    - total_alumnos
    - porcentaje_pagos_corriente
    - docentes_activos
    - tasa_reprobacion        ← NUEVO
    - deuda_pendiente         ← NUEVO
    """
    try:
        with engine.connect() as connection:
            # Rendimiento global
            rendimiento_row = connection.execute(
                text("SELECT ROUND(AVG(calificacion), 2) FROM calificaciones")
            ).fetchone()
            rendimiento_global = _to_number(
                rendimiento_row[0] if rendimiento_row else None, 0.0
            )

            # Total alumnos
            total_row = connection.execute(
                text("SELECT COUNT(*) FROM alumnos")
            ).fetchone()
            total_alumnos = int(_to_number(total_row[0] if total_row else None, 0))

            # Alumnos activos (para cálculo de pagos)
            activos_row = connection.execute(
                text("SELECT COUNT(*) FROM alumnos WHERE estatus = 'Activo'")
            ).fetchone()
            alumnos_activos = int(_to_number(activos_row[0] if activos_row else None, 0))

            # Porcentaje de pagos al corriente
            cumplimiento_row = connection.execute(
                text(
                    "SELECT AVG(porcentaje_individual) FROM ("
                    "  SELECT "
                    "    CASE "
                    "      WHEN IFNULL(cg.total_cargado, 0) = 0 THEN 0 "
                    "      ELSE LEAST(IFNULL(pg.total_pagado, 0) / cg.total_cargado * 100, 100) "
                    "    END AS porcentaje_individual "
                    "  FROM alumnos a "
                    "  LEFT JOIN ("
                    "    SELECT id_alumno, SUM(monto) AS total_cargado FROM cargos GROUP BY id_alumno"
                    "  ) cg ON cg.id_alumno = a.id_alumno "
                    "  LEFT JOIN ("
                    "    SELECT id_alumno, SUM(monto) AS total_pagado FROM pagos GROUP BY id_alumno"
                    "  ) pg ON pg.id_alumno = a.id_alumno "
                    "  WHERE a.estatus = 'Activo'"
                    ") t"
                )
            ).fetchone()
            porcentaje_pagos_corriente = round(
                _to_number(cumplimiento_row[0] if cumplimiento_row else None, 0.0), 2
            ) if alumnos_activos > 0 else 0.0

            # Docentes activos
            docentes_row = connection.execute(
                text("SELECT COUNT(DISTINCT id_docente) FROM cursos")
            ).fetchone()
            docentes_activos = int(_to_number(docentes_row[0] if docentes_row else None, 0))

            # ── NUEVO: Tasa de reprobación ──
            reprob_row = connection.execute(
                text(
                    "SELECT "
                    "  ROUND("
                    "    SUM(CASE WHEN calificacion < 70 THEN 1 ELSE 0 END) / COUNT(*) * 100"
                    "  , 2) "
                    "FROM calificaciones"
                )
            ).fetchone()
            tasa_reprobacion = _to_number(reprob_row[0] if reprob_row else None, 0.0)

            # ── NUEVO: Deuda pendiente ──
            deuda_row = connection.execute(
                text(
                    "SELECT ROUND("
                    "  IFNULL(SUM(c.monto), 0) - IFNULL(("
                    "    SELECT SUM(p.monto) FROM pagos p"
                    "  ), 0)"
                    ", 2) FROM cargos c"
                )
            ).fetchone()
            deuda_pendiente = _to_number(deuda_row[0] if deuda_row else None, 0.0)

            return {
                "rendimiento_global": rendimiento_global,
                "total_alumnos": total_alumnos,
                "porcentaje_pagos_corriente": porcentaje_pagos_corriente,
                "docentes_activos": docentes_activos,
                "tasa_reprobacion": tasa_reprobacion,
                "deuda_pendiente": deuda_pendiente,
            }
    except Exception as e:
        return {"error": str(e)}


# ───────────── Académico ─────────────

@app.get("/api/vistas/vw_rendimiento_por_carrera")
def get_rendimiento():
    try:
        return _safe_fetch_all(
            "SELECT * FROM vw_rendimiento_por_carrera",
            (
                "SELECT cr.nombre AS carrera, ROUND(AVG(ca.calificacion), 2) AS promedio_general "
                "FROM carreras cr "
                "JOIN carreras_materias cm ON cm.id_carrera = cr.id_carrera "
                "JOIN cursos cu ON cu.id_materia = cm.id_materia "
                "JOIN inscripciones i ON i.id_curso = cu.id_curso AND i.tipo = 'curso' "
                "JOIN calificaciones ca ON ca.id_inscripcion = i.id_inscripcion "
                "GROUP BY cr.id_carrera, cr.nombre"
            ),
            fallback_if_empty=True,
        )
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/academico/materias-criticas")
def get_materias_criticas():
    try:
        return _safe_fetch_all(
            "SELECT * FROM vw_materias_criticas",
            (
                "SELECT m.nombre AS materia, m.clave, ROUND(AVG(ca.calificacion), 2) AS promedio "
                "FROM materias m "
                "JOIN cursos cu ON cu.id_materia = m.id_materia "
                "JOIN inscripciones i ON i.id_curso = cu.id_curso AND i.tipo = 'curso' "
                "JOIN calificaciones ca ON ca.id_inscripcion = i.id_inscripcion "
                "GROUP BY m.id_materia, m.nombre, m.clave "
                "HAVING ROUND(AVG(ca.calificacion), 2) < 70"
            ),
        )
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/academico/ranking-docentes")
def get_ranking_docentes():
    try:
        return _safe_fetch_all(
            "SELECT * FROM vw_ranking_docentes_promedio",
            (
                "SELECT d.nombre, d.apellidos, d.num_empleado, "
                "ROUND(AVG(ca.calificacion), 2) AS promedio_alumnos "
                "FROM docentes d "
                "JOIN cursos cu ON cu.id_docente = d.id_docente "
                "JOIN inscripciones i ON i.id_curso = cu.id_curso AND i.tipo = 'curso' "
                "JOIN calificaciones ca ON ca.id_inscripcion = i.id_inscripcion "
                "GROUP BY d.id_docente, d.nombre, d.apellidos, d.num_empleado"
            ),
        )
    except Exception as e:
        return {"error": str(e)}


# ── NUEVO: Top reprobados ──
@app.get("/api/academico/top-reprobados")
def get_top_reprobados():
    try:
        return _safe_fetch_all(
            "SELECT * FROM vw_top_reprobados LIMIT 10",
            (
                "SELECT "
                "  t.materia, "
                "  t.clave, "
                "  SUM(CASE WHEN t.calificacion_final < 70 THEN 1 ELSE 0 END) AS total_reprobados, "
                "  COUNT(*) AS total_alumnos, "
                "  ROUND(SUM(CASE WHEN t.calificacion_final < 70 THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS porcentaje_reprobacion "
                "FROM ("
                "  SELECT "
                "    m.id_materia, "
                "    m.nombre AS materia, "
                "    m.clave AS clave, "
                "    i.id_alumno, "
                "    SUM(ca.calificacion * (e.porcentaje / 100.0)) AS calificacion_final "
                "  FROM calificaciones ca "
                "  JOIN inscripciones i ON i.id_inscripcion = ca.id_inscripcion AND i.tipo = 'curso' "
                "  JOIN evaluaciones e ON e.id_evaluacion = ca.id_evaluacion "
                "  JOIN cursos cu ON cu.id_curso = i.id_curso "
                "  JOIN materias m ON m.id_materia = cu.id_materia "
                "  GROUP BY m.id_materia, m.nombre, m.clave, i.id_alumno"
                ") t "
                "GROUP BY t.materia, t.clave "
                "ORDER BY total_reprobados DESC "
                "LIMIT 10"
            ),
        )
    except Exception as e:
        return {"error": str(e)}


# ── NUEVO: Carga docente ──
@app.get("/api/academico/carga-docente")
def get_carga_docente():
    try:
        sql = (
            "SELECT "
            "  CONCAT(d.nombre, ' ', d.apellidos) AS docente, "
            "  d.num_empleado, "
            "  COUNT(DISTINCT cu.id_curso) AS total_cursos, "
            "  COUNT(DISTINCT i.id_alumno) AS total_alumnos "
            "FROM docentes d "
            "JOIN cursos cu ON cu.id_docente = d.id_docente "
            "LEFT JOIN inscripciones i ON i.id_curso = cu.id_curso AND i.tipo = 'curso' "
            "GROUP BY d.id_docente, d.nombre, d.apellidos, d.num_empleado "
            "ORDER BY total_cursos DESC"
        )
        return _fetch_all_query(sql)
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/academico/radar-facultad")
def get_radar_facultad():
    try:
        sql = (
            "SELECT "
            "  f.facultad, "
            "  ROUND(IFNULL(r.rendimiento_promedio, 0), 2) AS rendimiento_promedio, "
            "  ROUND(IFNULL(o.ocupacion_promedio, 0), 2) AS ocupacion_promedio, "
            "  ROUND(IFNULL(rep.tasa_reprobacion, 0), 2) AS tasa_reprobacion, "
            "  ROUND(IFNULL(fin.cobertura_pagos, 0), 2) AS cobertura_pagos, "
            "  ROUND(IFNULL(ret.retencion_activos, 0), 2) AS retencion_activos "
            "FROM ("
            "  SELECT DISTINCT COALESCE(v.facultad, 'Sin facultad') AS facultad "
            "  FROM vw_alumnos_carrera v"
            ") f "
            "LEFT JOIN ("
            "  SELECT "
            "    COALESCE(v.facultad, 'Sin facultad') AS facultad, "
            "    AVG(ca.calificacion) AS rendimiento_promedio "
            "  FROM calificaciones ca "
            "  JOIN inscripciones i ON i.id_inscripcion = ca.id_inscripcion AND i.tipo = 'curso' "
            "  LEFT JOIN vw_alumnos_carrera v ON v.id_alumno = i.id_alumno "
            "  GROUP BY COALESCE(v.facultad, 'Sin facultad')"
            ") r ON r.facultad = f.facultad "
            "LEFT JOIN ("
            "  SELECT "
            "    COALESCE(fp.facultad_plan, 'Sin facultad') AS facultad, "
            "    AVG(LEAST((IFNULL(ins.inscritos, 0) / cu.cupo_max) * 100, 100)) AS ocupacion_promedio "
            "  FROM cursos cu "
            "  LEFT JOIN ("
            "    SELECT i.id_curso, COUNT(DISTINCT i.id_alumno) AS inscritos "
            "    FROM inscripciones i "
            "    WHERE i.tipo = 'curso' "
            "    GROUP BY i.id_curso"
            "  ) ins ON ins.id_curso = cu.id_curso "
            "  LEFT JOIN ("
            "    SELECT "
            "      cm.id_materia, "
            "      CASE WHEN COUNT(DISTINCT f.nombre) = 1 THEN MIN(f.nombre) ELSE 'Multifacultad' END AS facultad_plan "
            "    FROM carreras_materias cm "
            "    JOIN carreras cr ON cr.id_carrera = cm.id_carrera "
            "    JOIN facultades f ON f.id_facultad = cr.id_facultad "
            "    GROUP BY cm.id_materia"
            "  ) fp ON fp.id_materia = cu.id_materia "
            "  GROUP BY COALESCE(fp.facultad_plan, 'Sin facultad')"
            ") o ON o.facultad = f.facultad "
            "LEFT JOIN ("
            "  SELECT "
            "    COALESCE(v.facultad, 'Sin facultad') AS facultad, "
            "    SUM(CASE WHEN ca.calificacion < 70 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS tasa_reprobacion "
            "  FROM calificaciones ca "
            "  JOIN inscripciones i ON i.id_inscripcion = ca.id_inscripcion AND i.tipo = 'curso' "
            "  LEFT JOIN vw_alumnos_carrera v ON v.id_alumno = i.id_alumno "
            "  GROUP BY COALESCE(v.facultad, 'Sin facultad')"
            ") rep ON rep.facultad = f.facultad "
            "LEFT JOIN ("
            "  SELECT "
            "    z.facultad, "
            "    CASE WHEN IFNULL(z.total_cargado, 0) = 0 THEN 0 "
            "         ELSE LEAST(IFNULL(z.total_pagado, 0) / z.total_cargado * 100, 100) "
            "    END AS cobertura_pagos "
            "  FROM ("
            "    SELECT "
            "      COALESCE(v.facultad, 'Sin facultad') AS facultad, "
            "      SUM(c.monto) AS total_cargado, "
            "      SUM(IFNULL(pg.total_pagado, 0)) AS total_pagado "
            "    FROM cargos c "
            "    LEFT JOIN vw_alumnos_carrera v ON v.id_alumno = c.id_alumno "
            "    LEFT JOIN ("
            "      SELECT id_concepto, SUM(monto) AS total_pagado "
            "      FROM pagos "
            "      GROUP BY id_concepto"
            "    ) pg ON pg.id_concepto = c.id_cargo "
            "    GROUP BY COALESCE(v.facultad, 'Sin facultad')"
            "  ) z"
            ") fin ON fin.facultad = f.facultad "
            "LEFT JOIN ("
            "  SELECT "
            "    COALESCE(v.facultad, 'Sin facultad') AS facultad, "
            "    SUM(CASE WHEN a.estatus = 'Activo' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS retencion_activos "
            "  FROM alumnos a "
            "  LEFT JOIN vw_alumnos_carrera v ON v.id_alumno = a.id_alumno "
            "  GROUP BY COALESCE(v.facultad, 'Sin facultad')"
            ") ret ON ret.facultad = f.facultad "
            "ORDER BY f.facultad"
        )
        return _fetch_all_query(sql)
    except Exception:
        fallback_sql = (
            "SELECT "
            "  COALESCE(f.nombre, 'Sin facultad') AS facultad, "
            "  ROUND(AVG(ca.calificacion), 2) AS rendimiento_promedio, "
            "  ROUND(AVG(LEAST((IFNULL(ins.inscritos, 0) / cu.cupo_max) * 100, 100)), 2) AS ocupacion_promedio, "
            "  ROUND(SUM(CASE WHEN ca.calificacion < 70 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS tasa_reprobacion, "
            "  ROUND(AVG(CASE WHEN IFNULL(carg.total_cargado, 0) = 0 THEN 0 ELSE LEAST(IFNULL(carg.total_pagado, 0) / carg.total_cargado * 100, 100) END), 2) AS cobertura_pagos, "
            "  ROUND(SUM(CASE WHEN a.estatus = 'Activo' THEN 1 ELSE 0 END) / COUNT(DISTINCT a.id_alumno) * 100, 2) AS retencion_activos "
            "FROM alumnos a "
            "LEFT JOIN inscripciones icarr ON icarr.id_alumno = a.id_alumno AND icarr.tipo = 'carrera' "
            "LEFT JOIN carreras cr ON cr.id_carrera = icarr.id_carrera "
            "LEFT JOIN facultades f ON f.id_facultad = cr.id_facultad "
            "LEFT JOIN inscripciones i ON i.id_alumno = a.id_alumno AND i.tipo = 'curso' "
            "LEFT JOIN calificaciones ca ON ca.id_inscripcion = i.id_inscripcion "
            "LEFT JOIN cursos cu ON cu.id_curso = i.id_curso "
            "LEFT JOIN ("
            "  SELECT id_curso, COUNT(DISTINCT id_alumno) AS inscritos "
            "  FROM inscripciones "
            "  WHERE tipo = 'curso' "
            "  GROUP BY id_curso"
            ") ins ON ins.id_curso = cu.id_curso "
            "LEFT JOIN ("
            "  SELECT "
            "    c.id_alumno, "
            "    SUM(c.monto) AS total_cargado, "
            "    SUM(IFNULL(pg.total_pagado, 0)) AS total_pagado "
            "  FROM cargos c "
            "  LEFT JOIN ("
            "    SELECT id_concepto, SUM(monto) AS total_pagado "
            "    FROM pagos "
            "    GROUP BY id_concepto"
            "  ) pg ON pg.id_concepto = c.id_cargo "
            "  GROUP BY c.id_alumno"
            ") carg ON carg.id_alumno = a.id_alumno "
            "GROUP BY COALESCE(f.nombre, 'Sin facultad') "
            "ORDER BY facultad"
        )
        try:
            return _fetch_all_query(fallback_sql)
        except Exception as e:
            return {"error": str(e)}


@app.get("/api/academico/sunburst-jerarquia")
def get_sunburst_jerarquia():
    try:
        primary_sql = (
            "SELECT "
            "  cu.id_curso, "
            "  COALESCE(dom.facultad, fp.facultad_plan, 'Sin facultad') AS facultad, "
            "  COALESCE(dom.carrera, fp.carrera_plan, 'Sin carrera') AS carrera, "
            "  m.nombre AS materia, "
            "  CONCAT('Curso ', cu.id_curso) AS curso, "
            "  cu.cupo_max, "
            "  COUNT(DISTINCT i.id_alumno) AS inscritos, "
            "  LEAST(ROUND((COUNT(DISTINCT i.id_alumno) / cu.cupo_max) * 100, 2), 100) AS porcentaje_llenado "
            "FROM cursos cu "
            "JOIN materias m ON m.id_materia = cu.id_materia "
            "LEFT JOIN inscripciones i ON i.id_curso = cu.id_curso AND i.tipo = 'curso' "
            "LEFT JOIN ("
            "  SELECT y.id_curso, y.facultad, y.carrera "
            "  FROM ("
            "    SELECT "
            "      ic.id_curso, "
            "      COALESCE(v.facultad, 'Sin facultad') AS facultad, "
            "      COALESCE(v.carrera, 'Sin carrera') AS carrera, "
            "      COUNT(*) AS total, "
            "      ROW_NUMBER() OVER ("
            "        PARTITION BY ic.id_curso "
            "        ORDER BY COUNT(*) DESC, COALESCE(v.facultad, 'Sin facultad'), COALESCE(v.carrera, 'Sin carrera')"
            "      ) AS rn "
            "    FROM inscripciones ic "
            "    LEFT JOIN vw_alumnos_carrera v ON v.id_alumno = ic.id_alumno "
            "    WHERE ic.tipo = 'curso' "
            "    GROUP BY ic.id_curso, COALESCE(v.facultad, 'Sin facultad'), COALESCE(v.carrera, 'Sin carrera')"
            "  ) y "
            "  WHERE y.rn = 1"
            ") dom ON dom.id_curso = cu.id_curso "
            "LEFT JOIN ("
            "  SELECT "
            "    cm.id_materia, "
            "    CASE WHEN COUNT(DISTINCT f.nombre) = 1 THEN MIN(f.nombre) ELSE 'Multifacultad' END AS facultad_plan, "
            "    CASE WHEN COUNT(DISTINCT cr.nombre) = 1 THEN MIN(cr.nombre) ELSE 'Multicarrera' END AS carrera_plan "
            "  FROM carreras_materias cm "
            "  JOIN carreras cr ON cr.id_carrera = cm.id_carrera "
            "  JOIN facultades f ON f.id_facultad = cr.id_facultad "
            "  GROUP BY cm.id_materia"
            ") fp ON fp.id_materia = cu.id_materia "
            "GROUP BY cu.id_curso, m.nombre, cu.cupo_max, "
            "         COALESCE(dom.facultad, fp.facultad_plan, 'Sin facultad'), "
            "         COALESCE(dom.carrera, fp.carrera_plan, 'Sin carrera') "
            "ORDER BY facultad, carrera, m.nombre, cu.id_curso"
        )
        return _fetch_all_query(primary_sql)
    except Exception:
        fallback_sql = (
            "SELECT "
            "  cu.id_curso, "
            "  COALESCE(fp.facultad_plan, 'Sin facultad') AS facultad, "
            "  COALESCE(fp.carrera_plan, 'Sin carrera') AS carrera, "
            "  m.nombre AS materia, "
            "  CONCAT('Curso ', cu.id_curso) AS curso, "
            "  cu.cupo_max, "
            "  COUNT(DISTINCT i.id_alumno) AS inscritos, "
            "  LEAST(ROUND((COUNT(DISTINCT i.id_alumno) / cu.cupo_max) * 100, 2), 100) AS porcentaje_llenado "
            "FROM cursos cu "
            "JOIN materias m ON m.id_materia = cu.id_materia "
            "LEFT JOIN inscripciones i ON i.id_curso = cu.id_curso AND i.tipo = 'curso' "
            "LEFT JOIN ("
            "  SELECT "
            "    cm.id_materia, "
            "    CASE WHEN COUNT(DISTINCT f.nombre) = 1 THEN MIN(f.nombre) ELSE 'Multifacultad' END AS facultad_plan, "
            "    CASE WHEN COUNT(DISTINCT cr.nombre) = 1 THEN MIN(cr.nombre) ELSE 'Multicarrera' END AS carrera_plan "
            "  FROM carreras_materias cm "
            "  JOIN carreras cr ON cr.id_carrera = cm.id_carrera "
            "  JOIN facultades f ON f.id_facultad = cr.id_facultad "
            "  GROUP BY cm.id_materia"
            ") fp ON fp.id_materia = cu.id_materia "
            "GROUP BY cu.id_curso, m.nombre, cu.cupo_max, COALESCE(fp.facultad_plan, 'Sin facultad'), COALESCE(fp.carrera_plan, 'Sin carrera') "
            "ORDER BY facultad, carrera, m.nombre, cu.id_curso"
        )
        try:
            return _fetch_all_query(fallback_sql)
        except Exception as e:
            return {"error": str(e)}


# ───────────── Control Escolar ─────────────

@app.get("/api/academico/ranking-facultad-periodo")
def get_ranking_facultad_periodo():
    try:
        primary_sql = (
            "SELECT "
            "  t.periodo, "
            "  t.facultad, "
            "  t.total_inscripciones, "
            "  t.ranking "
            "FROM ("
            "  SELECT "
            "    p.id_periodo, "
            "    p.nombre AS periodo, "
            "    COALESCE(v.facultad, 'Sin facultad') AS facultad, "
            "    COUNT(*) AS total_inscripciones, "
            "    DENSE_RANK() OVER ("
            "      PARTITION BY p.id_periodo "
            "      ORDER BY COUNT(*) DESC"
            "    ) AS ranking "
            "  FROM inscripciones i "
            "  JOIN cursos cu ON cu.id_curso = i.id_curso "
            "  JOIN periodos p ON p.id_periodo = cu.id_periodo "
            "  LEFT JOIN vw_alumnos_carrera v ON v.id_alumno = i.id_alumno "
            "  WHERE i.tipo = 'curso' "
            "  GROUP BY p.id_periodo, p.nombre, COALESCE(v.facultad, 'Sin facultad')"
            ") t "
            "ORDER BY t.id_periodo, t.ranking, t.facultad"
        )
        return _fetch_all_query(primary_sql)
    except Exception:
        fallback_sql = (
            "SELECT "
            "  t.periodo, "
            "  t.facultad, "
            "  t.total_inscripciones, "
            "  t.ranking "
            "FROM ("
            "  SELECT "
            "    p.id_periodo, "
            "    p.nombre AS periodo, "
            "    COALESCE(f.nombre, 'Sin facultad') AS facultad, "
            "    COUNT(*) AS total_inscripciones, "
            "    DENSE_RANK() OVER ("
            "      PARTITION BY p.id_periodo "
            "      ORDER BY COUNT(*) DESC"
            "    ) AS ranking "
            "  FROM inscripciones i "
            "  JOIN cursos cu ON cu.id_curso = i.id_curso "
            "  JOIN periodos p ON p.id_periodo = cu.id_periodo "
            "  LEFT JOIN alumnos a ON a.id_alumno = i.id_alumno "
            "  LEFT JOIN inscripciones icarr ON icarr.id_alumno = a.id_alumno AND icarr.tipo = 'carrera' "
            "  LEFT JOIN carreras cr ON cr.id_carrera = icarr.id_carrera "
            "  LEFT JOIN facultades f ON f.id_facultad = cr.id_facultad "
            "  WHERE i.tipo = 'curso' "
            "  GROUP BY p.id_periodo, p.nombre, COALESCE(f.nombre, 'Sin facultad')"
            ") t "
            "ORDER BY t.id_periodo, t.ranking, t.facultad"
        )
        try:
            return _fetch_all_query(fallback_sql)
        except Exception as e:
            return {"error": str(e)}


@app.get("/api/control-escolar/estatus-inscripcion")
def get_estatus_inscripcion():
    try:
        return _safe_fetch_all(
            "SELECT * FROM vw_alumnos_por_estatus",
            "SELECT estatus, COUNT(*) AS total FROM alumnos GROUP BY estatus",
        )
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/control-escolar/saturacion-cursos")
def get_saturacion_cursos():
    try:
        primary_sql = "SELECT * FROM vw_saturacion_cursos ORDER BY porcentaje_llenado DESC, id_curso"
        fallback_sql = (
            "SELECT "
            "  cu.id_curso, "
            "  m.nombre AS materia, "
            "  COALESCE(fp.facultad_plan, 'Sin facultad') AS facultad, "
            "  CONCAT(m.nombre, ' (', COALESCE(fp.facultad_plan, 'Sin facultad'), ')') AS curso, "
            "  cu.cupo_max, "
            "  COUNT(DISTINCT i.id_alumno) AS inscritos, "
            "  LEAST(ROUND((COUNT(DISTINCT i.id_alumno) / cu.cupo_max) * 100, 2), 100) AS porcentaje_llenado, "
            "  cu.esta_lleno "
            "FROM cursos cu "
            "JOIN materias m ON m.id_materia = cu.id_materia "
            "LEFT JOIN inscripciones i ON i.id_curso = cu.id_curso AND i.tipo = 'curso' "
            "LEFT JOIN ("
            "  SELECT "
            "    cm.id_materia, "
            "    CASE "
            "      WHEN COUNT(DISTINCT f.nombre) = 1 THEN MIN(f.nombre) "
            "      ELSE 'Multifacultad' "
            "    END AS facultad_plan "
            "  FROM carreras_materias cm "
            "  JOIN carreras cr ON cr.id_carrera = cm.id_carrera "
            "  JOIN facultades f ON f.id_facultad = cr.id_facultad "
            "  GROUP BY cm.id_materia"
            ") fp ON fp.id_materia = cu.id_materia "
            "GROUP BY cu.id_curso, m.nombre, cu.cupo_max, cu.esta_lleno, COALESCE(fp.facultad_plan, 'Sin facultad') "
            "ORDER BY porcentaje_llenado DESC, cu.id_curso"
        )
        return _safe_fetch_all(primary_sql, fallback_sql, fallback_if_empty=True)
    except Exception as e:
        return {"error": str(e)}


# ── NUEVO: Inscripciones por periodo ──
@app.get("/api/control-escolar/inscripciones-periodo")
def get_inscripciones_periodo():
    try:
        sql = (
            "SELECT p.nombre AS periodo, COUNT(*) AS total_inscripciones "
            "FROM inscripciones i "
            "JOIN cursos cu ON cu.id_curso = i.id_curso "
            "JOIN periodos p ON p.id_periodo = cu.id_periodo "
            "WHERE i.tipo = 'curso' "
            "GROUP BY p.id_periodo, p.nombre "
            "ORDER BY p.fecha_inicio"
        )
        return _safe_fetch_all("SELECT * FROM vw_inscripciones_periodo", sql, fallback_if_empty=True)
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/control-escolar/alumnos")
def get_alumnos(carrera: str | None = None, estatus: EstatusAlumno | None = None):
    try:
        base_query = "SELECT * FROM vw_alumnos_carrera"
        fallback_query = (
            "SELECT "
            "a.id_alumno, "
            "CONCAT(a.nombre, ' ', a.apellidos) AS alumno, "
            "a.correo, a.telefono, "
            "a.estatus AS estatus_alumno, "
            "cr.nombre AS carrera, "
            "f.nombre AS facultad "
            "FROM alumnos a "
            "LEFT JOIN inscripciones icarr ON icarr.id_alumno = a.id_alumno AND icarr.tipo = 'carrera' "
            "LEFT JOIN carreras cr ON cr.id_carrera = icarr.id_carrera "
            "LEFT JOIN facultades f ON f.id_facultad = cr.id_facultad"
        )
        filters = []
        params: dict[str, str] = {}

        if carrera:
            filters.append("carrera = :carrera")
            params["carrera"] = carrera
        if estatus is not None:
            filters.append("estatus_alumno = :estatus")
            params["estatus"] = estatus.value

        if filters:
            where = " WHERE " + " AND ".join(filters)
            base_query += where
            fallback_query += where

        return _safe_fetch_all(base_query, fallback_query, fallback_if_empty=True, params=params)
    except Exception as e:
        return {"error": str(e)}


# ───────────── Finanzas ─────────────

@app.get("/api/finanzas/ingresos-mensuales")
def get_ingresos_mensuales():
    try:
        return _safe_fetch_all(
            "SELECT * FROM vw_ingresos_mensuales ORDER BY mes",
            (
                "SELECT DATE_FORMAT(p.fecha_pago, '%Y-%m') AS mes, "
                "SUM(p.monto) AS total_ingresos, "
                "COUNT(p.id_pago) AS numero_transacciones "
                "FROM pagos p "
                "GROUP BY DATE_FORMAT(p.fecha_pago, '%Y-%m') "
                "ORDER BY mes"
            ),
        )
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/finanzas/morosidad")
def get_morosidad():
    try:
        return _safe_fetch_all(
            "SELECT * FROM vw_morosidad_alumnos WHERE monto_pendiente > 60000",
            (
                "SELECT a.nombre, a.apellidos, a.correo, a.estatus, "
                "ROUND(SUM(GREATEST(c.monto - IFNULL(pg.total_pagado, 0), 0)), 2) AS monto_pendiente "
                "FROM alumnos a "
                "JOIN cargos c ON c.id_alumno = a.id_alumno "
                "LEFT JOIN ("
                "  SELECT id_concepto, SUM(monto) AS total_pagado "
                "  FROM pagos "
                "  GROUP BY id_concepto"
                ") pg ON pg.id_concepto = c.id_cargo "
                "WHERE a.estatus = 'Activo' "
                "GROUP BY a.id_alumno, a.nombre, a.apellidos, a.correo, a.estatus "
                "HAVING monto_pendiente > 60000"
            ),
        )
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/finanzas/resumen-pagos")
def get_resumen_pagos():
    try:
        return _safe_fetch_all(
            "SELECT * FROM vw_resumen_pagos",
            (
                "SELECT p.nombre AS periodo, c.concepto, "
                "COUNT(pg.id_pago) AS cantidad_pagos, "
                "ROUND(SUM(pg.monto), 2) AS total_recaudado, "
                "ROUND(AVG(pg.monto), 2) AS promedio_pago, "
                "MIN(pg.monto) AS pago_minimo, "
                "MAX(pg.monto) AS pago_maximo "
                "FROM pagos pg "
                "JOIN periodos p ON p.id_periodo = pg.id_periodo "
                "JOIN cargos c ON c.id_cargo = pg.id_concepto "
                "GROUP BY p.nombre, c.concepto "
                "ORDER BY p.nombre, c.concepto"
            ),
        )
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/finanzas/distribucion-concepto")
def get_distribucion_concepto():
    try:
        return _safe_fetch_all(
            "SELECT * FROM vw_distribucion_ingresos_concepto",
            (
                "SELECT c.concepto, SUM(p.monto) AS monto_total "
                "FROM pagos p "
                "JOIN cargos c ON c.id_cargo = p.id_concepto "
                "GROUP BY c.concepto"
            ),
        )
    except Exception as e:
        return {"error": str(e)}


# ── NUEVO: Cargos vs Pagos por facultad ──
@app.get("/api/finanzas/cargos-vs-pagos")
def get_cargos_vs_pagos():
    try:
        sql = (
            "SELECT "
            "  f.facultad, "
            "  ROUND(IFNULL(cg.total_cargado, 0), 2) AS total_cargado, "
            "  ROUND(IFNULL(pg.total_pagado, 0), 2) AS total_pagado "
            "FROM ("
            "  SELECT facultad FROM ("
            "    SELECT COALESCE(v.facultad, 'Sin facultad') AS facultad, SUM(c.monto) AS total_cargado "
            "    FROM cargos c "
            "    LEFT JOIN vw_alumnos_carrera v ON v.id_alumno = c.id_alumno "
            "    GROUP BY COALESCE(v.facultad, 'Sin facultad')"
            "  ) c_fac "
            "  UNION "
            "  SELECT facultad FROM ("
            "    SELECT COALESCE(v.facultad, 'Sin facultad') AS facultad, SUM(p.monto) AS total_pagado "
            "    FROM pagos p "
            "    LEFT JOIN vw_alumnos_carrera v ON v.id_alumno = p.id_alumno "
            "    GROUP BY COALESCE(v.facultad, 'Sin facultad')"
            "  ) p_fac "
            ") f "
            "LEFT JOIN ("
            "  SELECT COALESCE(v.facultad, 'Sin facultad') AS facultad, SUM(c.monto) AS total_cargado "
            "  FROM cargos c "
            "  LEFT JOIN vw_alumnos_carrera v ON v.id_alumno = c.id_alumno "
            "  GROUP BY COALESCE(v.facultad, 'Sin facultad')"
            ") cg ON cg.facultad = f.facultad "
            "LEFT JOIN ("
            "  SELECT COALESCE(v.facultad, 'Sin facultad') AS facultad, SUM(p.monto) AS total_pagado "
            "  FROM pagos p "
            "  LEFT JOIN vw_alumnos_carrera v ON v.id_alumno = p.id_alumno "
            "  GROUP BY COALESCE(v.facultad, 'Sin facultad')"
            ") pg ON pg.facultad = f.facultad "
            "ORDER BY f.facultad"
        )
        return _fetch_all_query(sql)
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/finanzas/estado-cuenta")
def get_estado_cuenta():
    try:
        return _safe_fetch_all(
            "SELECT * FROM vw_estado_cuenta",
            (
                "SELECT a.id_alumno, CONCAT(a.nombre, ' ', a.apellidos) AS alumno, "
                "p.nombre AS periodo, COUNT(pg.id_pago) AS pagos_realizados, "
                "ROUND(IFNULL(SUM(pg.monto), 0), 2) AS total_pagado "
                "FROM alumnos a CROSS JOIN periodos p "
                "LEFT JOIN pagos pg ON pg.id_alumno = a.id_alumno AND pg.id_periodo = p.id_periodo "
                "GROUP BY a.id_alumno, a.nombre, a.apellidos, p.id_periodo, p.nombre"
            ),
        )
    except Exception as e:
        return {"error": str(e)}
