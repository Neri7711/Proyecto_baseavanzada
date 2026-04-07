from facama import engine
from sqlalchemy import text

# =========================
# UTILIDADES
# =========================

def hay_conflicto(h1_inicio, h1_fin, h2_inicio, h2_fin):
    return h1_inicio < h2_fin and h1_fin > h2_inicio


def obtener_horarios_docente(conn, id_docente):
    return conn.execute(text("""
        SELECT h.dia_semana, h.hora_inicio, h.hora_fin
        FROM cursos c
        JOIN horarios h ON c.id_curso = h.id_curso
        WHERE c.id_docente = :d
    """), {"d": id_docente}).fetchall()


# =========================
# CREAR DOCENTE
# =========================

contador_docente = 20000

def crear_docente(conn):
    global contador_docente
    contador_docente += 1

    r = conn.execute(text("""
        INSERT INTO docentes (num_empleado, nombre, apellidos, correo)
        VALUES (:ne, :n, :a, :c)
    """), {
        "ne": f"DOC{contador_docente}",
        "n": "Docente",
        "a": f"UP{contador_docente}",
        "c": f"doc{contador_docente}@up.edu.mx"
    })

    return r.lastrowid


# =========================
# MAIN
# =========================

def optimizar_docentes():

    print("🔄 INICIANDO OPTIMIZACIÓN DE DOCENTES...\n")

    with engine.begin() as conn:

        # =========================
        # 1. TRAER CURSOS COMPLETOS
        # =========================
        cursos = conn.execute(text("""
            SELECT 
                cu.id_curso,
                f.id_facultad,
                h.dia_semana,
                h.hora_inicio,
                h.hora_fin
            FROM cursos cu
            JOIN materias m ON cu.id_materia = m.id_materia
            JOIN carreras_materias cm ON m.id_materia = cm.id_materia
            JOIN carreras c ON cm.id_carrera = c.id_carrera
            JOIN facultades f ON c.id_facultad = f.id_facultad
            JOIN horarios h ON cu.id_curso = h.id_curso
            ORDER BY f.id_facultad
        """)).fetchall()

        print(f"📊 Total cursos: {len(cursos)}")

        # =========================
        # 2. AGRUPAR POR FACULTAD
        # =========================
        facultades = {}

        for c in cursos:
            facultades.setdefault(c.id_facultad, []).append(c)

        total_docentes_usados = set()

        # =========================
        # 3. PROCESAR FACULTADES
        # =========================
        for id_facultad, lista_cursos in facultades.items():

            print(f"\n🏫 Facultad {id_facultad}")

            docentes_facultad = []

            for curso in lista_cursos:

                asignado = False

                # intentar reutilizar docente
                for docente in docentes_facultad:

                    horarios = obtener_horarios_docente(conn, docente)

                    conflicto = False

                    for h in horarios:
                        if h.dia_semana == curso.dia_semana:
                            if hay_conflicto(
                                curso.hora_inicio, curso.hora_fin,
                                h.hora_inicio, h.hora_fin
                            ):
                                conflicto = True
                                break

                    if not conflicto:
                        conn.execute(text("""
                            UPDATE cursos
                            SET id_docente = :d
                            WHERE id_curso = :c
                        """), {
                            "d": docente,
                            "c": curso.id_curso
                        })

                        total_docentes_usados.add(docente)
                        asignado = True
                        break

                # si no hay docente disponible → crear uno
                if not asignado:
                    nuevo = crear_docente(conn)

                    conn.execute(text("""
                        UPDATE cursos
                        SET id_docente = :d
                        WHERE id_curso = :c
                    """), {
                        "d": nuevo,
                        "c": curso.id_curso
                    })

                    docentes_facultad.append(nuevo)
                    total_docentes_usados.add(nuevo)

        # =========================
        # 4. ELIMINAR DOCENTES NO USADOS
        # =========================
        print("\n🧹 Eliminando docentes no utilizados...")

        todos_docentes = conn.execute(text("""
            SELECT id_docente FROM docentes
        """)).fetchall()

        eliminados = 0

        for d in todos_docentes:
            if d.id_docente not in total_docentes_usados:
                conn.execute(text("""
                    DELETE FROM docentes WHERE id_docente = :d
                """), {"d": d.id_docente})
                eliminados += 1

        # =========================
        # RESULTADOS
        # =========================
        print("\n✅ OPTIMIZACIÓN COMPLETADA")
        print(f"👨‍🏫 Docentes finales: {len(total_docentes_usados)}")
        print(f"🗑️ Docentes eliminados: {eliminados}")


# =========================
# RUN
# =========================

if __name__ == "__main__":
    optimizar_docentes()