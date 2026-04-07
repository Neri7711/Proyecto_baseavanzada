from sqlalchemy import create_engine, text
from tqdm import tqdm
import unicodedata
import re

DATABASE_URL = "mysql+pymysql://app:app123@localhost:3306/escuela"
engine = create_engine(DATABASE_URL)


# =========================
# NORMALIZACIÓN
# =========================
def normalizar(s):
    return s.strip().lower()


def limpiar_nombre(nombre):
    return re.sub(r'\s+', ' ', nombre.strip())


# =========================
# GENERADOR DE CLAVES
# =========================
def generar_clave_materia(nombre):

    # quitar acentos
    nombre = unicodedata.normalize('NFKD', nombre)
    nombre = ''.join(c for c in nombre if not unicodedata.combining(c))

    # limpiar caracteres
    nombre = re.sub(r'[^A-Za-z0-9 ]', '', nombre)

    palabras = nombre.upper().split()

    if len(palabras) == 1:
        base = palabras[0][:6]
    else:
        base = palabras[0][:3] + palabras[1][:3]

    return base


# =========================
# MAIN
# =========================
def ejecutar():

    with open("carreras.txt", "r", encoding="utf-8") as f:
        lineas = f.readlines()

    facultades_cache = {}
    carreras_cache = {}
    materias_cache = {}

    carrera_materias_set = {}
    carreras_vistas = set()
    claves_usadas = set()

    with engine.begin() as conn:

        facultad_actual = None
        carrera_actual = None

        for linea in tqdm(lineas, desc="Procesando dataset", ncols=100):

            linea = linea.strip()
            if not linea:
                continue

            # =========================
            # FACULTAD
            # =========================
            if linea.startswith("FACULTAD:"):
                nombre = limpiar_nombre(linea.replace("FACULTAD:", ""))
                key = normalizar(nombre)

                if key not in facultades_cache:

                    clave = f"FAC{len(facultades_cache)+1:02d}"

                    r = conn.execute(text("""
                        INSERT INTO facultades (nombre, clave)
                        VALUES (:n, :c)
                    """), {"n": nombre, "c": clave})

                    facultades_cache[key] = r.lastrowid

                facultad_actual = facultades_cache[key]

            # =========================
            # CARRERA
            # =========================
            elif linea.startswith("CARRERA:"):
                nombre = limpiar_nombre(linea.replace("CARRERA:", ""))
                key = normalizar(nombre)

                if key in carreras_vistas:
                    carrera_actual = None
                    continue

                carreras_vistas.add(key)

                if key not in carreras_cache:

                    r = conn.execute(text("""
                        INSERT INTO carreras (nombre, id_facultad)
                        VALUES (:n, :f)
                    """), {
                        "n": nombre,
                        "f": facultad_actual
                    })

                    carreras_cache[key] = r.lastrowid

                carrera_actual = carreras_cache[key]
                carrera_materias_set[carrera_actual] = set()

            # =========================
            # IGNORAR SEMESTRE
            # =========================
            elif linea.startswith("SEMESTRE"):
                continue

            # =========================
            # MATERIAS
            # =========================
            elif "," in linea and carrera_actual:

                try:
                    nombre, creditos = linea.split(",")
                    nombre = limpiar_nombre(nombre)
                    creditos = int(creditos.strip())
                except:
                    continue

                # 🚨 OMITIR CREDITOS = 0
                if creditos <= 0:
                    continue

                key = normalizar(nombre)

                # -------- MATERIA GLOBAL --------
                if key not in materias_cache:

                    # 🔑 generar clave única
                    base = generar_clave_materia(nombre)
                    clave = base
                    contador = 1

                    while clave in claves_usadas:
                        clave = f"{base}{contador}"
                        contador += 1

                    claves_usadas.add(clave)

                    r = conn.execute(text("""
                        INSERT INTO materias (clave, nombre, creditos)
                        VALUES (:cl, :n, :c)
                    """), {
                        "cl": clave,
                        "n": nombre,
                        "c": creditos
                    })

                    materias_cache[key] = r.lastrowid

                materia_id = materias_cache[key]

                # -------- EVITAR DUPLICADO EN CARRERA --------
                if materia_id in carrera_materias_set[carrera_actual]:
                    continue

                carrera_materias_set[carrera_actual].add(materia_id)

                conn.execute(text("""
                    INSERT INTO carreras_materias (id_carrera, id_materia)
                    VALUES (:c, :m)
                """), {
                    "c": carrera_actual,
                    "m": materia_id
                })

    # =========================
    # RESUMEN FINAL
    # =========================
    print("\n=========== RESUMEN ===========")
    print("Facultades:", len(facultades_cache))
    print("Carreras:", len(carreras_cache))
    print("Materias únicas:", len(materias_cache))

    print("\n=========== VALIDACIÓN ===========")

    with engine.connect() as conn:
        for nombre, carrera_id in carreras_cache.items():

            total = conn.execute(text("""
                SELECT COUNT(*)
                FROM carreras_materias
                WHERE id_carrera = :c
            """), {"c": carrera_id}).scalar()

            print(f"{nombre.upper()} → {total} materias")

    print("\n✔ Carga completada correctamente")


if __name__ == "__main__":
    ejecutar()