import { UserCheck } from "lucide-react";
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

interface EstatusInscripcionItem {
  estatus: string;
  total: number;
}

interface Props {
  data?: EstatusInscripcionItem[];
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

export function EstatusInscripcionChart({ data, isLoading }: Props) {
  return (
    <ChartPanel
      title="Estatus de Inscripción"
      subtitle="Distribución de alumnos según su estado de inscripción"
      icon={UserCheck}
    >
      {isLoading ? (
        <PanelLoading />
      ) : !data || data.length === 0 ? (
        <PanelEmpty message="No hay datos de estatus de inscripción" />
      ) : (
        <div className="h-[340px]">
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={data}
                dataKey="total"
                nameKey="estatus"
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
