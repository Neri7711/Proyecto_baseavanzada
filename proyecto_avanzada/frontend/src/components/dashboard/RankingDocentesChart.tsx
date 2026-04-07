import { Award } from "lucide-react";
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

interface RankingDocenteItem {
  docente: string;
  promedio: number;
}

interface Props {
  data?: RankingDocenteItem[];
  isLoading?: boolean;
}

export function RankingDocentesChart({ data, isLoading }: Props) {
  return (
    <ChartPanel
      title="Ranking de Docentes"
      subtitle="Comparativa de desempeño promedio por docente"
      icon={Award}
    >
      {isLoading ? (
        <PanelLoading />
      ) : !data || data.length === 0 ? (
        <PanelEmpty message="No hay datos de ranking docente" />
      ) : (
        <div className="h-[340px]">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={data} layout="vertical" margin={{ left: 20 }}>
              <CartesianGrid strokeDasharray="3 3" horizontal={false} />
              <XAxis type="number" tickLine={false} axisLine={false} />
              <YAxis
                type="category"
                dataKey="docente"
                tickLine={false}
                axisLine={false}
                width={150}
              />
              <Tooltip />
              <Bar dataKey="promedio" radius={[0, 12, 12, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      )}
    </ChartPanel>
  );
}
