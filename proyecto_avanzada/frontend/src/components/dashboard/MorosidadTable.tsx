import { AlertTriangle } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { ChartPanel } from "./ChartPanel";
import { PanelEmpty } from "./PanelState";

interface Moroso {
  matricula?: string;
  alumno?: string;
  nombre?: string;
  carrera?: string;
  monto_pendiente?: number;
  deuda_pendiente?: number;
  vencido?: string;
}

interface Props {
  data?: Moroso[];
}

const riskBadge = (monto: number) => {
  if (monto >= 10000) return "bg-rose-500/10 text-rose-700 border-rose-500/20";
  if (monto >= 5000) return "bg-amber-500/10 text-amber-700 border-amber-500/20";
  return "bg-slate-500/10 text-slate-700 border-slate-500/20";
};

const riskLabel = (monto: number) => {
  if (monto >= 10000) return "Alta";
  if (monto >= 5000) return "Media";
  return "Baja";
};

export function MorosidadTable({ data }: Props) {
  return (
    <ChartPanel
      title="Morosidad"
      subtitle="Seguimiento a alumnos con saldo pendiente y nivel de riesgo financiero"
      icon={AlertTriangle}
      contentClassName="p-0"
    >
      {!data || data.length === 0 ? (
        <div className="p-6">
          <PanelEmpty message="No hay registros de morosidad" />
        </div>
      ) : (
        <div className="overflow-hidden rounded-b-3xl">
          <div className="max-h-[480px] overflow-auto">
            <table className="w-full text-sm">
              <thead className="sticky top-0 z-10 bg-slate-50/95 backdrop-blur-md">
                <tr className="border-b border-border">
                  <th className="px-6 py-4 text-left font-bold text-foreground">Matrícula</th>
                  <th className="px-6 py-4 text-left font-bold text-foreground">Alumno</th>
                  <th className="px-6 py-4 text-left font-bold text-foreground">Carrera</th>
                  <th className="px-6 py-4 text-left font-bold text-foreground">Monto</th>
                  <th className="px-6 py-4 text-left font-bold text-foreground">Riesgo</th>
                </tr>
              </thead>
              <tbody>
                {data.map((row, idx) => {
                  const monto = Number(row.monto_pendiente ?? row.deuda_pendiente ?? 0);
                  const alumno = row.alumno ?? row.nombre ?? "Sin nombre";
                  return (
                    <tr
                      key={`${row.matricula ?? alumno}-${idx}`}
                      className="border-b border-border/60 transition-colors hover:bg-rose-500/5"
                    >
                      <td className="px-6 py-4 font-medium text-foreground">{row.matricula ?? "—"}</td>
                      <td className="px-6 py-4 text-foreground">{alumno}</td>
                      <td className="px-6 py-4 text-muted-foreground">{row.carrera ?? "—"}</td>
                      <td className="px-6 py-4 font-bold text-foreground">
                        ${monto.toLocaleString()}
                      </td>
                      <td className="px-6 py-4">
                        <Badge className={`rounded-full border ${riskBadge(monto)}`}>
                          {riskLabel(monto)}
                        </Badge>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </ChartPanel>
  );
}
