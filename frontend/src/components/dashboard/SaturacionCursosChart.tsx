import { UsersRound } from "lucide-react";
import {
  ResponsiveContainer,
  BarChart,
  Bar,
  CartesianGrid,
  XAxis,
  YAxis,
  Tooltip,
} from "recharts";
import { ChartPanel } from "./ChartPanel";
import { PanelEmpty, PanelLoading } from "./PanelState";
import type { SaturacionCurso } from "@/lib/api";

interface Props {
  data?: SaturacionCurso[];
  isLoading?: boolean;
}

export function SaturacionCursosChart({ data, isLoading }: Props) {
  const chartData = (data ?? [])
    .map((row) => ({
      ...row,
      curso: row.curso ?? `${row.materia}${row.facultad ? ` (${row.facultad})` : ""}`,
      porcentaje_llenado: Math.min(Number(row.porcentaje_llenado ?? 0), 100),
    }))
    .filter((row) => Number.isFinite(row.porcentaje_llenado) && row.porcentaje_llenado > 0);

  return (
    <ChartPanel
      title="Saturacion de Cursos"
      subtitle="Nivel de ocupacion por curso (sin mostrar etiquetas de nombres)"
      icon={UsersRound}
    >
      {isLoading ? (
        <PanelLoading />
      ) : chartData.length === 0 ? (
        <PanelEmpty message="No hay datos de saturacion de cursos" />
      ) : (
        <div className="h-[360px]">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={chartData} barSize={28}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis hide />
              <YAxis tickLine={false} axisLine={false} domain={[0, 100]} />
              <Tooltip
                labelFormatter={(_, payload) => {
                  const item = payload?.[0]?.payload as SaturacionCurso | undefined;
                  return item?.curso ?? item?.materia ?? "Sin nombre de curso";
                }}
                formatter={(v: number) => [`${Number(v).toFixed(2)}%`, "Ocupacion"]}
              />
              <Bar dataKey="porcentaje_llenado" fill="hsl(var(--chart-2))" radius={[12, 12, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      )}
    </ChartPanel>
  );
}
