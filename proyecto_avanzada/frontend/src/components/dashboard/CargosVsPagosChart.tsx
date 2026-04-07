import { Wallet } from "lucide-react";
import {
  ResponsiveContainer,
  BarChart,
  Bar,
  CartesianGrid,
  XAxis,
  YAxis,
  Tooltip,
  Legend,
} from "recharts";
import { ChartPanel } from "./ChartPanel";
import { PanelEmpty, PanelLoading } from "./PanelState";

interface CargosVsPagosItem {
  mes: string;
  cargos: number;
  pagos: number;
}

interface Props {
  data?: CargosVsPagosItem[];
  isLoading?: boolean;
}

export function CargosVsPagosChart({ data, isLoading }: Props) {
  return (
    <ChartPanel
      title="Cargos vs Pagos"
      subtitle="Comparativa mensual entre cargos emitidos y pagos recibidos"
      icon={Wallet}
    >
      {isLoading ? (
        <PanelLoading />
      ) : !data || data.length === 0 ? (
        <PanelEmpty message="No hay datos de cargos y pagos" />
      ) : (
        <div className="h-[340px]">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={data} barGap={8}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="mes" tickLine={false} axisLine={false} />
              <YAxis tickLine={false} axisLine={false} />
              <Tooltip />
              <Legend />
              <Bar dataKey="cargos" radius={[10, 10, 0, 0]} />
              <Bar dataKey="pagos" radius={[10, 10, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      )}
    </ChartPanel>
  );
}
