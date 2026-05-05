import { Search, Users } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { ChartPanel } from "./ChartPanel";
import { PanelEmpty } from "./PanelState";
import type { Alumno } from "@/lib/api";

interface Props {
  data?: Alumno[];
}

const getStatusStyles = (estatus?: string | null) => {
  const e = String(estatus ?? "").toLowerCase();
  if (e.includes("activo") || e.includes("inscrito")) {
    return "bg-emerald-500/10 text-emerald-700 border-emerald-500/20";
  }
  if (e.includes("baja") || e.includes("inactivo")) {
    return "bg-rose-500/10 text-rose-700 border-rose-500/20";
  }
  return "bg-slate-500/10 text-slate-700 border-slate-500/20";
};

export function AlumnosTable({ data }: Props) {
  return (
    <ChartPanel
      title="Listado de Alumnos"
      subtitle="Consulta rápida del padrón estudiantil con estatus académico"
      icon={Users}
      action={
        <div className="hidden sm:flex items-center gap-2 rounded-full border border-border bg-background/70 px-3 py-2 text-xs text-muted-foreground">
          <Search className="h-3.5 w-3.5" />
          Exploración rápida
        </div>
      }
      contentClassName="p-0"
    >
      {!data || data.length === 0 ? (
        <div className="p-6">
          <PanelEmpty message="No se encontraron alumnos para mostrar" />
        </div>
      ) : (
        <div className="overflow-hidden rounded-b-3xl">
          <div className="max-h-[480px] overflow-auto">
            <table className="w-full text-sm">
              <thead className="sticky top-0 z-10 bg-slate-50/95 backdrop-blur-md">
                <tr className="border-b border-border">
                  <th className="px-6 py-4 text-left font-bold text-foreground">ID</th>
                  <th className="px-6 py-4 text-left font-bold text-foreground">Nombre</th>
                  <th className="px-6 py-4 text-left font-bold text-foreground">Carrera</th>
                  <th className="px-6 py-4 text-left font-bold text-foreground">Facultad</th>
                  <th className="px-6 py-4 text-left font-bold text-foreground">Estatus</th>
                </tr>
              </thead>
              <tbody>
                {data.map((alumno, idx) => (
                  <tr
                    key={`${alumno.id_alumno}-${idx}`}
                    className="border-b border-border/60 transition-colors hover:bg-primary/5"
                  >
                    <td className="px-6 py-4 font-medium text-foreground">{alumno.id_alumno}</td>
                    <td className="px-6 py-4 text-foreground">{alumno.alumno}</td>
                    <td className="px-6 py-4 text-muted-foreground">{alumno.carrera ?? "—"}</td>
                    <td className="px-6 py-4 text-muted-foreground">{alumno.facultad ?? "—"}</td>
                    <td className="px-6 py-4">
                      <Badge className={`rounded-full border ${getStatusStyles(alumno.estatus_alumno)}`}>
                        {alumno.estatus_alumno}
                      </Badge>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </ChartPanel>
  );
}
