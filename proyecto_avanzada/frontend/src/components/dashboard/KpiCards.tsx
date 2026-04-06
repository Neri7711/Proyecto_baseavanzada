import { Users, GraduationCap, DollarSign, BookOpen, TrendingDown, AlertCircle } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import type { KPIs } from "@/lib/api";

interface Props {
  data: KPIs | undefined;
  isLoading: boolean;
}

const cards = [
  { key: "total_alumnos" as const, label: "Total Alumnos", icon: Users, color: "bg-kpi-blue" },
  { key: "rendimiento_global" as const, label: "Rendimiento Global", icon: GraduationCap, color: "bg-kpi-teal", suffix: "%" },
  { key: "tasa_reprobacion" as const, label: "Tasa Reprobación", icon: TrendingDown, color: "bg-destructive", suffix: "%" },
  { key: "porcentaje_pagos_corriente" as const, label: "Pagos al Corriente", icon: DollarSign, color: "bg-kpi-amber", suffix: "%" },
  { key: "deuda_pendiente" as const, label: "Deuda Pendiente", icon: AlertCircle, color: "bg-destructive", prefix: "$", format: true },
  { key: "docentes_activos" as const, label: "Docentes Activos", icon: BookOpen, color: "bg-kpi-green" },
];

export function KpiCards({ data, isLoading }: Props) {
  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-4">
      {cards.map((c) => (
        <Card key={c.key} className="border-none shadow-md hover:shadow-lg transition-shadow">
          <CardContent className="flex items-center gap-4 p-5">
            <div className={`${c.color} rounded-xl p-3 text-primary-foreground`}>
              <c.icon className="h-6 w-6" />
            </div>
            <div>
              <p className="text-sm text-muted-foreground font-medium">{c.label}</p>
              {isLoading ? (
                <div className="h-7 w-16 bg-muted animate-pulse rounded mt-1" />
              ) : (
                <p className="text-2xl font-bold text-foreground">
                  {data ? (
                    <>
                      {(() => {
                        const raw = data[c.key];
                        const value = typeof raw === "number" ? raw : Number(raw ?? 0);
                        return (
                          <>
                            {c.prefix ?? ""}
                            {c.format ? value.toLocaleString() : value}
                            {c.suffix ?? ""}
                          </>
                        );
                      })()}
                    </>
                  ) : "—"}
                </p>
              )}
            </div>
          </CardContent>
        </Card>
      ))}
    </div>
  );
}
