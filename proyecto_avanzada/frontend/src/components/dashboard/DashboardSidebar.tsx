import {
  LayoutDashboard,
  GraduationCap,
  Users,
  DollarSign,
  ChevronDown,
  Sparkles,
} from "lucide-react";
import { useState } from "react";

interface Section {
  id: string;
  label: string;
  icon: React.ElementType;
  children?: { id: string; label: string }[];
}

const sections: Section[] = [
  { id: "kpis", label: "Resumen Ejecutivo", icon: LayoutDashboard },
  {
    id: "academico",
    label: "Académico",
    icon: GraduationCap,
    children: [
      { id: "rendimiento", label: "Rendimiento por Carrera" },
      { id: "materias-criticas", label: "Materias Críticas" },
      { id: "top-reprobados", label: "Top Reprobados" },
      { id: "ranking-docentes", label: "Ranking Docentes" },
      { id: "carga-docente", label: "Carga Docente" },
      { id: "radar-facultad", label: "Radar por Facultad" },
      { id: "bump-facultad-periodo", label: "Bump Ranking Periodo" },
    ],
  },
  {
    id: "control-escolar",
    label: "Control Escolar",
    icon: Users,
    children: [
      { id: "estatus", label: "Estatus Inscripción" },
      { id: "inscripciones-periodo", label: "Tendencia Inscripciones" },
      { id: "saturacion", label: "Saturación de Cursos" },
      { id: "saturacion-rangos", label: "Rangos de Saturación" },
    ],
  },
  {
    id: "finanzas",
    label: "Finanzas",
    icon: DollarSign,
    children: [
      { id: "ingresos", label: "Ingresos Mensuales" },
      { id: "cargos-vs-pagos", label: "Cargos vs Pagos" },
      { id: "distribucion", label: "Distribución Ingresos" },
      { id: "morosidad", label: "Morosidad" },
    ],
  },
];

interface Props {
  collapsed: boolean;
  onToggle: () => void;
}

export function DashboardSidebar({ collapsed, onToggle }: Props) {
  const [expanded, setExpanded] = useState<Record<string, boolean>>({
    academico: true,
    "control-escolar": true,
    finanzas: true,
  });

  const scrollTo = (id: string) => {
    document.getElementById(id)?.scrollIntoView({ behavior: "smooth", block: "start" });
  };

  const toggleGroup = (id: string) => {
    setExpanded((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  return (
    <aside
	className={`fixed top-0 left-0 h-screen z-40 transition-all duration-300 flex flex-col border-r border-sidebar-border/80 bg-[linear-gradient(180deg,#4c1d95_0%,#312e81_45%,#0f172a_100%)] text-sidebar-foreground shadow-2xl ${     
   	collapsed ? "w-20" : "w-72"
      }`}
    >
      <div className="relative flex items-center gap-3 px-5 h-20 border-b border-sidebar-border shrink-0">
        <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-sidebar-primary text-sidebar-primary-foreground shadow-lg">
          <GraduationCap className="h-6 w-6" />
        </div>
        {!collapsed && (
          <div>
            <p className="text-[11px] uppercase tracking-[0.22em] text-sidebar-foreground/55">Analytics Suite</p>
            <span className="font-extrabold text-xl tracking-tight text-white">EscuelaDash</span>
          </div>
        )}
      </div>

      {!collapsed && (
        <div className="mx-4 mt-4 rounded-2xl border border-white/10 bg-white/5 p-4 backdrop-blur-md">
          <div className="flex items-center gap-2 text-cyan-300">
            <Sparkles className="h-4 w-4" />
            <span className="text-xs font-semibold uppercase tracking-wider">Vista inteligente</span>
          </div>
          <p className="mt-2 text-sm leading-relaxed text-sidebar-foreground/80">
            Monitorea desempeño académico, inscripción y finanzas desde un solo panel.
          </p>
        </div>
      )}

      <nav className="flex-1 overflow-y-auto py-5 px-3 space-y-2">
        {sections.map((s) => (
          <div key={s.id}>
            {s.children ? (
              <>
                <button
                  onClick={() => (collapsed ? scrollTo(s.children![0].id) : toggleGroup(s.id))}
                  className="w-full flex items-center gap-3 rounded-2xl px-3 py-3 text-sm font-semibold text-left transition-all hover:bg-white/10 hover:text-white"
                >
                  <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-white/5">
			<s.icon className="h-5 w-5 shrink-0 text-fuchsia-300" />	                 
                  </div>
                  {!collapsed && (
                    <>
                      <span className="flex-1">{s.label}</span>
                      <ChevronDown
                        className={`h-4 w-4 transition-transform ${expanded[s.id] ? "rotate-0" : "-rotate-90"}`}
                      />
                    </>
                  )}
                </button>

                {!collapsed && expanded[s.id] && (
                  <div className="ml-6 mt-2 space-y-1 border-l border-white/10 pl-4">
                    {s.children.map((c) => (
                      <button
                        key={c.id}
                        onClick={() => scrollTo(c.id)}
                        className="block w-full rounded-xl px-3 py-2 text-left text-sm text-sidebar-foreground/75 transition-all hover:bg-white/10 hover:text-white"
                      >
                        {c.label}
                      </button>
                    ))}
                  </div>
                )}
              </>
            ) : (
              <button
                onClick={() => scrollTo(s.id)}
                className="w-full flex items-center gap-3 rounded-2xl px-3 py-3 text-sm font-semibold transition-all hover:bg-white/10 hover:text-white"
              >
                <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-white/5">
                  <s.icon className="h-5 w-5 shrink-0 text-cyan-300" />
                </div>
                {!collapsed && <span>{s.label}</span>}
              </button>
            )}
          </div>
        ))}
      </nav>

      <button
        onClick={onToggle}
        className="m-3 flex h-12 items-center justify-center rounded-2xl border border-white/10 bg-white/5 text-sidebar-foreground/70 transition-all hover:bg-white/10 hover:text-white"
      >
        <ChevronDown className={`h-5 w-5 transition-transform ${collapsed ? "-rotate-90" : "rotate-90"}`} />
      </button>
    </aside>
  );
}
