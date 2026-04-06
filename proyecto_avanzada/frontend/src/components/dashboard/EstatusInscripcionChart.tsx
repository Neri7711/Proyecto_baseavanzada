import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { PieChart, Pie, Cell, ResponsiveContainer, Tooltip, Legend } from "recharts";
import type { EstatusInscripcion } from "@/lib/api";

const COLORS = ["hsl(174,42%,45%)", "hsl(0,72%,51%)", "hsl(38,90%,55%)"];

export function EstatusInscripcionChart({ data }: { data: EstatusInscripcion[] | undefined }) {
  if (!data?.length) return null;
  return (
    <Card className="border-none shadow-md">
      <CardHeader className="pb-2">
        <CardTitle className="text-base font-semibold">Distribución por Estatus</CardTitle>
      </CardHeader>
      <CardContent>
        <ResponsiveContainer width="100%" height={300}>
          <PieChart>
            <Pie data={data} dataKey="total" nameKey="estatus" cx="50%" cy="50%" outerRadius={100} innerRadius={50} paddingAngle={3} label={({ estatus, total }) => `${estatus}: ${total}`}>
              {data.map((_, i) => (
                <Cell key={i} fill={COLORS[i % COLORS.length]} />
              ))}
            </Pie>
            <Tooltip />
            <Legend />
          </PieChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
