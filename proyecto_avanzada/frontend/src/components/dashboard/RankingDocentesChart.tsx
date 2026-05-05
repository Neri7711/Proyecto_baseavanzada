import { Award } from "lucide-react";
import {
  ResponsiveContainer,
  BarChart,
  Bar,
  CartesianGrid,
  XAxis,
  YAxis,
  Tooltip,
  Cell,
} from "recharts";
import { ChartPanel } from "./ChartPanel";
import { PanelEmpty, PanelLoading } from "./PanelState";
import type { RankingDocente } from "@/lib/api";

interface Props {
  data?: RankingDocente[];
  isLoading?: boolean;
}

export function RankingDocentesChart({ data, isLoading }: Props) {
  const normalized = data
    ? [...data]
        .map((row) => ({
          docente: `${row.nombre} ${row.apellidos}`.trim(),
          promedio_alumnos: Number(row.promedio_alumnos ?? 0),
        }))
        .sort((a, b) => b.promedio_alumnos - a.promedio_alumnos)
    : [];

  const top10 = normalized.slice(0, 10);
  const bottom10Asc = [...normalized]
    .sort((a, b) => a.promedio_alumnos - b.promedio_alumnos)
    .slice(0, 10);

  const selected = [...top10];
  for (const row of bottom10Asc) {
    if (!selected.some((item) => item.docente === row.docente)) {
      selected.push(row);
    }
  }

  const chartData = selected.map((row) => ({
    ...row,
    segmento: top10.some((top) => top.docente === row.docente) ? "Top 10" : "Bottom 10",
  }));

  const chartHeight = Math.max(180, chartData.length * 26);

  return (
    <ChartPanel
      title="Ranking de Docentes"
      subtitle="Top 10 y bottom 10 por promedio de alumnos"
      icon={Award}
    >
      {isLoading ? (
        <PanelLoading />
      ) : chartData.length === 0 ? (
        <PanelEmpty message="No hay datos de ranking docente" />
      ) : (
        <div className="max-h-[420px] overflow-auto">
          <div style={{ height: `${chartHeight}px`, minHeight: "180px" }}>
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={chartData} layout="vertical" margin={{ left: 2, right: 8, top: 0, bottom: 0 }}>
                <CartesianGrid strokeDasharray="3 3" horizontal={false} />
                <XAxis type="number" tickLine={false} axisLine={false} />
                <YAxis
                  type="category"
                  dataKey="docente"
                  tickLine={false}
                  axisLine={false}
                  width={160}
                  tick={{ fontSize: 11 }}
                />
                <Tooltip formatter={(v: number) => [v.toFixed(2), "Promedio"]} />
                <Bar dataKey="promedio_alumnos" barSize={16} radius={[0, 8, 8, 0]}>
                  {chartData.map((row) => (
                    <Cell
                      key={`${row.docente}-${row.segmento}`}
                      fill={row.segmento === "Top 10" ? "hsl(var(--chart-1))" : "hsl(var(--chart-3))"}
                    />
                  ))}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      )}
    </ChartPanel>
  );
}
