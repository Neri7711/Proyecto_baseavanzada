import { useMemo } from "react";
import { Orbit } from "lucide-react";
import {
  ResponsiveContainer,
  RadarChart,
  Radar,
  PolarGrid,
  PolarAngleAxis,
  PolarRadiusAxis,
  Tooltip,
  Legend,
} from "recharts";
import { ChartPanel } from "./ChartPanel";
import { PanelEmpty, PanelLoading } from "./PanelState";
import type { RadarFacultadItem } from "@/lib/api";

interface Props {
  data?: RadarFacultadItem[];
  isLoading?: boolean;
}

const COLORS = [
  "hsl(var(--chart-1))",
  "hsl(var(--chart-2))",
  "hsl(var(--chart-3))",
  "hsl(var(--chart-4))",
  "hsl(var(--chart-5))",
];

const METRICS = [
  { key: "rendimiento_promedio", label: "Rendimiento" },
  { key: "ocupacion_promedio", label: "Ocupacion" },
  { key: "tasa_reprobacion", label: "Reprobacion" },
  { key: "cobertura_pagos", label: "Cobertura" },
  { key: "retencion_activos", label: "Retencion" },
] as const;

export function RadarFacultadChart({ data, isLoading }: Props) {
  const facultades = useMemo(() => (data ?? []).slice(0, 5), [data]);

  const radarData = useMemo(() => {
    if (!facultades.length) return [];

    return METRICS.map((metric) => {
      const row: Record<string, number | string> = { metrica: metric.label };
      for (const item of facultades) {
        row[item.facultad] = Number(item[metric.key] ?? 0);
      }
      return row;
    });
  }, [facultades]);

  return (
    <ChartPanel
      title="Radar Multidimensional por Facultad"
      subtitle="Comparativo de rendimiento, ocupacion, reprobacion, cobranza y retencion"
      icon={Orbit}
    >
      {isLoading ? (
        <PanelLoading />
      ) : radarData.length === 0 ? (
        <PanelEmpty message="No hay datos para radar por facultad" />
      ) : (
        <div className="h-[380px]">
          <ResponsiveContainer width="100%" height="100%">
            <RadarChart data={radarData} outerRadius="70%">
              <PolarGrid />
              <PolarAngleAxis dataKey="metrica" />
              <PolarRadiusAxis domain={[0, 100]} />
              <Tooltip />
              <Legend />
              {facultades.map((item, idx) => (
                <Radar
                  key={item.facultad}
                  name={item.facultad}
                  dataKey={item.facultad}
                  stroke={COLORS[idx % COLORS.length]}
                  fill={COLORS[idx % COLORS.length]}
                  fillOpacity={0.2}
                  strokeWidth={2}
                />
              ))}
            </RadarChart>
          </ResponsiveContainer>
        </div>
      )}
    </ChartPanel>
  );
}
