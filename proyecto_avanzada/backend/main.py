from fastapi import FastAPI
from sqlalchemy import create_engine, text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from fastapi.middleware.cors import CORSMiddleware

from decimal import Decimal

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"], # Permite la entrada de tu React
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

# Ruta de prueba para verificar salud del backend
@app.get("/")
def read_root():
    return {"status": "Backend en Python funcionando"}

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


@app.get("/api/dashboard/kpis")
def get_dashboard_kpis():
    """
    Indicadores principales del dashboard:
    - Rendimiento global
    - Total de alumnos
    - Estatus de pagos (al corriente vs morosos)
    - Docentes activos
    """
    try:
        with engine.connect() as connection:
            rendimiento_global_query = text(
                "SELECT ROUND(AVG(promedio_general), 2) AS rendimiento_global "
                "FROM vw_rendimiento_por_carrera"
            )
            rendimiento_row = connection.execute(rendimiento_global_query).fetchone()
            rendimiento_global = _to_number(
                rendimiento_row[0] if rendimiento_row else None, 0.0
            )

            total_alumnos_query = text(
                "SELECT SUM(total) AS total_alumnos FROM vw_alumnos_por_estatus"
            )
            total_row = connection.execute(total_alumnos_query).fetchone()
            total_alumnos = int(
                _to_number(total_row[0] if total_row else None, 0)
            )

            activos_query = text(
                "SELECT total AS activos FROM vw_alumnos_por_estatus "
                "WHERE estatus = 'Activo'"
            )
            activos_row = connection.execute(activos_query).fetchone()
            alumnos_activos = int(
                _to_number(activos_row[0] if activos_row else None, 0)
            )

            morosos_query = text(
                "SELECT COUNT(*) AS morosos FROM vw_morosidad_alumnos "
                "WHERE estatus = 'Activo'"
            )
            morosos_row = connection.execute(morosos_query).fetchone()
            alumnos_morosos = int(
                _to_number(morosos_row[0] if morosos_row else None, 0)
            )

            if alumnos_activos > 0:
                porcentaje_pagos_corriente = round(
                    (alumnos_activos - alumnos_morosos) * 100.0 / alumnos_activos, 2
                )
            else:
                porcentaje_pagos_corriente = 0.0

            docentes_query = text(
                "SELECT COUNT(*) AS docentes_activos FROM vw_docentes_cursos"
            )
            docentes_row = connection.execute(docentes_query).fetchone()
            docentes_activos = int(
                _to_number(docentes_row[0] if docentes_row else None, 0)
            )

            return {
                "rendimiento_global": rendimiento_global,
                "total_alumnos": total_alumnos,
                "porcentaje_pagos_corriente": porcentaje_pagos_corriente,
                "docentes_activos": docentes_activos,
            }
    except Exception as e:
        return {"error": str(e)}

@app.get("/api/vistas/vw_rendimiento_por_carrera")
def get_rendimiento():
    try:
        with engine.connect() as connection:
            query = text("SELECT * FROM vw_rendimiento_por_carrera")
            result = connection.execute(query)
            data = [dict(row._mapping) for row in result]
            return data
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/academico/materias-criticas")
def get_materias_criticas():
    try:
        with engine.connect() as connection:
            query = text("SELECT * FROM vw_materias_criticas")
            result = connection.execute(query)
            return [dict(row._mapping) for row in result]
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/academico/ranking-docentes")
def get_ranking_docentes():
    try:
        with engine.connect() as connection:
            query = text("SELECT * FROM vw_ranking_docentes_promedio")
            result = connection.execute(query)
            return [dict(row._mapping) for row in result]
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/control-escolar/alumnos")
def get_alumnos(carrera: str | None = None, estatus: str | None = None):
    try:
        base_query = "SELECT * FROM vw_alumnos_carrera"
        filters = []
        params: dict[str, str] = {}

        if carrera:
            filters.append("carrera = :carrera")
            params["carrera"] = carrera
        if estatus:
            filters.append("estatus_alumno = :estatus")
            params["estatus"] = estatus

        if filters:
            base_query += " WHERE " + " AND ".join(filters)

        with engine.connect() as connection:
            result = connection.execute(text(base_query), params)
            return [dict(row._mapping) for row in result]
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/control-escolar/estatus-inscripcion")
def get_estatus_inscripcion():
    try:
        with engine.connect() as connection:
            query = text("SELECT * FROM vw_alumnos_por_estatus")
            result = connection.execute(query)
            return [dict(row._mapping) for row in result]
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/control-escolar/saturacion-cursos")
def get_saturacion_cursos():
    try:
        with engine.connect() as connection:
            query = text("SELECT * FROM vw_saturacion_cursos")
            result = connection.execute(query)
            return [dict(row._mapping) for row in result]
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/finanzas/estado-cuenta")
def get_estado_cuenta():
    try:
        with engine.connect() as connection:
            query = text("SELECT * FROM vw_estado_cuenta")
            result = connection.execute(query)
            return [dict(row._mapping) for row in result]
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/finanzas/morosidad")
def get_morosidad():
    try:
        with engine.connect() as connection:
            query = text("SELECT * FROM vw_morosidad_alumnos")
            result = connection.execute(query)
            return [dict(row._mapping) for row in result]
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/finanzas/ingresos-mensuales")
def get_ingresos_mensuales():
    try:
        with engine.connect() as connection:
            query = text("SELECT * FROM vw_ingresos_mensuales ORDER BY mes")
            result = connection.execute(query)
            return [dict(row._mapping) for row in result]
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/finanzas/resumen-pagos")
def get_resumen_pagos():
    try:
        with engine.connect() as connection:
            query = text("SELECT * FROM vw_resumen_pagos")
            result = connection.execute(query)
            return [dict(row._mapping) for row in result]
    except Exception as e:
        return {"error": str(e)}


@app.get("/api/finanzas/distribucion-concepto")
def get_distribucion_concepto():
    try:
        with engine.connect() as connection:
            query = text("SELECT * FROM vw_distribucion_ingresos_concepto")
            result = connection.execute(query)
            return [dict(row._mapping) for row in result]
    except Exception as e:
        return {"error": str(e)}