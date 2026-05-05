import { useMemo } from "react";
import { BookOpenCheck } from "lucide-react";
import {
  ResponsiveContainer,
  LineChart,
  Line,
  CartesianGrid,
  XAxis,
  YAxis,
  Tooltip,
} from "recharts";
import { ChartPanel } from "./ChartPanel";
import { PanelEmpty, PanelLoading } from "./PanelState";
import type { CargaDocente } from "@/lib/api";

interface Props {
  data?: CargaDocente[];
  isLoading?: boolean;
}

export function CargaDocenteChart({ data, isLoading }: Props) {
  const histogramData = useMemo(() => {
    if (!data?.length) return [];

    const bins = new Map<number, number>();

    for (const row of data) {
      const cursos = Number(row.total_cursos ?? 0);
      bins.set(cursos, (bins.get(cursos) ?? 0) + 1);
    }

    return [...bins.entries()]
      .sort((a, b) => a[0] - b[0])
      .map(([totalCursos, totalDocentes]) => ({
        cursos: totalCursos,
        total_docentes: totalDocentes,
      }));
  }, [data]);

  return (
    <ChartPanel
      title="Carga Docente"
      subtitle="Histograma de docentes por número de cursos asignados"
      icon={BookOpenCheck}
    >
      {isLoading ? (
        <PanelLoading />
      ) : histogramData.length === 0 ? (
        <PanelEmpty message="No hay datos de carga docente" />
      ) : (
        <div className="h-[340px]">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={histogramData}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis
                dataKey="cursos"
                type="number"
                tickLine={false}
                axisLine={false}
                label={{ value: "Cursos asignados", position: "insideBottom", offset: -6 }}
                allowDecimals={false}
              />
              <YAxis
                dataKey="total_docentes"
                type="number"
                tickLine={false}
                axisLine={false}
                allowDecimals={false}
                label={{ value: "Docentes", angle: -90, position: "insideLeft" }}
              />
              <Tooltip />
              <Line
                type="monotone"
                dataKey="total_docentes"
                name="Docentes"
                stroke="hsl(var(--chart-4))"
                strokeWidth={2}
                dot={{ r: 5 }}
                activeDot={{ r: 7 }}
              />
            </LineChart>
          </ResponsiveContainer>
        </div>
      )}
    </ChartPanel>
  );
}
