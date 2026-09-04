import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  ReferenceLine,
} from "recharts";
import type { MateriaCritica } from "@/lib/api";

interface Props {
  data?: MateriaCritica[];
  isLoading?: boolean;
}

export function MateriasCriticasChart({ data, isLoading }: Props) {
  if (isLoading) return null;

  if (!data?.length) {
    return (
      <Card className="border-none shadow-md">
        <CardHeader>
          <CardTitle className="text-base font-semibold">Materias Críticas</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground text-sm">No hay materias con promedio menor a 70.</p>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card className="border-none shadow-md">
      <CardHeader className="pb-2">
        <CardTitle className="text-base font-semibold">Materias Críticas (Promedio &lt; 70)</CardTitle>
      </CardHeader>
      <CardContent>
        <ResponsiveContainer width="100%" height={300}>
          <BarChart data={data} layout="vertical" margin={{ top: 5, right: 20, bottom: 5, left: 80 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="hsl(210,15%,88%)" />
            <XAxis type="number" domain={[0, 100]} tick={{ fontSize: 11 }} />
            <YAxis type="category" dataKey="materia" tick={{ fontSize: 11 }} width={75} />
            <Tooltip formatter={(v: number) => [`${v}`, "Promedio"]} />
            <ReferenceLine
              x={70}
              stroke="hsl(0,72%,51%)"
              strokeDasharray="4 4"
              label={{ value: "70", fill: "hsl(0,72%,51%)", fontSize: 11 }}
            />
            <Bar dataKey="promedio" fill="hsl(0,72%,51%)" radius={[0, 6, 6, 0]} opacity={0.8} />
          </BarChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
