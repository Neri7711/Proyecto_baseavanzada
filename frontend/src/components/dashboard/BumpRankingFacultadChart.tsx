import { useMemo } from "react";
import { TrendingUp } from "lucide-react";
import {
  ResponsiveContainer,
  LineChart,
  Line,
  CartesianGrid,
  XAxis,
  YAxis,
  Tooltip,
  Legend,
} from "recharts";
import { ChartPanel } from "./ChartPanel";
import { PanelEmpty, PanelLoading } from "./PanelState";
import type { RankingFacultadPeriodoItem } from "@/lib/api";

interface Props {
  data?: RankingFacultadPeriodoItem[];
  isLoading?: boolean;
}

const COLORS = [
  "hsl(var(--chart-1))",
  "hsl(var(--chart-2))",
  "hsl(var(--chart-3))",
  "hsl(var(--chart-4))",
  "hsl(var(--chart-5))",
];

export function BumpRankingFacultadChart({ data, isLoading }: Props) {
  const { chartData, faculties, maxRank, inscripcionesMap } = useMemo(() => {
    const rows = data ?? [];
    if (!rows.length) {
      return {
        chartData: [] as Record<string, string | number | null>[],
        faculties: [] as string[],
        maxRank: 1,
        inscripcionesMap: new Map<string, number>(),
      };
    }

    const periodSet = new Set<string>();
    const facultyToRanks = new Map<string, number[]>();
    const rankByPeriodFaculty = new Map<string, number>();
    const inscripciones = new Map<string, number>();
    let highestRank = 1;

    for (const row of rows) {
      periodSet.add(row.periodo);
      if (!facultyToRanks.has(row.facultad)) facultyToRanks.set(row.facultad, []);
      facultyToRanks.get(row.facultad)?.push(Number(row.ranking));
      rankByPeriodFaculty.set(`${row.periodo}__${row.facultad}`, Number(row.ranking));
      inscripciones.set(`${row.periodo}__${row.facultad}`, Number(row.total_inscripciones));
      highestRank = Math.max(highestRank, Number(row.ranking));
    }

    const periods = [...periodSet].sort();
    const topFaculties = [...facultyToRanks.entries()]
      .sort((a, b) => {
        const avgA = a[1].reduce((acc, r) => acc + r, 0) / a[1].length;
        const avgB = b[1].reduce((acc, r) => acc + r, 0) / b[1].length;
        return avgA - avgB;
      })
      .slice(0, 5)
      .map(([facultad]) => facultad);

    const linesData = periods.map((periodo) => {
      const row: Record<string, string | number | null> = { periodo };
      for (const facultad of topFaculties) {
        row[facultad] = rankByPeriodFaculty.get(`${periodo}__${facultad}`) ?? null;
      }
      return row;
    });

    return {
      chartData: linesData,
      faculties: topFaculties,
      maxRank: highestRank,
      inscripcionesMap: inscripciones,
    };
  }, [data]);

  return (
    <ChartPanel
      title="Bump Chart de Facultades"
      subtitle="Cambio de posicion por periodo segun total de inscripciones"
      icon={TrendingUp}
    >
      {isLoading ? (
        <PanelLoading />
      ) : chartData.length === 0 ? (
        <PanelEmpty message="No hay datos para ranking por periodo" />
      ) : (
        <div className="h-[420px]">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={chartData} margin={{ left: 10, right: 10, top: 8, bottom: 8 }}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="periodo" tickLine={false} axisLine={false} />
              <YAxis
                type="number"
                domain={[1, maxRank]}
                reversed
                allowDecimals={false}
                tickLine={false}
                axisLine={false}
                label={{ value: "Ranking (1 mejor)", angle: -90, position: "insideLeft" }}
              />
              <Tooltip
                formatter={(value: number | string, name, meta) => {
                  const rank = Number(value);
                  const periodo = String(meta?.payload?.periodo ?? "");
                  const total = inscripcionesMap.get(`${periodo}__${String(name)}`) ?? 0;
                  return [`#${rank} (${total} inscripciones)`, String(name)];
                }}
              />
              <Legend />
              {faculties.map((facultad, idx) => (
                <Line
                  key={facultad}
                  type="monotone"
                  dataKey={facultad}
                  name={facultad}
                  connectNulls
                  stroke={COLORS[idx % COLORS.length]}
                  strokeWidth={2.5}
                  dot={{ r: 4 }}
                  activeDot={{ r: 6 }}
                />
              ))}
            </LineChart>
          </ResponsiveContainer>
        </div>
      )}
    </ChartPanel>
  );
}
