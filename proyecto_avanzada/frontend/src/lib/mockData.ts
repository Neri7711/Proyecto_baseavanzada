import type {
  KPIs, RendimientoCarrera, MateriaCritica, RankingDocente,
  TopReprobado, CargaDocente, EstatusInscripcion, SaturacionCurso,
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

export const mockEstatus: EstatusInscripcion[] = [
  { estatus: "Activo", total: 1890 },
  { estatus: "Baja", total: 215 },
  { estatus: "Egresado", total: 240 },
];

export const mockSaturacion: SaturacionCurso[] = [
  { materia: "Cálculo Diferencial", cupo_max: 40, inscritos: 40, porcentaje_llenado: 100, esta_lleno: true },
  { materia: "Programación I", cupo_max: 35, inscritos: 34, porcentaje_llenado: 97, esta_lleno: false },
  { materia: "Física II", cupo_max: 30, inscritos: 28, porcentaje_llenado: 93, esta_lleno: false },
  { materia: "Inglés IV", cupo_max: 25, inscritos: 20, porcentaje_llenado: 80, esta_lleno: false },
  { materia: "Derecho Civil", cupo_max: 45, inscritos: 30, porcentaje_llenado: 67, esta_lleno: false },
  { materia: "Anatomía I", cupo_max: 40, inscritos: 22, porcentaje_llenado: 55, esta_lleno: false },
  { materia: "Contabilidad II", cupo_max: 35, inscritos: 18, porcentaje_llenado: 51, esta_lleno: false },
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
  { periodo: "2023-1", total_cargado: 3500000, total_pagado: 2800000 },
  { periodo: "2023-2", total_cargado: 3700000, total_pagado: 3100000 },
  { periodo: "2024-1", total_cargado: 4000000, total_pagado: 3200000 },
  { periodo: "2024-2", total_cargado: 4200000, total_pagado: 3500000 },
  { periodo: "2025-1", total_cargado: 4500000, total_pagado: 2650000 },
];

export const mockDistribucion: DistribucionConcepto[] = [
  { concepto: "Colegiatura", monto_total: 8500000 },
  { concepto: "Inscripción", monto_total: 2300000 },
  { concepto: "Laboratorio", monto_total: 1100000 },
  { concepto: "Credencial", monto_total: 450000 },
  { concepto: "Examen extraordinario", monto_total: 680000 },
];

export const mockMorosidad: MorosidadAlumno[] = [
  { nombre: "Carlos", apellidos: "Gómez Ruiz", correo: "carlos.gomez@uni.edu", estatus: "Pendiente" },
  { nombre: "Patricia", apellidos: "Luna Vargas", correo: "pat.luna@uni.edu", estatus: "Vencido" },
  { nombre: "Miguel", apellidos: "Ángel Reyes", correo: "miguel.ar@uni.edu", estatus: "Pendiente" },
  { nombre: "Sofía", apellidos: "Castillo Ramos", correo: null, estatus: "Vencido" },
  { nombre: "Fernando", apellidos: "Ortega Silva", correo: "fer.os@uni.edu", estatus: "Pendiente" },
];
