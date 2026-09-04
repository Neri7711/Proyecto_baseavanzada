import { TrendingDown } from "lucide-react";
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
import type { TopReprobado } from "@/lib/api";

interface Props {
  data?: TopReprobado[];
  isLoading?: boolean;
}

export function TopReprobadosChart({ data, isLoading }: Props) {
  return (
    <ChartPanel
      title="Top Reprobados"
      subtitle="Materias con mayor concentración de reprobación"
      icon={TrendingDown}
    >
      {isLoading ? (
        <PanelLoading />
      ) : !data || data.length === 0 ? (
        <PanelEmpty message="No hay datos de materias reprobadas" />
      ) : (
        <div className="h-[340px]">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={data} barSize={34}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="materia" tickLine={false} axisLine={false} />
              <YAxis tickLine={false} axisLine={false} />
              <Tooltip />
              <Bar dataKey="total_reprobados" fill="hsl(var(--chart-4))" radius={[12, 12, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      )}
    </ChartPanel>
  );
}
