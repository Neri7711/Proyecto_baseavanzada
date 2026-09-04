import { useEffect, useMemo, useRef, useState } from "react";
import { Waypoints } from "lucide-react";
import { SunburstChart } from "recharts";
import { ChartPanel } from "./ChartPanel";
import { PanelEmpty, PanelLoading } from "./PanelState";
import type { SunburstJerarquiaItem } from "@/lib/api";

interface Props {
  data?: SunburstJerarquiaItem[];
  isLoading?: boolean;
}

type SunburstNode = {
  name: string;
  value?: number;
  fill?: string;
  children?: SunburstNode[];
  meta?: {
    facultad?: string;
    carrera?: string;
    materia?: string;
    curso?: string;
    inscritos?: number;
    porcentaje_llenado?: number;
  };
};

const FACULTY_COLORS = [
  "hsl(var(--chart-1))",
  "hsl(var(--chart-2))",
  "hsl(var(--chart-3))",
  "hsl(var(--chart-4))",
  "hsl(var(--chart-5))",
];

export function SunburstJerarquicoChart({ data, isLoading }: Props) {
  const [activeNode, setActiveNode] = useState<SunburstNode | null>(null);
  const chartContainerRef = useRef<HTMLDivElement | null>(null);
  const [chartSize, setChartSize] = useState({ width: 0, height: 420 });

  useEffect(() => {
    const element = chartContainerRef.current;
    if (!element) return;

    const resize = () => {
      setChartSize({
        width: element.clientWidth,
        height: element.clientHeight || 420,
      });
    };

    resize();

    const observer = new ResizeObserver(resize);
    observer.observe(element);

    return () => observer.disconnect();
  }, []);

  const treeData = useMemo<SunburstNode | undefined>(() => {
    if (!data?.length) return undefined;

    const root: SunburstNode = { name: "Academico", children: [] };
    const facultyMap = new Map<string, SunburstNode>();
    const colorMap = new Map<string, string>();

    for (const row of data) {
      if (!colorMap.has(row.facultad)) {
        colorMap.set(
          row.facultad,
          FACULTY_COLORS[colorMap.size % FACULTY_COLORS.length]
        );
      }

      let facultyNode = facultyMap.get(row.facultad);
      if (!facultyNode) {
        facultyNode = {
          name: row.facultad,
          children: [],
          fill: colorMap.get(row.facultad),
        };
        facultyMap.set(row.facultad, facultyNode);
        root.children?.push(facultyNode);
      }

      let careerNode = facultyNode.children?.find((c) => c.name === row.carrera);
      if (!careerNode) {
        careerNode = { name: row.carrera, children: [], fill: facultyNode.fill };
        facultyNode.children?.push(careerNode);
      }

      let subjectNode = careerNode.children?.find((m) => m.name === row.materia);
      if (!subjectNode) {
        subjectNode = { name: row.materia, children: [], fill: facultyNode.fill };
        careerNode.children?.push(subjectNode);
      }

      subjectNode.children?.push({
        name: row.curso,
        value: Math.max(Number(row.inscritos ?? 0), 1),
        fill: facultyNode.fill,
        meta: {
          facultad: row.facultad,
          carrera: row.carrera,
          materia: row.materia,
          curso: row.curso,
          inscritos: Number(row.inscritos ?? 0),
          porcentaje_llenado: Number(row.porcentaje_llenado ?? 0),
        },
      });
    }

    return root;
  }, [data]);

  return (
    <ChartPanel
      title="Sunburst Jerarquico Academico"
      subtitle="Facultad > Carrera > Materia > Curso (peso por inscritos)"
      icon={Waypoints}
    >
      {isLoading ? (
        <PanelLoading />
      ) : !treeData?.children?.length ? (
        <PanelEmpty message="No hay datos para jerarquia academica" />
      ) : (
        <div className="space-y-3">
          <div className="rounded-xl border border-border/60 bg-muted/20 p-3 text-xs text-muted-foreground">
            {activeNode?.meta?.curso ? (
              <span>
                {activeNode.meta.facultad} / {activeNode.meta.carrera} / {activeNode.meta.materia} /{" "}
                <strong>{activeNode.meta.curso}</strong> - {activeNode.meta.inscritos} inscritos (
                {activeNode.meta.porcentaje_llenado?.toFixed(2)}%)
              </span>
            ) : (
              <span>Pasa el cursor por un sector para ver detalle del curso.</span>
            )}
          </div>
          <div ref={chartContainerRef} className="h-[420px]">
            {chartSize.width > 0 ? (
              <SunburstChart
                data={treeData}
                width={chartSize.width}
                height={chartSize.height}
                dataKey="value"
                ringPadding={2}
                innerRadius={50}
                outerRadius={Math.max(Math.min(chartSize.width, chartSize.height) / 2 - 12, 120)}
                cx={chartSize.width / 2}
                cy={chartSize.height / 2}
                stroke="hsl(var(--background))"
                onMouseEnter={(node) => setActiveNode(node as SunburstNode)}
                onMouseLeave={() => setActiveNode(null)}
              />
            ) : null}
          </div>
        </div>
      )}
    </ChartPanel>
  );
}
