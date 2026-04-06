import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { DashboardSidebar } from "@/components/dashboard/DashboardSidebar";
import { KpiCards } from "@/components/dashboard/KpiCards";
import { RendimientoCarreraChart } from "@/components/dashboard/RendimientoCarreraChart";
import { MateriasCriticasChart } from "@/components/dashboard/MateriasCriticasChart";
import { RankingDocentesChart } from "@/components/dashboard/RankingDocentesChart";
import { TopReprobadosChart } from "@/components/dashboard/TopReprobadosChart";
import { CargaDocenteChart } from "@/components/dashboard/CargaDocenteChart";
import { EstatusInscripcionChart } from "@/components/dashboard/EstatusInscripcionChart";
import { SaturacionCursosChart } from "@/components/dashboard/SaturacionCursosChart";
import { InscripcionesPeriodoChart } from "@/components/dashboard/InscripcionesPeriodoChart";
import { AlumnosTable } from "@/components/dashboard/AlumnosTable";
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
  const estatus = useQuery({ queryKey: ["estatus"], queryFn: api.getEstatusInscripcion });
  const saturacion = useQuery({ queryKey: ["saturacion"], queryFn: api.getSaturacionCursos });
  const inscPeriodo = useQuery({ queryKey: ["inscPeriodo"], queryFn: api.getInscripcionesPeriodo });
  const alumnos = useQuery({ queryKey: ["alumnos"], queryFn: () => api.getAlumnos() });
  const ingresos = useQuery({ queryKey: ["ingresos"], queryFn: api.getIngresosMensuales });
  const cargosVsPagos = useQuery({ queryKey: ["cargosVsPagos"], queryFn: api.getCargosVsPagos });
  const distribucion = useQuery({ queryKey: ["distribucion"], queryFn: api.getDistribucionConcepto });
  const morosidad = useQuery({ queryKey: ["morosidad"], queryFn: api.getMorosidad });

  return (
    <div className="min-h-screen bg-background">
      <DashboardSidebar collapsed={collapsed} onToggle={() => setCollapsed(!collapsed)} />

      <main className={`transition-all duration-300 ${collapsed ? "ml-16" : "ml-64"}`}>
        <header className="sticky top-0 z-30 bg-background/80 backdrop-blur-md border-b border-border px-6 py-4">
          <h1 className="text-xl font-bold text-foreground">Panel de Control Escolar</h1>
          <p className="text-sm text-muted-foreground">Vista general del sistema académico y financiero</p>
        </header>

        <div className="p-6 space-y-10">
          {/* KPIs */}
          <section id="kpis">
            <KpiCards data={kpis.data} isLoading={kpis.isLoading} />
          </section>

          {/* Académico */}
          <div>
            <h2 className="text-lg font-semibold text-foreground mb-4">Académico</h2>
            <div className="space-y-6">
              <section id="rendimiento">
                <RendimientoCarreraChart data={rendimiento.data} />
              </section>
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <section id="materias-criticas">
                  <MateriasCriticasChart data={criticas.data} />
                </section>
                <section id="top-reprobados">
                  <TopReprobadosChart data={topReprobados.data} />
                </section>
              </div>
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <section id="ranking-docentes">
                  <RankingDocentesChart data={docentes.data} />
                </section>
                <section id="carga-docente">
                  <CargaDocenteChart data={cargaDocente.data} />
                </section>
              </div>
            </div>
          </div>

          {/* Control Escolar */}
          <div>
            <h2 className="text-lg font-semibold text-foreground mb-4">Control Escolar</h2>
            <div className="space-y-6">
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <section id="estatus">
                  <EstatusInscripcionChart data={estatus.data} />
                </section>
                <section id="inscripciones-periodo">
                  <InscripcionesPeriodoChart data={inscPeriodo.data} />
                </section>
              </div>
              <section id="saturacion">
                <SaturacionCursosChart data={saturacion.data} />
              </section>
              <section id="alumnos">
                <AlumnosTable data={alumnos.data} />
              </section>
            </div>
          </div>

          {/* Finanzas */}
          <div>
            <h2 className="text-lg font-semibold text-foreground mb-4">Finanzas</h2>
            <div className="space-y-6">
              <section id="ingresos">
                <IngresosMensualesChart data={ingresos.data} />
              </section>
              <section id="cargos-vs-pagos">
                <CargosVsPagosChart data={cargosVsPagos.data} />
              </section>
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <section id="distribucion">
                  <DistribucionConceptoChart data={distribucion.data} />
                </section>
                <section id="morosidad">
                  <MorosidadTable data={morosidad.data} />
                </section>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
};

export default Index;
