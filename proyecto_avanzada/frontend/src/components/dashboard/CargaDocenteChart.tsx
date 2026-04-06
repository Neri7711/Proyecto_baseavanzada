import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend } from "recharts";
import type { CargaDocente } from "@/lib/api";

export function CargaDocenteChart({ data }: { data: CargaDocente[] | undefined }) {
  if (!data?.length) return null;

  const sorted = [...data].sort((a, b) => b.total_alumnos - a.total_alumnos).slice(0, 10);
  const chartData = sorted.map((d) => ({
    docente: d.docente.length > 20 ? d.docente.slice(0, 18) + "…" : d.docente,
    cursos: d.total_cursos,
    alumnos: d.total_alumnos,
  }));

  return (
    <Card className="border-none shadow-md">
      <CardHeader className="pb-2">
        <CardTitle className="text-base font-semibold">Carga Docente (Cursos y Alumnos)</CardTitle>
      </CardHeader>
      <CardContent>
        <ResponsiveContainer width="100%" height={320}>
          <BarChart data={chartData} margin={{ top: 5, right: 20, bottom: 50, left: 0 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="hsl(210,15%,88%)" />
            <XAxis dataKey="docente" angle={-30} textAnchor="end" tick={{ fontSize: 10 }} />
            <YAxis tick={{ fontSize: 11 }} />
            <Tooltip />
            <Legend />
            <Bar dataKey="cursos" name="Cursos" fill="hsl(210,70%,35%)" radius={[4, 4, 0, 0]} />
            <Bar dataKey="alumnos" name="Alumnos" fill="hsl(174,42%,45%)" radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
