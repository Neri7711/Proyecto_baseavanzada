import type {
  KPIs, RendimientoCarrera, MateriaCritica, RankingDocente,
  TopReprobado, CargaDocente, EstatusInscripcion, SaturacionCurso,
  RadarFacultadItem, SunburstJerarquiaItem, RankingFacultadPeriodoItem,
  InscripcionPeriodo, Alumno, IngresoMensual, CargosVsPagos,
  DistribucionConcepto, MorosidadAlumno,
} from "./api";

export const mockKPIs: KPIs = {
  rendimiento_global: 78.4,
  total_alumnos: 2345,
  porcentaje_pagos_corriente: 68.2,
  docentes_activos: 142,
  tasa_reprobacion: 12.7,
  deuda_pendiente: 1850400,
};

export const mockRendimiento: RendimientoCarrera[] = [
  { carrera: "Ing. Sistemas", promedio_general: 82.3 },
  { carrera: "Medicina", promedio_general: 79.1 },
  { carrera: "Derecho", promedio_general: 76.8 },
  { carrera: "Arquitectura", promedio_general: 81.5 },
  { carrera: "Contaduría", promedio_general: 74.2 },
  { carrera: "Psicología", promedio_general: 80.6 },
];

export const mockCriticas: MateriaCritica[] = [
  { materia: "Cálculo Diferencial", clave: "MAT101", promedio: 58.3 },
  { materia: "Física II", clave: "FIS102", promedio: 62.1 },
  { materia: "Química Orgánica", clave: "QUI201", promedio: 65.4 },
  { materia: "Estadística", clave: "EST101", promedio: 67.8 },
  { materia: "Álgebra Lineal", clave: "MAT202", promedio: 63.2 },
];

export const mockDocentes: RankingDocente[] = [
  { nombre: "Carlos", apellidos: "Hernández", num_empleado: "D001", promedio_alumnos: 88.2 },
  { nombre: "María", apellidos: "López", num_empleado: "D002", promedio_alumnos: 85.7 },
  { nombre: "Jorge", apellidos: "Ramírez", num_empleado: "D003", promedio_alumnos: 82.4 },
  { nombre: "Ana", apellidos: "Torres", num_empleado: "D004", promedio_alumnos: 79.9 },
  { nombre: "Luis", apellidos: "García", num_empleado: "D005", promedio_alumnos: 77.3 },
  { nombre: "Rosa", apellidos: "Méndez", num_empleado: "D006", promedio_alumnos: 91.0 },
  { nombre: "Pedro", apellidos: "Sánchez", num_empleado: "D007", promedio_alumnos: 74.5 },
  { nombre: "Elena", apellidos: "Díaz", num_empleado: "D008", promedio_alumnos: 86.1 },
];

export const mockTopReprobados: TopReprobado[] = [
  { materia: "Cálculo Diferencial", clave: "MAT101", total_reprobados: 45, total_alumnos: 120, porcentaje_reprobacion: 37.5 },
  { materia: "Física II", clave: "FIS102", total_reprobados: 38, total_alumnos: 95, porcentaje_reprobacion: 40.0 },
  { materia: "Química Orgánica", clave: "QUI201", total_reprobados: 30, total_alumnos: 110, porcentaje_reprobacion: 27.3 },
  { materia: "Álgebra Lineal", clave: "MAT202", total_reprobados: 25, total_alumnos: 100, porcentaje_reprobacion: 25.0 },
  { materia: "Estadística", clave: "EST101", total_reprobados: 20, total_alumnos: 130, porcentaje_reprobacion: 15.4 },
];

export const mockCargaDocente: CargaDocente[] = [
  { docente: "Carlos Hernández", num_empleado: "D001", total_cursos: 4, total_alumnos: 160 },
  { docente: "María López", num_empleado: "D002", total_cursos: 3, total_alumnos: 120 },
  { docente: "Jorge Ramírez", num_empleado: "D003", total_cursos: 5, total_alumnos: 200 },
  { docente: "Ana Torres", num_empleado: "D004", total_cursos: 2, total_alumnos: 80 },
  { docente: "Luis García", num_empleado: "D005", total_cursos: 4, total_alumnos: 155 },
  { docente: "Rosa Méndez", num_empleado: "D006", total_cursos: 3, total_alumnos: 110 },
];

export const mockRadarFacultad: RadarFacultadItem[] = [
  { facultad: "Ingenieria", rendimiento_promedio: 82.1, ocupacion_promedio: 88.3, tasa_reprobacion: 18.2, cobertura_pagos: 81.1, retencion_activos: 89.4 },
  { facultad: "Ciencias de la Salud", rendimiento_promedio: 79.8, ocupacion_promedio: 85.7, tasa_reprobacion: 14.1, cobertura_pagos: 79.4, retencion_activos: 91.2 },
  { facultad: "Ciencias Sociales", rendimiento_promedio: 76.4, ocupacion_promedio: 72.5, tasa_reprobacion: 22.7, cobertura_pagos: 74.3, retencion_activos: 84.9 },
  { facultad: "Diseno", rendimiento_promedio: 80.3, ocupacion_promedio: 77.1, tasa_reprobacion: 16.8, cobertura_pagos: 78.2, retencion_activos: 87.5 },
  { facultad: "Negocios", rendimiento_promedio: 78.6, ocupacion_promedio: 70.9, tasa_reprobacion: 19.5, cobertura_pagos: 76.9, retencion_activos: 86.1 },
];

