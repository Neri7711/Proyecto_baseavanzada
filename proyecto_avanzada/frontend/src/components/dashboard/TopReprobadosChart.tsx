import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell } from "recharts";
import type { TopReprobado } from "@/lib/api";

export function TopReprobadosChart({ data }: { data: TopReprobado[] | undefined }) {
  if (!data?.length) return (
    <Card className="border-none shadow-md">
      <CardHeader><CardTitle className="text-base font-semibold">Top Materias con Reprobados</CardTitle></CardHeader>
      <CardContent><p className="text-muted-foreground text-sm">No hay datos de reprobación.</p></CardContent>
    </Card>
  );

  const sorted = [...data].sort((a, b) => b.total_reprobados - a.total_reprobados).slice(0, 10);

  return (
    <Card className="border-none shadow-md">
      <CardHeader className="pb-2">
        <CardTitle className="text-base font-semibold">Top Materias con Más Reprobados</CardTitle>
      </CardHeader>
      <CardContent>
        <ResponsiveContainer width="100%" height={300}>
          <BarChart data={sorted} layout="vertical" margin={{ top: 5, right: 20, bottom: 5, left: 100 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="hsl(210,15%,88%)" />
            <XAxis type="number" tick={{ fontSize: 11 }} />
            <YAxis type="category" dataKey="materia" tick={{ fontSize: 11 }} width={95} />
            <Tooltip
              formatter={(v: number, name: string) => [
                name === "total_reprobados" ? `${v} alumnos` : `${v}%`,
                name === "total_reprobados" ? "Reprobados" : "% Reprobación",
              ]}
            />
            <Bar dataKey="total_reprobados" radius={[0, 6, 6, 0]}>
              {sorted.map((d, i) => (
                <Cell key={i} fill={d.porcentaje_reprobacion > 30 ? "hsl(0,72%,51%)" : d.porcentaje_reprobacion > 15 ? "hsl(38,90%,55%)" : "hsl(174,42%,45%)"} />
              ))}
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
