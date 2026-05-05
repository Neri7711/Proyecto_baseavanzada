import { PieChart as PieChartIcon } from "lucide-react";
import {
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  Tooltip,
  Legend,
} from "recharts";
import { ChartPanel } from "./ChartPanel";
import { PanelEmpty, PanelLoading } from "./PanelState";
import type { DistribucionConcepto } from "@/lib/api";

interface Props {
  data?: DistribucionConcepto[];
  isLoading?: boolean;
}

const COLORS = [
  "hsl(var(--chart-1))",
  "hsl(var(--chart-2))",
  "hsl(var(--chart-3))",
  "hsl(var(--chart-4))",
  "hsl(var(--chart-5))",
  "hsl(var(--primary))",
  "hsl(var(--secondary))",
];

export function DistribucionConceptoChart({ data, isLoading }: Props) {
  return (
    <ChartPanel
      title="Distribución por Concepto"
      subtitle="Participación de cada concepto dentro del ingreso total"
      icon={PieChartIcon}
    >
      {isLoading ? (
        <PanelLoading />
      ) : !data || data.length === 0 ? (
        <PanelEmpty message="No hay datos de distribución por concepto" />
      ) : (
        <div className="h-[340px]">
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={data}
                dataKey="monto_total"
                nameKey="concepto"
                cx="50%"
                cy="50%"
                outerRadius={110}
                innerRadius={55}
                paddingAngle={3}
              >
                {data.map((_, index) => (
                  <Cell
                    key={`cell-${index}`}
                    fill={COLORS[index % COLORS.length]}
                  />
                ))}
              </Pie>
              <Tooltip />
              <Legend />
            </PieChart>
          </ResponsiveContainer>
        </div>
      )}
    </ChartPanel>
  );
}