export const mockSunburstJerarquia: SunburstJerarquiaItem[] = [
  { id_curso: 101, facultad: "Ingenieria", carrera: "Ing. Sistemas", materia: "Calculo Diferencial", curso: "Curso 101", cupo_max: 40, inscritos: 40, porcentaje_llenado: 100 },
  { id_curso: 103, facultad: "Ingenieria", carrera: "Ing. Sistemas", materia: "Programacion I", curso: "Curso 103", cupo_max: 35, inscritos: 34, porcentaje_llenado: 97.14 },
  { id_curso: 104, facultad: "Ingenieria", carrera: "Ing. Civil", materia: "Fisica II", curso: "Curso 104", cupo_max: 30, inscritos: 28, porcentaje_llenado: 93.33 },
  { id_curso: 105, facultad: "Humanidades", carrera: "Lenguas", materia: "Ingles IV", curso: "Curso 105", cupo_max: 25, inscritos: 20, porcentaje_llenado: 80 },
  { id_curso: 106, facultad: "Derecho", carrera: "Derecho", materia: "Derecho Civil", curso: "Curso 106", cupo_max: 45, inscritos: 30, porcentaje_llenado: 66.67 },
  { id_curso: 107, facultad: "Negocios", carrera: "Contaduria", materia: "Contabilidad II", curso: "Curso 107", cupo_max: 35, inscritos: 18, porcentaje_llenado: 51.43 },
];

export const mockRankingFacultadPeriodo: RankingFacultadPeriodoItem[] = [
  { periodo: "2023-1", facultad: "Ingenieria", total_inscripciones: 420, ranking: 1 },
  { periodo: "2023-1", facultad: "Ciencias de la Salud", total_inscripciones: 380, ranking: 2 },
  { periodo: "2023-1", facultad: "Negocios", total_inscripciones: 320, ranking: 3 },
  { periodo: "2023-1", facultad: "Ciencias Sociales", total_inscripciones: 290, ranking: 4 },
  { periodo: "2023-2", facultad: "Ciencias de la Salud", total_inscripciones: 430, ranking: 1 },
  { periodo: "2023-2", facultad: "Ingenieria", total_inscripciones: 410, ranking: 2 },
  { periodo: "2023-2", facultad: "Negocios", total_inscripciones: 340, ranking: 3 },
  { periodo: "2023-2", facultad: "Ciencias Sociales", total_inscripciones: 300, ranking: 4 },
  { periodo: "2024-1", facultad: "Ingenieria", total_inscripciones: 465, ranking: 1 },
  { periodo: "2024-1", facultad: "Ciencias de la Salud", total_inscripciones: 450, ranking: 2 },
  { periodo: "2024-1", facultad: "Negocios", total_inscripciones: 360, ranking: 3 },
  { periodo: "2024-1", facultad: "Ciencias Sociales", total_inscripciones: 325, ranking: 4 },
  { periodo: "2024-2", facultad: "Ingenieria", total_inscripciones: 490, ranking: 1 },
  { periodo: "2024-2", facultad: "Ciencias de la Salud", total_inscripciones: 470, ranking: 2 },
  { periodo: "2024-2", facultad: "Negocios", total_inscripciones: 390, ranking: 3 },
  { periodo: "2024-2", facultad: "Ciencias Sociales", total_inscripciones: 345, ranking: 4 },
];

export const mockEstatus: EstatusInscripcion[] = [
  { estatus: "Activo", total: 1890 },
  { estatus: "Baja", total: 215 },
  { estatus: "Egresado", total: 240 },
];

export const mockSaturacion: SaturacionCurso[] = [
  { id_curso: 101, curso: "Cálculo Diferencial (Ingeniería)", materia: "Cálculo Diferencial", facultad: "Ingeniería", cupo_max: 40, inscritos: 40, porcentaje_llenado: 100, esta_lleno: true },
  { id_curso: 102, curso: "Cálculo Diferencial (Ciencias)", materia: "Cálculo Diferencial", facultad: "Ciencias", cupo_max: 40, inscritos: 36, porcentaje_llenado: 90, esta_lleno: false },
  { id_curso: 103, curso: "Programación I (Ingeniería)", materia: "Programación I", facultad: "Ingeniería", cupo_max: 35, inscritos: 34, porcentaje_llenado: 97.14, esta_lleno: false },
  { id_curso: 104, curso: "Física II (Ingeniería)", materia: "Física II", facultad: "Ingeniería", cupo_max: 30, inscritos: 28, porcentaje_llenado: 93.33, esta_lleno: false },
  { id_curso: 105, curso: "Inglés IV (Humanidades)", materia: "Inglés IV", facultad: "Humanidades", cupo_max: 25, inscritos: 20, porcentaje_llenado: 80, esta_lleno: false },
  { id_curso: 106, curso: "Derecho Civil (Derecho)", materia: "Derecho Civil", facultad: "Derecho", cupo_max: 45, inscritos: 30, porcentaje_llenado: 66.67, esta_lleno: false },
  { id_curso: 107, curso: "Contabilidad II (Negocios)", materia: "Contabilidad II", facultad: "Negocios", cupo_max: 35, inscritos: 18, porcentaje_llenado: 51.43, esta_lleno: false },
];

