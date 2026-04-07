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

interface SaturacionCursoItem {
  curso: string;
  porcentaje: number;
}

interface Props {
  data?: SaturacionCursoItem[];
  isLoading?: boolean;
}

export function SaturacionCursosChart({ data, isLoading }: Props) {
  return (
    <ChartPanel
      title="Saturación de Cursos"
      subtitle="Nivel de ocupación de los cursos con mayor demanda"
      icon={UsersRound}
    >
      {isLoading ? (
        <PanelLoading />
      ) : !data || data.length === 0 ? (
        <PanelEmpty message="No hay datos de saturación de cursos" />
      ) : (
        <div className="h-[340px]">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={data} barSize={34}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="curso" tickLine={false} axisLine={false} />
              <YAxis tickLine={false} axisLine={false} />
              <Tooltip />
              <Bar dataKey="porcentaje" radius={[12, 12, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      )}
    </ChartPanel>
  );
}
