import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell, ReferenceLine } from "recharts";
import type { SaturacionCurso } from "@/lib/api";

export function SaturacionCursosChart({ data }: { data: SaturacionCurso[] | undefined }) {
  if (!data?.length) return null;
  return (
    <Card className="border-none shadow-md">
      <CardHeader className="pb-2">
        <CardTitle className="text-base font-semibold">Saturación de Cursos</CardTitle>
      </CardHeader>
      <CardContent>
        <ResponsiveContainer width="100%" height={300}>
          <BarChart data={data} margin={{ top: 5, right: 20, bottom: 40, left: 0 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="hsl(210,15%,88%)" />
            <XAxis dataKey="materia" angle={-25} textAnchor="end" tick={{ fontSize: 10 }} />
            <YAxis domain={[0, 100]} tick={{ fontSize: 11 }} unit="%" />
            <Tooltip formatter={(v: number) => [`${v}%`, "Llenado"]} />
            <ReferenceLine y={90} stroke="hsl(0,72%,51%)" strokeDasharray="4 4" />
            <Bar dataKey="porcentaje_llenado" radius={[6, 6, 0, 0]}>
              {data.map((d, i) => (
                <Cell key={i} fill={d.porcentaje_llenado >= 90 ? "hsl(0,72%,51%)" : d.porcentaje_llenado >= 70 ? "hsl(38,90%,55%)" : "hsl(174,42%,45%)"} />
              ))}
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
