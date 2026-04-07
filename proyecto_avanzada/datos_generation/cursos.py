from facama import engine
from sqlalchemy import text
import random
from datetime import time

# =========================
# INTENTO DE PROGRESO
# =========================
try:
    from tqdm import tqdm
except:
    # fallback si no tienes tqdm
    def tqdm(iterable, **kwargs):
        return iterable


# =========================
# CONFIG
# =========================

PERIODO_NOMBRE = "Otoño-2025"
FECHA_INICIO = "2025-08-01"
FECHA_FIN = "2025-12-18"

DIAS = [1, 2, 3, 4, 5]

HORAS = [
    (7, 0, 9, 0),
    (9, 0, 11, 0),
    (11, 0, 13, 0),
    (13, 0, 15, 0),
    (15, 0, 17, 0),
    (17, 0, 19, 0)
]

EDIFICIOS = ["A", "B", "C"]

# =========================
# DATOS FAKE DOCENTES
# =========================

NOMBRES = [
    "Luis", "Carlos", "Juan", "Miguel", "Fernando",
    "Sofia", "Ana", "Mariana", "Valeria", "Andrea"
]

APELLIDOS = [
    "Hernandez", "Martinez", "Gonzalez", "Lopez",
    "Garcia", "Ramirez", "Torres", "Flores"
]


def generar_docente_fake():
    nombre = random.choice(NOMBRES)
    apellido = random.choice(APELLIDOS)
    correo = f"{nombre.lower()}.{apellido.lower()}@up.edu.mx"
    return nombre, apellido, correo


# =========================
# CREACIÓN
# =========================

def crear_periodo(conn):
    existente = conn.execute(text("""
        SELECT id_periodo FROM periodos WHERE nombre = :n
    """), {"n": PERIODO_NOMBRE}).fetchone()

    if existente:
        return existente[0]

    r = conn.execute(text("""
        INSERT INTO periodos (nombre, fecha_inicio, fecha_fin)
        VALUES (:n, :fi, :ff)
    """), {
        "n": PERIODO_NOMBRE,
        "fi": FECHA_INICIO,
        "ff": FECHA_FIN
    })

    return r.lastrowid


def crear_aulas(conn):
    aulas = []

    existentes = conn.execute(text("SELECT id_aula FROM aulas")).fetchall()
    if existentes:
        return [a[0] for a in existentes]

    for edificio in EDIFICIOS:
        for i in range(1, 11):
            r = conn.execute(text("""
                INSERT INTO aulas (edificio, nombre_aula, capacidad)
                VALUES (:e, :n, :c)
            """), {
                "e": edificio,
                "n": f"{edificio}-{i}",
                "c": random.randint(25, 40)
            })

            aulas.append(r.lastrowid)

    return aulas


def crear_docente(conn, index):
    nombre, apellido, correo = generar_docente_fake()

    r = conn.execute(text("""
        INSERT INTO docentes (num_empleado, nombre, apellidos, correo)
        VALUES (:ne, :n, :a, :c)
    """), {
        "ne": f"DOC{index:05d}",
        "n": nombre,
        "a": apellido,
        "c": correo
    })

    return r.lastrowid


def crear_curso(conn, id_materia, id_docente, id_periodo):
    r = conn.execute(text("""
        INSERT INTO cursos (id_materia, id_docente, id_periodo, cupo_max)
        VALUES (:m, :d, :p, :c)
    """), {
        "m": id_materia,
        "d": id_docente,
        "p": id_periodo,
        "c": random.randint(25, 40)
    })

    return r.lastrowid


def crear_horario(conn, id_curso, id_aula):
    dia = random.choice(DIAS)
    h = random.choice(HORAS)

    conn.execute(text("""
        INSERT INTO horarios (id_curso, id_aula, dia_semana, hora_inicio, hora_fin)
        VALUES (:c, :a, :d, :hi, :hf)
    """), {
        "c": id_curso,
        "a": id_aula,
        "d": dia,
        "hi": time(h[0], h[1]),
        "hf": time(h[2], h[3])
    })


# =========================
# MAIN
# =========================

def generar_datos():

    print("🚀 INICIANDO GENERACIÓN...\n")

    with engine.begin() as conn:

        print("📅 Creando periodo...")
        id_periodo = crear_periodo(conn)

        print("🏫 Creando aulas...")
        aulas = crear_aulas(conn)

        print("📚 Obteniendo materias...")

        rows = conn.execute(text("""
            SELECT c.id_carrera, m.id_materia
            FROM carreras c
            JOIN carreras_materias cm ON c.id_carrera = cm.id_carrera
            JOIN materias m ON cm.id_materia = m.id_materia
        """)).fetchall()

        total = len(rows)
        print(f"📊 Total cursos a generar: {total}\n")

        docente_index = 1

        for i, row in enumerate(tqdm(rows, desc="Generando cursos")):

            id_materia = row[1]

            id_docente = crear_docente(conn, docente_index)
            docente_index += 1

            id_curso = crear_curso(conn, id_materia, id_docente, id_periodo)

            id_aula = random.choice(aulas)
            crear_horario(conn, id_curso, id_aula)

            # fallback progreso si no hay tqdm
            if i % 100 == 0 and i > 0:
                print(f"Progreso: {i}/{total}")

    print("\n✅ GENERACIÓN COMPLETADA")


# =========================
# RUN
# =========================

if __name__ == "__main__":
    generar_datos()