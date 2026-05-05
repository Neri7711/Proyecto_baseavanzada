import { useMemo } from "react";
import { Gauge } from "lucide-react";
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
import type { SaturacionCurso } from "@/lib/api";

interface Props {
  data?: SaturacionCurso[];
  isLoading?: boolean;
}

type Bucket = {
  rango: string;
  total_cursos: number;
  color: string;
};

const BUCKETS = [
  { label: "0%", min: 0, max: 0, color: "hsl(var(--muted-foreground))" },
  { label: "1-25%", min: 1, max: 25, color: "hsl(var(--chart-5))" },
  { label: "26-50%", min: 26, max: 50, color: "hsl(var(--chart-3))" },
  { label: "51-75%", min: 51, max: 75, color: "hsl(var(--chart-2))" },
  { label: "76-99%", min: 76, max: 99, color: "hsl(var(--chart-1))" },
  { label: "100%", min: 100, max: 100, color: "hsl(var(--primary))" },
];

export function SaturacionRangosChart({ data, isLoading }: Props) {
  const chartData = useMemo<Bucket[]>(() => {
    if (!data?.length) return [];

    const initial = BUCKETS.map((b) => ({
      rango: b.label,
      total_cursos: 0,
      color: b.color,
    }));

    for (const row of data) {
      const value = Math.max(0, Math.min(100, Number(row.porcentaje_llenado ?? 0)));
      const bucket = BUCKETS.find((b) => value >= b.min && value <= b.max);
      if (!bucket) continue;
      const index = BUCKETS.findIndex((b) => b.label === bucket.label);
      initial[index].total_cursos += 1;
    }

    return initial.filter((b) => b.total_cursos > 0);
  }, [data]);

  return (
    <ChartPanel
      title="Distribucion de Saturacion"
      subtitle="Cantidad de cursos por rango de ocupacion"
      icon={Gauge}
    >
      {isLoading ? (
        <PanelLoading />
      ) : chartData.length === 0 ? (
        <PanelEmpty message="No hay datos para distribuir saturacion" />
      ) : (
        <div className="h-[340px]">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={chartData} layout="vertical" margin={{ left: 12, right: 12 }}>
              <CartesianGrid strokeDasharray="3 3" horizontal={false} />
              <XAxis type="number" tickLine={false} axisLine={false} allowDecimals={false} />
              <YAxis dataKey="rango" type="category" tickLine={false} axisLine={false} width={70} />
              <Tooltip formatter={(value: number) => [value, "Cursos"]} />
              <Bar dataKey="total_cursos" radius={[0, 10, 10, 0]}>
                {chartData.map((entry) => (
                  <Cell key={entry.rango} fill={entry.color} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      )}
    </ChartPanel>
  );
}
