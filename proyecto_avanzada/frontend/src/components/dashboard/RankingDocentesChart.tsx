import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { RadarChart, Radar, PolarGrid, PolarAngleAxis, PolarRadiusAxis, ResponsiveContainer, Tooltip } from "recharts";
import type { RankingDocente } from "@/lib/api";

export function RankingDocentesChart({ data }: { data: RankingDocente[] | undefined }) {
  if (!data?.length) return null;
  const chartData = data.slice(0, 8).map((d) => ({
    name: `${d.nombre} ${d.apellidos.charAt(0)}.`,
    promedio: d.promedio_alumnos,
  }));
  return (
    <Card className="border-none shadow-md">
      <CardHeader className="pb-2">
        <CardTitle className="text-base font-semibold">Ranking Docentes (Promedio Alumnos)</CardTitle>
      </CardHeader>
      <CardContent>
        <ResponsiveContainer width="100%" height={320}>
          <RadarChart data={chartData} outerRadius="70%">
            <PolarGrid stroke="hsl(210,15%,88%)" />
            <PolarAngleAxis dataKey="name" tick={{ fontSize: 10 }} />
            <PolarRadiusAxis domain={[0, 100]} tick={{ fontSize: 9 }} />
            <Tooltip formatter={(v: number) => [`${v}`, "Promedio"]} />
            <Radar dataKey="promedio" stroke="hsl(174,42%,45%)" fill="hsl(174,42%,45%)" fillOpacity={0.3} />
          </RadarChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
