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
  "#8b5cf6",
  "#06b6d4",
  "#fb923c",
  "#ec4899",
  "#22c55e",
  "#f43f5e",
  "#14b8a6",
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
