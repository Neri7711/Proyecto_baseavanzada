import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { PieChart, Pie, Cell, ResponsiveContainer, Tooltip, Legend } from "recharts";
import type { DistribucionConcepto } from "@/lib/api";

const COLORS = ["hsl(210,70%,35%)", "hsl(174,42%,45%)", "hsl(38,90%,55%)", "hsl(280,50%,50%)", "hsl(145,55%,42%)"];

export function DistribucionConceptoChart({ data }: { data: DistribucionConcepto[] | undefined }) {
  if (!data?.length) return null;
  return (
    <Card className="border-none shadow-md">
      <CardHeader className="pb-2">
        <CardTitle className="text-base font-semibold">Distribución por Concepto</CardTitle>
      </CardHeader>
      <CardContent>
        <ResponsiveContainer width="100%" height={300}>
          <PieChart>
            <Pie data={data} dataKey="monto_total" nameKey="concepto" cx="50%" cy="50%" outerRadius={100} label={({ concepto }) => concepto}>
              {data.map((_, i) => (
                <Cell key={i} fill={COLORS[i % COLORS.length]} />
              ))}
            </Pie>
            <Tooltip formatter={(v: number) => [`$${Number(v).toLocaleString()}`, "Monto"]} />
            <Legend />
          </PieChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
