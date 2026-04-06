import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend } from "recharts";
import type { CargosVsPagos } from "@/lib/api";

export function CargosVsPagosChart({ data }: { data: CargosVsPagos[] | undefined }) {
  if (!data?.length) return null;

  const chartData = data.map((d) => ({
    ...d,
    eficiencia: d.total_cargado > 0 ? Math.round((d.total_pagado / d.total_cargado) * 100) : 0,
  }));

  return (
    <Card className="border-none shadow-md">
      <CardHeader className="pb-2">
        <CardTitle className="text-base font-semibold">Cargos vs Pagos por Periodo</CardTitle>
      </CardHeader>
      <CardContent>
        <ResponsiveContainer width="100%" height={320}>
          <BarChart data={chartData} margin={{ top: 5, right: 20, bottom: 30, left: 10 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="hsl(210,15%,88%)" />
            <XAxis dataKey="periodo" angle={-15} textAnchor="end" tick={{ fontSize: 11 }} />
            <YAxis tick={{ fontSize: 11 }} />
            <Tooltip
              formatter={(v: number, name: string) => [
                `$${v.toLocaleString()}`,
                name === "total_cargado" ? "Cargado" : "Pagado",
              ]}
            />
            <Legend />
            <Bar dataKey="total_cargado" name="Cargado" fill="hsl(210,70%,35%)" radius={[4, 4, 0, 0]} />
            <Bar dataKey="total_pagado" name="Pagado" fill="hsl(145,55%,42%)" radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
