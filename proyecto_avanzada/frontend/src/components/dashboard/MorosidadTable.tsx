import { AlertTriangle } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { ChartPanel } from "./ChartPanel";
import { PanelEmpty, PanelLoading } from "./PanelState";
import type { MorosidadAlumno } from "@/lib/api";

interface Props {
  data?: MorosidadAlumno[];
  isLoading?: boolean;
}

export function MorosidadTable({ data, isLoading }: Props) {
  const filteredData = (data ?? []).filter(
    (row) => Number(row.monto_pendiente ?? 0) > 60000
  );

  return (
    <ChartPanel
      title="Morosidad"
      subtitle="Solo alumnos activos con deuda pendiente mayor a $60,000"
      icon={AlertTriangle}
      contentClassName="p-0"
    >
      {isLoading ? (
        <div className="p-6">
          <PanelLoading message="Cargando morosidad..." />
        </div>
      ) : filteredData.length === 0 ? (
        <div className="p-6">
          <PanelEmpty message="Sin registros de morosidad mayores a $60,000" />
        </div>
      ) : (
        <div className="overflow-hidden rounded-b-3xl">
          <div className="max-h-[480px] overflow-auto">
            <table className="w-full text-sm">
              <thead className="sticky top-0 z-10 bg-slate-50/95 backdrop-blur-md">
                <tr className="border-b border-border">
                  <th className="px-6 py-4 text-left font-bold text-foreground">Alumno</th>
                  <th className="px-6 py-4 text-left font-bold text-foreground">Correo</th>
                  <th className="px-6 py-4 text-left font-bold text-foreground">Estatus</th>
                  <th className="px-6 py-4 text-left font-bold text-foreground">Monto pendiente</th>
                </tr>
              </thead>
              <tbody>
                {filteredData.map((row, idx) => {
                  const fullName = `${row.nombre} ${row.apellidos}`.trim();
                  const monto = Number(row.monto_pendiente ?? 0);

                  return (
                    <tr
                      key={`${row.correo ?? fullName}-${idx}`}
                      className="border-b border-border/60 transition-colors hover:bg-secondary/5"
                    >
                      <td className="px-6 py-4 font-medium text-foreground">{fullName || "Sin nombre"}</td>
                      <td className="px-6 py-4 text-muted-foreground">{row.correo ?? "—"}</td>
                      <td className="px-6 py-4">
                        <Badge className="rounded-full border border-secondary/30 bg-secondary/10 text-secondary">
                          {row.estatus}
                        </Badge>
                      </td>
                      <td className="px-6 py-4 font-bold text-foreground">
                        ${monto.toLocaleString()}
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
