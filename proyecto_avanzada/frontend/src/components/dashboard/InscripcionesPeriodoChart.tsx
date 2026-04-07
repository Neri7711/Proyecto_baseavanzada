import { CalendarRange } from "lucide-react";
import {
  ResponsiveContainer,
  AreaChart,
  Area,
  CartesianGrid,
  XAxis,
  YAxis,
  Tooltip,
} from "recharts";
import { ChartPanel } from "./ChartPanel";
import { PanelEmpty, PanelLoading } from "./PanelState";

interface InscripcionPeriodoItem {
  periodo: string;
  total: number;
}

interface Props {
  data?: InscripcionPeriodoItem[];
  isLoading?: boolean;
}

export function InscripcionesPeriodoChart({ data, isLoading }: Props) {
  return (
    <ChartPanel
      title="Tendencia de Inscripciones"
      subtitle="Comportamiento de inscripciones por periodo académico"
      icon={CalendarRange}
    >
      {isLoading ? (
        <PanelLoading />
      ) : !data || data.length === 0 ? (
        <PanelEmpty message="No hay datos de inscripciones por periodo" />
      ) : (
        <div className="h-[340px]">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={data}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="periodo" tickLine={false} axisLine={false} />
              <YAxis tickLine={false} axisLine={false} />
              <Tooltip />
              <Area type="monotone" dataKey="total" strokeWidth={3} />
            </AreaChart>
          </ResponsiveContainer>
        </div>
      )}
    </ChartPanel>
  );
}
