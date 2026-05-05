import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";
import type { IngresoMensual } from "@/lib/api";

interface Props {
  data?: IngresoMensual[];
  isLoading?: boolean;
}

export function IngresosMensualesChart({ data, isLoading }: Props) {
  if (isLoading) return null;
  if (!data?.length) return null;

  return (
    <Card className="border-none shadow-md">
      <CardHeader className="pb-2">
        <CardTitle className="text-base font-semibold">Ingresos Mensuales</CardTitle>
      </CardHeader>
      <CardContent>
        <ResponsiveContainer width="100%" height={300}>
          <AreaChart data={data} margin={{ top: 5, right: 20, bottom: 5, left: 10 }}>
            <defs>
              <linearGradient id="gradIngresos" x1="0" y1="0" x2="0" y2="1">
                <stop offset="5%" stopColor="hsl(var(--chart-2))" stopOpacity={0.4} />
                <stop offset="95%" stopColor="hsl(var(--chart-2))" stopOpacity={0} />
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" stroke="hsl(210,15%,88%)" />
            <XAxis dataKey="mes" tick={{ fontSize: 11 }} />
            <YAxis tick={{ fontSize: 11 }} />
            <Tooltip formatter={(v: number) => [`$${v.toLocaleString()}`, "Ingresos"]} />
            <Area type="monotone" dataKey="total_ingresos" stroke="hsl(var(--chart-2))" fill="url(#gradIngresos)" strokeWidth={2} />
          </AreaChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
