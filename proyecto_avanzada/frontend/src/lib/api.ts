import {
  mockKPIs,
  mockRendimiento,
  mockCriticas,
  mockDocentes,
  mockTopReprobados,
  mockCargaDocente,
  mockRadarFacultad,
  mockRankingFacultadPeriodo,
  mockSunburstJerarquia,
  mockEstatus,
  mockSaturacion,
  mockInscPeriodo,
  mockAlumnos,
  mockIngresos,
  mockCargosVsPagos,
  mockDistribucion,
  mockMorosidad,
} from "./mockData";

const API_BASE = import.meta.env.VITE_API_BASE_URL ?? "http://localhost:8000";
const USE_MOCKS = import.meta.env.VITE_USE_MOCKS === "true";

async function fetchApi<T>(path: string, fallback: T): Promise<T> {
  try {
    const res = await fetch(`${API_BASE}${path}`);
    if (!res.ok) throw new Error(`Error ${res.status}`);
    const payload: unknown = await res.json();

    if (
      payload &&
      typeof payload === "object" &&
      !Array.isArray(payload) &&
      "error" in payload
    ) {
      throw new Error("Backend returned error payload");
    }

    if (Array.isArray(fallback) && !Array.isArray(payload)) {
      throw new Error("Unexpected payload shape");
    }

    return payload as T;
  } catch (error) {
    if (USE_MOCKS) {
      console.warn(`[API] Using mock data for ${path}`);
      return fallback;
    }
    throw error;
  }
}

export interface KPIs {
  rendimiento_global: number;
  total_alumnos: number;
  porcentaje_pagos_corriente: number;
  docentes_activos: number;
  tasa_reprobacion?: number;
  deuda_pendiente?: number;
}

export interface RendimientoCarrera {
  carrera: string;
  promedio_general: number;
}

export interface MateriaCritica {
  materia: string;
  clave: string;
  promedio: number;
}

export interface RankingDocente {
  nombre: string;
  apellidos: string;
  num_empleado: string;
  promedio_alumnos: number;
}

export interface EstatusInscripcion {
  estatus: string;
  total: number;
}

export interface SaturacionCurso {
  id_curso?: number;
  curso?: string;
  materia: string;
  facultad?: string;
  cupo_max: number;
  inscritos: number;
  porcentaje_llenado: number;
  esta_lleno: number | boolean;
}

export interface Alumno {
  id_alumno: number;
  alumno: string;
  correo: string | null;
  telefono: string | null;
  estatus_alumno: string;
  carrera: string | null;
  facultad: string | null;
}

export interface IngresoMensual {
  mes: string;
  total_ingresos: number;
  numero_transacciones: number;
}

export interface MorosidadAlumno {
  nombre: string;
  apellidos: string;
  correo: string | null;
  estatus: string;
  monto_pendiente?: number;
}

export interface ResumenPago {
  periodo: string;
  concepto: string;
  cantidad_pagos: number;
  total_recaudado: number;
  promedio_pago: number;
  pago_minimo: number;
  pago_maximo: number;
}

export interface DistribucionConcepto {
  concepto: string;
  monto_total: number;
}

export interface TopReprobado {
  materia: string;
  clave: string;
  total_reprobados: number;
  total_alumnos: number;
  porcentaje_reprobacion: number;
}

export interface CargaDocente {
  docente: string;
  num_empleado: string;
  total_cursos: number;
  total_alumnos: number;
}

export interface RadarFacultadItem {
  facultad: string;
  rendimiento_promedio: number;
  ocupacion_promedio: number;
  tasa_reprobacion: number;
  cobertura_pagos: number;
  retencion_activos: number;
}

export interface SunburstJerarquiaItem {
  id_curso: number;
  facultad: string;
  carrera: string;
  materia: string;
  curso: string;
  cupo_max: number;
  inscritos: number;
  porcentaje_llenado: number;
}

export interface RankingFacultadPeriodoItem {
  periodo: string;
  facultad: string;
  total_inscripciones: number;
  ranking: number;
}

export interface InscripcionPeriodo {
  periodo: string;
  total_inscripciones: number;
}

export interface CargosVsPagos {
  facultad: string;
  total_cargado: number;
  total_pagado: number;
}

export const api = {
  getKPIs: () => fetchApi<KPIs>("/api/dashboard/kpis", mockKPIs),
  getRendimientoCarrera: () =>
    fetchApi<RendimientoCarrera[]>(
      "/api/vistas/vw_rendimiento_por_carrera",
      mockRendimiento
    ),
  getMateriasCriticas: () =>
    fetchApi<MateriaCritica[]>("/api/academico/materias-criticas", mockCriticas),
  getRankingDocentes: () =>
    fetchApi<RankingDocente[]>("/api/academico/ranking-docentes", mockDocentes),
  getTopReprobados: () =>
    fetchApi<TopReprobado[]>("/api/academico/top-reprobados", mockTopReprobados),
  getCargaDocente: () =>
    fetchApi<CargaDocente[]>("/api/academico/carga-docente", mockCargaDocente),
  getRadarFacultad: () =>
    fetchApi<RadarFacultadItem[]>(
      "/api/academico/radar-facultad",
      mockRadarFacultad
    ),
  getSunburstJerarquia: () =>
    fetchApi<SunburstJerarquiaItem[]>(
      "/api/academico/sunburst-jerarquia",
      mockSunburstJerarquia
    ),
  getRankingFacultadPeriodo: () =>
    fetchApi<RankingFacultadPeriodoItem[]>(
      "/api/academico/ranking-facultad-periodo",
      mockRankingFacultadPeriodo
    ),
  getEstatusInscripcion: () =>
    fetchApi<EstatusInscripcion[]>(
      "/api/control-escolar/estatus-inscripcion",
      mockEstatus
    ),
  getSaturacionCursos: () =>
    fetchApi<SaturacionCurso[]>(
      "/api/control-escolar/saturacion-cursos",
      mockSaturacion
    ),
  getInscripcionesPeriodo: () =>
    fetchApi<InscripcionPeriodo[]>(
      "/api/control-escolar/inscripciones-periodo",
      mockInscPeriodo
    ),
  getAlumnos: (carrera?: string, estatus?: string) => {
    const params = new URLSearchParams();
    if (carrera) params.set("carrera", carrera);
    if (estatus) params.set("estatus", estatus);
    const qs = params.toString();
    return fetchApi<Alumno[]>(
      `/api/control-escolar/alumnos${qs ? `?${qs}` : ""}`,
      mockAlumnos
    );
  },
  getIngresosMensuales: () =>
    fetchApi<IngresoMensual[]>("/api/finanzas/ingresos-mensuales", mockIngresos),
  getMorosidad: () =>
    fetchApi<MorosidadAlumno[]>("/api/finanzas/morosidad", mockMorosidad),
  getResumenPagos: () =>
    fetchApi<ResumenPago[]>("/api/finanzas/resumen-pagos", []),
  getDistribucionConcepto: () =>
    fetchApi<DistribucionConcepto[]>(
      "/api/finanzas/distribucion-concepto",
      mockDistribucion
    ),
  getCargosVsPagos: () =>
    fetchApi<CargosVsPagos[]>("/api/finanzas/cargos-vs-pagos", mockCargosVsPagos),
};
