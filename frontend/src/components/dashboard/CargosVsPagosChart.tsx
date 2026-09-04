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
import type { CargosVsPagos } from "@/lib/api";

interface Props {
  data?: CargosVsPagos[];
  isLoading?: boolean;
}

export function CargosVsPagosChart({ data, isLoading }: Props) {
  return (
    <ChartPanel
      title="Cargos vs Pagos"
      subtitle="Comparativa por facultad: cargos emitidos contra pagos recibidos"
      icon={Wallet}
    >
      {isLoading ? (
        <PanelLoading />
      ) : !data || data.length === 0 ? (
        <PanelEmpty message="No hay datos de cargos y pagos" />
      ) : (
        <div className="h-[360px]">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={data} barGap={8}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="facultad" tickLine={false} axisLine={false} interval={0} angle={-18} textAnchor="end" height={70} />
              <YAxis tickLine={false} axisLine={false} />
              <Tooltip formatter={(v: number) => [`$${Number(v).toLocaleString()}`, ""]} />
              <Legend />
              <Bar dataKey="total_cargado" name="Cargos" fill="hsl(var(--chart-1))" radius={[10, 10, 0, 0]} />
              <Bar dataKey="total_pagado" name="Pagos" fill="hsl(var(--chart-2))" radius={[10, 10, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      )}
    </ChartPanel>
  );
}
