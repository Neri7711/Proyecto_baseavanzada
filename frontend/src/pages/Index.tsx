import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { CalendarDays, GraduationCap, DollarSign, ShieldCheck } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { api } from "@/lib/api";
import { DashboardSidebar } from "@/components/dashboard/DashboardSidebar";
import { KpiCards } from "@/components/dashboard/KpiCards";
import { RendimientoCarreraChart } from "@/components/dashboard/RendimientoCarreraChart";
import { MateriasCriticasChart } from "@/components/dashboard/MateriasCriticasChart";
import { RankingDocentesChart } from "@/components/dashboard/RankingDocentesChart";
import { TopReprobadosChart } from "@/components/dashboard/TopReprobadosChart";
import { CargaDocenteChart } from "@/components/dashboard/CargaDocenteChart";
import { RadarFacultadChart } from "@/components/dashboard/RadarFacultadChart";
import { BumpRankingFacultadChart } from "@/components/dashboard/BumpRankingFacultadChart";
import { EstatusInscripcionChart } from "@/components/dashboard/EstatusInscripcionChart";
import { SaturacionCursosChart } from "@/components/dashboard/SaturacionCursosChart";
import { SaturacionRangosChart } from "@/components/dashboard/SaturacionRangosChart";
import { InscripcionesPeriodoChart } from "@/components/dashboard/InscripcionesPeriodoChart";
import { IngresosMensualesChart } from "@/components/dashboard/IngresosMensualesChart";
import { CargosVsPagosChart } from "@/components/dashboard/CargosVsPagosChart";
import { DistribucionConceptoChart } from "@/components/dashboard/DistribucionConceptoChart";
import { MorosidadTable } from "@/components/dashboard/MorosidadTable";