export const mockInscPeriodo: InscripcionPeriodo[] = [
  { periodo: "2023-1", total_inscripciones: 1850 },
  { periodo: "2023-2", total_inscripciones: 1920 },
  { periodo: "2024-1", total_inscripciones: 2050 },
  { periodo: "2024-2", total_inscripciones: 2180 },
  { periodo: "2025-1", total_inscripciones: 2345 },
];

export const mockAlumnos: Alumno[] = [
  { id_alumno: 1, alumno: "Juan Pérez García", correo: "juan.perez@uni.edu", telefono: "5551234567", estatus_alumno: "Activo", carrera: "Ing. Sistemas", facultad: "Ingeniería" },
  { id_alumno: 2, alumno: "María Rodríguez López", correo: "maria.rod@uni.edu", telefono: "5559876543", estatus_alumno: "Activo", carrera: "Medicina", facultad: "Ciencias de la Salud" },
  { id_alumno: 3, alumno: "Carlos Gómez Ruiz", correo: "carlos.gomez@uni.edu", telefono: null, estatus_alumno: "Baja", carrera: "Derecho", facultad: "Ciencias Sociales" },
  { id_alumno: 4, alumno: "Ana Martínez Díaz", correo: "ana.mtz@uni.edu", telefono: "5554567890", estatus_alumno: "Activo", carrera: "Arquitectura", facultad: "Diseño" },
  { id_alumno: 5, alumno: "Roberto Sánchez Villa", correo: null, telefono: "5557891234", estatus_alumno: "Egresado", carrera: "Contaduría", facultad: "Negocios" },
  { id_alumno: 6, alumno: "Laura Torres Méndez", correo: "laura.tm@uni.edu", telefono: "5553216549", estatus_alumno: "Activo", carrera: "Psicología", facultad: "Ciencias Sociales" },
  { id_alumno: 7, alumno: "Diego Flores Reyes", correo: "diego.fr@uni.edu", telefono: null, estatus_alumno: "Activo", carrera: "Ing. Sistemas", facultad: "Ingeniería" },
  { id_alumno: 8, alumno: "Patricia Luna Vargas", correo: "pat.luna@uni.edu", telefono: "5558523697", estatus_alumno: "Baja", carrera: "Medicina", facultad: "Ciencias de la Salud" },
];

export const mockIngresos: IngresoMensual[] = [
  { mes: "Ene 2025", total_ingresos: 580000, numero_transacciones: 312 },
  { mes: "Feb 2025", total_ingresos: 1250000, numero_transacciones: 845 },
  { mes: "Mar 2025", total_ingresos: 420000, numero_transacciones: 256 },
  { mes: "Abr 2025", total_ingresos: 380000, numero_transacciones: 198 },
  { mes: "May 2025", total_ingresos: 310000, numero_transacciones: 167 },
  { mes: "Jun 2025", total_ingresos: 290000, numero_transacciones: 145 },
];

export const mockCargosVsPagos: CargosVsPagos[] = [
  { facultad: "Ingeniería", total_cargado: 4500000, total_pagado: 3650000 },
  { facultad: "Ciencias de la Salud", total_cargado: 3900000, total_pagado: 3220000 },
  { facultad: "Ciencias Sociales", total_cargado: 2800000, total_pagado: 2140000 },
  { facultad: "Diseño", total_cargado: 1650000, total_pagado: 1290000 },
  { facultad: "Negocios", total_cargado: 2300000, total_pagado: 1810000 },
];

export const mockDistribucion: DistribucionConcepto[] = [
  { concepto: "Colegiatura", monto_total: 8500000 },
  { concepto: "Inscripción", monto_total: 2300000 },
  { concepto: "Laboratorio", monto_total: 1100000 },
  { concepto: "Credencial", monto_total: 450000 },
  { concepto: "Examen extraordinario", monto_total: 680000 },
];

export const mockMorosidad: MorosidadAlumno[] = [
  { nombre: "Carlos", apellidos: "Gomez Ruiz", correo: "carlos.gomez@uni.edu", estatus: "Activo", monto_pendiente: 125000 },
  { nombre: "Patricia", apellidos: "Luna Vargas", correo: "pat.luna@uni.edu", estatus: "Activo", monto_pendiente: 98300 },
  { nombre: "Miguel", apellidos: "Angel Reyes", correo: "miguel.ar@uni.edu", estatus: "Activo", monto_pendiente: 77100 },
  { nombre: "Sofia", apellidos: "Castillo Ramos", correo: null, estatus: "Activo", monto_pendiente: 66800 },
  { nombre: "Fernando", apellidos: "Ortega Silva", correo: "fer.os@uni.edu", estatus: "Activo", monto_pendiente: 61400 },
];
