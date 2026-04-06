import { LayoutDashboard, GraduationCap, Users, DollarSign, ChevronDown } from "lucide-react";
import { useState } from "react";

interface Section {
  id: string;
  label: string;
  icon: React.ElementType;
  children?: { id: string; label: string }[];
}

const sections: Section[] = [
  { id: "kpis", label: "Dashboard", icon: LayoutDashboard },
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
      { id: "alumnos", label: "Listado de Alumnos" },
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
      className={`fixed top-0 left-0 h-screen bg-sidebar text-sidebar-foreground z-40 transition-all duration-300 flex flex-col ${
        collapsed ? "w-16" : "w-64"
      }`}
    >
      <div className="flex items-center gap-3 px-4 h-16 border-b border-sidebar-border shrink-0">
        <GraduationCap className="h-7 w-7 text-sidebar-primary shrink-0" />
        {!collapsed && <span className="font-bold text-lg tracking-tight">EscuelaDash</span>}
      </div>

      <nav className="flex-1 overflow-y-auto py-4 px-2 space-y-1">
        {sections.map((s) => (
          <div key={s.id}>
            {s.children ? (
              <>
                <button
                  onClick={() => (collapsed ? scrollTo(s.children![0].id) : toggleGroup(s.id))}
                  className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium hover:bg-sidebar-accent transition-colors"
                >
                  <s.icon className="h-5 w-5 shrink-0 text-sidebar-primary" />
                  {!collapsed && (
                    <>
                      <span className="flex-1 text-left">{s.label}</span>
                      <ChevronDown
                        className={`h-4 w-4 transition-transform ${expanded[s.id] ? "rotate-0" : "-rotate-90"}`}
                      />
                    </>
                  )}
                </button>
                {!collapsed && expanded[s.id] && (
                  <div className="ml-8 mt-1 space-y-0.5">
                    {s.children.map((c) => (
                      <button
                        key={c.id}
                        onClick={() => scrollTo(c.id)}
                        className="block w-full text-left px-3 py-2 text-sm rounded-md hover:bg-sidebar-accent transition-colors text-sidebar-foreground/80 hover:text-sidebar-foreground"
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
                className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium hover:bg-sidebar-accent transition-colors"
              >
                <s.icon className="h-5 w-5 shrink-0 text-sidebar-primary" />
                {!collapsed && <span>{s.label}</span>}
              </button>
            )}
          </div>
        ))}
      </nav>

      <button
        onClick={onToggle}
        className="h-12 flex items-center justify-center border-t border-sidebar-border text-sidebar-foreground/60 hover:text-sidebar-foreground transition-colors"
      >
        <ChevronDown className={`h-5 w-5 transition-transform ${collapsed ? "rotate-[-90deg]" : "rotate-90"}`} />
      </button>
    </aside>
  );
}