const Index = () => {
  const [collapsed, setCollapsed] = useState(false);

  const kpis = useQuery({ queryKey: ["kpis"], queryFn: api.getKPIs });
  const rendimiento = useQuery({ queryKey: ["rendimiento"], queryFn: api.getRendimientoCarrera });
  const criticas = useQuery({ queryKey: ["criticas"], queryFn: api.getMateriasCriticas });
  const docentes = useQuery({ queryKey: ["docentes"], queryFn: api.getRankingDocentes });
  const topReprobados = useQuery({ queryKey: ["topReprobados"], queryFn: api.getTopReprobados });
  const cargaDocente = useQuery({ queryKey: ["cargaDocente"], queryFn: api.getCargaDocente });
  const radarFacultad = useQuery({ queryKey: ["radarFacultad"], queryFn: api.getRadarFacultad });
  const rankingFacultadPeriodo = useQuery({ queryKey: ["rankingFacultadPeriodo"], queryFn: api.getRankingFacultadPeriodo });
  const estatus = useQuery({ queryKey: ["estatus"], queryFn: api.getEstatusInscripcion });
  const saturacion = useQuery({ queryKey: ["saturacion"], queryFn: api.getSaturacionCursos });
  const inscPeriodo = useQuery({ queryKey: ["inscPeriodo"], queryFn: api.getInscripcionesPeriodo });
  const ingresos = useQuery({ queryKey: ["ingresos"], queryFn: api.getIngresosMensuales });
  const cargosVsPagos = useQuery({ queryKey: ["cargosVsPagos"], queryFn: api.getCargosVsPagos });
  const distribucion = useQuery({ queryKey: ["distribucion"], queryFn: api.getDistribucionConcepto });
  const morosidad = useQuery({ queryKey: ["morosidad"], queryFn: api.getMorosidad });

  return (
    <div className="dashboard-shell">
      <DashboardSidebar collapsed={collapsed} onToggle={() => setCollapsed(!collapsed)} />

      <main className={`relative z-10 transition-all duration-300 ${collapsed ? "ml-20" : "ml-72"}`}>
        <header className="sticky top-0 z-30 border-b border-white/60 bg-background/70 backdrop-blur-xl">
          <div className="px-6 py-5 lg:px-8">
            <div className="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
              <div>
                <h1 className="text-2xl lg:text-3xl font-black tracking-tight text-foreground">
                  Panel de Control Escolar
                </h1>
                <p className="text-sm text-muted-foreground mt-1">
                  Vista general académica, operativa y financiera de la institución
                </p>
              </div>

              <div className="flex flex-wrap items-center gap-2">
                <Badge className="rounded-full bg-primary/10 text-primary hover:bg-primary/10 border border-primary/20">
                  <ShieldCheck className="mr-1 h-3.5 w-3.5" />
                  Sistema activo
                </Badge>
                <Badge className="rounded-full bg-secondary/10 text-secondary hover:bg-secondary/10 border border-secondary/20">
                  <CalendarDays className="mr-1 h-3.5 w-3.5" />
                  Periodo 2025-1
                </Badge>
              </div>
            </div>
          </div>
        </header>

        <div className="px-6 py-6 lg:px-8 space-y-8">
          <section className="hero-card p-7 lg:p-10">
            <div className="relative z-10 flex flex-col gap-8 lg:flex-row lg:items-end lg:justify-between">
              <div className="max-w-3xl">
                <div className="flex flex-wrap gap-2 mb-4">
			<span className="rounded-full bg-white/20 px-3 py-1 text-xs font-bold text-white backdrop-blur-md">
			Académico
			</span>
			<span className="rounded-full bg-fuchsia-400/30 px-3 py-1 text-xs font-bold text-white backdrop-blur-md">
			Control Escolar
			</span>
			<span className="rounded-full bg-orange-400/30 px-3 py-1 text-xs font-bold text-white backdrop-blur-md">
			Finanzas
			</span>	                  
                </div>
                <h2 className="text-3xl lg:text-5xl font-black tracking-tight leading-tight">
                  Gestión universitaria con una vista clara, ejecutiva y accionable
                </h2>
                <p className="mt-4 max-w-2xl text-sm lg:text-base text-white/75 leading-relaxed">
                  Supervisa desempeño, capacidad operativa, comportamiento de inscripción y flujo
                  financiero desde un solo tablero.
                </p>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 min-w-full lg:min-w-[420px] lg:max-w-[520px]">
                <div className="rounded-2xl bg-white/10 border border-white/10 p-4 backdrop-blur-md">
                  <GraduationCap className="h-5 w-5 text-cyan-300 mb-3" />
                  <p className="text-xs uppercase tracking-wider text-white/60">Indicador</p>
                  <p className="text-lg font-bold text-white">Rendimiento</p>
                </div>
                <div className="rounded-2xl bg-white/10 border border-white/10 p-4 backdrop-blur-md">
                  <ShieldCheck className="h-5 w-5 text-emerald-300 mb-3" />
                  <p className="text-xs uppercase tracking-wider text-white/60">Estado</p>
                  <p className="text-lg font-bold text-white">Operación estable</p>
                </div>
                <div className="rounded-2xl bg-white/10 border border-white/10 p-4 backdrop-blur-md">
                  <DollarSign className="h-5 w-5 text-amber-300 mb-3" />
                  <p className="text-xs uppercase tracking-wider text-white/60">Seguimiento</p>
                  <p className="text-lg font-bold text-white">Cobranza</p>
                </div>
              </div>
            </div>
          </section>

          <section id="kpis" className="space-y-4">
            <div>
              <h2 className="section-title">Resumen Ejecutivo</h2>
              <p className="section-subtitle">Indicadores clave del estado general de la institución</p>
            </div>
            <KpiCards data={kpis.data} isLoading={kpis.isLoading} />
          </section>

          <section className="section-card">
            <div className="mb-6">
              <h2 className="section-title">Académico</h2>
              <p className="section-subtitle">Desempeño, calidad docente y materias de mayor riesgo</p>
            </div>

            <div className="space-y-6">
              <section id="rendimiento">
                <RendimientoCarreraChart data={rendimiento.data} isLoading={rendimiento.isLoading} />
              </section>
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <section id="materias-criticas">
                  <MateriasCriticasChart data={criticas.data} isLoading={criticas.isLoading} />
                </section>
                <section id="top-reprobados">
                  <TopReprobadosChart data={topReprobados.data} isLoading={topReprobados.isLoading} />
                </section>
              </div>
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <section id="ranking-docentes">
                  <RankingDocentesChart data={docentes.data} isLoading={docentes.isLoading} />
                </section>
                <section id="carga-docente">
                  <CargaDocenteChart data={cargaDocente.data} isLoading={cargaDocente.isLoading} />
                </section>
              </div>
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <section id="radar-facultad">
                  <RadarFacultadChart data={radarFacultad.data} isLoading={radarFacultad.isLoading} />
                </section>
                <section id="bump-facultad-periodo">
                  <BumpRankingFacultadChart data={rankingFacultadPeriodo.data} isLoading={rankingFacultadPeriodo.isLoading} />
                </section>
              </div>
            </div>
          </section>

          <section className="section-card">
            <div className="mb-6">
              <h2 className="section-title">Control Escolar</h2>
              <p className="section-subtitle">Comportamiento de la matrícula, inscripción y ocupación de cursos</p>
            </div>

            <div className="space-y-6">
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <section id="estatus">
                  <EstatusInscripcionChart data={estatus.data} isLoading={estatus.isLoading} />
                </section>
                <section id="inscripciones-periodo">
                  <InscripcionesPeriodoChart data={inscPeriodo.data} isLoading={inscPeriodo.isLoading} />
                </section>
              </div>
              <section id="saturacion">
                <SaturacionCursosChart data={saturacion.data} isLoading={saturacion.isLoading} />
              </section>
              <section id="saturacion-rangos">
                <SaturacionRangosChart data={saturacion.data} isLoading={saturacion.isLoading} />
              </section>
            </div>
          </section>

          <section className="section-card">
            <div className="mb-6">
              <h2 className="section-title">Finanzas</h2>
              <p className="section-subtitle">Ingresos, cargos, pagos y comportamiento de morosidad</p>
            </div>

            <div className="space-y-6">
              <section id="ingresos">
                <IngresosMensualesChart data={ingresos.data} isLoading={ingresos.isLoading} />
              </section>
              <section id="cargos-vs-pagos">
                <CargosVsPagosChart data={cargosVsPagos.data} isLoading={cargosVsPagos.isLoading} />
              </section>
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <section id="distribucion">
                  <DistribucionConceptoChart data={distribucion.data} isLoading={distribucion.isLoading} />
                </section>
                <section id="morosidad">
                  <MorosidadTable data={morosidad.data} isLoading={morosidad.isLoading} />
                </section>
              </div>
            </div>
          </section>
        </div>
      </main>
    </div>
  );
};

export default Index;
