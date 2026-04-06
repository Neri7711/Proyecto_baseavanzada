import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell } from "recharts";
import type { RendimientoCarrera } from "@/lib/api";

const COLORS = [
  "hsl(210,70%,35%)", "hsl(174,42%,45%)", "hsl(38,90%,55%)",
  "hsl(280,50%,50%)", "hsl(145,55%,42%)", "hsl(0,72%,51%)",
];

export function RendimientoCarreraChart({ data }: { data: RendimientoCarrera[] | undefined }) {
  if (!data?.length) return null;
  return (
    <Card className="border-none shadow-md">
      <CardHeader className="pb-2">
        <CardTitle className="text-base font-semibold">Rendimiento por Carrera</CardTitle>
      </CardHeader>
      <CardContent>
        <ResponsiveContainer width="100%" height={300}>
          <BarChart data={data} margin={{ top: 5, right: 20, bottom: 40, left: 0 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="hsl(210,15%,88%)" />
            <XAxis dataKey="carrera" angle={-25} textAnchor="end" tick={{ fontSize: 11 }} />
            <YAxis domain={[0, 100]} tick={{ fontSize: 11 }} />
            <Tooltip formatter={(v: number) => [`${v}`, "Promedio"]} />
            <Bar dataKey="promedio_general" radius={[6, 6, 0, 0]}>
              {data.map((_, i) => (
                <Cell key={i} fill={COLORS[i % COLORS.length]} />
              ))}
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
